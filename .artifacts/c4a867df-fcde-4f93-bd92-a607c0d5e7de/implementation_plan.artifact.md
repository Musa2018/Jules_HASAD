# Implementation Plan — Sprint 11.2: Database and Lookup Tables (Flutter)

This plan focuses on synchronizing the Flutter offline database with the redesigned Farm backend model. It includes implementing lookup tables, updating the `Farms` table, and handling the Drift migration.

## User Review Required

> [!IMPORTANT]
> **Feature Migration**: All farm-related files will be moved from `lib/features/farmers/` to a new dedicated feature folder `lib/features/farms/`. This ensures clean separation of concerns as the Farm module grows.

> [!WARNING]
> **Drift Migration v10**: This migration will update the `Farms` table. While existing data will be preserved, many new columns are non-nullable and will be initialized with default values (e.g., OwnershipTypeId = 1).

## Proposed Changes

### [Architectural Refinement]
Record the pending decision to consolidate `AreaUnit` into a universal `MeasurementUnit` entity in `ARCHITECTURE.md` and `AI_CONTEXT.md`. (Already completed in pre-step).

---

### [Domain Layer]
#### [MOVE] [farm.dart](file:///hasad/mobile/lib/features/farmers/domain/farm.dart) -> `mobile/lib/features/farms/domain/farm.dart`
Update the `Farm` model with the new fields:
- `localFarmName` (replacing `name`)
- `ownerFarmerId`
- `relationshipToOwnerId`
- `directorateId`
- `basin`
- `parcel`
- `area` (replacing `landArea`)
- `areaUnitId` (replacing `landAreaUnit` string)
- `agriculturalSectorId`
- `politicalClassificationId`
- `notes`
- `isDeleted`, `deletedAt`, `deletedBy` (metadata for soft delete)

#### [NEW] Lookup Models
Create domain models for lookups:
- `OwnershipType`, `AgriculturalSector`, `PoliticalClassification`, `AreaUnit`, `RelationshipToOwner`.

---

### [Data Layer — Drift Database]
#### [MODIFY] [database.dart](file:///hasad/mobile/lib/core/storage/database.dart)
- Define new tables for all 5 lookup entities.
- Update `Farms` table:
    - Rename `name` to `localFarmName`.
    - Rename `landArea` to `area`.
    - Add `ownerFarmerId`, `relationshipToOwnerId`, `directorateId`, `basin`, `parcel`, `areaUnitId`, `agriculturalSectorId`, `politicalClassificationId`.
    - Add `isDeleted`, `deletedAt`, `deletedBy`.
    - Add indices for `farmerId`, `ownerFarmerId`, and geographic fields.
- **Migration**: Increment `schemaVersion` to **10** and implement `onUpgrade` logic.
    - Create new lookup tables.
    - Alter `Farms` table (Drift `m.alterTable` or manual column addition).

---

### [Repository Layer]
#### [MOVE & MODIFY] `OfflineFirstFarmRepository`
- Move to `mobile/lib/features/farms/data/`.
- Update mapping logic to handle all new fields.
- Ensure `getFarmsByFarmer` filters out `isPendingDelete` or `isDeleted` records.

---

### [Sync Layer]
#### [MODIFY] `FarmSyncDto`
- Update `toCreateJson` and `toUpdateJson` to match the new backend contract (Sprint 11.1).
- Ensure local metadata (syncStatus, isDeleted) is NOT sent to backend.

#### [MODIFY] `BackgroundSyncService`
- Update `_syncFarm` and `_resolveConflict` for Farms to handle the new fields.

---

## Verification Plan

### Automated Tests
- **Database Tests**:
    - Verify `schemaVersion` is 10.
    - Verify all new columns exist in `Farms` table.
    - Verify lookup tables are created.
- **Repository Tests**:
    - Test `createFarm` with the new complex model.
    - Test `watchFarms` filters out deleted records.
- **Sync Tests**:
    - Verify `FarmSyncDto.toCreateJson` produces the exact payload required by backend.

### Manual Verification
- Run `dart run build_runner build` and ensure no generation errors.
- Verify app launches and migration runs without crashes.
