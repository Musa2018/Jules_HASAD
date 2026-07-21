# Implementation Plan - HASAD Farmers Sync Hardening Verification & Fix

Perform a deep-dive verification of the sync hardening implementation and address a discovered risk regarding operation collapsing in the sync queue.

## User Review Required

> [!WARNING]
> A bug was identified during research: If a farmer is created offline (pending `create`) and then edited before syncing, the task operation is currently changed to `update`. This would cause a `404 Not Found` on the backend since the record doesn't exist yet. I will apply a fix to preserve the `create` operation in this scenario.

## Proposed Changes

### Storage & Sync Logic

#### [MODIFY] [background_sync_service.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/background_sync_service.dart)
- Update `addToQueue` logic:
    - If an existing `pending`/`failed`/`invalid` task is found:
        - If the existing operation is `create`, keep it as `create` even if the new request is an `update`.
        - Otherwise, update the operation as requested.

## Verification Plan

### Automated Tests (New & Updated)
- Update `test/core/storage/background_sync_service_test.dart`:
    - **Scenario: User Correction Flow**:
        - Start with an `invalid` item.
        - Call `addToQueue` with updated data.
        - Verify status resets to `pending`.
    - **Scenario: Offline Create Then Update (Operation Collapsing)**:
        - Call `addToQueue` with `create`.
        - Call `addToQueue` with `update`.
        - Verify queue item operation remains `create`.
    - **Scenario: Multiple Offline Updates**:
        - Call `addToQueue` multiple times.
        - Verify only 1 row exists in `SyncQueue` with latest data.

### Migration Verification
- Create a scratch script `test/migration_v7_v8_test.dart` to:
    - Initialize a database at schema v7.
    - Insert test data.
    - Trigger upgrade to v8.
    - Verify `lastSyncError` columns are present and null.
    - Verify test data is preserved.

### Manual Verification Findings
- Will report on `ValidationFailed` vs `invalid` status alignment.
- Will report on App Restart recovery behavior.
