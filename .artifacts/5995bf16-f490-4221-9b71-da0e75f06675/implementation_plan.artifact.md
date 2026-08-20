# Implementation Plan - Harvest System Redesign (Stage 1: Core & Permissions)

This plan implements the first stage of the "Harvest" system redesign as defined in the brainstorming document. The goal is to decouple the Farmer entity from specific directorates and unify authorization logic.

## Proposed Changes

### 1. Backend (Data & API)

#### [MODIFY] [Farmer.cs](file:///hasad/backend/Hasad.Domain/Entities/Farmer.cs)
- Remove `DirectorateId` property.
- Update EF Core configuration to reflect the change.

#### [MODIFY] [CreateFarmerCommand.cs](file:///hasad/backend/Hasad.Application/Features/Farmers/Commands/CreateFarmer/CreateFarmerCommand.cs) & [UpdateFarmerCommand.cs](file:///hasad/backend/Hasad.Application/Features/Farmers/Commands/UpdateFarmer/UpdateFarmerCommand.cs)
- Remove `DirectorateId` from input and logic.
- Remove geographic scope checks for `AgriculturalEngineer` when managing farmers.

#### [MODIFY] [GetFarmersListQuery.cs](file:///hasad/backend/Hasad.Application/Features/Farmers/Queries/GetFarmersList/GetFarmersListQuery.cs)
- Update query to support "Global Search" and "Operational Filter" (joining with Farms table).
- Limit dashboard view to last 10 farmers for non-authorized users.

### 2. Mobile (Flutter & Drift)

#### [MODIFY] [database.dart](file:///hasad/mobile/lib/core/storage/database.dart)
- Increment `schemaVersion` to 34.
- Create migration in `onUpgrade` to drop/ignore `directorateId` in `farmers` table.

#### [MODIFY] [authorization_service.dart](file:///hasad/mobile/lib/core/auth/authorization_service.dart)
- Update `canManageFarmers` to reflect global access for engineers.

#### [MODIFY] [damage_reports_list_screen.dart](file:///hasad/mobile/lib/features/damage_reports/presentation/screens/damage_reports_list_screen.dart)
- Hide Floating Action Button (FAB) if `canCreateDamageReport` is false.

### 3. Workflow & Dates

#### [MODIFY] [damage_report_header_screen.dart](file:///hasad/mobile/lib/features/damage_reports/presentation/screens/damage_report_header_screen.dart)
- Make `documentationDate` editable.
- Add validation: `documentationDate >= damageDate` and no future dates.

## Verification Plan

### Automated Tests
- Run `dotnet test` to ensure backend business rules are intact.
- Run `flutter test` for repository and validation logic.

### Manual Verification
- Verify that a user in Directorate A can edit a farmer who only has farms in Directorate B.
- Verify that the Add Damage Report button is hidden for a ReadOnly user.
- Verify that date validation prevents choosing tomorrow's date.
