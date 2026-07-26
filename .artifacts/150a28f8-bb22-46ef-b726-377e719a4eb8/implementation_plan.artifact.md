# Implementation Plan - HASAD Production Blockers Fix

Restore stability to the HASAD workflow by fixing the Farmer visibility regression and the DamageReport sync 404 error.

## User Review Required

> [!IMPORTANT]
> **Authorization Scope for Farmers**: I am assuming the "Authorization Scope" for an `AgriculturalEngineer` for the Farmer entity is **Governorate-wide** in "All View", but **Directorate-restricted** in "Operational View". This allows engineers to find any farmer in their district to register them, while focusing on their local area for daily operations.

> [!WARNING]
> This fix avoids modifying the `innerJoin` in the Operational view to ensure data integrity, but it fixes the "All View" by removing the join entirely when not filtering by Directorate.

## Proposed Changes

### [Component] Mobile Farmer Visibility Fix

#### [MODIFY] [farmer_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/farmer_repository.dart)
- Update `getFarmers` and `watchFarmers` to distinguish between **Authorization Scope** and **Operational Display Filter**.
- **All View** (`isOperational: false`):
    - Remove the `innerJoin` with `localities` to prevent "silent filtering" of farmers with missing locality data.
    - Apply `governorateId` filter as the mandatory Authorization Scope for `AgriculturalEngineer` and `FieldSurveyor`.
- **Operational View** (`isOperational: true`):
    - Preserve the `innerJoin` with `localities` and filter by `directorateId` as per the operational requirement: `Farmer -> Locality -> Directorate`.
- Ensure `SuperAdmin` and `Administrator` roles continue to see all farmers (Global scope).

### [Component] Backend DamageReport Sync Fix

#### [MODIFY] [DamageReportsController.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Api/Controllers/DamageReportsController.cs)
- Explicitly define the route as `api/v1/damage-reports` to match the mobile app's kebab-case request and resolve the 404 error.

## Verification Plan

### Automated Tests
- **Mobile**: Update `farmer_repository_hardening_test.dart` to include:
    - Test proving `isOperational: false` shows farmers across the Governorate.
    - Test proving `isOperational: true` filters by Directorate.
    - Test proving `SuperAdmin` sees all farmers regardless of `isOperational` (unless they choose to filter).
- **Backend**: Verify the controller route via a simple integration test if applicable, or manual verification of the endpoint mapping.

### Manual Verification
1. **Farmer Visibility**:
    - Login as `AgriculturalEngineer`.
    - Check "All View" -> Verify farmers from multiple localities in the same governorate are visible.
    - Toggle "Operational View" -> Verify only farmers in the assigned Directorate are visible.
2. **Sync Verification**:
    - Create a DamageReport header on mobile.
    - Trigger Sync.
    - Verify the request to `/api/v1/damage-reports` returns `200 OK` and the record is marked as `completed` locally.
