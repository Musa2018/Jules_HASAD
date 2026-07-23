# Implementation Plan - Backend Valuation Guards (Sprint 13.2 Phase 1)

Implement the backend calculation protection layer for Damage Assessment, ensuring technical loss calculations are authoritative and audit-ready.

## User Review Required

> [!IMPORTANT]
> **Authoritative Backend Calculation**: The backend will now recalculate all technical losses. Client-provided `EstimatedLoss` values will be used for audit comparison only and will be overwritten by server-calculated values.

> [!WARNING]
> **Strict Costing Validation**: Reports will be rejected if the provided `CostingSheetId` does not match the `ClassificationId` or was not active at the time of the damage.

## Proposed Changes

### [Backend] Application Layer

#### [NEW] [ICostingService.cs](file:///hasad/backend/Hasad.Application/Common/Interfaces/ICostingService.cs)
- Define interface for resolving and validating unit prices.

#### [MODIFY] [CreateDamageReportCommandHandler.cs](file:///hasad/backend/Hasad.Application/Features/DamageReports/Commands/CreateDamageReport/CreateDamageReportCommand.cs)
- Inject `ICostingService` and `ILogger`.
- Recalculate `EstimatedLoss` for every item.
- Log mismatches between client-provided and server-calculated values.
- Store server-calculated `CalculatedUnitPrice` and `EstimatedLoss`.

#### [MODIFY] [UpdateDamageItemCommandHandler.cs](file:///hasad/backend/Hasad.Application/Features/DamageReports/Commands/UpdateDamageItem/UpdateDamageItemCommand.cs)
- Inject `ICostingService` and `ILogger`.
- Recalculate and validate technical loss upon item update.

---

### [Backend] Infrastructure Layer

#### [NEW] [CostingService.cs](file:///hasad/backend/Hasad.Infrastructure/Services/CostingService.cs)
- Implement `ICostingService` with database lookups for active costing sheets.
- Validation logic for `ClassificationId`, `EffectiveFrom`, `EffectiveTo`, and `IsActive`.

#### [MODIFY] [DependencyInjection.cs](file:///hasad/backend/Hasad.Infrastructure/DependencyInjection.cs)
- Register `CostingService`.

---

### [Backend] Documentation

#### [MODIFY] [AI_CONTEXT.md](file:///AI_CONTEXT.md)
- Document that backend valuation is the authoritative source for technical loss.

#### [MODIFY] [PROJECT_STATUS.md](file:///PROJECT_STATUS.md)
- Update Sprint 13.2 status.

---

## Verification Plan

### Automated Tests
- **CostingService Tests**:
    - Valid resolution.
    - Classification mismatch rejection.
    - Date out of range rejection.
    - Inactive version rejection.
- **Valuation Guard Tests (Create/Update)**:
    - Client value overwrite.
    - Mismatch logging (verify via Mock Logger).
    - Sync scenarios for offline-generated items.

### Manual Verification
- Attempt to sync a report with an intentionally wrong `EstimatedLoss` and verify the backend corrects it in the database.
- Verify log entries for valuation mismatches in the development environment.
