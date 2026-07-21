# Implementation Plan - Farmers Create Sync Validation Fix

Prevent invalid farmer data from entering the sync pipeline by implementing strict validation in both the UI and Repository layers.

## User Review Required

> [!IMPORTANT]
> The validation rules will be enforced at the Repository level. This means any call to `createFarmer` or `updateFarmer` with invalid data will throw a `FarmerException`. UI components should handle this exception or prevent it via form validation.

## Proposed Changes

### Domain Layer

#### [MODIFY] [gender.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/domain/gender.dart)
- No changes needed, but will be referenced in validation.

### Data Layer

#### [MODIFY] [farmer_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/farmer_repository.dart)
- Implement `_validateFarmer(domain.Farmer farmer)` private method.
- Validation logic:
    - `idTypeId > 0` (IdType required).
    - `Validators.isAtLeast18(farmer.birthDate)` is true.
    - `farmer.gender != Gender.unspecified`.
    - `farmer.familySize >= 1`.
- Update `createFarmer` and `updateFarmer` to call `_validateFarmer` before database insertion or sync queue addition.

### Presentation Layer

#### [MODIFY] [farmer_form_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/farmer_form_screen.dart)
- Update `Gender` dropdown:
    - Add validator to ensure `Gender.unspecified` is not selected.
- Update `FamilySize` field:
    - Update validator to ensure `int.tryParse(v) >= 1`.
- Update `BirthDate` field:
    - Already has 18+ check, will ensure it's robust.
- Update `IdType` dropdown:
    - Add validator if needed (currently defaults to 1).

## Verification Plan

### Automated Tests
- Run `flutter test test/farmers/offline_first_farmer_repository_test.dart`.
- New test cases:
    - `createFarmer` throws error if `idTypeId` is 0.
    - `createFarmer` throws error if age < 18.
    - `createFarmer` throws error if gender is `unspecified`.
    - `createFarmer` throws error if family size < 1.
    - `createFarmer` succeeds with valid data.
- Run `flutter analyze` to ensure no regressions.

### Manual Verification
- Not possible in this environment, relying on automated tests and code analysis.
