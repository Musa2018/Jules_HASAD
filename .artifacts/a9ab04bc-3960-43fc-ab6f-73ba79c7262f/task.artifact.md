# Task - Farmer Update Sync Hardening

- [x] Domain & DTO Hardening
    - [x] Add `serverId`, `syncStatus`, and `lastSyncError` to `Farm`, `DamageReport`, and `DamageItem` domain models.
    - [x] Update `farmer_sync_dtos.dart` to use `serverId` for all update operations.
- [x] Repository Mapping Refinement
    - [x] Update `OfflineFirstFarmRepository` mapping logic.
    - [x] Update `OfflineFirstDamageReportRepository` mapping logic.
- [x] Metadata Sync Verification
    - [x] Ensure `BackgroundSyncService` correctly reconciles metadata for all entities after sync.
- [x] Verification & Tests
    - [x] Run `build_runner`.
    - [x] Update and run `farmer_sync_dtos_test.dart`.
    - [x] Run full sync test suite.
- [x] Documentation
    - [x] Update `PROJECT_STATUS.md` and `CHANGELOG.md`.
