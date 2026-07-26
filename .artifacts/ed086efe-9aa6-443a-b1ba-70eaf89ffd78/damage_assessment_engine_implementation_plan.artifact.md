# Damage Assessment & Valuation Engine Implementation Plan (Sprint 13.2)

## Goal
Establish the technical foundation for agricultural damage valuation, ensuring backend math integrity, costing sheet snapshotting, and hierarchical classification enforcement.

## 1. Current Foundation Analysis

- **Data Models**: `DamageItem`, `CostingSheet`, and `DamageClassification` entities are in place with the required relationship links.
- **Valuation Logic (Mobile)**: `ValuationEngine` correctly implements the formula: `Quantity * UnitPrice * (DamagePercentage / 100)`.
- **Reference Data**: `ReferenceDataController` successfully serves the 4-level classification hierarchy and active costing sheets.
- **Snapshot Pattern**: `DamageItem` already includes fields for `CalculatedUnitPrice` and `MeasurementUnitSnapshot` as required by ADR 0012.

## 2. Missing Components & Gaps

- **Backend Math Guard**: Command handlers (`CreateDamageReport`, `UpdateDamageItem`) currently trust client-provided `EstimatedLoss`.
- **Costing Sheet Resolver**: No backend service exists to verify if a `CostingSheetId` is truly active for a given `ClassificationId` and `DamageDate`.
- **Administrative Pricing UI**: No backend commands yet for creating/versioning `CostingSheet` records.
- **Evidence Locking**: Missing logic to prevent evidence modification after the report moves past the `TechReview` stage (ADR 0012 constraint).

## 3. Proposed Data Model & API Changes

### [Backend] Infrastructure Layer
- **NEW** `ICostingService`:
    - `decimal GetActivePrice(int classificationId, DateTime damageDate)`
    - `Guid GetActiveCostingSheetId(int classificationId, DateTime damageDate)`
- **MODIFY** `CreateDamageReportCommandHandler`:
    - Inject `ICostingService`.
    - Recalculate and overwrite `EstimatedLoss` before saving to DB.
    - Validate that the provided `CostingSheetId` matches the server's active version for the `DamageDate`.

### [Backend] API Layer
- **NEW** `CostingSheetsController`:
    - `POST /api/v1/CostingSheets`: Create new version for a classification (Admin only).
    - `GET /api/v1/CostingSheets/{classificationId}/history`: Version history.

## 4. Flutter Integration

- **Form Hardening**: Connect `ClassificationWizardProvider` state directly to the `DamageItem` form fields.
- **Real-time Valuation**: Ensure the `ValuationEngine` updates the `EstimatedLoss` display as the user types quantity or percentage.

## 5. Verification Plan

### Automated Tests
- **Backend Unit Tests**: `DamageValuationTests.cs`
    - Verify that sending `EstimatedLoss = 0` from client results in a correctly calculated loss on the server.
    - Verify that an invalid `CostingSheetId` for a classification is rejected.
- **Mobile Widget Tests**:
    - Verify that changing the classification automatically updates the unit price from the local costing sheet cache.

## 6. Sprint Breakdown

### Phase 1: Backend Calculation Guards
- Implement `CostingService`.
- Hardened `CreateDamageReport` math logic.

### Phase 2: Pricing Administration
- Implement `CostingSheet` management commands (Admin).
- Implementation of "Locking" logic for attachments.

### Phase 3: Mobile UI Hardening
- Integrity checks in the Damage Item form.
- Full offline classification search alignment.

## 7. Technical Risks

- **Price Volatility**: If a `CostingSheet` is updated while a user is offline capturing data, the sync engine might encounter a "Price Mismatch".
- **Risk Mitigation**: The backend will allow a 24-hour grace period for "recently expired" costing sheets during sync, but will log the version discrepancy.
