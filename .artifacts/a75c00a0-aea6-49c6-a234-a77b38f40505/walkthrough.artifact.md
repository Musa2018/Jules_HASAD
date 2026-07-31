# Walkthrough - Investigating "Submit For Review" HTTP 400

We have investigated the submission process and identified potential failure points. Detailed diagnostic logging has been added to the backend to pinpoint the exact cause of any remaining 400 errors.

## Investigation Findings

### 1. Workflow Alignment
- **Current Initial Status**: Reports are created on the server with status `PendingTechnicalVerification`.
- **UI Action**: "Submit for Review" is available when items exist and are synced.
- **Backend Mapping**: This action maps to the `SubmitDamageReportCommand`, which transitions the report from `PendingTechnicalVerification` to `TechReview`.
- **Validation**: The transition rule in `DamageWorkflowService` correctly allows `AgriculturalEngineer` and `FieldSurveyor` roles to perform this move.

### 2. Potential Failure Causes
- **Missing Items**: If previous `AddDamageItem` calls failed (due to the GUID binding issue fixed in the previous task), the backend correctly rejects the submission because a report cannot be reviewed without assessment items.
- **Scope Mismatch**: If the user is assigned to a different Directorate than the Farm, the backend enforces geographic isolation.
- **Report Number**: Submission is now explicitly blocked if the official `ReportNumber` hasn't been assigned yet (ensuring Phase 1 sync completion).

## Changes Made

### Backend Diagnostic Hardening
Updated [SubmitDamageReportCommand.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/DamageReports/Commands/SubmitDamageReport/SubmitDamageReportCommand.cs) with comprehensive logging:
- Logs the loaded status and item count.
- Logs specific reasons for rejection (Status mismatch, Missing Items, Missing Report Number, Scope issues, or Workflow service rejection).

## Next Steps for Verification
1. Re-add a Damage Item (verifying the sync fix).
2. Click "Submit for Review".
3. If the error persists, monitor the backend console output for "SubmitDamageReport: ..." log entries. These will state the exact business rule being violated.

> [!NOTE]
> The UI label "Submit for Review" is correctly aligned with the technical transition to the `TechReview` state, where a Technical Reviewer will take over.
