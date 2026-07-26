# Implementation Plan - HASAD Release Candidate Hardening

Hardening and verification of the Farmers and Farms modules to ensure production readiness before implementing new features.

## User Review Required

> [!IMPORTANT]
> **FieldSurveyor Permissions**: Currently, `FieldSurveyor` is restricted from managing farmers/farms in `AuthorizationService`. This prevents them from registering new data in the field, which contradicts the core mission. I propose removing `FieldSurveyor` from the `restrictedRoles` list for `canManageFarmers` and `canManageFarms`.

> [!IMPORTANT]
> **Operational View Filter**: The `FarmerRepository` applies Directorate scoping whenever a user is a Surveyor/Engineer, ignoring the `isOperational` toggle in the UI. Also, the `innerJoin` on `farms` hides farmers who don't have farms yet, making it impossible for a Surveyor to see a farmer they just added until a farm is attached. I propose fixing the repository to respect the `isOperational` flag and use a more appropriate filtering logic.

## Open Questions

- Should a `FieldSurveyor` be allowed to **Delete** or only **Create/Edit**? Currently `canManageFarmers` covers all three.
- Is "المزارع" (Farms) the preferred label for the button in `FarmerCard`? The UAT test expected "مزرعة" (Farm).

## Proposed Changes

### [Core]

#### [MODIFY] [AuthorizationService](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/auth/authorization_service.dart)
- Remove `FieldSurveyor` from `restrictedRoles` in `canManageFarmers()` and `canManageFarms()`.

### [Farmers Module]

#### [MODIFY] [FarmerRepository](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/farmer_repository.dart)
- Update `watchFarmers` to respect `filter.isOperational`.
- Refine the scoping logic: If `isOperational` is true, show farmers in the user's directorate.
- Consider using a `EXISTS` subquery or a different join to ensure farmers without farms are still visible if they match other criteria (e.g. they were created by the current user or are in the same location).

#### [MODIFY] [FarmerCard UAT Test](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/test/features/farmers/farmer_card_authorization_uat_test.dart)
- Update the test to expect the correct localized string (or at least "المزارع" if that's the intended UI).
- Fix the false positive in the `TechnicalReviewer` test by checking for the correct button text.

### [Farms Module]

#### [MODIFY] [FarmFormScreen](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farms/presentation/farm_form_screen.dart)
- Address the `deprecated_member_use` for `areaUnitId` if it's a simple fix to use `measurementUnitId`.

### [Storage]

#### [MODIFY] [StorageProviders](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/storage_providers.dart)
- Investigate why `AppDatabase` is being instantiated multiple times in tests and ensure a singleton pattern or proper provider overrides in tests.

## Verification Plan

### Automated Tests
- Run `flutter test test/farmers test/farms test/features/farmers test/features/farms`.
- Ensure all 54+ tests pass (currently failing 1).

### Manual Verification
- Verify the "Operational View" toggle in the UI correctly filters farmers.
- Verify that a `FieldSurveyor` user (mocked or via session override) can see the "Add Farmer" and "Add Farm" buttons.
- Verify that farmers without farms are visible to Surveyors in their directorate.
