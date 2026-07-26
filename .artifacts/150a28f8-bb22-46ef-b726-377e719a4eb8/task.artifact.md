# Task: Fix Production Blockers (Farmer Visibility & Sync 404)

- [ ] **Issue 1: Farmer Visibility Regression**
    - [ ] Refactor `OfflineFirstFarmerRepository.getFarmers` to separate Authorization Scope and Operational Filter.
    - [ ] Refactor `OfflineFirstFarmerRepository.watchFarmers` to separate Authorization Scope and Operational Filter.
    - [ ] Add/Update regression tests in `farmer_repository_hardening_test.dart`.
    - [ ] Verify fix with `flutter analyze`.
- [ ] **Issue 2: DamageReport Sync 404**
    - [ ] Modify `DamageReportsController.cs` to use explicit kebab-case route `api/v1/damage-reports`.
    - [ ] Verify backend builds and tests pass.
- [ ] **Final Verification**
    - [ ] Run mobile tests.
    - [ ] Run backend tests.
    - [ ] Prepare Walkthrough and final report.
