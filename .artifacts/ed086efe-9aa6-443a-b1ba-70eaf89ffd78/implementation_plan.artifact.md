# DamageReport Security Implementation Plan (Sprint 12.4)

## Goal
Establish a production-grade security boundary for the `DamageReport` module that inherits authorization from the `Farm` operational scope, while preserving the stable `Farmer` and `Farm` modules.

## User Review Required

> [!IMPORTANT]
> **Directorate Denormalization Strategy**: `DamageReport.DirectorateId` will be added as a derived optimization field. It will ALWAYS be synchronized with `Farm.DirectorateId` during creation and validated during updates to prevent mismatches.

> [!WARNING]
> **Geographic Type Migration**: `GovernorateId` and `LocalityId` in `DamageReport` will be migrated from `string` to `Guid` for architectural consistency with the `Farm` module. Existing records (if any) will be migrated via an EF Core migration script.

## Architectural Constraints

- **Source of Truth**: `Farm.DirectorateId` is the absolute source of truth for authorization scope.
- **Derived Optimization**: `DamageReport.DirectorateId` is only used for O(1) authorization checks in queries and commands.
- **Consistency Rule**: `DamageReport.DirectorateId` MUST match its parent `Farm.DirectorateId`. Creation and Update commands will enforce this via database-backed validation.
- **Implementation Order**:
    1. Phase 1: Authorization Tests (Regression & Security).
    2. Phase 2: Backend Authorization Guards (Commands).
    3. Phase 3: Backend Query Filtering (Queries).
    4. Phase 4: Data Model Migration (EF Migration & Denormalization).
    5. Phase 5: Documentation & Verification.

## Proposed Changes

### [Backend] Domain & Persistence Layer

#### [MODIFY] [DamageReport.cs](file:///hasad/backend/Hasad.Domain/Entities/DamageReport.cs)
- Change `GovernorateId` type from `string` to `Guid`.
- Change `LocalityId` type from `string` to `Guid`.
- **Add** `DirectorateId` (`Guid`) as a denormalized authorization field.

#### [NEW] [Migration] Sprint12_4_DamageReportSecurityAlignment
- Schema update for `DamageReport` geographic fields.
- Migration script to populate `DirectorateId` from `Farm` join and convert string GUIDs to uniqueidentifiers.

---

### [Backend] Application Layer (Authorization Hardening)

#### [MODIFY] [CreateDamageReportCommand.cs](file:///hasad/backend/Hasad.Application/Features/DamageReports/Commands/CreateDamageReport/CreateDamageReportCommand.cs)
- Fetch `Farm` details early.
- **Enforce**: `report.DirectorateId = farm.DirectorateId`.
- **Authorize**: Check if user has access to `farm.DirectorateId`.

#### [MODIFY] [UpdateDamageReportCommand.cs](file:///hasad/backend/Hasad.Application/Features/DamageReports/Commands/UpdateDamageReport/UpdateDamageReportCommand.cs)
- **Authorize**: Check user scope against `report.DirectorateId`.
- **Constraint**: Ensure `DirectorateId` is NOT modifiable via the update command (derived from the original farm link).

#### [MODIFY] [DeleteDamageReportCommand.cs](file:///hasad/backend/Hasad.Application/Features/DamageReports/Commands/DeleteDamageReport/DeleteDamageReportCommand.cs)
- **Authorize**: Check user scope against `report.DirectorateId`.

#### [MODIFY] [SubmitDamageReportCommand.cs](file:///hasad/backend/Hasad.Application/Features/DamageReports/Commands/SubmitDamageReport/SubmitDamageReportCommand.cs)
- **Authorize**: Check user scope against `report.DirectorateId`.

#### [MODIFY] [TransitionDamageReportCommand.cs](file:///hasad/backend/Hasad.Application/Features/DamageReports/Commands/TransitionDamageReport/TransitionDamageReportCommand.cs)
- **Authorize**: Standardize `IsWithinScope` to use the denormalized `DirectorateId`.

#### [MODIFY] [UpdateDamageItemCommand.cs](file:///hasad/backend/Hasad.Application/Features/DamageReports/Commands/UpdateDamageItem/UpdateDamageItemCommand.cs)
- **Authorize**: Join with `DamageReport` to check scope against `report.DirectorateId`.

#### [MODIFY] [UploadAttachmentCommand.cs](file:///hasad/backend/Hasad.Application/Features/DamageReports/Commands/UploadAttachment/UploadAttachmentCommand.cs)
- **Authorize**: Join with `DamageReport` to check scope against `report.DirectorateId`.

#### [MODIFY] [Queries](file:///hasad/backend/Hasad.Application/Features/DamageReports/Queries/)
- Apply geographic scope filtering to all DamageReport query handlers.

---

### [Mobile] Sync Engine & Data Layer

#### [MODIFY] [DamageReportSyncDto](file:///hasad/mobile/lib/features/damage_reports/data/dto/damage_report_sync_dto.dart)
- Update field types for `governorateId` and `localityId` to match backend GUID strings.

## Verification Plan

### Security Test Requirements
- **Engineer Scope**: Jericho Engineer + foreign farmer + local farm = **Allowed**.
- **Engineer Boundary**: Engineer + foreign farm = **Rejected**.
- **Child Integrity**: `DamageItem` and `Attachment` operations MUST fail if the parent `DamageReport` is outside the user's scope.
- **Privacy**: Unauthorized query (e.g., Engineer listing reports from another directorate) must return an empty list or 403.

### Regression Protection
- Run all existing tests for **Farmer**, **Farm**, and **User Management** modules to ensure zero regression.
- Verify `SyncQueue` remains consistent during geographic data synchronization.
