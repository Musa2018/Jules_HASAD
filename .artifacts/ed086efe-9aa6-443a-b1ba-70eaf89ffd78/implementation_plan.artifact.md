# Implementation Plan - DamageReport Workflow Alignment (Sprint 13.1)

Align the `DamageWorkflowService` and `AppRoles` with the 10-stage ministerial workflow defined in **ADR 0012**.

## Status Mapping Table

| Old Status | New Status | Migration Reason |
| :--- | :--- | :--- |
| `Draft` | `Draft` | Continuity of initial state. |
| `Submitted` | `TechReview` | Terminology alignment with Technical Reviewers. |
| `TechnicalReview` | `ArchiveDir` | Alignment with Directorate-level document verification stage. |
| `SupervisorReview` | `DirManager` | Explicit Directorate/Governorate Management stage. |
| `MinistryReview` | `MinTechReview` | Headquarters Technical Review stage. |
| `Archive` | `MinArchive` | Central Ministry Archival stage. |
| `Approved` | `Completed` | Definition of final immutable state. |

## Role Expansion Plan

| Role Name | Purpose | Scope |
| :--- | :--- | :--- |
| `LegalReviewer` | Legal validation of assessment and ownership docs. | **Global** |
| `ProceduralReviewer` | Verification of ministerial procedures compliance. | **Global** |
| `MinistryTechReviewer` | Technical oversight at the central ministry level. | **Global** |
| `ChiefArchiveOfficer` | Final central document audit and archival. | **Global** |
| `DirectorateManager` | Approval of reports within assigned region. | **Governorate** |

## Implementation Phases

### Phase 1: Backend Status Model and Workflow Engine
1.  **Define Constants**: Create `DamageReportStatus.cs` in `Hasad.Domain`.
2.  **Update Roles**: Add new roles to `AppRoles.cs` and configure their scopes.
3.  **Refactor Workflow Service**:
    - Update `IsTransitionValid` with the full 10-stage matrix.
    - Implement the `CanTransition` logic integrating role, scope, and comment rules.

### Phase 2: Backend Tests
1.  **New Transition Tests**: Verify every forward path in the 10-stage flow.
2.  **Return Path Tests**: Verify mandatory comments for all backward transitions.
3.  **Security/Scope Tests**: Ensure `DirManager` cannot approve reports outside their Governorate.

### Phase 3: Database Migration
1.  **EF Migration**: Update existing `DamageReport.StatusId` values based on the mapping table.
2.  **Audit Integrity**: Verify that `DamageWorkflowHistory` records are NOT modified.

### Phase 4: API Contract Verification
1.  Verify `DamageReportDto` consistency.
2.  Ensure `CreateDamageReportCommand` defaults to `Draft` (consistent with new engine).

### Phase 5: Flutter Update
1.  **Localization**: Add Arabic/English strings for all 10 stages.
2.  **Models**: Update status handling in `damage_report.dart`.
3.  **UI**: Update the stepper/status display in `DamageReportDetailsScreen`.

## User Review Required

> [!IMPORTANT]
> **WorkflowHistory Immobility**: Historical transitions will still point to old status IDs. The UI must handle both old and new status keys for localization to avoid "empty" status labels for old reports.

> [!WARNING]
> **Backward Compatibility**: Any client currently holding an offline report with status `Submitted` will find that their next sync (which might be an `Update`) will need to handle the backend transition to `TechReview`.
