# Implementation Plan - DamageReport Final Sync & Localization Hardening

Fix critical synchronization and numbering issues in the `DamageReport` module and ensure duplicate prevention is user-friendly and localized.

## User Review Required

> [!IMPORTANT]
> The numbering format will be updated from `DIR-DIR-YEAR-SEQ` to `GOV-DIR-YEAR-SEQ` as per ADR-0014 and the latest Palestinian numbering convention requirements.

## Proposed Changes

### Backend (.NET)

#### [MODIFY] [DamageReportNumberService.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Services/DamageReportNumberService.cs)
- Update `GeneratePermanentNumberAsync` to include the Governorate code.
- Format change: `{GovCode}-{DirCode}-{Year}-{Sequence}`.

#### [MODIFY] [CreateDamageReportCommand.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/DamageReports/Commands/CreateDamageReport/CreateDamageReportCommand.cs)
- Return a stable error code `DAMAGE_REPORT_DUPLICATE` instead of a raw string when a duplicate report is detected.

---

### Mobile (Flutter)

#### [MODIFY] [background_sync_service.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/background_sync_service.dart)
- **Header Sync**: Implement pruning of `damage_item` tasks from `SyncQueue` after successful bulk `create` of a `DamageReport`. This prevents redundant individual item syncs.
- **Workflow Sync**: Add diagnostic logging to `_syncDamageReportWorkflow` to identify why it might be marking items as `failed` despite backend success.
- **Error Mapping**: Map `DAMAGE_REPORT_DUPLICATE` error code from server to a localized message.

#### [MODIFY] [offline_first_damage_report_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/data/repositories/offline_first_damage_report_repository.dart)
- Update local duplicate checks to use the `duplicateReportError` localization key instead of a hardcoded English string.
- In `submitReport`, set a more accurate predicted status (e.g., `DamageReportStatus.pendingTechnicalVerification` or `techReview`) instead of the legacy `'Submitted'`.

#### [MODIFY] [remote_damage_report_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/data/repositories/remote_damage_report_repository.dart)
- Ensure `_errorsFromDio` correctly extracts and propagates the `DAMAGE_REPORT_DUPLICATE` code from conflict responses.

## Verification Plan

### Automated Tests
- Run `dotnet test` for backend numbering and creation logic.
- Run `flutter test` for `BackgroundSyncService` and `DamageReportRepository`.

### Manual Verification
1. **Numbering**: Create a report and verify it gets a number like `NBL-JEN-2026-000001`.
2. **Duplicate Protection**:
   - Try to create a report for the same farm and date offline. Verify localized error.
   - Try to sync a duplicate report to the server. Verify it is marked as `conflict` with a localized message.
3. **Workflow Sync**: Create a report, add items, sync everything, and "Submit For Review". Verify it ends up as `Synced` and `TechReview`.
