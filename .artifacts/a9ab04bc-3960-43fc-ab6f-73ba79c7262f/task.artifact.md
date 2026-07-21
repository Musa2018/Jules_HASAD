# Task - Farmers Offline Sync Hardening Verification & Operation Collapsing Fix

- [x] Research & Preparation
    - [x] Verify current branch (`farmers`) and latest commit (`6b90f47`).
    - [x] Review sync lifecycle documentation.
- [x] implementation
    - [x] Update `BackgroundSyncService.addToQueue` to preserve `create` operations during offline edits.
    - [x] Ensure `lastSyncError` is cleared when a task is updated for retry.
    - [x] Implement generic `SyncException` and `SyncValidationException`.
    - [x] Implement soft-delete in repositories and `BackgroundSyncService`.
- [x] Verification
    - [x] Add Scenario 1: Offline Create Then Update test.
    - [x] Add Scenario 2: Multiple Offline Updates test.
    - [x] Add Scenario 3: Invalid Create Correction test.
    - [x] Add Scenario 4: Existing Synced Farmer Update test.
    - [x] Verify Drift migration safety (v7 to v9).
- [x] Documentation & Delivery
    - [x] Update `PROJECT_STATUS.md`.
    - [x] Update `AI_CONTEXT.md`.
    - [x] Commit and push to `farmers` branch.
