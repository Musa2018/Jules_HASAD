# HASAD - Architecture Documentation

## Overview
HASAD follows a **Clean Architecture** approach combined with a **Feature-First** structure to ensure scalability, maintainability, and offline-first capabilities.

## Mobile (Flutter)
- **Presentation Layer**: Riverpod for state management, GoRouter for navigation.
- **Domain Layer**: Entities and Repository interfaces.
- **Data Layer**: Repository implementations, Data sources (Dio for API, Drift for SQLite).
- **Core**: Cross-cutting concerns like synchronization, secure storage, and networking.

## Backend (.NET 8)
- **Web API**: Controllers and Middleware.
- **Application**: CQRS patterns using MediatR, FluentValidation.
- **Domain**: Core entities and business rules.
- **Infrastructure**: Persistence (EF Core, PostgreSQL), Identity, and External Services.

## Offline First Strategy
- **Local First**: Data is saved to SQLite via Drift first. Every record has a client-generated UUID for backend idempotency.
- **Sync Queue**: Operations are queued in a persistent local table and processed by `BackgroundSyncService` when connectivity is detected, using an exponential backoff retry policy.
- **Geographic Caching**: Reference data (Governorates, Directorates, Localities) and **Damage Classification Hierarchy** are synchronized to local Drift tables to support offline CRUD validation and cascading lookups.
- **Conflict Resolution**: **Optimistic Concurrency** via `RowVersion` tokens. The server returns `409 Conflict` if the record has been modified by another user.
    - **Current Strategy**: **Server Wins**. The background sync engine automatically fetches the remote authority data and overwrites the local Drift record to resolve the conflict.
    - **Roadmap**: Implement a **Merge UI** in future sprints to allow users to manually compare local changes with server data before resolving conflicts.

## Architectural Decisions
### ADR 0012: Damage Report Architecture & Workflow Design
- **Status**: Accepted
- **Context**: Production-grade damage assessment requires complex hierarchies and ministerial workflows.
- **Decision**: 
    - **Classification Hierarchy**: Nature -> Category -> SubCategory -> Classification -> Price Version.
    - **Snapshot Pattern**: DamageItem snapshots `CalculatedUnitPrice` and `CostingSheetVersionId` for historical integrity.
    - **Financial Separation**: `DamageItem` handles technical loss; a separate `Agricultural Assistance` entity handles financial payout.
    - **Two-Phase Numbering**: Temporary offline IDs replaced by permanent server-assigned numbers upon sync.
- **Reasoning**: Ensures field work can proceed offline while maintaining strict financial and document integrity.

### ADR 0009: Measurement Units Consolidation (Pending)
- **Status**: Proposed / Future Target
- **Decision**: Replace domain-specific lookup tables like `AreaUnit` with a unified `MeasurementUnit` entity.
- **Reasoning**: Measurement units are cross-domain master data (Land Area, Damage Quantities, Assistance Amounts, Production) and should be managed centrally with category support (LandArea, Weight, Count, Volume, etc.).
- **Implementation**: Current Sprint 11.2 will continue using `AreaUnit` for the Farm module to maintain focus, with refactoring planned for a future infrastructure sprint.

### ADR 0010: Reusable Search-First Selection Pattern
- **Status**: Accepted
- **Decision**: Implement a standardized "Search-First" selection pattern for all major entity lookups (e.g., Farm Owner selection, Damage Report -> Farm).
- **Requirements**:
    - **Search-First**: Users MUST search for an existing entity before creating a new one.
    - **Offline Search**: Search logic MUST be implemented in the `OfflineFirstRepository` using optimized Drift queries (covering names, ID, and phone).
    - **Create-New Fallback**: If no results are found, the lookup field MUST provide an action to create the new entity.
    - **Return Selection**: The creation form MUST return the created entity directly via `Navigator.pop(context, entity)`.
    - **Preserve State**: The parent form MUST receive the returned entity, update the selection, and preserve all other field states without a reset.
- **Reasoning**: This pattern reduces duplicate data entry, ensures regional scoping is maintained, and provides a seamless user experience for field officers working offline.

### ADR 0011: Late Binding ID Resolution Pattern
- **Status**: Accepted
- **Decision**: Implement "Late Binding" in the `BackgroundSyncService` to resolve cross-entity dependencies just before synchronization.
- **Requirements**:
    - **Dependency Resolution**: Before an entity (e.g., Farm) is sent to the backend, the sync engine MUST check if its dependent IDs (e.g., `farmerId`, `ownerFarmerId`) are local `ClientId`s.
    - **Mapping Lookup**: If a dependent `ClientId` is found, the sync engine MUST query the local database to find the corresponding server-assigned `serverId`.
    - **Deferral**: If a required `serverId` is not yet available (parent entity hasn't synced), the dependent sync task MUST be deferred (kept as `pending`) and retried in the next loop.
    - **Logging**: Clear logs MUST be provided showing the transition from `ClientId` to `ServerId` for troubleshooting.
- **Reasoning**: This allows users to create complex relational data (Farmer -> Farm -> Damage Report) while offline without worrying about the order of creation or the technical details of server identity.

## Folder Structure (Mobile)
- `lib/core`: Cross-cutting logic (Networking, Storage, Config).
- `lib/features`: Domain-driven feature modules.
  - `auth`: Authentication logic.
  - `dashboard`: Main user interface and statistics.
  - `farmers`: Farmer management.
  - `farms`: Farm management.
  - `damage_reports`: Report creation and viewing.
  - `map`: GIS features.
  - `admin`: User management and administrative tools.
- `lib/shared`: Reusable UI components and models.

## User Scope & Regional Isolation
Users are categorized into three scope levels which define their data access and operational boundaries:
1. **Global**: Access to system-wide data (e.g., SuperAdmin, Finance). No geographic assignment required.
2. **Governorate**: Tied to a specific Governorate. Can access all data within that governorate.
3. **Directorate**: Tied to a specific Directorate within a Governorate. Restricted to local data entry and assessment.

Geographic Hierarchy:
Governorate -> Directorate -> Locality -> Farm

These rules are enforced in the Backend via `RoleScopeType` validation and in the Flutter app via dynamic UI forms and regional filtering.
