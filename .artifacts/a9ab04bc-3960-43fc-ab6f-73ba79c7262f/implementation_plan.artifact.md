# Implementation Plan - Soft Delete & Duplicate ID Fix

Harden the Farmer Soft Delete workflow to allow reusing ID numbers from deleted records for new creations.

## User Review Required

> [!IMPORTANT]
> This change introduces a **Global Query Filter** on the backend for the `Farmer` entity. Standard queries will now ignore deleted records by default. I will also update the unique database indexes to be **Partial Indexes**, which only enforce uniqueness among non-deleted records.

## Proposed Changes

### 1. Backend (ASP.NET Core)

#### [MODIFY] [ApplicationDbContext.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Persistence/ApplicationDbContext.cs)
- Add a Global Query Filter for the `Farmer` entity: `builder.Entity<Farmer>().HasQueryFilter(f => !f.IsDeleted);`.
- Update the unique index on `(IdTypeId, IdNumber)` to be partial: `.HasFilter("\"IsDeleted\" = false")`.
- Update the unique index on `ClientId` to be partial: `.HasFilter("\"IsDeleted\" = false")`.

#### [NEW] [Migration: FilterFarmerIndexes]
- Generate a new EF Core migration to apply the index changes to the physical database.

### 2. Flutter (Mobile)

#### [MODIFY] [farmer_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/farmer_repository.dart)
- Update `findByIdNumber` query to include `& t.isPendingDelete.equals(false)`.
- This ensures that if a user searches for an ID that was previously used by a deleted farmer, the system starts a fresh creation flow instead of loading the old record.

### 3. Verification & Regression Tests

#### [NEW] [soft_delete_workflow_test.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/test/farmers/soft_delete_workflow_test.dart)
- Scenario:
    1. Create a farmer (ID: 123).
    2. Soft delete the farmer (marks `isPendingDelete: true`).
    3. Create a new farmer with same ID (ID: 123).
    4. Verify both records exist in the DB (one deleted, one active).
    5. Verify sync behavior (handled by existing service, but ensures new creation is queued).

## Verification Plan

### Automated Tests
- **Flutter**: Run `flutter test test/farmers/soft_delete_workflow_test.dart`.
- **Backend**: Run `dotnet test`.

### Manual Verification
1. Create a farmer with ID `949585335`.
2. Sync to server.
3. Delete the farmer from the UI.
4. Attempt to add a new farmer with the same ID `949585335`.
5. Verify the form is empty and a new record is created.
6. Verify synchronization succeeds on the backend.
