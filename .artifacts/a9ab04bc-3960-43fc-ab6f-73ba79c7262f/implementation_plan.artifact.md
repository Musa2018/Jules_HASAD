# Implementation Plan - Sprint 10.11: Sync Lifecycle Consistency & Soft-Delete

Achieve end-to-end synchronization consistency across all HASAD entities by fixing the broken delete lifecycle and generalizing sync logic.

## User Review Required

> [!IMPORTANT]
> This change involves a Drift database schema upgrade to **v9**. A new `isPendingDelete` column will be added to all tracked entities to support offline deletions without losing data integrity before remote sync.

## Proposed Changes

### 1. Storage & Persistence

#### [MODIFY] [database.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/database.dart)
- Increment `schemaVersion` to **9**.
- Add `isPendingDelete` boolean column (default `false`) to:
    - `Farmers`, `Farms`, `DamageReports`, `DamageItems`, `DamageReportAttachments`.
- Update `onUpgrade` to handle the v9 migration.

#### [MODIFY] [background_sync_service.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/background_sync_service.dart)
- Refactor `addToQueue` to handle lifecycle collapsing:
    - **CREATE + DELETE**: If an existing `pending` CREATE is deleted, remove both the task and the local record immediately (it never reached the server).
    - **UPDATE + DELETE**: If an existing `pending`/`failed`/`invalid` UPDATE is deleted, change the operation to DELETE.
- Generalize "CREATE preservation": The existing logic already works for all entities based on `entityType` and `localId`. I will ensure it stays robust.

### 2. Domain & Data Layer

#### [NEW] [sync_exceptions.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/exceptions/sync_exceptions.dart)
- Define `SyncValidationException` extending a base `SyncException`.

#### [MODIFY] [remote_farmer_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/remote_farmer_repository.dart) (and others)
- Replace `FarmerValidationException` with the generic `SyncValidationException`.
- Ensure all remote repositories throw this on HTTP 400.

#### [MODIFY] [farmer_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/farmer_repository.dart) (and others)
- Update `deleteFarmer`:
    - Instead of hard delete, update `isPendingDelete = true` and `syncStatus = 'pending'`.
    - Add `delete` task to `SyncQueue`.
- Update `getFarmers` (list): Filter out items where `isPendingDelete` is true.

### 3. Sync Engine Hardening

#### [MODIFY] [background_sync_service.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/background_sync_service.dart)
- Update `_syncFarmer` (and others) for `delete` operation:
    - Perform remote DELETE call.
    - On success: **Hard delete** local record from Drift.
- Update `_processItem` to handle `SyncValidationException` generically for all entity types.

## Verification Plan

### Automated Tests
- **Delete Lifecycle Test**:
    - [x] Synced Farmer → Delete Offline → Sync → Verified Hard Deleted locally.
    - [x] New Farmer → Delete Offline (Before Sync) → Verified Task and Record removed immediately.
- **Generic Collapsing Test**:
    - [x] Farm CREATE → Edit Offline → Verify operation stays CREATE.
- **Validation Test**:
    - [x] Any entity → HTTP 400 → Verify INVALID status and no retry.

### Manual Verification
- Verify that deleted farmers disappear from the list immediately (due to `isPendingDelete` filter) but remain in the database until sync.
- Verify safe migration from v8 to v9.

## Conflict Handling Review (Documentation)
Currently, HASAD uses a **"Server Wins"** strategy:
1. When an `Update` fails with `409 Conflict` (RowVersion mismatch).
2. `BackgroundSyncService._resolveConflict` is triggered.
3. It fetches the latest record from the server and overwrites the local Drift record.
4. **Risk**: The user's local changes are lost without notification.
5. **Future Work**: Implement a "Conflict Resolution UI" to allow users to merge or choose between local/server versions.
