# Task: Fix Production Blockers (Farmer Visibility & Sync 404)

- [x] **Issue 1: Farmer Visibility Regression**
    - [x] Refactor `OfflineFirstFarmerRepository.getFarmers` to separate Authorization Scope and Operational Filter.
    - [x] Refactor `OfflineFirstFarmerRepository.watchFarmers` to separate Authorization Scope and Operational Filter.
    - [x] Add/Update regression tests in `farmer_repository_hardening_test.dart`.
    - [x] Verify fix with `flutter analyze`.
- [x] **Issue 2: DamageReport Sync 404**
    - [x] Modify `DamageReportsController.cs` to use explicit kebab-case route `api/v1/damage-reports`.
    - [x] Verify backend builds and tests pass.
- [x] **Final Verification**
    - [x] Run mobile tests.
    - [x] Run backend tests.
    - [x] Prepare Walkthrough and final report.
