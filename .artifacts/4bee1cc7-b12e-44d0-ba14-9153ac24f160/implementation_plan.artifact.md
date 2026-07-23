# Fix SQL Server Migration Error (Filtered Index Syntax)

The database migration `20260722071132_RedesignFarmModule` is failing because it uses PostgreSQL-style syntax for filtered indexes (`"IsDeleted" = false`), while the application is now targeting SQL Server. SQL Server requires `[IsDeleted] = 0` for boolean filters.

## User Review Required

> [!IMPORTANT]
> This change assumes the project is fully committed to using SQL Server. If multi-provider support is needed, a different approach (like provider-specific configuration in `OnModelCreating`) would be required. However, the current logs show a direct connection to a SQL Server instance.

## Proposed Changes

### [Persistence Layer]

#### [MODIFY] [ApplicationDbContext.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Persistence/ApplicationDbContext.cs)
- Update `HasFilter` calls to use SQL Server syntax: `[IsDeleted] = 0`.

#### [MODIFY] [20260722071132_RedesignFarmModule.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Migrations/20260722071132_RedesignFarmModule.cs)
- Update `filter` parameters in `CreateIndex` calls to `[IsDeleted] = 0`.

#### [MODIFY] [20260722071132_RedesignFarmModule.Designer.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Migrations/20260722071132_RedesignFarmModule.Designer.cs)
- Update `HasFilter` metadata to `[IsDeleted] = 0`.

#### [MODIFY] [ApplicationDbContextModelSnapshot.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Migrations/ApplicationDbContextModelSnapshot.cs)
- Update `HasFilter` metadata to `[IsDeleted] = 0`.

## Verification Plan

### Automated Tests
- Run `dotnet run --project Hasad.Api` to verify that migrations apply successfully.

### Manual Verification
- Check the database schema using a SQL tool to ensure `IX_Farmers_ClientId` and `IX_Farmers_IdTypeId_IdNumber` are created with the correct filter.
