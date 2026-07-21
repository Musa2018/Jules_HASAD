# Task - Farmer Update Sync Hardening

- [ ] Domain & DTO Hardening
    - [ ] Add `serverId`, `syncStatus`, and `lastSyncError` to `Farm`, `DamageReport`, and `DamageItem` domain models.
    - [ ] Update `farmer_sync_dtos.dart` to use `serverId` for all update operations.
- [ ] Repository Mapping Refinement
    - [ ] Update `OfflineFirstFarmRepository` mapping logic.
    - [ ] Update `OfflineFirstDamageReportRepository` mapping logic.
- [ ] Metadata Sync Verification
    - [ ] Ensure `BackgroundSyncService` correctly reconciles metadata for all entities after sync.
- [ ] Verification & Tests
    - [ ] Run `build_runner`.
    - [ ] Update and run `farmer_sync_dtos_test.dart`.
    - [ ] Run full sync test suite.
- [ ] Documentation
    - [ ] Update `PROJECT_STATUS.md` and `CHANGELOG.md`.
