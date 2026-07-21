# Task - Farmers Offline Sync Sprint 10.11: Final Refinements

- [x] Implementation Refinements
    - [x] Update `BackgroundSyncService._hardDeleteLocalEntity` to manually handle cascades for `damage_report`.
    - [x] Update `_syncAttachment` to use the correct ID for remote deletion.
    - [x] Ensure local files are removed when `DamageReportAttachment` is hard deleted.
- [x] Test Suite Expansion
    - [x] Add generic operation collapsing test for `DamageReport`.
    - [x] Add `isPendingDelete` filter test for Farmers list.
    - [x] Add test for `damage_report` local hard delete cascade.
- [x] Documentation
    - [x] Update `ARCHITECTURE.md` with conflict resolution policy.
    - [x] Update `PROJECT_STATUS.md` and `AI_CONTEXT.md`.
- [x] Delivery
    - [x] Commit and push to `farmers` branch.
