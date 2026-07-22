# Implementation Plan — Farmers Bug Fixes

Resolve critical issues in the Farmers Edit workflow and Details screen to ensure data integrity and user clarity.

## User Review Required

> [!IMPORTANT]
> The "Edit Save Failure" was partially caused by `FarmerSearchScreen` bypassing the `FarmerDetailsScreen` and navigating directly to `FarmerFormScreen`. This has been corrected to follow the intended workflow: **Search → Details → Edit**.

> [!NOTE]
> Synchronization status labels are being updated to be more descriptive (e.g., "Awaiting Sync" instead of just "Pending").

## Proposed Changes

### [Farmers] Navigation & Workflow Fixes

#### [MODIFY] [farmer_search_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/farmer_search_screen.dart)
- Change found farmer navigation from `editFarmer` to `farmerDetails`.
- This ensures the navigation stack is consistent: Search → Details → Edit.

#### [MODIFY] [farmer_form_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/farmer_form_screen.dart)
- Improve Save feedback by showing the SnackBar via the Navigator's context or after the pop.
- Ensure state invalidation is thorough.

---

### [Farmers] Details Screen Enhancements

#### [MODIFY] [farmer_details_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/farmer_details_screen.dart)
- Resolve `governorateId` and `localityId` to their localized names using `governoratesProvider` and `localitiesProvider`.
- Map `idTypeId` (1, 2, 3) to localized names.
- Distinguish between `pending` (Awaiting Sync) and `syncing` (Syncing in progress) in the status badge.

---

### [L10n] Synchronization & ID Terminology

#### [MODIFY] [app_en.arb](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/l10n/app_en.arb) & [app_ar.arb](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/l10n/app_ar.arb)
- Update `pendingSync` wording.
- Add `syncing` label.
- Ensure all ID Type names are present.

## Verification Plan

### Manual Verification
- **Edit Workflow**:
    - Search for a farmer → Verify it goes to Details.
    - Press Edit → Modify → Save.
    - Verify it returns to Details and shows updated data.
    - Verify success SnackBar appears.
- **Details Display**:
    - Verify Governorate and Locality names appear instead of GUIDs.
    - Verify ID Type name appears.
    - Verify Sync Status badge shows correct terminology.
- **Offline Integrity**:
    - Perform an edit while offline.
    - Verify local record is updated and `SyncQueue` entry is created.

### Automated Tests
- Run `flutter analyze` to ensure no regressions.
- Run `test/farmers/farmer_form_screen_test.dart` if relevant.
