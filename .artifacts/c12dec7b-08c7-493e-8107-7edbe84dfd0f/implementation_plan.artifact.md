# Implementation Plan: Farmers & Farms UAT Stabilization

Address UAT-004 through UAT-007 to stabilize the foundation for Damage Report implementation. This phase focuses on error transparency, UX standardization, and strict identity uniqueness.

## User Review Required

> [!IMPORTANT]
> **Identity Uniqueness (UAT-007)**: We are enforcing **Global IdentityNumber uniqueness** among active farmers. This is a business rule change. A pre-migration audit is mandatory to identify existing duplicates that would violate the new schema constraint.

> [!WARNING]
> **Migration Safety**: The EF Core migration will only change the schema. It is the responsibility of the system administrator to perform data cleanup using the provided audit script before applying the migration.

## 1. UAT-007: Identity Uniqueness Strategy

### Deployment Sequence
1. **Data Audit**: Administrator executes `IdentityUniquenessAudit.sql`.
2. **Data Cleanup**: Administrator resolves duplicates based on the audit report.
3. **Migration**: Apply EF Core migration to update the unique index.
4. **Verification**: Application handlers and repository validation ensure no new duplicates are created.

### Data Audit Procedure
Administrators must execute the following SQL script to detect active duplicate identity numbers before applying the migration.

#### [NEW] [IdentityUniquenessAudit.sql](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Persistence/deployment/database/IdentityUniquenessAudit.sql)
- **Location**: `hasad/backend/Hasad.Infrastructure/Persistence/deployment/database/`
- **Expected Output**: A table of duplicate `IdentityNumber`s with associated farmer names and locations.
- **Required Action**: Administrators must coordinate with field survey teams to verify which record is correct and either merge or soft-delete the duplicate.

```sql
-- HASAD Identity Uniqueness Audit Script
-- Detects active farmers with duplicate Identity Numbers
-- Instructions: Run this script. If any rows are returned, you MUST resolve them
-- by soft-deleting duplicates or merging records before applying migration Sprint14_UpdateIdentityUniqueness.
WITH ActiveDuplicates AS (
    SELECT IdNumber
    FROM Farmers
    WHERE IsDeleted = 0
    GROUP BY IdNumber
    HAVING COUNT(*) > 1
)
SELECT
    f.IdNumber AS [Identity Number],
    f.Id AS [Farmer Id],
    f.FirstNameAr + ' ' + f.FamilyNameAr AS [Farmer Name],
    it.NameAr AS [Identity Type],
    g.NameAr AS [Governorate],
    dir.NameAr AS [Directorate]
FROM Farmers f
JOIN ActiveDuplicates ad ON f.IdNumber = ad.IdNumber
JOIN IdTypes it ON f.IdTypeId = it.Id
LEFT JOIN Governorates g ON f.GovernorateId = CAST(g.Id AS NVARCHAR(50))
LEFT JOIN Localities l ON f.LocalityId = CAST(l.Id AS NVARCHAR(50))
LEFT JOIN Directorates dir ON l.DirectorateId = dir.Id
WHERE f.IsDeleted = 0
ORDER BY f.IdNumber;
```

### Migration Plan
1. **EF Core**: Schema-only migration. Drop composite index `IX_Farmers_IdTypeId_IdNumber`.
2. **EF Core**: Create new unique filtered index `IX_Farmers_IdNumber` with filter `[IsDeleted] = 0`.
3. **Application**: Update handlers and repository validation to reflect global uniqueness.

---

## 2. UAT-004: Error Propagation Standard

### Exception Propagation Standard
- **Preservation**: Every layer must rethrow exceptions while preserving context.
- **ProblemDetails**: Backend `Result.Failure(errors)` must reach the UI.
- **No Swallowing**: Generic `catch (_)` blocks are prohibited for known operations.

### Resolution
- **Refactor Providers**: Update `FarmerFormNotifier`, `FarmFormNotifier`, etc., to catch `Exception e` and `StackTrace st`.
- **Display**: Use localized messages from `SyncException` or `Drift` errors directly in UI banners.

---

## 3. UAT-005 & UAT-006: Form UX Standard

### Reusable `FormSaveFooter`
Implement a project-wide standard component for all editable forms.

**Features:**
- **Sticky Footer**: Persistent bottom area with shadow and safe-area aware.
- **Validation-Driven UI**: Live binding to `FormState` via `ValueListenableBuilder` or custom listener.
- **Loading State**: Disables interaction and shows progress indicator.

### Regression Review
**Screens with custom save buttons:**
- `FarmerFormScreen`: Migrating NOW.
- `FarmFormScreen`: Migrating NOW.
- `UserFormScreen`: Migrating LATER.
- `DamageReportFormScreen`: Migrating LATER.
- `DamageItemFormSheet`: Migrating LATER.

---

## Proposed Changes

### [Component: UI Framework]

#### [NEW] [form_save_footer.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/presentation/widgets/form_save_footer.dart)
- Reusable sticky footer component.

### [Component: Farmer Module]

#### [MODIFY] [ApplicationDbContext.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Persistence/ApplicationDbContext.cs)
- Redefine unique index for `IdNumber`.

#### [MODIFY] [CreateFarmerCommand.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farmers/Commands/CreateFarmer/CreateFarmerCommand.cs)
- Remove `IdTypeId` from uniqueness check.

#### [MODIFY] [UpdateFarmerCommand.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farmers/Commands/UpdateFarmer/UpdateFarmerCommand.cs)
- Remove `IdTypeId` from uniqueness check.

#### [MODIFY] [farmer_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/farmer_repository.dart)
- Update `_checkUniqueness` and `findByIdNumber` to reflect global uniqueness.

#### [MODIFY] [farmers_providers.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/farmers_providers.dart)
- Improve error handling in `FarmerFormNotifier`.

#### [MODIFY] [farmer_form_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/farmer_form_screen.dart)
- Adopt `FormSaveFooter`.

### [Component: Farm Module]

#### [MODIFY] [farms_providers.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farms/presentation/farms_providers.dart)
- Improve error handling in `FarmFormNotifier`.

#### [MODIFY] [farm_form_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farms/presentation/farm_form_screen.dart)
- Adopt `FormSaveFooter`.

---

## Documentation Updates

#### [MODIFY] [ADR-0017: Global Identity Uniqueness](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/docs/adr/0017-global-identity-uniqueness.md)
- Document the transition to global IdentityNumber uniqueness, migration audit, and deployment sequence.

#### [MODIFY] [PROJECT_STATUS.md](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/PROJECT_STATUS.md)
- Record the UAT hardening completion and architectural refinements.

---

## Verification Plan

### Automated Tests
- `dotnet test`: Verify unique index enforcement and command handler logic.
- `flutter test`: Verify `FormSaveFooter` reactive states and Repository uniqueness checks.

### Manual Verification
1. Run SQL Audit Script on target database.
2. Verify "Sticky Save" on long forms.
3. Verify button turns RED on validation failure.
4. Verify backend validation error (e.g., duplicate ID) reaches UI with the real message.
