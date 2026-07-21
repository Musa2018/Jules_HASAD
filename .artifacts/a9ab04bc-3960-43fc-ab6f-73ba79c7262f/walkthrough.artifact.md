# Walkthrough - Sprint 10.14: Update Sync & Metadata Hardening

Successfully hardened the Farmer Update synchronization flow by ensuring all entities correctly preserve server-side metadata and use strict DTO mapping. This resolves previous sync failures caused by Authority ID mismatches and payload pollution.

## Changes Made

### Universal Metadata Parity
- **[MODIFY] Domain Models**: Added `serverId`, `syncStatus`, and `lastSyncError` to `Farm`, `DamageReport`, `DamageItem`, and `DamageReportAttachment`.
- This ensures that once a record is created on the server, its Authority ID is available in the domain layer for subsequent updates, rather than relying only on the local `id` (ClientId).

### Hardened DTO Mapping
- **[MODIFY] [farmer_sync_dtos.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/farmer_sync_dtos.dart)**: Updated all `toUpdateJson` methods to prioritize `serverId` for the `id` field in the API contract.
- Verified that `rowVersion` (Concurrency Token) is correctly included in all update payloads to support optimistic concurrency control.

### Repository Refactoring
- **[MODIFY] Offline Repositories**: Updated `OfflineFirstFarmRepository` and `OfflineFirstDamageReportRepository` to correctly map the new sync metadata fields during local database operations.
- Implemented clearing of `lastSyncError` on record update to ensure clean retry state for corrected data.

### Sync Lifecycle Reliability
- **[MODIFY] [background_sync_service.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/background_sync_service.dart)**: Verified that the service correctly captures the `serverId` and `rowVersion` returned from the API after creation and persists them to the local database.

## Verification Results

### Automated Tests
- **[MODIFY] [farmer_sync_dtos_test.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/test/farmers/farmer_sync_dtos_test.dart)**: Added scenarios for `Update` operations for all entities, verifying Authority ID mapping and `rowVersion` inclusion.
- Full sync test suite (including `BackgroundSyncService` and `OfflineFirstFarmerRepository`): **31 tests passed**.
- **Result**: `flutter analyze` reports `No issues found!`.

### Captured Update Payload (Example)
```json
{
  "id": "remote-uuid-from-server",
  "clientId": "local-uuid-1234",
  "birthDate": "1985-05-10",
  "gender": 1,
  "rowVersion": "AAAAAAAAB98="
}
```

## Root Cause Summary
Previously, `Update` operations for Farms and Damage Reports were sending the local `id` (ClientId) to the backend's `/v1/{entity}/{id}` endpoint. Since the backend expects the database `Id` (Authority ID), these requests were failing with `404 Not Found`. By adding `serverId` to the domain models and prioritizing it in the DTO layer, we have established a correct Authority ID mapping flow.
