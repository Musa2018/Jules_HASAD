# UAT Results - Farmer & Farm Modules

Verification results for the UAT phase.

> [!IMPORTANT]
> **Status Legend**:
> - **PASS**: Behavior verified manually in the running application.
> - **FAIL**: Behavior does not match expected result.
> - **NOT TESTED**: Scenario pending verification.

## 1. Farmers

| ID | Scenario | Status | Evidence / Notes |
|:---|:---|:---|:---|
| F-01 | Create Farmer (Valid) | NOT TESTED | |
| F-02 | Create Farmer (Invalid) | NOT TESTED | |
| F-03 | Duplicate Identity | NOT TESTED | |
| F-04 | Reuse Identity after Soft Delete | NOT TESTED | |
| F-05 | Edit Farmer | NOT TESTED | |
| F-06 | Delete Farmer | NOT TESTED | |
| F-07 | Search Behavior | NOT TESTED | |
| F-08 | Operational Filtering | NOT TESTED | |

## 2. Farms

| ID | Scenario | Status | Evidence / Notes |
|:---|:---|:---|:---|
| R-01 | Create Farm from Farmer | NOT TESTED | |
| R-02 | Edit Farm | NOT TESTED | |
| R-03 | Delete Farm | NOT TESTED | |
| R-04 | Open Farm Details | NOT TESTED | |
| R-05 | Damage Report Button | NOT TESTED | |

## 3. Offline Scenarios

| ID | Scenario | Status | Evidence / Notes |
|:---|:---|:---|:---|
| O-01 | Create Farmer/Farm Offline | NOT TESTED | |
| O-02 | Edit Offline | NOT TESTED | |
| O-03 | Delete Offline | NOT TESTED | |
| O-04 | Connection Restoration | NOT TESTED | |
| O-05 | Conflict Handling | NOT TESTED | |

## 4. Security & Roles

| ID | Role | Status | Evidence / Notes |
|:---|:---|:---|:---|
| S-01 | SuperAdmin | NOT TESTED | |
| S-02 | Administrator | NOT TESTED | |
| S-03 | Director | NOT TESTED | |
| S-04 | AgriculturalEngineer | NOT TESTED | |
| S-05 | FieldSurveyor | NOT TESTED | |
| S-06 | TechnicalReviewer | NOT TESTED | |
| S-07 | ReadOnly | NOT TESTED | |

---
**Summary Results**:
- **Total Scenarios**: 25
- **Passed**: 0
- **Failed**: 0
- **Not Tested**: 25
