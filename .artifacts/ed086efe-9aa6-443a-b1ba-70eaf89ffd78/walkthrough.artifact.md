# Walkthrough - DamageReport Workflow Alignment (Sprint 13.1)

I have successfully evolved the `DamageReport` workflow from a simplified 6-stage operational flow into the full 10-stage ministerial workflow defined in **ADR 0012**. This alignment ensures that the system meets production audit and financial payout requirements.

## Key Changes

### 1. Ministerial Workflow Engine
- **10-Stage Flow**: Overhauled `DamageWorkflowService` to support:
  `Draft` -> `TechReview` -> `ArchiveDir` -> `DirManager` -> `MinTechReview` -> `LegalReview` -> `ProcReview` -> `MinArchive` -> `GenManager` -> `Completed`.
- **CanTransition Logic**: Implemented a centralized validation method that integrates role permissions, regional geographic scope, and mandatory comment rules for return paths.
- **Role Expansion**: Added 5 new ministerial roles to `AppRoles.cs` (`LegalReviewer`, `ProceduralReviewer`, `MinistryTechReviewer`, `ChiefArchiveOfficer`, `DirectorateManager`) and configured their regional scopes.

### 2. Data Integrity & Migration
- **Centralized Status**: Created `DamageReportStatus.cs` in the domain layer to eliminate hardcoded strings and ensure consistency across backend and mobile.
- **EF Core Migration**: Implemented a safe migration script (`Sprint13_1_WorkflowAlignment`) that updates existing `DamageReport` status IDs while preserving historical `WorkflowHistory` records for audit purposes.
- **Mapping Table**:
  - `Submitted` -> `TechReview`
  - `TechnicalReview` -> `ArchiveDir`
  - `SupervisorReview` -> `DirManager`
  - `MinistryReview` -> `MinTechReview`
  - `Archive` -> `MinArchive`
  - `Approved` -> `Completed`

### 3. Mobile UI & Localization
- **10-Stage Visibility**: Added Arabic and English translations for all 10 workflow stages.
- **Role-Aware Actions**: Updated `DamageReportDetailsScreen.dart` to support the new transition paths based on the user's role (e.g., `ArchiveOfficer` now handles `ArchiveDir` -> `DirManager`).
- **Audit Consistency**: Updated the history viewer to correctly map both legacy and new status labels for existing reports.

## Verification Results

### Automated Tests
- **Unit Tests**: Updated `DamageWorkflowTests.cs` to verify all 10 forward transitions and mandatory comments for backward paths.
- **Regression**: All 107 existing backend tests passed (including security and data integrity checks).
- **Compilation**: Verified clean build of both Backend (.NET) and Mobile (Flutter/Dart) projects.

### Migration Safety
- **Verified Mapping**: SQL update script strictly follows the approved mapping table.
- **Audit Immobility**: Historical records in `DamageWorkflowHistories` remain unchanged.

## Final Summary
- **Workflow States**: 10 (Draft to Completed).
- **Roles Added**: 5.
- **Tests Added**: Verified full matrix coverage.
- **Remaining Risks**: Clients with pending offline `Submitted` reports may experience a status mismatch upon sync, which the backend shim handles by defaulting to `TechReview`.

render_diffs(file:///hasad/backend/Hasad.Domain/Constants/DamageReportStatus.cs)
render_diffs(file:///hasad/backend/Hasad.Infrastructure/Services/DamageWorkflowService.cs)
render_diffs(file:///hasad/mobile/lib/l10n/app_ar.arb)
render_diffs(file:///hasad/mobile/lib/features/damage_reports/presentation/screens/damage_report_details_screen.dart)
