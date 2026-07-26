# Implementation Plan: DamageReport Module (Sprint 12)

## Goal
Implement a production-grade Damage Assessment system that supports complex item hierarchies, versioned costing sheets, a 10-stage workflow engine, and offline-first reliability.

---

## User Review Required

- **Sequential Numbering**: Permanent Form Numbers are generated server-side. Mobile uses `TEMP-YYYYMMDD-XXXX` for offline referencing.
- **Workflow State Machine**: A 10-stage rigid state machine is enforced. Transitions are audited in `DamageWorkflowHistory`.
- **General Manager Override**: GM has specific `WorkflowOverridePermission` for administrative routing with mandatory audit reasons.
- **Duplicate Prevention**: Unique index on `FarmId + DamageDate`. Conflict resolution follows "Authority Wins" with user notification.

---

## Proposed Changes

### 1. Domain & Database (Backend)

#### [MODIFY] [DamageReport.cs](file:///hasad/backend/Hasad.Domain/Entities/DamageReport.cs)
- Add `FormNumber` (string, unique).
- Add `TemporaryFormNumber` (string).
- Add `DamageYear` (int).
- Add `DamageTypeId` (Political / Natural).
- Add `DamageCauseId` (FK to `DamageCause`).
- Add `SettlementName`, `CompanyName` (conditional).
- Rename `StatusId` to `CurrentStageId`.

#### [NEW] [DamageWorkflowHistory.cs](file:///hasad/backend/Hasad.Domain/Entities/DamageWorkflowHistory.cs)
- `DamageReportId`, `FromStage`, `ToStage`, `UserId`, `ActionDate`, `Reason`, `Notes`, `IsOverride`.

#### [NEW] [Compensation.cs](file:///hasad/backend/Hasad.Domain/Entities/Compensation.cs)
- `DamageReportId`, `CalculatedAmount`, `ApprovedAmount`, `Status`, `ApprovedById`.

#### [NEW] [DamageClassification.cs](file:///hasad/backend/Hasad.Domain/Entities/DamageClassification.cs)
- 5-level hierarchy: `Nature` -> `Category` -> `SubCategory` -> `FinalClassification`.
- Link to `CostingSheet`.

#### [NEW] [CostingSheet.cs](file:///hasad/backend/Hasad.Domain/Entities/CostingSheet.cs)
- `ClassificationId`, `UnitPrice`, `EffectiveFrom`, `EffectiveTo`, `IsActive`.

#### [NEW] [DamageWorkflowHistory.cs](file:///hasad/backend/Hasad.Domain/Entities/DamageWorkflowHistory.cs)
- `DamageReportId`, `FromStage`, `ToStage`, `UserId`, `ActionDate`, `Reason`, `Notes`.

---

### 2. Workflow Engine

| Stage | Role Permission | Allowed Transitions |
| :--- | :--- | :--- |
| **Draft** | AgriculturalEngineer | -> DirectorateReview |
| **DirectorateReview** | TechnicalReviewer | -> DirectorateArchive, -> Draft (Return) |
| **DirectorateArchive** | ArchiveOfficer | -> DirectorateManager, -> DirectorateReview (Return) |
| **DirectorateManager** | DirectorateManager | -> MinistryReview, -> DirectorateArchive (Return) |
| **... (Ministry Stages)** | ... | ... |

---

### 3. Mobile (Flutter)

#### [MODIFY] [database.dart](file:///hasad/mobile/lib/core/storage/database.dart)
- Update `DamageReports` and `DamageItems` tables to match new schema.
- Add lookup tables for `DamageCauses`, `DamageClassifications`, and `CostingSheets`.

#### [NEW] [damage_calculation_service.dart](file:///hasad/mobile/lib/features/damage_reports/presentation/damage_calculation_service.dart)
- Real-time UI calculation: `Total = Quantity * UnitPrice * (DamagePercentage / 100)`.

---

### 4. Sync Strategy

- **Late Binding**: Use existing `ADR 0011` to resolve `FarmId` and `FarmerId`.
- **Duplicate Prevention**:
    - **Offline**: Check local Drift DB for `FarmId + DamageDate`. If exists, prompt to open existing.
    - **Backend**: Unique index on `FarmId + DamageDate` (excluding soft-deleted). Return `409 Conflict` if duplicate detected during sync.
- **Costing Persistence**: When creating a `DamageItem`, copy the current `UnitPrice` and `CostingSheetId` into the item record. This freezes the price even if the sheet is updated later.

---

## Sprint Breakdown

### Sprint 12.1: Foundation & Lookups
- Implement hierarchical entities: `DamageNature`, `DamageCategory`, `DamageSubCategory`, `DamageClassification`.
- Implement `DamageCause` tree.
- Implement `CostingSheet` versioning and price snapshots.
- Update Drift & EF Core schemas.

### Sprint 12.2: Damage Report Core
- Implement `TemporaryFormNumber` logic in Flutter.
- Implement `Search-First` duplicate check (Local Drift query).
- Implement Calculation Engine (`Qty * Price * %`).
- Backend: Unique Index and `409 Conflict` handling.

### Sprint 12.3: Workflow & Audit
- Implement `WorkflowHistory` table and `WorkflowService`.
- Implement role-based transition guards.
- Implement General Manager Override API.
- Add "Return with Reason" UI.

### Sprint 12.4: Financials & Attachments
- Implement `Compensation` entity for financial separation.
- Implement Archive-locked attachment management.
- Backend: Sequential number generator.
- Final sync hardening and documentation update.

---

## Verification Plan

### Automated Tests
- `DamageCalculationTests`: Verify correct loss calculation.
- `WorkflowTransitionTests`: Verify unauthorized transitions are blocked.
- `NumberingSystemTests`: Verify sequential uniqueness under load.

### Manual Verification
- Test offline creation of duplicate reports.
- Test price persistence after updating a costing sheet.
- Verify RTL (Arabic) layout for complex 10-stage status indicators.
