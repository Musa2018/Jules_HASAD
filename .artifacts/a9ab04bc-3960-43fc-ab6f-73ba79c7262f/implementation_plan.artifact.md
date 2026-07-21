# Implementation Plan - Farmers Offline Sync Invalid Data Handling Hardening

Harden the offline sync process to handle invalid business data gracefully, prevent endless retries for unrecoverable validation errors, and provide clear feedback to users.

## User Review Required

> [!IMPORTANT]
> This change involves a Drift database schema upgrade to **v8**. Existing local data will be preserved, but new columns will be added to track sync errors across all major entities.

## Proposed Changes

### Storage & Persistence

#### [MODIFY] [database.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/database.dart)
- Increment `schemaVersion` to **8**.
- Add `lastSyncError` nullable TextColumn to:
    - `Farmers`
    - `Farms`
    - `DamageReports`
    - `DamageItems`
    - `DamageReportAttachments`
- Update `onUpgrade` to add these columns for version 8.

#### [MODIFY] [background_sync_service.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/background_sync_service.dart)
- Update `_processItem` to catch `FarmerValidationException` (and similar for other entities).
- Introduce `invalid` status for `SyncQueue` and entities.
- When a validation error (HTTP 400) occurs:
    - Set `SyncQueue` item status to `invalid`.
    - Update entity `syncStatus` to `invalid` and store error in `lastSyncError`.
- **Optimization**: Update `addToQueue` to "upsert" tasks. If a `pending`, `failed`, or `invalid` task exists for the same `localId` and `entityType`, update it instead of adding a new row.

### Domain & Data Layer

#### [MODIFY] [farmer.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/domain/farmer.dart)
- Add `lastSyncError` field to `Farmer` class.

#### [MODIFY] [farmer_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/farmer_repository.dart)
- Add `FarmerValidationException` class.
- Update `_mapToDomain` to populate `lastSyncError`.
- Update `_mapToCompanion` to include `lastSyncError` (resetting it on manual update).

#### [MODIFY] [remote_farmer_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/remote_farmer_repository.dart)
- Update `_errorsFromDio` to detect `statusCode == 400` and throw `FarmerValidationException`.

### Presentation Layer

#### [MODIFY] [farmer_details_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/farmer_details_screen.dart)
- Update `_SyncStatusBadge` to handle `invalid` status.
- Add a warning banner at the top of the body if `farmer.syncStatus` is `invalid` or `failed`, displaying `farmer.lastSyncError`.

#### [MODIFY] [app_en.arb](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/l10n/app_en.arb) (and `app_ar.arb`)
- Add localized strings:
    - `syncInvalid`: "Invalid Data"
    - `syncErrorDetails`: "Sync Error Details"
    - `fixData`: "Fix Data"

## Verification Plan

### Automated Tests
- Run `flutter test test/farmers/offline_first_farmer_repository_test.dart`.
- Add new tests in `background_sync_service_test.dart`:
    - Verify that HTTP 400 marks item as `invalid`.
    - Verify that `invalid` items are NOT retried in `processQueue`.
    - Verify that `addToQueue` replaces existing `invalid`/`pending` items.

### Manual Verification
- Not applicable in this environment.
