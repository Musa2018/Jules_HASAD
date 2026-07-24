# Fix Database Migration Conflict in Terminology Audit

The application is failing to start because of a primary key violation during the application of the `TerminologyAudit` migration. This conflict arises because the migration attempts to insert lookup data (via `InsertData`) into tables that have already been populated by `DbInitializer.SeedDamageReferenceDataAsync`.

## User Review Required

> [!IMPORTANT]
> The proposed fix involves clearing the lookup tables (`DamageCategories`, `DamageSubCategories`, `DamageClassifications`, `DamageNatures`, `DamageActions`, and `MeasurementUnits`) within the migration before re-inserting the audited terminology. This is safe in development, but in a production environment with existing reports, this could temporarily break foreign key constraints or data integrity if not handled carefully. However, given the current project state and the nature of this "Audit" migration, it seems the intended behavior is to re-align these lookup values.

## Proposed Changes

### Infrastructure Layer

#### [MODIFY] [TerminologyAudit.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Migrations/20260724030736_TerminologyAudit.cs)
- Add `migrationBuilder.Sql("DELETE FROM ...")` for the affected lookup tables before the `InsertData` calls.
- This ensures that the migration can cleanly insert the updated terminology without conflicting with existing data from manual seeding.
- Tables to clear: `DamageClassifications`, `DamageSubCategories`, `DamageCategories`, `DamageActions`, `DamageNatures`.
- For `MeasurementUnits`, we will only delete IDs 5 and above before insertion, as 1-4 are updated.

#### [MODIFY] [DbInitializer.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Persistence/Seed/DbInitializer.cs)
- Remove the `SeedDamageReferenceDataAsync` method or the parts that seed tables now managed by EF Core migrations (`HasData`).
- This prevents future conflicts between manual seeding and migration-based seeding.

## Verification Plan

### Manual Verification
- Run `dotnet run --project Hasad.Api` and verify that migrations are applied successfully and the application starts.
- Check the logs for "Database schema is up to date".
- Verify that the terminology in the database matches the new "Audit" values (e.g., `AgriculturalSector` names updated).
