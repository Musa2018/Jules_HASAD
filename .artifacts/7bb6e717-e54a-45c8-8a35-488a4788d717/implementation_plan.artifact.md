# Implementation Plan - Farm Scope Authorization Regression Fix

A regression in the Farm module incorrectly restricts the selection of Farmers (operators/owners) based on the logged-in user's geographic scope. The business rule states that the user's geographic scope applies **ONLY** to the Farm location, not to the Farmer entities.

## User Review Required

> [!IMPORTANT]
> The geographic scope checks in `CreateFarmer`, `UpdateFarmer`, and `DeleteFarmer` command handlers will be removed to allow Agricultural Engineers to manage farmers regardless of their governorate. This is necessary because farmers may live in one area but own/operate farms in another.

## Proposed Changes

### Backend (Hasad.Application)

#### [MODIFY] [CreateFarmerCommandHandler.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farmers/Commands/CreateFarmer/CreateFarmerCommand.cs)
- Remove the authorization check that compares `request.GovernorateId` with `_currentUser.GovernorateId`.

#### [MODIFY] [UpdateFarmerCommandHandler.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farmers/Commands/UpdateFarmer/UpdateFarmerCommand.cs)
- Remove the authorization check that compares `request.GovernorateId` with `_currentUser.GovernorateId`.

#### [MODIFY] [DeleteFarmerCommandHandler.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farmers/Commands/DeleteFarmer/DeleteFarmerCommand.cs)
- Remove the authorization check that compares `farmer.GovernorateId` with `_currentUser.GovernorateId`.

#### [MODIFY] [FarmCommandHandlerTests.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application.Tests/FarmCommandHandlerTests.cs)
- Add a test case: Agricultural Engineer from one directorate creates a farm in their directorate for a farmer from a different governorate (SUCCESS).
- Add a test case: Agricultural Engineer from one directorate tries to create a farm in a different directorate (FAIL).

### Flutter (mobile)

#### [VERIFY] [farm_validator.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farms/domain/farm_validator.dart)
- Confirm no incorrect farmer-based geographic checks exist.

#### [VERIFY] [farm_form_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farms/presentation/farm_form_screen.dart)
- Ensure the farmer search and selection logic is not restricted by user scope.

## Verification Plan

### Automated Tests
- Run backend tests: `dotnet test`
- Run Flutter tests: `flutter test`
- Run Flutter static analysis: `flutter analyze`

### Manual Verification
1. Login as Agricultural Engineer (Jericho).
2. Search for a farmer in Bethlehem.
3. Create a farm in Jericho for this Bethlehem farmer.
4. Verify success.
5. Try to create a farm in Bethlehem for any farmer.
6. Verify failure (Access Denied).
