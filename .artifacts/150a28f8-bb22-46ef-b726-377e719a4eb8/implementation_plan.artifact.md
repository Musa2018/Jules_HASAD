# Implementation Plan - Offline-First Pull Synchronization (Farmers & Farms)

Restore visibility and consistency for Farmers and Farms on fresh installations and multi-device scenarios by implementing an incremental pull synchronization mechanism.

## User Review Required

> [!IMPORTANT]
> **Architectural Separation**: As requested, Pull Synchronization will be handled by a dedicated `PullSyncCoordinator`, separate from the existing `BackgroundSyncService` (which focuses on pushing local changes). This maintains the "Push vs Pull" responsibility boundary.

> [!CAUTION]
> **Unsynced Data Protection**: During the Pull process, any local records with statuses other than `completed`, `failed`, or `invalid` (e.g., `pending`, `syncing`, `conflict`, or `isPendingDelete`) will be strictly preserved. The pull logic will NOT overwrite these records to prevent losing unsynced field work.

## Proposed Changes

### [Backend] Authoritative Scoping & Sync Support

#### [MODIFY] [GetFarmersListQuery.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farmers/Queries/GetFarmersList/GetFarmersListQuery.cs)
- Add `DateTime? UpdatedSince` parameter.
- Inject `ICurrentUserService`.
- **Authorization**: Apply mandatory `Where(f => f.GovernorateId == _currentUser.GovernorateId)` for regional roles.
- **Filtering**: Add `Where(f => f.UpdatedAt > request.UpdatedSince || f.CreatedAt > request.UpdatedSince)`.

#### [NEW] `GetFarmsListQuery.cs`
- Implement a paginated list for Farms.
- **Authorization**: Apply mandatory `Where(f => f.DirectorateId == _currentUser.DirectorateId)` for regional roles.
- Support `UpdatedSince` watermarking.

#### [MODIFY] [FarmsController.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Api/Controllers/FarmsController.cs)
- Add `[HttpGet]` endpoint for the new `GetFarmsListQuery`.

---

### [Mobile] Sync Core & Infrastructure

#### [MODIFY] [database.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/database.dart)
- Increment `schemaVersion` to **23**.
- **[NEW] `SyncMetadata` Table**:
    - `entityName` (TEXT, Primary Key)
    - `lastSyncedAt` (DATETIME, Nullable)
    - `lastSyncStatus` (TEXT)
    - `lastSyncError` (TEXT, Nullable)
- Implement schema migration strategy.

#### [NEW] `PullSyncCoordinator`
- A dedicated service responsible for:
    - Managing `SyncMetadata` state.
    - Orchestrating the order of entity pulls (Farmers must pull before Farms due to relational dependencies).
    - Handling pagination loops.
    - Reporting overall pull progress.

#### [MODIFY] [BackgroundSyncService](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/background_sync_service.dart)
- Act as the top-level orchestration layer.
- Trigger `PullSyncCoordinator.synchronizeAll()` upon app initialization or login.

---

### [Mobile] Repository Enhancements

#### [MODIFY] Farmer & Farm Repositories
- Implement a standardized `synchronize()` method in the `OfflineFirst` implementations.
- **Protection Logic**:
    - Use `_db.farmers.id.isNotIn(...)` or check each item before upsert.
    - Do NOT call `insertOnConflictUpdate` for any local record where `syncStatus` is `pending`, `syncing`, or `conflict`, or where `isPendingDelete` is `true`.

---

### [Mobile] UI Integration

#### [MODIFY] [farmers_list_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/farmers_list_screen.dart)
#### [MODIFY] [farms_list_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farms/presentation/farms_list_screen.dart)
- Wrap lists in `RefreshIndicator`.
- Trigger the respective repository's `synchronize()` method.

## Verification Plan

### Automated Tests
- **Pull Logic**: Verify that `synchronize()` correctly skips records with `pending` status.
- **Watermarking**: Verify the `SyncMetadata` is updated only after a successful full pull.
- **Backend**: Verify `GetFarmersListQuery` respects the `GovernorateId` filter.

### Manual Verification
1. **Fresh Install**: Clear app data, login, and verify data starts appearing without manual intervention.
2. **Offline Mode**: Ensure previously pulled data is visible while offline.
3. **Idempotency**: Perform manual refresh and verify no duplicate cards appear.
4. **Auth Scope**: Login with different regional users and verify only their data is pulled.
