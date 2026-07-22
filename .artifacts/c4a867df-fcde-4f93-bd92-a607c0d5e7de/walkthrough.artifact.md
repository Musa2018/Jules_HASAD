# Walkthrough — Sprint 11.2: Farm Offline Database Foundation

I have completed the offline database foundation for the Farm module. This sprint focused on isolating farm-related logic, updating the Drift schema to support the complex agricultural land model, and preparing the synchronization layer.

## Changes Made

### 1. Feature Isolation
- Moved all farm-related code from `lib/features/farmers/` to a dedicated `lib/features/farms/` directory.
- Created a clear structure: `data/`, `domain/`, `presentation/`.
- Isolated Riverpod providers into `farms_providers.dart`.

### 2. Domain & Data Layer Updates
- **[Farm.cs](file:///hasad/mobile/lib/features/farms/domain/farm.dart)**: Updated domain model with `basin`, `parcel`, `area`, `ownerFarmerId`, and `directorateId`.
- **Lookup Tables**: Implemented 5 new Drift tables for offline reference data:
    - `OwnershipType`, `AgriculturalSector`, `PoliticalClassification`, `AreaUnit`, `RelationshipToOwner`.
- **[database.dart](file:///hasad/mobile/lib/core/storage/database.dart)**:
    - Incremented schema version to **10**.
    - Implemented `onUpgrade` logic to add new columns and create lookup tables.
    - Added indices for performance on geographic and relationship fields.

### 3. Repository & Sync Foundation
- **[OfflineFirstFarmRepository](file:///hasad/mobile/lib/features/farms/data/offline_first_farm_repository.dart)**: Updated with the new schema, supporting reactive streams and soft deletes.
- **[FarmSyncDto](file:///hasad/mobile/lib/features/farms/data/farm_sync_dtos.dart)**: Refactored to strictly match the backend contract from Sprint 11.1. Local-only metadata is now correctly excluded from payloads.
- **BackgroundSyncService**: Updated to handle the new `Farm` fields during synchronization and "Server Wins" conflict resolution.

### 4. Architectural Refinement
- **ADR 0009**: Formally recorded the decision to consolidate measurement units into a unified `MeasurementUnit` entity in future sprints.

## Verification Results

### Automated Tests
- Ran all mobile tests (`flutter test`). All **105** tests passed.
- **Database Migration**: Verified Drift migration to v10 on both fresh and existing setups.
- **Repository**: Verified offline creation, updates, and reactive streaming with the new complex model.
- **Sync Mappings**: Verified that `FarmSyncDto` produces the exact JSON required by the backend.

```powershell
01:16 +105 ~1: All tests passed!
```

### Analyzer Status
- `flutter analyze` reported no issues.

> [!IMPORTANT]
> **Geographic Hierarchy**: The system now follows the `Governorate -> Directorate -> Locality` hierarchy for Farms. `Locality` records now effectively belong to a `Directorate` in the context of a Farm.

> [!NOTE]
> **User Scoping**: The foundation is ready for Directorate-level authorization rules which will be enforced in the upcoming UI sprints.
