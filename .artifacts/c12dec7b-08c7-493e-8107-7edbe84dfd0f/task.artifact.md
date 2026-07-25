# Task: Farmers & Farms UAT Stabilization

Address UAT-004 through UAT-007 to stabilize the foundation for Damage Report implementation.

## Checklist

- [ ] **Infrastructure & Deployment**
    - [ ] Create `IdentityUniquenessAudit.sql` deployment script
    - [ ] Create EF Core migration for Global Identity Uniqueness
- [ ] **Backend Implementation**
    - [ ] Update `CreateFarmerCommandHandler` uniqueness check
    - [ ] Update `UpdateFarmerCommandHandler` uniqueness check
- [ ] **UI Framework**
    - [ ] Create reusable `FormSaveFooter` widget
- [ ] **Mobile Implementation**
    - [ ] Refactor `FarmerFormNotifier` and `FarmFormNotifier` for error propagation
    - [ ] Update `OfflineFirstFarmerRepository` uniqueness check
    - [ ] Adopt `FormSaveFooter` in `FarmerFormScreen`
    - [ ] Adopt `FormSaveFooter` in `FarmFormScreen`
- [ ] **Documentation**
    - [ ] Update `ADR-0017`
    - [ ] Update `PROJECT_STATUS.md`
    - [ ] Update `UAT_Farmers_Farms_Hardening.md`
- [ ] **Verification**
    - [ ] Run backend tests
    - [ ] Run mobile tests
    - [ ] Manual UAT verification
