# Task List — Farmers Bug Fixes

- [ ] **Research & Investigation**
    - [x] Trace navigation from Search to Form
    - [x] Investigate `updateFarmer` repository logic
    - [x] Identify missing name mappings in Details screen

- [x] **Fix Issue 1 — Edit Save Failure**
    - [x] Update `FarmerSearchScreen` to push `farmerDetails` instead of `editFarmer`
    - [x] Update `FarmerFormScreen` save feedback logic
    - [x] Verify `pop()` target in `FarmerFormScreen`

- [x] **Fix Issue 2 — Details Screen Names**
    - [x] Implement name resolution for Governorate in `FarmerDetailsScreen`
    - [x] Implement name resolution for Locality in `FarmerDetailsScreen`
    - [x] Update ID Type mapping in `FarmerDetailsScreen`

- [x] **Fix Issue 3 — Sync Status Wording**
    - [x] Update `app_en.arb` and `app_ar.arb` with clearer sync terms
    - [x] Add `syncing` state to `_SyncStatusBadge` in `FarmerDetailsScreen`

- [x] **Verification**
    - [x] Run `flutter analyze`
    - [x] Manual verification of Edit workflow
    - [x] Manual verification of Details display
