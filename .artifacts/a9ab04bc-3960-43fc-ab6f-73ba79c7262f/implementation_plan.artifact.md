# Implementation Plan - Sprint 10.14: Entity Metadata Hardening & Update Sync Fix

Resolve synchronization failures for `Update` operations by ensuring all entities preserve server-side metadata (`serverId`, `rowVersion`) and use strictly mapped DTOs.

## User Review Required

> [!IMPORTANT]
> I will add `serverId`, `syncStatus`, and `lastSyncError` to the `Farm`, `DamageReport`, and `DamageItem` domain models. This is necessary to correctly map the server's Authority ID during updates, preventing `404 Not Found` errors.

## Proposed Changes

### 1. Domain Model Refinement

#### [MODIFY] [farm.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/domain/farm.dart)
#### [MODIFY] [damage_report.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/domain/damage_report.dart)
#### [MODIFY] [damage_item.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/domain/damage_item.dart)
- Add `String? serverId`.
- Add `String? lastSyncError`.
- Ensure `@Default('completed') String syncStatus` is present.

### 2. DTO Mapping Fixes

#### [MODIFY] [farmer_sync_dtos.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/farmer_sync_dtos.dart)
- `FarmSyncDto.toUpdateJson`: Change `'id': farm.id` to `'id': farm.serverId ?? farm.id`.
- `DamageReportSyncDto.toUpdateJson`: Change `'id': report.id` to `'id': report.serverId ?? report.id`.
- `DamageReportSyncDto.itemToUpdateJson`: Change `'id': item.id` to `'id': item.serverId ?? item.id`.

### 3. Repository Mapping Updates

#### [MODIFY] [offline_first_farm_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/offline_first_farm_repository.dart)
#### [MODIFY] [offline_first_damage_report_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/offline_first_damage_report_repository.dart)
- Update `_mapToDomain` and `_mapToCompanion` to handle `serverId`, `syncStatus`, and `lastSyncError`.
- Ensure `lastSyncError` is cleared on `update` (just as implemented for Farmers in 10.10).

### 4. Background Sync Service Hardening

#### [MODIFY] [background_sync_service.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/background_sync_service.dart)
- Ensure successful `create` operations for Farm/Report/Item correctly update the local record with the returned `serverId` and `rowVersion`.

## Verification Plan

### Automated Tests
- Run `flutter pub run build_runner build`.
- Update `farmer_sync_dtos_test.dart` to verify `Update` payloads for all entities.
- Run the full test suite in `background_sync_service_test.dart`.

### Manual Verification Flow
1. Create a Farm offline.
2. Sync to server.
3. Confirm `serverId` is stored in the local DB.
4. Edit the Farm offline.
5. Sync again and verify the `PUT` request uses the `serverId`.
