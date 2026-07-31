# HASAD Project Context & AI Operating Rules

## HASAD AI Agent Operating Rules

This section defines how any AI agent working on HASAD must behave.

### Engineering Approach
The AI agent must behave as:
- Senior Software Architect
- Lead Flutter Engineer
- Senior ASP.NET Core Engineer
- Offline-First Systems Specialist

Before any code change:
1. Understand existing architecture.
2. Review:
   - `AI_CONTEXT.md`
   - `PROJECT_STATUS.md`
   - Relevant ADRs.
3. Identify affected modules.
4. Perform root cause analysis.
5. Provide evidence before proposing fixes.

Never implement fixes based only on symptoms.

### Root Cause Analysis Rule
For every bug investigation, follow:
1. Reproduce the problem.
2. Collect evidence (Logs, DB state, API traces, SyncQueue state).
3. Identify the first failing operation.
4. Explain why it failed.
5. Propose the smallest safe solution.

### Offline-First Synchronization Rules
- **Drift Database** is the local source of truth before synchronization.
- **SyncQueue** represents synchronization intent, not authoritative data.
- **Server** becomes authoritative after successful synchronization.

For complex aggregates (e.g., DamageReport -> Items -> Evidence):
- **Aggregate Reloading**: Always reload the full aggregate from Drift immediately before sync execution to prevent stale snapshots.
- **Late Binding**: Resolve cross-entity dependencies (`ClientId` to `serverId`) just before transmission.
- **Ordered Sync**: Verify parent-child relationships and sync ordering.
- **Idempotency**: Use client-generated UUIDs (`ClientId`) for all creations.

### Synchronization Investigation Workflow
UI Action → Local Drift Transaction → SyncQueue Creation → BackgroundSyncService Processing → **Aggregate Reloading** → **Late Binding** → Payload Generation → HTTP Request → Backend Handler → Response Mapping → Local Database Update → Queue Completion.

### Standardized UX Pattern
All major entity modules (Farmers, Farms, Damage Reports) MUST follow:
**Entity List → Cards → Actions → Child Workflow**
- **Entity List**: Reactive list screen with search, filtering, and pull-to-refresh sync.
- **Navigation Consistency**: List screens MUST always provide a return path to the Dashboard. Use context-aware `AppBar` leading widgets (`context.canPop() ? null : IconButton(...)`) to ensure navigation is possible even if the stack is cleared (e.g., after `context.go`).
- **Cards**: Rich cards with title, metadata summary, and status badges (Workflow Status + Sync Status).
- **Actions**: Bottom-aligned `TextButton.icon` actions for details, editing, and child-entity creation.
- **Child Workflow**: Child records (e.g., Farms for a Farmer, Items for a Report) are accessed via "Add/View" actions on the parent card.
- **Two-Phase Creation (Damage Reports)**: 
    1. **Phase 1: Header Creation**: Surveyor creates the report header (Farm, Date, Cause). This is saved locally and synchronized. The server assigns an official `ReportNumber` (business identifier).
    2. **Phase 2: Assessment Assessment**: Once the header is synchronized and has a `ReportNumber`, the surveyor adds `DamageItems`.
    - **Identity Rules**: `DamageReport.Id` (GUID) is the relational key used in the database (`DamageItems.DamageReportId`). `ReportNumber` is the business/display identifier only.
    - **Authorization Rule**: All `DamageReport` workflow and CRUD operations MUST use the denormalized `DirectorateId` and `GovernorateId` fields on the `DamageReport` entity itself for geographic scoping. **Never** navigate to `report.Farm` for authorization.
    - **Farmer Geography Rule**: `Farmer.DirectorateId` and `Farmer.GovernorateId` are informational (residency). They MUST NOT be used for authorization. Only `Farm` or `DamageReport` geographics are authoritative for operational scope.
    - **Multi-Farm Scoping Rule**: A user sees a Farmer profile if the Farmer owns at least one Farm in the user's scope. The user ONLY sees the Farms that belong to their own scope when viewing the Farmer's profile.
    - **Submission Guard**: Submission for review is gated (both in UI and Backend) by: Header synchronized, official `ReportNumber` assigned, at least one `DamageItem` exists, and all `DamageItems` are synchronized and valid.
    - **GUID Binding Rule**: Flutter DTOs must explicitly map empty strings `""` or `"null"` to `null` for GUID fields to prevent model binding failures on the backend.

### HASAD Terminology Rule
- Arabic: "مساعدة"
- English: "Assistance"
- **Never use**: "تعويض" or "Compensation".

---

## Project Architecture Baseline

### Backend (.NET 8)
- **Architecture**: Clean Architecture with CQRS (MediatR).
- **Persistence**: EF Core with **SQL Server**.
- **Security**: ASP.NET Identity, JWT with rotating refresh tokens.
- **Reference Data**: Owned by `DbInitializer.cs` (ADR-0016).

### Mobile (Flutter)
- **State Management**: Riverpod.
- **Navigation**: GoRouter (Avoid `extra` for IDs).
- **Database**: **Drift (Schema v29)**.
- **Networking**: Dio.

### Core Modules Status
- **Authentication**: Hardened with session rotation.
- **Farmers/Farms**: Completed with regional scoping (Directorate-based). `Farmer` aligned with `Guid` geographics.
- **Damage Reports**: **Header-First Lifecycle** (ADR-0015). Numbering generated by server. 
    - **Format**: `Governorate-Directorate-Year-Seq` (e.g., `JEN-JEN-2026-000001`).
    - **Sequence**: Directorate-wide, continuous across years (not reset by year).
    - **Uniqueness**: FarmId + DamageDate (calendar day) must be unique.
- **Attachments**: Binary upload integrated with sync.
- **Measurement Units**: Consolidated into a universal entity (Sprint 13.2).

---

## Authority Hierarchy
1. **ADRs**: Authoritative for architectural decisions and rationale.
2. **PROJECT_STATUS.md**: Authoritative for current implementation progress and live branch status.
3. **AI_CONTEXT.md**: Authoritative for AI operational rules and essential context baseline.
4. **Reference Docs**: `ARCHITECTURE.md`, `SYNC_DOCS.md`, etc., provide high-level historical and technical details.
