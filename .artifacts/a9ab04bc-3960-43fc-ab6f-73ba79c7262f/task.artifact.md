# Task - Farmers Offline Sync Sprint 10.11: Final Refinements

- [ ] Implementation Refinements
    - [ ] Update `BackgroundSyncService._hardDeleteLocalEntity` to manually handle cascades for `damage_report`.
    - [ ] Update `_syncAttachment` to use the correct ID for remote deletion.
    - [ ] Ensure local files are removed when `DamageReportAttachment` is hard deleted.
- [ ] Test Suite Expansion
    - [ ] Add generic operation collapsing test for `DamageReport`.
    - [ ] Add `isPendingDelete` filter test for Farmers list.
    - [ ] Add test for `damage_report` local hard delete cascade.
- [ ] Documentation
    - [ ] Update `ARCHITECTURE.md` with conflict resolution policy.
    - [ ] Update `PROJECT_STATUS.md` and `AI_CONTEXT.md`.
- [ ] Delivery
    - [ ] Commit and push to `farmers` branch.
