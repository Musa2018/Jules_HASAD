# Implementation Plan - Sync DTO Mapping Layer

Implement a dedicated DTO mapping layer for Farmers, Farms, and Damage Reports to ensure synchronization payloads strictly match the backend command contracts.

## User Review Required

> [!IMPORTANT]
> This change strictly decouples the Offline Domain Entities from the Synchronization payloads. `Farmer.toJson()` will no longer be used for API requests.

- **Date Formatting**: `BirthDate` will be formatted as `yyyy-MM-dd` to match .NET `DateOnly`.
- **Gender Validation**: Payloads will be blocked or defaulted if `Gender.unspecified` is present, as the backend forbids it.
- **Payload Sanitization**: Metadata like `syncStatus` and `lastSyncError` will be excluded from all sync payloads.

## Proposed Changes

### 1. Data Layer Mappings

#### [NEW] [farmer_sync_dtos.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/farmer_sync_dtos.dart)
- Create `FarmerSyncDto` with static methods:
    - `toCreateJson(Farmer farmer)`: Maps to `CreateFarmerCommand`.
    - `toUpdateJson(Farmer farmer)`: Maps to `UpdateFarmerCommand`.
- Create `FarmSyncDto` with static methods:
    - `toCreateJson(Farm farm)`: Maps to `CreateFarmCommand`.
    - `toUpdateJson(Farm farm)`: Maps to `UpdateFarmCommand`.
- Create `DamageReportSyncDto` with static methods:
    - `toCreateJson(DamageReport report)`: Maps to `CreateDamageReportCommand`.
    - `toUpdateJson(DamageReport report)`: Maps to `UpdateDamageReportCommand`.

### 2. Repository Refactoring

#### [MODIFY] [remote_farmer_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/remote_farmer_repository.dart)
- Update `createFarmer` and `updateFarmer` to use `FarmerSyncDto`.

#### [MODIFY] [remote_farm_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/remote_farm_repository.dart)
- Update `createFarm` and `updateFarm` to use `FarmSyncDto`.

#### [MODIFY] [remote_damage_report_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/remote_damage_report_repository.dart)
- Update `createDamageReport`, `updateDamageReport`, `addDamageItem`, and `updateDamageItem` to use `DamageReportSyncDto`.

### 3. Synchronization Engine

#### [MODIFY] [background_sync_service.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/background_sync_service.dart)
- Ensure the `data` stored in `SyncQueue` remains the full entity JSON for resilience (so it can be re-mapped if the DTO logic changes), but the Repositories will perform the final DTO mapping before the HTTP call.

## Verification Plan

### Automated Tests
- **Flutter**:
    - Update/Add tests in `remote_farmer_repository_test.dart` to verify exact payload generation.
    - Run `flutter test`.
- **Backend**:
    - Run existing command tests to ensure they still accept the new payloads.

### Code Analysis
- Run `flutter analyze`.
