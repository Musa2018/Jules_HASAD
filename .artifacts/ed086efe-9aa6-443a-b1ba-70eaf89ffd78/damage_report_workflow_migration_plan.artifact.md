# DamageReport Workflow Migration Plan

This document outlines the strategy for evolving the current simplified 6-stage operational workflow into the full 10-stage ministerial workflow defined in **ADR 0012**.

## 1. Workflow Analysis

### Current Workflow (Simplified)
`Draft` --(Eng)--> `Submitted` --(TechRev)--> `TechnicalReview` --(TechRev)--> `SupervisorReview` --(Supervisor)--> `MinistryReview` --(MinistryRev)--> `Archive` --(ArchiveOff)--> `Approved`.

### Target Workflow (Ministerial - ADR 0012)
1.  **Draft**: Initial state (Eng/Surveyor).
2.  **TechReview**: Awaiting technical verification (TechReviewer).
3.  **ArchiveDir**: Awaiting directorate document verification (ArchiveOfficer).
4.  **DirManager**: Awaiting directorate-level approval (Director/Supervisor).
5.  **MinTechReview**: Awaiting ministry technical validation (MinTechReviewer).
6.  **LegalReview**: Awaiting legal validation (LegalReviewer).
7.  **ProcReview**: Awaiting procedural validation (ProceduralReviewer).
8.  **MinArchive**: Awaiting central archival processing (ChiefArchiveOfficer).
9.  **GenManager**: Awaiting final sign-off (GeneralManager).
10. **Completed**: Final immutable technical record.

---

## 2. Status Mapping & Data Migration

To maintain continuity for existing records, a data migration is required for the `DamageReports.StatusId` column. **WorkflowHistory** records will remain unchanged to preserve the historical audit trail.

| Old Status | New Status | Target Responsible Role |
| :--- | :--- | :--- |
| `Draft` | `Draft` | AgriculturalEngineer |
| `Submitted` | `TechReview` | TechnicalReviewer |
| `TechnicalReview` | `ArchiveDir` | ArchiveOfficer |
| `SupervisorReview` | `DirManager` | DirectorateManager (Director) |
| `MinistryReview` | `MinTechReview` | MinistryTechReviewer |
| `Archive` | `MinArchive` | ChiefArchiveOfficer |
| `Approved` | `Completed` | System |

---

## 3. Role & Permission Impact

New roles must be added to `AppRoles.cs` and integrated into the regional scoping logic.

### Missing Roles
- **MinistryTechReviewer**: Global Scope (Replacing MinistryReviewer).
- **LegalReviewer**: Global Scope.
- **ProceduralReviewer**: Global Scope.
- **ChiefArchiveOfficer**: Global Scope.
- **DirectorateManager**: Directorate/Governorate Scope (Mapping to `Director`).

---

## 4. Implementation Phases (Sprint 13.1)

### Phase 1: Domain Constants
- Create `DamageReportStatus` constants in `Hasad.Domain`.
- Map all current hardcoded strings to these constants.

### Phase 2: Workflow Service Overhaul
- Rewrite `DamageWorkflowService.IsTransitionValid` to implement the 10-stage matrix.
- Implement mandatory comment validation for all "Return" (backward) transitions.

### Phase 3: Role Hardening
- Update `AppRoles.cs` with the new ministerial roles.
- Update `ICurrentUserService` and regional scope validation to handle new roles.

### Phase 4: Data Migration (Backend)
- Create EF Core migration script to update `StatusId` for active reports based on the mapping table.

### Phase 5: Mobile Alignment
- Update Flutter `DamageReport` model and localization.
- Update `DamageReportDetailsScreen` transition buttons to reflect new stages.

---

## 5. Risks & Mitigation

- **Historical Integrity**: We will NOT modify existing `DamageWorkflowHistory` status strings. The UI history viewer must be updated to handle both old and new status labels (legacy mapping).
- **Sync Interruption**: If a client has an offline update pending with an "Old" status, the backend `UpdateDamageReportCommand` must include a compatibility shim or the client must be forced to refresh.
- **UI Complexity**: The transition from 6 to 10 stages increases the vertical length of the workflow history. A "Stages" stepper UI is recommended.
