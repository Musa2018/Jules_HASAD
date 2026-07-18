# Sprint 10.3 — Flutter Farmer Data Layer Alignment Plan

Align the Flutter data layer with the updated backend schema from Sprint 10.2. This includes updating the domain model, the local Drift database, and the repository mapping logic.

## User Review Required

> [!IMPORTANT]
> - The Drift database schema will be upgraded to version 7.
> - A migration path will be added to the `Farmers` table to include the new columns without data loss.
> - The `Farmer` domain model will now use individual name parts (firstNameAr, etc.) instead of a single `name` field, matching the backend's explicit mapping.

## Proposed Changes

### Domain Layer

#### [NEW] [gender.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/domain/gender.dart)
Create a `Gender` enum to match the backend:
```dart
enum Gender { unspecified, male, female }
```

#### [MODIFY] [farmer.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/domain/farmer.dart)
Update the `Farmer` model with all new fields:
- Identity: `id`, `clientId`, `rowVersion`, `serverId`, `idTypeId`, `idNumber`
- Arabic Name: `firstNameAr`, `secondNameAr`, `thirdNameAr`, `fourthNameAr`
- English Name: `firstNameEn`, `secondNameEn`, `thirdNameEn`, `fourthNameEn`
- Demographics: `birthDate`, `gender`, `mobileNumber`, `familySize`
- Geography: `governorateId`, `localityId`
- Audit: `createdAt`, `updatedAt`

---

### Local Storage Layer (Drift)

#### [MODIFY] [database.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/database.dart)
- Update `Farmers` table with new columns matching the backend.
- Increment `schemaVersion` to `7`.
- Add migration logic in `onUpgrade` to add the new columns to the `farmers` table.

---

### Data Layer (Repository)

#### [MODIFY] [farmer_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/farmer_repository.dart)
Update `OfflineFirstFarmerRepository` mapping logic:
- Update `getFarmers` and `getFarmer` to map all new Drift columns to the `Farmer` domain model.
- Update `createFarmer` and `updateFarmer` to map the `Farmer` domain model back to `FarmersCompanion`.

---

### Verification Plan

#### Automated Tests
- Run `flutter analyze` to ensure no compile-time errors.
- Run `flutter test mobile/test/farmers/` if available.
- Verify JSON serialization of the updated `Farmer` model.

#### Manual Verification
- Verify that the Drift migration logic is correctly defined in `database.dart`.
