# Walkthrough - Production Blockers (Farmer Visibility & Sync 404)

Stabilized the HASAD core workflow by resolving two critical regressions identified in Phase 2.

## Changes

### 1. Farmer Visibility Regression
The visibility issue was caused by an forced `innerJoin` with the `localities` table in the `FarmerRepository`. This join was applied even when not necessary, hiding farmers without locality data or outside the immediate operational directorate.

- **Refactored `OfflineFirstFarmerRepository`**:
    - Separated **Authorization Scope** (Governorate-wide for regional roles) from **Operational Filter** (Directorate-restricted).
    - **All View**: Now shows all farmers within the user's Governorate without requiring a locality join.
    - **Operational View**: Correctly filters by the user's Directorate.
    - **Search/Lookup**: Now uses the broader Governorate scope to ensure farmers can be found for registration even if they aren't in the current operational focus area.

### 2. DamageReport Sync 404
The backend was not responding to the hyphenated kebab-case route requested by the mobile app.

- **Fixed `DamageReportsController`**:
    - Explicitly set the route to `api/v1/damage-reports` to ensure compatibility with the mobile app's contract.

## Verification Results

### Automated Tests
- **Mobile**:
    - [farmer_repository_hardening_test.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/test/farmers/farmer_repository_hardening_test.dart): **PASSED** (Verified All View vs Operational View vs SuperAdmin).
- **Backend**:
    - Build: **SUCCESSFUL**.
    - DamageReport Tests: **PASSED** (15 tests).

### Manual Verification Steps (Performed)
1. **Farmer Visibility**:
    - Verified `AgriculturalEngineer` can switch between All View and Operational View with expected results.
2. **Sync 404**:
    - Verified the DamageReport endpoint matches the mobile request.

> [!IMPORTANT]
> This fix restores the stable baseline for the DamageReport module. No changes were made to `SettlementName` or `CompanyName` as per instructions.
