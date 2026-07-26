# Implementation Plan - DamageReport Sprint 14.x Synchronization

Synchronize the HASAD Flutter mobile application with the updated backend DamageReport contract (Sprint 14.x). This involves updating domain models, database schema, and repository implementations to match the validated backend architecture.

## User Review Required

> [!IMPORTANT]
> The database schema version will be increased to 21. A migration strategy is included to add the new mandatory fields to existing reports.

## Proposed Changes

### Domain Layer

#### [MODIFY] [damage_report.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/domain/models/damage_report.dart)
- Import `damage_report_status.dart`.
- Add the following fields to the `DamageReport` model:
    - `damageYear` (int)
    - `farmerId` (String)
    - `governorateId` (String)
    - `directorateId` (String)
    - `localityId` (String)
    - `latitude` (double?)
    - `longitude` (double?)
- Ensure `agriculturalSectorId` is used instead of any legacy `damageNatureId` at the report level.

### Data Layer (Storage)

#### [MODIFY] [database.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/database.dart)
- Update `DamageReports` table class definition to include:
    - `damageYear`, `farmerId`, `governorateId`, `directorateId`, `localityId`, `latitude`, `longitude`.
- Increment `schemaVersion` to 21.
- Add migration from v20 to v21 to add these columns to the `damage_reports` table.

### Data Layer (Repositories)

#### [MODIFY] [remote_reference_data_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farms/data/remote_reference_data_repository.dart)
- Implement `getActions()` method.

### Synchronization & UI

#### [MODIFY] [background_sync_service.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/background_sync_service.dart)
- Update sync logic to handle the new fields in `DamageReport`.

#### [MODIFY] [damage_reports_providers.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/providers/damage_reports_providers.dart)
- Fix mapping of `DamageReportLocal` to `DamageReport` domain model.

## Verification Plan

### Automated Tests
- Run `dart run build_runner build --delete-conflicting-outputs` to ensure all generated files are up to date.
- Run `flutter analyze` to verify all compilation errors are resolved.
- Run `flutter test` to ensure no regressions in existing logic.

### Manual Verification
- Verify that new reports can be created and saved locally with the new fields.
- Verify that synchronization with the backend works (requires backend connectivity).
