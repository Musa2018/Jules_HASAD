# ADR 0013: DamageReport Operational Scope and Authorization Inheritance

## Status
Accepted

## Context
Damage reports are intrinsically linked to the physical location of agricultural assets (Farms). To maintain regional isolation and operational security, the system must ensure that access to a damage report is governed by the same regional boundaries as the parent farm, regardless of the farmer's place of residence.

## Decision

### 1. Authorization Source of Truth
The `Farm.DirectorateId` is the absolute source of truth for authorization scope. Any operation on a `DamageReport` or its children must validate the user's regional assignment against the Directorate of the farm associated with the report.

### 2. Directorate Denormalization for Performance
To enable O(1) authorization checks in high-volume queries and list operations without requiring expensive joins to the `Farms` table, we adopt a **Derived Authorization Snapshot** pattern:
- **Field**: `DamageReport.DirectorateId` (Guid).
- **Rule**: This field is automatically populated from the parent `Farm` during the creation of the `DamageReport`.
- **Constraint**: The field is immutable regarding independent updates; it must always be synchronized with the parent farm's location at the time of report capture.

### 3. Authorization Inheritance Chain
Security follows a strict parent-to-child inheritance model:
- `DamageReport` inherits from `Farm`.
- `DamageItem` inherits from `DamageReport`.
- `DamageReportAttachment` inherits from `DamageReport`.
- `DamageWorkflowHistory` inherits from `DamageReport`.

In the application layer, all commands affecting child entities MUST perform a join or lookup to the parent `DamageReport` to verify the user's operational scope (`DirectorateId` or `GovernorateId`).

### 4. Decoupling from Farmer residency
Farmer residency (`Farmer.GovernorateId`) is explicitly excluded from authorization boundaries for managed assets. An Agricultural Engineer assigned to Directorate A can manage a farm located in Directorate A even if the owner farmer resides in Directorate B.

### 5. Offline Compatibility
- **Local Storage**: The Drift database schema (Version 15) is updated to include `directorateId` in the `DamageReports` table.
- **Sync Safety**: The backend `CreateDamageReportCommand` is responsible for deriving the `DirectorateId` from the `FarmId`. This ensures that older offline clients (which do not yet capture `DirectorateId`) can still synchronize successfully without data corruption or security bypasses.

## Consequences
- **Storage**: Minor increase in storage due to denormalized GUID in the `DamageReports` table.
- **Maintenance**: Requires vigilance in command handlers to ensure joins to the parent are always implemented.
- **Integrity**: Stronger guarantee that users cannot view or modify reports outside their assigned regions.

## Alternatives Rejected
- **Farmer-Based Scoping**: Rejected because farmers often own land in multiple regions, and regional ministry offices are organized by the location of the land, not the farmer.
- **Pure Join-Based Auth**: Rejected for listing queries due to performance concerns at scale; the denormalized `DirectorateId` provides significantly better index performance for filtered lists.
