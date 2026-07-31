# Geographic Integrity & Multi-Farm Validation Task List

- [ ] **Phase 1: Backend Scoping Hardening**
    - [ ] Update `GetFarmsByFarmerQueryHandler` with `ICurrentUserService` and geographic filtering.
    - [ ] Update `GetFarmByIdQueryHandler` with explicit 403 authorization check.
    - [ ] Verify `dotnet build` with zero warnings.

- [ ] **Phase 2: Security Integration Tests**
    - [ ] Implement `MultiFarmSecurityScenariosTests.cs`.
    - [ ] Test Scenario A: Farmer Ahmed with Multi-Directorate farms.
    - [ ] Test Scenario B: Farmer Ali with no local farms (should be invisible to local user).
    - [ ] Run `dotnet test`.

- [ ] **Phase 3: Mobile UI & Terminology**
    - [ ] Update `.arb` files with "Personal Address" labels.
    - [ ] Update `FarmerDetailsScreen.dart` and `FarmerCard.dart` labels.
    - [ ] Review `Farmer` entity UI to ensure no "Directorate" (residency) is shown if it causes confusion.

- [ ] **Phase 4: Sync & Documentation**
    - [ ] Implement `multi_farm_offline_sync_test.dart`.
    - [ ] Update `ADR-0013`, `AI_CONTEXT.md`, and `PROJECT_STATUS.md`.
    - [ ] Final regression run: `dotnet test` and `flutter test`.
    - [ ] Generate final walkthrough report.
