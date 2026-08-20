# Tasks - Harvest System Redesign (Stage 1)

- [ ] **1. Backend Core Changes**
    - [ ] Modify `Farmer` entity (remove `DirectorateId`).
    - [ ] Update `CreateFarmer` and `UpdateFarmer` handlers.
    - [ ] Update `GetFarmersList` query logic.
    - [ ] Run/Create EF Core migration.
- [ ] **2. Mobile Core Changes**
    - [ ] Update Drift database schema (v34) and migration.
    - [ ] Re-generate Drift code (`build_runner`).
    - [ ] Update `AuthorizationService`.
- [ ] **3. UI/UX Fixes**
    - [ ] Fix FAB visibility in `DamageReportsListScreen`.
    - [ ] Update `DamageReportHeaderScreen` date logic and validation.
