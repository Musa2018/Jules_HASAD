# ADR 0012: Damage Report Architecture & Workflow Design

## Status
Accepted

## Context
The project requires a production-grade Damage Assessment module (Sprint 12) to replace existing placeholders. This module must handle complex hierarchies, costing, and a multi-stage ministry workflow.

## Decision

### 1. Offline Identification Strategy
To ensure offline usability without duplicate numbers, we adopt a two-phase identification strategy:
- **Phase 1 (Offline)**: Generate a `TemporaryFormNumber` (format: `TEMP-YYYYMMDD-XXXX` where XXXX is a random suffix). This number is searchable and appears on all mobile views.
- **Phase 2 (Sync)**: Upon synchronization, the backend generates a `PermanentFormNumber` (format: `Sequential-Directorate-Year`). The `ClientId` (UUID) remains the immutable primary key for relational integrity.
- **UI Update**: Once synced, the permanent number replaces the temporary one in the UI, but the temporary number is kept in an audit field for search history.

### 2. Duplicate Prevention Rule
- **Scope**: A "Duplicate" is defined as `Same FarmId + Same DamageDate`.
- **Backend Enforcement**: A unique index `UIX_Farm_DamageDate` will be applied (filtered for non-deleted records).
- **Conflict Handling**: 
  - If a sync conflict occurs (409), the backend returns the `serverId` of the existing record.
  - The `BackgroundSyncService` will implement a **Merge-to-Authority** strategy, overwriting the local draft with the authoritative server record to prevent data fragmentation.

### 3. Workflow State Machine
The workflow is implemented as a rigid state machine. Transitions are restricted by role.

| State | Responsible Role | Actions | Return Path |
| :--- | :--- | :--- | :--- |
| **Draft** | AgriculturalEngineer | Create, Edit, Submit | N/A |
| **TechReview** | TechnicalReviewer | Verify, Request Change | -> Draft |
| **ArchiveDir** | ArchiveOfficer | Attach Docs, Verify Docs | -> TechReview |
| **DirManager** | DirectorateManager | Approve, Reject | -> ArchiveDir |
| **MinTechReview**| MinistryTechReview | Technical Validation | -> DirManager |
| **LegalReview** | LegalReviewer | Legal Validation | -> MinTechReview |
| **ProcReview** | ProceduralReviewer | Procedural Validation | -> LegalReview |
| **MinArchive** | ChiefArchiveOfficer | Final Document Audit | -> ProcReview |
| **GenManager** | GeneralManager | Final Sign-off | -> Any Previous |
| **Completed** | System | Read-Only | N/A |

### 4. General Manager Override
- The General Manager (GM) possesses `WorkflowOverridePermission`.
- **Action**: GM can use the `DirectRoute` command to move a report to any state.
- **Audit**: Every override is recorded in `WorkflowHistory` with a mandatory `Reason` and flagged as `IsOverride = true`.

### 5. Costing & Pricing Engine
- **Hierarchy**: `Nature -> Category -> SubCategory -> Classification -> Version`.
- **Snapshot Pattern**: To preserve historical integrity, `DamageItem` stores:
  - `CostingSheetVersionId` (FK)
  - `CalculatedUnitPrice` (Decimal)
- **Calculation**: Total Loss is a computed field: `Quantity * Price * (Percentage / 100)`.

### 6. Financial Separation
- **DamageItem**: Technical calculation of loss based on field observation.
- **Agricultural Assistance Entity**: Separate entity created after `LegalReview`. 
  - `CalculatedAmount` (from report).
  - `ApprovedAmount` (modified by GM/Finance).
  - This ensures the technical record remains unchanged even if the financial payout is adjusted.

### 7. Attachment Architecture
- **Archive Lock**: After a report enters `TechReview`, only users with `Archive` roles can add or remove attachments.
- **Sync**: Multi-part background upload. `Attachment` entity tracks `UploadStatus` (Pending, Success, Failure).

### 8. Database Migration
- Placeholder tables (`DamageReports`, `DamageItems`) will be migrated using EF Core Migrations.
- Existing data will be mapped to a default `Legacy` category in the new classification system to maintain referential integrity.

## Consequences
- Requires a significant update to the `BackgroundSyncService` to handle `409 Conflict` specifically for Damage Reports.
- Requires new lookup tables and hierarchical data entry forms in Flutter.
- Increased complexity in role-based UI (conditional visibility of "Approve/Return" buttons).
