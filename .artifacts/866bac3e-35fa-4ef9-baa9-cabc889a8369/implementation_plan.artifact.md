# DamageReport Offline Sync Hardening Implementation Plan (Phase 1)

This plan outlines the steps to implement "Late Binding" in `BackgroundSyncService` for `DamageReport` synchronization. This ensures that when a report is created offline and items are added before synchronization, the bulk creation payload correctly includes all technical items.

## Proposed Changes

### Core Storage

#### [MODIFY] [BackgroundSyncService](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/background_sync_service.dart)

1.  **Helper Method**: Add `_getLocalDamageReport(String localId)` to reload the aggregate from Drift.
    - Uses `_db.damageReports` and `_db.damageItems`.
    - Maps to `report_domain.DamageReport`.
2.  **Sync Logic Update**: Modify `_syncDamageReport`'s `create` branch.
    - Call `_getLocalDamageReport` to get the latest state.
    - Fallback to `report_domain.DamageReport.fromJson(data)` ONLY if local record is missing (should not happen in normal flows, but for backward compatibility with old queue items that might have been partially deleted).
    - Use the reloaded report to generate the `DamageReportSyncDto.toCreateJson` payload.
3.  **Queue Cleanup**: After successful bulk creation, iterate through the reloaded items and remove their individual `damage_item:create` tasks from `SyncQueue`.

## Verification Plan

### Automated Tests
- [ ] **Stale Snapshot Test**: A test that simulates creating a report header (adding to queue), then adding items to DB, then running sync. Verify items are in the payload.
- [ ] **Backward Compatibility Test**: Verify sync still works if local DB record is missing but queue data exists (graceful degradation).
- [ ] **Partial Failure/Retry Test**: Verify that if sync fails and more items are added, the retry includes the new items.

### Manual Verification
- This phase focuses on logic hardening. Manual verification will be done after Phase 2 (UI unlocking).
- Logs will be verified via `DebugLogger` during execution.
