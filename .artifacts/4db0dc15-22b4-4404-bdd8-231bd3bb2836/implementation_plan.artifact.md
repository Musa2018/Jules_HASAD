# Implementation Plan - Domain Integrity Hardening (Deletion Rules)

## Goal
Implement business rules to prevent the deletion of Farmer and Farm entities when they are referenced by other operational data (Farms or Damage Reports). This ensures domain integrity and prevents orphaned records.

## User Review Required
> [!IMPORTANT]
> These rules are implemented at the Backend layer during the soft-delete operation. Since the mobile app uses an offline-first sync queue, the deletion will first appear as "Pending" in the UI. If the backend rejects the deletion due to these integrity rules, the sync will fail, and the specific business error will be displayed on the entity card.

## Proposed Changes

### Backend - Features

#### [MODIFY] [DeleteFarmerCommandHandler](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farmers/Commands/DeleteFarmer/DeleteFarmerCommand.cs)
- Add a check using `_context.Farms` to see if the farmer is either an operator (`FarmerId`) or an owner (`OwnerFarmerId`) of any non-deleted farm.
- If references exist, return a failure result with the message: `"لا يمكن حذف المزارع لوجود أراضٍ مرتبطة به."` (Arabic) / `"Cannot delete farmer because there are farms associated with them."` (English).

#### [MODIFY] [DeleteFarmCommandHandler](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farms/Commands/DeleteFarm/DeleteFarmCommand.cs)
- Add a check using `_context.DamageReports` to see if any reports reference this farm.
- If references exist, return a failure result with the message: `"لا يمكن حذف المزرعة لوجود استمارات ضرر مرتبطة بها."` (Arabic) / `"Cannot delete farm because there are damage reports associated with it."` (English).

### Flutter - Localization & UI

#### [MODIFY] [app_ar.arb](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/l10n/app_ar.arb)
- Add `"deleteRestrictedError": "لا يمكن حذف هذا السجل لأنه مرتبط ببيانات أخرى."` (As a fallback or general UI message).

#### [MODIFY] [app_en.arb](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/l10n/app_en.arb)
- Add `"deleteRestrictedError": "This record cannot be deleted because it is linked to other data."`

#### [VERIFY] [FarmerCard](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/widgets/farmer_card.dart) & [FarmCard](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farms/presentation/widgets/farm_card.dart)
- Ensure the `lastSyncError` is displayed clearly when `syncStatus == 'failed'`. The current implementation already shows this under the title, which is appropriate for business rule violations.

## Verification Plan

### Automated Tests (Backend)
- Update `FarmerCommandHandlerTests.cs`:
    - `DeleteFarmer_Fails_WhenLinkedToFarm`: Mock a farm referencing the farmer and assert failure.
- Update `FarmCommandHandlerTests.cs`:
    - `DeleteFarm_Fails_WhenLinkedToDamageReport`: Mock a damage report referencing the farm and assert failure.

### Automated Tests (Flutter)
- Update `offline_delete_workflow_test.dart` to simulate a "Restricted Delete" failure from the backend and verify the error message is shown on the card.

### Manual Verification
1. Create a Farmer.
2. Create a Farm for that Farmer.
3. Attempt to delete the Farmer.
4. Verify the Farmer remains "Pending Delete" then turns to "Sync Error" with the correct message.
5. Delete the Farm first.
6. Attempt to delete the Farmer again.
7. Verify successful deletion.
8. Repeat for Farm and Damage Report once reports are implemented (or mock the DB record).
