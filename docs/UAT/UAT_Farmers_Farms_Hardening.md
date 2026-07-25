# User Acceptance Testing (UAT): Farmers & Farms Hardening

# 1. Purpose

This User Acceptance Testing (UAT) document serves as the official baseline for validating the **Farmers and Farms Hardening phase**. Successful completion of these scenarios is a mandatory precondition before proceeding to the **Damage Report** workflow implementation. This ensures that the foundation—geographic scoping, authorization, and core entity management—is stable and reliable.

> [!IMPORTANT]
> **Damage Report implementation is gated.** Development of the assessment items and workflow stages may only begin AFTER this UAT baseline is approved and all **Critical** and **High** issues are resolved.

---

# 2. General UX Principles

These principles apply to every current and future form unless explicitly documented otherwise.

- **Sticky Actions:** Save action must always remain visible (sticky) while scrolling.
- **Consistency:** Save button location must be consistent across all forms.
- **Visual Feedback:** Validation errors must immediately change the Save button to **RED**.
- **Workflow Navigation:** Successful save must navigate users to the correct destination defined by the workflow.
- **Role-Based Visibility:** Unauthorized users must never see actions they cannot execute.
- **Read-Only Enforcement:** Read-only roles must never see Create/Edit/Delete actions.
- **Navigation Integrity:** Navigation must never leave users on obsolete intermediate screens.
- **Parity:** Offline and online behavior must remain identical.
- **Pre-emptive Validation:** Forms must prevent invalid data before synchronization.
- **Constraint Alignment:** UI validation must match backend validation rules.

---

| UAT ID | Module | Screen | Business Requirement | Current Behavior | Expected Behavior | Severity | Root Cause | Status | Related Commit | Verification Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| UAT-001 | Farmers / Farms Authorization | Farmer Card | Non-authorized roles must have Read Only access. Users without farm creation permission must not see actions that open create workflows. | TechnicalReviewer can see and click "Farm" button to open Add Farm form. | "Add Farm" action must not be visible for roles without farm creation permission. | High | Missing authorization guard in FarmerCard actions and route. | CLOSED | [f3254cd](https://github.com/musa/Jules_HASAD/commit/f3254cd) | VERIFIED |

## Status Lifecycle Definitions
- **NOT STARTED**: Issue identified but work has not begun.
- **IN PROGRESS**: Resolution is currently being implemented.
- **READY FOR VERIFICATION**: Implementation complete, awaiting manual UAT verification.
- **VERIFIED**: Manual verification successful.
- **CLOSED**: Code completed, automated tests passed, manual verification completed, and documentation updated.

---

# 4. UAT Observation History

*Record all manual observations here. Do not delete or overwrite previous entries.*

| Date | Module | Observation | Severity | Status | Proposed Resolution |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 2026-07-25 | Authorization | TechnicalReviewer can see and access "Add Farm" from Farmer Card. | High | RESOLVED | Implement visibility guards and navigation protection. |

---

# 5. Regression Impact Assessment

*For every resolved issue, document the potential side effects.*

| UAT ID | Affected Modules | Possible Regression Areas | Tests Executed | Manual Verification Result |
| :--- | :--- | :--- | :--- | :--- |
| UAT-001 | Farmers, Farms, Auth, Router | Authorized users (Engineer/Admin) might lose access if service logic is wrong. | authorization_service_test, farmer_card_authorization_uat_test, farm_repository_authorization_test | PASS |

---

# 6. Architectural Decisions From UAT

*Record all architectural decisions that arise during UAT.*

| ID | Decision | Rationale | Date |
| :--- | :--- | :--- | :--- |
| | | | |

---

# 7. Farmer Module Test Scenarios

## Farmer Creation Navigation
**Verify:**
- User opens "Add Farmer".
- Completes form with valid data.
- Saves successfully.
- Application returns to the Farmers main list.
- The list refreshes automatically to show the new record.

**Expected Result:**
- Navigation follows a consistent "Forward to Form -> Backward to List" flow.
- No return to unintended screens or intermediate loading pages.

---

## Identity Uniqueness Validation
**Verify Business Rule:** `IdentityTypeId + IdentityNumber` must be unique for active records.

**Rules:**
- **Same IdentityType + Same Number:** System must block creation and show a clear validation error.
- **Same Number + Different Identity Type:** Allowed (e.g., Passport vs. National ID).
- **Soft Delete Rule:** Records marked as deleted (logically) must NOT block the reuse of identity numbers for new records.

---

## Farmer Authorization
**Verify Permissions:** Only authorized roles can perform mutations.

- **Allowed Roles:** SuperAdmin, Administrator, Agricultural Engineer.
- **Unauthorized Roles:** `FieldSurveyor`, `TechnicalReviewer`.

**Check:**
- Unauthorized roles must NOT see action buttons (Add, Edit, Delete).
- Unauthorized roles must be blocked at the repository/API level if they attempt a direct call.

---

## Farmer Read Only Access
**For users without modification permission:**

- **Allowed:** View farmer details, browse list.
- **Forbidden:** Add Farmer, Edit Farmer, Delete Farmer, Add Farm (from farmer card).

---

## Farmer Operational View
**Verify:**
- For **Agricultural Engineers**, the default view should prioritize farmers with damaged farms inside their assigned **Directorate**.

**Important:**
- This is an operational default filter only.
- It must not prevent searching for or viewing other allowed farmers within the user's broader geographic scope (Governorate).

---

## Farmer Form Validation UX
**Verify:**
- When validation fails (required fields missing or invalid format):
    - The "Save" button becomes visually **RED**.
    - The Save action is disabled/blocked.
    - Error states are clearly marked on the relevant fields.
- The **Save button must remain visible** (sticky) while scrolling through long forms.

---

# 8. Farm Module Test Scenarios

## Create Farm From Farmer Card
**Verify:**
- Start from a specific Farmer's details/card.
- Select "Add Farm".
- After successful farm creation:
    - **Expected:** Navigate directly to the **Farm Details** screen for the newly created farm.
    - **Expected:** Do NOT return to the Farmers list.

---

## Farm Card Actions
**Verify:**
- The previous "Search" action on the Farm card has been replaced with: **"Damage Report"**.
- This action must open the Damage Report creation workflow with the `FarmId` context pre-filled.

---

## Farm Operational View
**Verify:**
- The Farm main screen displays farms according to the user's **Directorate** operational scope.

---

## Farm Read Only Access
**Users without edit permission:**
- **Allowed:** View farm details.
- **Forbidden:** Edit Farm, Delete Farm.

---

# 9. Authorization Matrix

| Role | Farmers (CUD) | Farms (CUD) | Read Access |
| :--- | :---: | :---: | :---: |
| **SuperAdmin** | Full | Full | Yes |
| **Administrator** | Full | Full | Yes |
| **Agricultural Engineer** | Operational | Operational | Yes |
| **FieldSurveyor** | No | No | Yes (Read Only) |
| **TechnicalReviewer** | No | No | Yes (Read Only) |

---

# 10. Damage Report Preparation Preconditions

Before implementing the full Damage Report workflow, verify these architectural foundations:

## New Damage Report Creation
- The first screen must show only:
    - Required header fields (Date, Cause, etc.).
    - Save button.
- **Do not show:** Damage items list or Assessment workflow sub-sections yet.

## Report Header Save
- After a valid save of the header:
    - System must create a **temporary form identity** according to ADR-0014.
    - Add the item to the **Sync Queue**.
    - Attempt synchronization with the backend.

## After Successful Synchronization
- Only after the report header is successfully synced and receives a server-side ID:
    - Show the **"Add Damage Items"** action.

---

# 11. DamageReport Database Audit Requirement

The `DamageReports` table requires a final review before the workflow implementation proceeds.

**Current Fields to Audit:**
`Id`, `ClientId`, `FarmId`, `DamageDate`, `DocumentationDate`, `StatusId`, `Notes`, `CreatedAt`, `UpdatedAt`, `RowVersion`, `CompanyName`, `DamageCauseId`, `DamageCauseCategoryId`, `DeletedAt`, `DeletedBy`, `PermanentFormNumber`, `IsDeleted`, `SettlementName`, `TemporaryFormNumber`, `AgriculturalSectorId`, `ReportNumber`.

**Review Goals:**
- Identify deprecated fields.
- Resolve duplicate concepts (e.g., `PermanentFormNumber` vs `ReportNumber`).
- Align terminology with backend contracts.

> [!CAUTION]
> Do NOT modify the database schema during this audit. Schema changes must be approved via ADR or Sprint Plan.

---

# 12. Offline Sync Verification

**Include verification of:**
- **Offline Creation:** Records can be created without a network connection.
- **Sync Queue Handling:** Tasks are queued and retried correctly.
- **Permission Validation:** Sync must fail gracefully if the user's session lacks permissions for the target Directorate.
- **Payload Correctness:** Verify JSON contracts match Sprint 14.x requirements.
- **Backend Response Handling:** System must handle authorization errors (403) specifically, stopping retries and flagging the record.

---

# 13. Acceptance Criteria

The hardening phase is accepted only when:
1. All **Critical** UAT scenarios listed above **PASS**.
2. Authorization guards are verified both in UI and Repository.
3. Navigation flows match the optimized "Detail-Oriented" pattern.
4. Identity uniqueness is enforced locally.
5. Offline-to-Online sync lifecycle is verified for core entities.

> [!IMPORTANT]
> **Implementation Stop:** Damage Report assessment items and workflow stages MUST NOT be implemented while any **Critical** or **High** UAT issues are unresolved.
