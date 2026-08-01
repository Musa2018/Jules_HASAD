# Damage Report Duplicate Prevention Implementation

Implement and verify the business rule: "A farm cannot have more than one DamageReport with the same DamageDate."

## User Review Required

> [!IMPORTANT]
> - This rule enforces uniqueness based on the **calendar day** (DamageDate with time normalized to 00:00:00).
> - Backend will now strictly **reject** duplicate creation attempts with a 400 Bad Request instead of returning the existing report.
> - Mobile app will block duplicate creation locally before synchronization occurs.

## Proposed Changes

### Backend (C#)

#### [MODIFY] [CreateDamageReportCommandHandler.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/DamageReports/Commands/CreateDamageReport/CreateDamageReportCommand.cs)
- Change duplicate check logic: If a report with the same `FarmId` and `DamageDate.Date` exists and has a different `ClientId`, return `Result.Failure` with the message "A damage report already exists for this farm on the specified date."
- Normalize `DamageDate` to `request.DamageDate.Date` before persistence to ensure the database unique index (`FarmId + DamageDate`) correctly enforces "one report per day".

### Mobile (Dart)

#### [MODIFY] [damage_report_header_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/screens/damage_report_header_screen.dart)
- Normalize `_damageDate` in `initState` and in the date picker callback using `.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0)`.

#### [MODIFY] [offline_first_damage_report_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/data/repositories/offline_first_damage_report_repository.dart)
- Ensure `damageDate` is normalized (time set to zero) in both `createDamageReport` and `updateDamageReport` before any database queries or insertions.
- This ensures the local unique index and the local duplicate check work reliably.

### Documentation

#### [MODIFY] [PROJECT_STATUS.md](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/PROJECT_STATUS.md)
- Document the duplicate prevention rule enforcement.

## Verification Plan

### Automated Tests
- `DamageReportDuplicatePreventionTests` [NEW]: Verify backend rejection of duplicates.
- `damage_report_duplicate_prevention_test.dart` [NEW]: Verify mobile local blocking of duplicates.

### Manual Verification
1. **Scenario 1 (Fresh Report)**: Create a report for Farm A on 2026-07-31. Expect Success.
2. **Scenario 2 (Duplicate Report)**: Attempt to create another report for Farm A on 2026-07-31. Expect local error: "A damage report already exists for this farm and date."
3. **Scenario 3 (Different Date)**: Create a report for Farm A on 2026-08-01. Expect Success.
4. **Scenario 4 (Sync Conflict)**: Create a report offline, create same report on another device, then sync. Expect backend rejection and clear sync failure/conflict in the queue.
