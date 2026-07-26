# Task: Farmers & Farms UAT Stabilization

Address UAT-004 through UAT-007 to stabilize the foundation for Damage Report implementation.

## Checklist

- [x] **Infrastructure & Deployment**
    - [x] Create `IdentityUniquenessAudit.sql` deployment script
    - [x] Create EF Core migration for Global Identity Uniqueness
- [x] **Backend Implementation**
    - [x] Update `CreateFarmerCommandHandler` uniqueness check
    - [x] Update `UpdateFarmerCommandHandler` uniqueness check
- [x] **UI Framework**
    - [x] Create reusable `FormSaveFooter` widget
- [x] **Mobile Implementation**
    - [x] Refactor `FarmerFormNotifier` and `FarmFormNotifier` for error propagation
    - [x] Update `OfflineFirstFarmerRepository` uniqueness check
    - [x] Adopt `FormSaveFooter` in `FarmerFormScreen`
    - [x] Adopt `FormSaveFooter` in `FarmFormScreen`
- [x] **Documentation**
    - [x] Update `ADR-0017`
    - [x] Update `PROJECT_STATUS.md`
    - [x] Update `UAT_Farmers_Farms_Hardening.md`
- [x] **Verification**
    - [x] Run backend tests
    - [x] Run mobile tests
    - [x] Manual UAT verification
