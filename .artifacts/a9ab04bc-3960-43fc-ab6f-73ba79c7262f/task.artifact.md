# Task - Farmers Offline Sync Hardening Verification & Operation Collapsing Fix

- [/] Research & Preparation
    - [x] Verify current branch (`farmers`) and latest commit (`6b90f47`).
    - [x] Review sync lifecycle documentation.
- [ ] implementation
    - [ ] Update `BackgroundSyncService.addToQueue` to preserve `create` operations during offline edits.
    - [ ] Ensure `lastSyncError` is cleared when a task is updated for retry.
- [ ] Verification
    - [ ] Add Scenario 1: Offline Create Then Update test.
    - [ ] Add Scenario 2: Multiple Offline Updates test.
    - [ ] Add Scenario 3: Invalid Create Correction test.
    - [ ] Add Scenario 4: Existing Synced Farmer Update test.
    - [ ] Verify Drift migration safety (v7 to v8).
- [ ] Documentation & Delivery
    - [ ] Update `PROJECT_STATUS.md`.
    - [ ] Update `AI_CONTEXT.md`.
    - [ ] Commit and push to `farmers` branch.
