# Sprint 10.2 — Farmers Backend & Schema Enhancement Plan

Enhance the Farmers module backend schema and API contracts to support new demographic fields and search capabilities for the upcoming Search-First workflow.

## User Review Required

> [!IMPORTANT]
> - I will add a `Gender` enum in the Domain layer (`Hasad.Domain.Enums`).
> - `CreatedAt` and `UpdatedAt` will be added directly to the `Farmer` entity to match the pattern seen in `Farm` and `DamageReport`.
> - A new EF Core migration will be created and applied.

## Proposed Changes

### Domain Layer

#### [NEW] [Gender.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Domain/Enums/Gender.cs)
Define a `Gender` enum (e.g., `Male`, `Female`, `Other/PreferNotToSay`).

#### [MODIFY] [Farmer.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Domain/Entities/Farmer.cs)
- Add `Gender Gender { get; set; }`
- Add `int FamilySize { get; set; }`
- Add `DateTime CreatedAt { get; set; }`
- Add `DateTime? UpdatedAt { get; set; }`

---

### Infrastructure Layer

#### [MODIFY] [ApplicationDbContext.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Persistence/ApplicationDbContext.cs)
- Configure `Gender` (likely as an `int` or `string` in DB, I will follow existing patterns). Looking at other entities, enums aren't explicitly converted, so EF will use `int` by default.
- Ensure `CreatedAt` has a default value (e.g., `GETUTCDATE()`).
- Add shadow properties or explicit properties for audit if needed, but since they are in the entity, I'll just map them.

#### [NEW] Migration
Generate and apply a migration named `EnhanceFarmerSchema`.

---

### Application Layer

#### [MODIFY] [FarmerDto.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farmers/Models/FarmerDto.cs)
- Add the new fields.
- Ensure 8-part names are kept as individual fields (already present in the DTO, but I'll make sure they are used correctly).

#### [MODIFY] [CreateFarmerCommand.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farmers/Commands/CreateFarmer/CreateFarmerCommand.cs)
- Update command record to include `Gender` and `FamilySize`.
- Update handler to map these to the entity.
- Update validator to ensure they are required and valid.

#### [MODIFY] [UpdateFarmerCommand.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farmers/Commands/UpdateFarmer/UpdateFarmerCommand.cs)
- Similar updates as `CreateFarmerCommand`.

#### [MODIFY] [GetFarmersListQuery.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farmers/Queries/GetFarmersList/GetFarmersListQuery.cs)
- Add `string? Name` and `string? IdNumber` to the query.
- Update handler to filter the `IQueryable<Farmer>` based on these parameters.
- Search should be case-insensitive and support partial matches.
- Name search should check across all 8 name parts (Ar and En).

---

### Verification Plan

#### Automated Tests
- Run existing `FarmerCommandHandlerTests.cs` and `FarmerValidatorTests.cs`.
- Update tests to cover new fields and search functionality.
- Commands: `dotnet test backend/Hasad.Application.Tests`

#### Manual Verification
- Verify the migration by inspecting the `ApplicationDbContextModelSnapshot.cs`.
- Build the project: `dotnet build backend/Hasad.Api`.
