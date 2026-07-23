# Task: DamageReport Workflow Alignment (Sprint 13.1)

- `[/]` **Phase 1: Backend status model and workflow engine**
    - [ ] Create `DamageReportStatus.cs` constants
    - [ ] Update `AppRoles.cs` with new roles and scopes
    - [ ] Update `DamageWorkflowService.cs` with the new 10-stage matrix
- [ ] **Phase 2: Backend tests**
    - [ ] Update unit tests for all 10 forward transitions
    - [ ] Update unit tests for backward transitions and mandatory comments
    - [ ] Update security tests for role-based restrictions
- [ ] **Phase 3: Database migration**
    - [ ] Create EF Core migration for `StatusId` updates
    - [ ] Verify migration script with mapping table
- [ ] **Phase 4: API contract verification**
    - [ ] Update `CreateDamageReportCommand` defaults
    - [ ] Replace hardcoded status strings in Application features
- [ ] **Phase 5: Flutter update**
    - [ ] Add localization for 10 stages
    - [ ] Update `damage_report.dart` models
    - [ ] Update `DamageReportDetailsScreen.dart` transition logic
