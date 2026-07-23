# DamageReport Roadmap Review — Post Sprint 13.2 Phase 2C

This document provides a comprehensive architecture review and proposes the next strategic direction for the HASAD DamageReport module.

## 1. Current DamageReport Architecture Review

### Existing Entities
- **DamageReport**: The central header entity managing basic data (numbers, dates, cause) and 10-stage workflow status.
- **DamageItem**: Hierarchical items capturing technical loss (classification, quantity, percentage, unit snapshots).
- **DamageReportAttachment**: Binary evidence links with location/timestamp metadata.
- **DamageWorkflowHistory**: Audit trail for state transitions.

### Evidence Implementation Status
- Current terminology is **Attachment**.
- Binary files are stored locally (mobile) and uploaded via a background queue.
- States are limited to `Pending`, `Completed`, `Failed` (Upload-centric).
- Lacks semantic verification and immutable locking.

### Sync Architecture Impact
- **Identity**: Reliable UUID (`ClientId`) for offline-first, GUID (`ServerId`) for authority.
- **Hardening**: Sprint 13.2 successfully addressed terminology and unit resolution issues.
- **Constraint**: Header and Items sync together; Attachments sync independently via multi-part background upload.

### Offline-First Requirements
- Local SQLite (Drift) schema supports full entity graph and sync queue.
- `TemporaryFormNumber` provides immediate identification for field engineers.

### Existing DTO Contracts
- `DamageReportSyncDto` maps local models to backend commands.
- **Observation**: Attachment metadata is NOT part of the header sync; it follows its own lifecycle.

---

## 2. Evidence Lifecycle Proposal

We propose transitioning from "Attachments" to **Evidence** with a structured lifecycle.

### Proposed Evidence States
1.  **Captured**: Physical file exists on the mobile device with metadata (Lat/Long/Time).
2.  **Uploaded**: File successfully persisted in backend storage (Azure/S3).
3.  **Validated**: Evidence reviewed by an `ArchiveOfficer` and confirmed as relevant/clear.
4.  **Locked**: Immutable state. No further evidence can be added or removed for this report stage.
5.  **Archived**: Long-term storage state after the report reaches `Completed`.

### Implementation Rules
- **Immutability**: Once a report enters `TechReview`, existing Evidence is **Locked**.
- **Authority**: `ArchiveOfficer` can add/modify evidence until `DirManager` approval.
- **Versioning**: If evidence must be replaced, a new version is created; the original is kept with a "Superseded" flag.
- **Offline Behavior**: Engineers capture evidence offline. Validation/Locking only occurs server-side.

---

## 3. Assistance Integration Analysis

DamageReports serve as the technical foundation for providing assistance.

### Workflow Integration
1.  **DamageReport**: Defines the scope of loss.
2.  **Assessment Result**: The technical valuation of damage (Computed).
3.  **Recommended Assistance**: A bridge entity mapping loss to specific interventions:
    - **Input Support**: Seeds, fertilizers, tools (Quantity based).
    - **Extension Services**: Training for recovery.
    - **Rehabilitation**: Irrigation repair, soil treatment.

### Data Flow
`DamageItem (Loss)` -> `AssistanceRuleEngine` -> `ProposedAssistance (Draft)`.

---

## 4. Sync Impact Review

To support the Evidence Lifecycle, the sync architecture must evolve:

- **Metadata Expansion**: `Evidence` entities must include `LockStatus`, `ValidationStatus`, and `Version`.
- **Conflict Handling**: If an engineer tries to delete evidence that was locked on the server, the server must return a `403 Forbidden` with a specific business error.
- **Offline Integrity**: Mobile must enforce "Read-Only" UI for evidence once the report status indicates it is locked.

---

## Recommended Next Sprint: Sprint 14.1 — Evidence Lifecycle Foundation

**Objective**: Transition to "Evidence" domain and implement locking mechanisms.

### Key Tasks:
- [ ] Refactor `DamageReportAttachment` to `Evidence` in both Backend and Mobile.
- [ ] Implement `EvidenceLockingService` on the backend.
- [ ] Add `Status` and `Validation` fields to Evidence entities.
- [ ] Update Mobile UI to reflect Evidence states and enforce read-only rules.

### Risks and Dependencies:
- **Risk**: Large binary file sync during high-volume assessment seasons.
- **Dependency**: Requires `IFileStorageService` to be production-ready (Azure/S3 transition).
- **Assumed Role**: `ArchiveOfficer` role must be active in the system.
