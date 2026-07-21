# Implementation Plan - Fix RowVersion Missing in Farmer Updates

Resolve the "RowVersion is required" sync error by ensuring the latest database state (including server-assigned metadata) is passed to the Farmer Form during edits.

## User Review Required

> [!IMPORTANT]
> The root cause of the missing `RowVersion` is that the "Edit" button in the Farmer Details screen was using stale data passed to the screen constructor instead of the reactive data from the database stream. This resulted in an empty `rowVersion` being sent in the update sync payload.

## Proposed Changes

### 1. Presentation Layer Fixes

#### [MODIFY] [farmer_details_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/farmer_details_screen.dart)
- Update the `IconButton` in `AppBar` to use the latest farmer data from `farmerAsync` instead of the stale `widget.farmer`.
- Ensure `_FarmerDetailsBody` passes the reactive `farmer` object to any navigation calls.

### 2. Synchronization Reliability

#### [MODIFY] [remote_farmer_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/remote_farmer_repository.dart)
- Add a safety check in `updateFarmer` to throw an informative local exception if `rowVersion` is missing before attempting a network call.

### 3. Verification & Traceability

- Re-enable `DebugLogger` for a single run to verify the fix.
- Create `sync_update_fix_report.artifact.md` with the verified payload.

## Verification Plan

### Automated Tests
- Run `flutter test test/farmers/farmer_sync_dtos_test.dart` to ensure DTO mapping still works correctly.
- Add a test case to verify `rowVersion` inclusion in the `Update` payload when server metadata is present.

### Manual Verification Flow
1. Create a Farmer offline.
2. Allow sync to complete (observe "Synced" status).
3. Tap "Edit" and change a field.
4. Observe the sync queue or debug logs to confirm `rowVersion` is sent.
5. Verify the backend accepts the update.
