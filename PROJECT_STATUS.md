# HASAD Project Status

> Living document — updated at the end of every sprint.

- **Current Version**: v0.12.0-alpha (Architecture Design)
- **Current Sprint**: Sprint 12.3 — Form & Sync Hardening (Regression Fix: Geographic Authorization)
- **Current Branch**: `DamageReport`
- **Last Updated**: 2026-07-23
- **Latest Commit**: `e073d75`

## Sprint 13.2 — IN PROGRESS
Damage Assessment & Valuation Engine:
- **Phase 1 (Completed)**: Backend Valuation Guards.
    - Implemented `ICostingService` for authoritative price resolution.
    - Hardened `CreateDamageReport` and `UpdateDamageItem` handlers to recalculate technical loss.
    - Added valuation mismatch auditing via server logs.
- **Phase 2A (Completed)**: Pricing Catalog Backend Implementation.
    - Implemented `CostingSheetCatalog`, `CostingSheetVersion`, and `CostingSheetItem` hierarchy.
    - Consolidated `AreaUnit` into a universal `MeasurementUnit` entity.
    - Implemented Data Preservation migration for existing pricing and snapshots.
    - Refactored all backend commands and tests to align with the new architecture.
    - Maintained backward compatibility for existing offline mobile payloads.
- **Phase 2B (Completed)**: Flutter Domain & Repository Migration.
    - Upgraded Drift schema to v16 with hierarchical pricing support.
    - Refactored domain models (`DamageItem`, `Farm`, `ReferenceData`) to align with the new architecture.
    - Updated `OfflineFirstReferenceDataRepository` to resolve the `Active` pricing version via database joins.
    - Implemented legacy pricing compatibility wrapper for unsynced offline data.
    - **Hardening**: Implemented safe multi-step migration for `directorate_id` in `DamageReport` to prevent schema migration failures on existing data while maintaining authorization integrity.
    - **Validation**: Completed Production Readiness Gate with 115 backend and 25 critical sync tests passing (including v15 backfill verification).
- **Phase 2C (Completed)**: Flutter Client Terminology Update.
    - Aligned UI terminology with universal `MeasurementUnit` domain model.
    - Updated localization (Ar/En) for "Measurement Unit" and unit categories (Area, Weight, Count, Volume).
    - Hardened `DamageItemFormSheet` to dynamically resolve measurement units from costing snapshots.
    - Verified full backward compatibility for legacy `areaUnitId` and `costingSheetId` fields.
    - Passed all 152 mobile tests and static analysis.
- **Roadmap Review (Completed)**: Post Sprint 13.2 Architecture Gate.
    - Performed comprehensive DamageReport Roadmap Review.
    - Defined "Evidence Lifecycle" (Captured -> Uploaded -> Validated -> Locked -> Archived).
    - Analyzed "Assistance Integration" requirements.
    - Verified sync impact for locking and metadata.
- **Phase 3 (In Progress)**: DamageReport Form Completion & Evidence Foundation.
    - **Gap Analysis (Completed)**: Identified missing Hierarchical Cause Selection and Form Integration on mobile.
    - **UI Polish (Pending)**: Integrate `DamageItemFormSheet` and implement `DamageCauseSelector`.
    - **Evidence Foundation (Pending)**: Domain migration from Attachments to Evidence Lifecycle.

## Sprint 13.1 — COMPLETED

## Sprint 12.3 — COMPLETED
Hierarchical Classification UI:
- **Cascading Selector**: Implemented a 4-step wizard for selecting Damage Nature, Category, SubCategory, and Classification.
- **Price Snapshot Engine**: Automated resolution of active Costing Sheets with immutable snapshotting for Damage Items.
- **Valuation Logic**: Integrated `ValuationEngine` for real-time technical loss calculation on the mobile device.
- **Cascading Resets**: Hardened state management to ensure child selections are cleared when a parent level is changed.
- **Search Integration**: Enabled Arabic/English partial search for all hierarchy levels completely offline.
- **Status**: ✅ **Production Ready**.

## Sprint 12.1 — COMPLETED

## Sprint 12.0 — COMPLETED
Damage Report Engineering Audit & Design:
- **Audit**: Completed analysis of existing placeholder damage implementation.
- **Gap Analysis**: Identified critical missing features: Sequential numbering, 10-stage workflow, costing sheets, and hierarchical causes.
- **Design Deliverables**: Prepared Engineering Audit Report, Proposed Domain Model, Workflow State Machine, and Sync Strategy.
- **Documentation**: Updated `AI_CONTEXT.md` and `PROJECT_STATUS.md` with the new module roadmap.
- **Status**: ✅ **Approved**.

## Sprint 11.17 — COMPLETED
Domain Integrity Hardening:
- **Deletion Protection**: Hardened the domain layer by implementing dependency checks in delete commands, preventing orphaned records.
- **Business Rule Enforcement**: Farmers can no longer be deleted if linked to any Farm; Farms can no longer be deleted if linked to any Damage Report.
- **Error Transparency**: Enhanced the sync engine and UI to propagate and display localized business error messages from the backend (e.g., "لا يمكن حذف المزارع...").
- **Test Coverage**: Expanded both backend and mobile test suites to cover restricted deletion scenarios and error reporting.
- **Status**: ✅ **Production Ready**.

## Sprint 11.16 — COMPLETED
Hardened Offline Delete Workflow:
- **Pending Delete Visibility**: Implemented a new UX rule where records stay visible (dimmed) during the deletion sync process, preventing silent disappearance and data loss.
- **Undo/Retry Support**: Added "Undo Delete" and "Retry" actions to both `FarmerCard` and `FarmCard` to handle sync failures gracefully.
- **Repository Hardening**: Updated `FarmerRepository` and `FarmRepository` to include `cancelDelete` methods, ensuring the `SyncQueue` and local storage remain consistent.
- **Sync Reliability**: Fixed a bug in `BackgroundSyncService` where generic error messages were not being propagated to the local database, hindering user troubleshooting.
- **Test Coverage**: Added `offline_delete_workflow_test.dart` verifying the complete lifecycle of offline deletion, failure recovery, and undo actions.
- **Status**: ✅ **Production Ready**.

## Sprint 11.15 — COMPLETED
Search-First Owner Workflow:
- **Workflow Standardization**: Implemented the "Search First" pattern for owner selection, supporting ID, Ar/En names, and Phone number searching.
- **Repository Optimization**: Unified searching logic in `OfflineFirstFarmerRepository` to use a single `searchText` with OR-based SQL queries.
- **Seamless Creation**: Integrated the "Add New Farmer" action directly into the lookup sheet, with automatic selection upon return and state preservation for the parent form.
- **Strict Validation**: Hardened `FarmValidator` to ensure all relational dependencies (`OwnerFarmerId`, `RelationshipToOwnerId`) are met for non-owned farms.
- **Test Coverage**: Added `owner_search_workflow_test.dart` and updated `farm_validator_test.dart` to cover the new workflow and rules.

## Sprint 11.14 — COMPLETED
Farm Module Production Hardening:
- **Identity Hardening**: Secured the JWT identity contract by adding the `Name` claim, enabling reliable user-based auditing.
- **Automated Auditing**: Centralized soft-delete audit logic in the backend persistence layer. All deletions now automatically capture `DeletedAt` and `DeletedBy`.
- **Entity Alignment**: Upgraded the `Farmer` entity to include audit fields, reaching parity with the `Farm` module.
- **UX Verification**: Hardened the `FarmFormScreen` against stale data, ensuring switching between "Owned" and "Rented" types correctly nullifies or populates relationships.
- **Test Coverage**: Reached 91 backend tests and 130 mobile tests with a focus on audit integrity and UX reliability.
- **Status**: ✅ **Production Ready**.

## Sprint 11.13 — COMPLETED
Farm UX Enhancement:
- **Direct Action**: Replaced the "Search" button on the `FarmerCard` with a "Farm" (`مزرعة`) button for quick farm creation.
- **Form Intelligence**: Enabled `FarmFormScreen` to pre-fill Operator and Owner details based on the navigation context, reducing redundant data entry.
- **RTL Support**: Ensured the new button and icon align with the Arabic RTL layout and Material Design standards.
- **Test Coverage**: Added `farmer_card_navigation_test.dart` and `farm_form_prefill_test.dart` verifying the new UX flow.

## Sprint 11.12 — COMPLETED
Sync Identity Mapping & Lifecycle Fix:
- **Identity Standard**: Implemented an explicit identity mapping contract across the mobile app. Standardized `serverId` (Backend GUID) and `id` (Local ClientId/UUID) separation to prevent ID collision and 404 errors.
- **Explicit JSON Mapping**: Updated all synchronized domain models (`Farm`, `Farmer`, `DamageReport`, `DamageItem`, `Attachment`) with `@JsonKey` annotations to ensure deterministic mapping: Backend `Id` -> `serverId`, Backend `ClientId` -> `id`.
- **Sync Hardening**: Updated `BackgroundSyncService` to correctly persist `serverId` after creation and enforced its usage in update payloads, resolving "Farm not found" errors during ownership type updates.
- **Documentation**: Formally documented the **Offline Sync Identity Contract** in `AI_CONTEXT.md` as a reusable architectural rule.
- **Test Coverage**: Added `farm_sync_flow_test.dart` verifying the complete "Create -> Sync -> Edit -> Sync Update" lifecycle and late-binding dependency resolution.

## Sprint 11.11 — COMPLETED
Navigation Type Mismatch Fix:
- **Type Safety**: Fixed the `_FarmImpl is not a subtype of Map<String, dynamic>` crash by refactoring the edit navigation to use strongly typed `Farm` objects.
- **Form Resilience**: Enabled `FarmFormScreen` to work without a pre-provided `Farmer` object by fetching it from the local database using the farm's `farmerId`.
- **Navigation Consistency**: Unified the navigation patterns in `FarmCard`, `FarmsListScreen`, and `FarmDetailsScreen`.
- **Test Coverage**: Added `farm_edit_navigation_test.dart` to verify the new strongly-typed navigation and lazy-loading of operator data.

## Sprint 11.10 — COMPLETED
Late Binding ID Resolution:
- **Dependency Sync**: Resolved the "Farmer not found" failure by implementing late-binding resolution of local IDs to server IDs during the sync process.
- **Ordered Execution**: The sync engine now automatically deferrs dependent tasks (like Farm creation) until their parent records (like Farmer) are successfully created on the server.
- **Improved Logging**: Added detailed debug logs tracing the resolution of `ClientId` to `serverId` for all relational fields.
- **Test Coverage**: Added `late_binding_sync_test.dart` verifying the complete lifecycle of ordered offline creation and synchronization.

## Sprint 11.9 — COMPLETED
Authorization Hardening & Token Fix:
- **JWT Fix**: Added geographic scope claims (`governorate_id`, `directorate_id`) to the authentication token, resolving "Access Denied" errors in synchronization.
- **Universal Scoping**: Applied regional authorization rules across all synchronized entities: Farmers, Farms, and Damage Reports.
- **Security Hardening**: Enforced that Agricultural Engineers and Surveyors can only create/update data within their assigned Directorate.
- **Test Coverage**: Verified with 89/89 active backend tests passing, including new token and scope validation scenarios.

## Sprint 11.8 — COMPLETED
Search-First Owner Selection Workflow:
- **Reusable Pattern**: Formally adopted the **Search-First Selection Pattern** for all major entity lookups.
- **Enhanced Search**: Upgraded `OfflineFirstFarmerRepository` to support comprehensive 8-part name searching (Arabic/English), ID, and phone number matching locally.
- **Actionable Lookups**: Enhanced `SearchableLookupField` with `onAction` support, allowing seamless "Create New" transitions when results are empty.
- **Seamless UX**: Integrated "Create Farmer" into the Farm Creation form. Newly created farmers are automatically selected upon return, and all previously entered farm data is preserved.
- **Hardened Data Layer**: Ensured soft-deleted and pending-delete records are strictly excluded from all search results.

## Sprint 11.7 — COMPLETED
Geographic Regression & API Centralization:
- **Regression Fix**: Resolved the Governorate dropdown failure by aligning Backend DTOs with Flutter Domain Models (added missing `Code` field).
- **API Centralization**: Moved and unified geographic lookup endpoints to a shared `LocationController`, improving code reuse and fixing authorization issues for non-admin users.
- **Flutter Refinement**: Fixed critical syntax errors and incorrect API paths in `LocationRepository`.
- **Test Coverage**: Added backend tests verifying `Code` field return and authorized access to geographic data.

## Sprint 11.5 — COMPLETED
Farm Production Acceptance Audit:
- **Comprehensive Audit**: Performed complete end-to-end, offline, and authorization audit of the Farm module.
- **Certification**: Certified the Farm module as Production Ready.
- **Refinement**: Resolved minor linting issues and optimized code for Dart 3.8 features.
- **Test Coverage**: Verified 111 passing tests across the module.

## Sprint 11.4 — COMPLETED
Farm Management UI:
- **Card-Based UI**: Implemented `FarmCard` with comprehensive farm details, reactive sync status, and integrated actions.
- **Reactive Streams**: Migrated Farm list to `StreamProvider` powered by Drift database streams for real-time updates.
- **Advanced Filtering**: Implemented search-by-name/basin/parcel and multi-parameter filtering (Sector, Ownership, Sync Status, Geography).
- **Farm Details**: Created a dedicated details screen with sectioned layout and reactive data binding (preventing stale RowVersion).
- **Soft Delete Workflow**: Integrated a production-grade soft-delete confirmation and synchronization UI.
- **Integrated Search**: Enhanced `SearchableLookupField` with async searching for large datasets like Farmers.

## Sprint 11.3 — COMPLETED
Farm CRUD & Sync Hardening:
- **Production CRUD**: Implemented full offline-first CRUD for Farms with `FarmValidator` enforcing business and geographic rules.
- **Geographic Hierarchy**: Updated system to `Governorate -> Directorate -> Locality`. Modified both Backend and Flutter models/tables.
- **Offline Geography**: Implemented `OfflineFirstLocationRepository` with Drift caching for all 16 Governorates and their associated Directorates and Localities.
- **Sync Hardening**: Improved `BackgroundSyncService` with "Server Wins" policy for Farm conflicts, handling `RowVersion` and detailed logging.
- **Authorization**: Enforced Directorate-based scoping for Engineers and Surveyors in both UI (read-only fields) and Repository/Backend layers.
- **Owner Farmer Integration**: Enabled searchable owner farmer selection using existing offline farmer cache and async searching in lookups.

## Sprint 11.1 — COMPLETED
Backend Farm Foundation:
- **Entity Redesign**: Redesigned `Farm` entity with `FarmerId`, `OwnerFarmerId`, and lookup relationships.
- **Lookup Tables**: Added `OwnershipType`, `AgriculturalSector`, `PoliticalClassification`, `AreaUnit`, and `RelationshipToOwner` entities with seed data.
- **Soft Delete**: Implemented `IsDeleted`, `DeletedAt`, and `DeletedBy` with EF Core Global Query Filters.
- **DTOs & Commands**: Updated `CreateFarmCommand`, `UpdateFarmCommand`, and `FarmDto` to align with the new business model.
- **Synchronization**: Ensured `ClientId`, `ServerId`, and `RowVersion` consistency.
- **Validation**: Added conditional validation for Owner Farmer mandatory rule.

## Sprint 11.0 — COMPLETED
Farm Module Engineering Audit:
- **Comprehensive Audit**: Performed complete audit of existing Farm module against Farmer module quality standards.
- **Gap Analysis**: Identified missing fields (Basin, Parcel, OwnerFarmer, etc.) and architectural misalignments.
- **Roadmap Definition**: Created a detailed 9-sprint roadmap for Farm module implementation.
- **Implementation Plan**: Prepared a detailed design document for approval.

## Sprint 10.17 — COMPLETED
Farmer Soft Delete Workflow Fix:
- **Filtered Lookups**: Updated `OfflineFirstFarmerRepository` to exclude soft-deleted records from the "search by ID" flow, enabling the creation of new farmers using the same ID number as a deleted record.
- **Global Query Filter**: Implemented an EF Core Global Query Filter on the backend for the `Farmer` entity to transparently ignore deleted records in standard queries.
- **Partial Unique Indexes**: Updated backend database indexes for `IdNumber` and `ClientId` to be partial, enforcing uniqueness only among active (non-deleted) records.
- **Workflow Verification**: Added `soft_delete_workflow_test.dart` verifying the complete "Delete then Re-create" scenario.

## Sprint 10.16 — COMPLETED
Farmer Management UI Redesign:
- **Card-Based Interface**: Replaced the simple list view with a detailed `FarmerCard` UI showing essential demographics, location, and reactive sync status.
- **Advanced Offline Filtering**: Implemented a real-time search and filter system powered by Drift database streams, supporting search by name/ID/phone and filtering by gender and sync status.
- **Synchronized Soft-Delete**: Integrated a secure soft-delete workflow that marks local records as pending and queues remote deletion, preserving data integrity.
- **Reactive Data Binding**: Refactored the list provider to use `StreamProvider`, ensuring the UI automatically reflects background synchronization progress and local edits.

## Sprint 10.15 — COMPLETED
Farmer Update Sync Reliability:
- **Reactive Data Flow**: Fixed a critical bug in `FarmerDetailsScreen` where stale constructor data was being passed to the Edit form instead of the reactive database stream.
- **RowVersion Persistence**: Ensured `rowVersion` (Concurrency Token) is correctly propagated to the edit form, resolving "RowVersion is required" sync failures.
- **Repository Safety**: Added a guard in `RemoteFarmerRepository` to prevent sending updates with empty concurrency tokens.

## Sprint 10.14 — COMPLETED
Entity Metadata Hardening & Update Sync Fix:
- **Universal Metadata Mapping**: Added `serverId`, `syncStatus`, and `lastSyncError` to `Farm`, `DamageReport`, and `DamageItem` domain models to ensure consistency with the `Farmer` entity.
- **Authority ID Reconciliation**: Hardened `Update` DTO mapping to use `serverId` for the primary resource identification, resolving `404 Not Found` errors during update synchronization.
- **Refined Repository Mappings**: Updated offline repositories to correctly map and preserve synchronization metadata from the local database into domain models.
- **Concurrency Token Flow**: Verified that `rowVersion` (Optimistic Concurrency Token) is correctly passed in `PUT` requests for all entity types.
- **Regression Tests**: Added unit tests for Update payload generation for all entity types.

## Sprint 10.13 — COMPLETED
Sync DTO Mapping Layer Implementation:
- **Decoupled Sync Payloads**: Implemented `FarmerSyncDto`, `FarmSyncDto`, and `DamageReportSyncDto` to strictly map local domain entities to backend command contracts.
- **Date Normalization**: Ensured `BirthDate` for Farmers is sent in `yyyy-MM-dd` format to match .NET `DateOnly`, resolving parsing errors.
- **Gender Validation Hardening**: DTO layer now enforces `Gender` rules (Male/Female) and blocks `unspecified` values before transmission.
- **Payload Sanitization**: Cleaned all sync payloads of local-only metadata (`syncStatus`, `lastSyncError`, etc.), preventing payload pollution and backend binding issues.
- Tests: Added `farmer_sync_dtos_test.dart` to verify exact JSON output for all sync operations.

## Sprint 10.12 — COMPLETED
Universal Sync Lifecycle & Soft-Delete Hardening:
- **Soft-Delete Foundation**: Implemented `isPendingDelete` across all entities. Local hard-deletes now only occur after successful server-side deletion, ensuring remote data integrity.
- **Robust Local Cascades**: Updated `BackgroundSyncService` to manually handle relational deletions (Damage Reports -> Items & Attachments) and local file cleanup during hard-deletes.
- **Generic Validation Abstraction**: Unified sync error handling using `SyncValidationException`. All entity types now correctly handle HTTP 400 validation failures by stopping retries and informing the user.
- **Sync Engine Refinement**: Fixed operation collapsing bug where unsynced `CREATE` tasks were incorrectly changed to `UPDATE`. Implemented "Lifecycle Collapsing" (CREATE + DELETE = immediate removal).
- **Drift Migration**: Successfully migrated to schema **v9**.
- Tests: Reached 23 passing sync/repository tests covering soft-delete, cascading deletes, and generic operation preservation.

## Sprint 10.11 — COMPLETED
Sync Lifecycle Consistency & Soft-Delete:
- **Soft-Delete Lifecycle**: Implemented "Pending Delete" state across all entities (Farmers, Farms, DamageReports, Attachments). Records are now soft-deleted locally, synchronized with the server, and then hard-deleted upon success.
- **Universal Operation Collapsing**: Generalised "Preserve CREATE" logic to all entity types. Offline edits to pending `create` tasks now correctly maintain the `create` operation, preventing backend 404s.
- **Lifecycle Collapsing**: Implemented immediate removal of unsynced records when deleted offline (CREATE + DELETE = NO-OP), keeping the database and sync queue clean.
- **Generic Sync Abstractions**: Centralized error handling with `SyncException` and `SyncValidationException`. All remote repositories now uniformly map HTTP 400 errors to block retries and inform the user.
- **Safe Migration**: Successfully migrated Drift schema to **v9**.
- Tests: Added comprehensive coverage for the new delete lifecycle and generic operation collapsing.

## Sprint 10.10 — COMPLETED
Farmers Sync Hardening Verification & Fix:
- **Operation Collapsing Fix**: Resolved a critical bug where offline edits to a pending `CREATE` operation would change the task to `UPDATE`, causing backend 404s. The system now preserves the `CREATE` operation until the record is successfully born on the server.
- **Error Recovery Hardening**: Ensured `lastSyncError` is cleared when a record is updated after user correction, providing a clean slate for retry.
- **Lifecycle Verification**: Verified the complete sync lifecycle including Invalid data flow, User correction flow, Offline Create-Update collapsing, and App Restart recovery.
- Tests: Added 3 new test scenarios to `BackgroundSyncService` covering operation preservation, multiple update collapsing, and retry status resets.

## Sprint 10.9 — COMPLETED
Offline Sync Invalid Data Handling Hardening:
- **Schema Upgrade (v8)**: Added `lastSyncError` columns to all entities to persist exact backend failure reasons.
- **Validation-Driven Sync**: Background sync now distinguishes between transient (network) and permanent (business rule) failures. HTTP 400 errors mark items as `invalid` and stop retries.
- **Task Upsertion**: Enhanced `SyncQueue` logic to update existing pending/invalid tasks instead of creating duplicates, preventing queue bloat.
- **Error Visibility**: Implemented prominent error banners in `FarmerDetailsScreen` allowing users to see specific backend validation messages and navigate directly to the edit form.
- **Safe Migration**: Verified safe Drift schema migration from v7 to v8.
- Tests: Added coverage for validation failure handling, network retry logic, and queue upsertion.

## Sprint 10.8 — COMPLETED
Farmers Create Sync Validation Fix:
- **Two-Level Validation**: Implemented mandatory validation in both `FarmerFormScreen` (UI) and `OfflineFirstFarmerRepository` (Data layer).
- **Reusable Domain Logic**: Created `FarmerValidator` in the domain layer to centralize rules: IdType required, Gender required (Male/Female), Family Size >= 1, and Age >= 18.
- **Data Integrity**: Repository rejects invalid data before Drift insertion or SyncQueue addition, throwing `FarmerException`.
- **UI Feedback**: Form fields provide immediate localized feedback for demographic and identity rules.
- Tests: Added comprehensive validation tests for all failure cases and verified valid creation enters the sync pipeline.

## Sprint 10.7 — COMPLETED
Hardened Farmers synchronization and fixed "Create Farmer" stuck status:
- **Interrupted Sync Recovery**: Enhanced `BackgroundSyncService` to recover items stuck in `syncing` status using a 5-minute timeout or startup trigger.
- **Unified Propagation**: Centralized `syncStatus` updates from `SyncQueue` to entity tables (e.g., `Farmers`), ensuring the UI (badge) accurately reflects states like `syncing`, `failed`, or `conflict`.
- **Payload Optimization**: Fixed `RemoteFarmerRepository.createFarmer` to remove generated database `id` from POST requests, relying on `clientId` for idempotency as per backend requirements.
- **Robustness**: Added tests for recovery of stuck items and real-time status propagation through the sync lifecycle.
- Tests: Verified with all `background_sync_service_test.dart` scenarios passing.

## Sprint 10.6 — COMPLETED
Fixed permanent "Awaiting Sync" status and improved UI reactivity:
- **Background Sync**: Refactored `BackgroundSyncService` with a drain loop to process items added during active sync and added a startup trigger.
- **Reactivity**: Added `watchFarmer` stream to `FarmerRepository` and `farmerStreamProvider` to enable real-time UI updates when sync completes.
- **UI**: Updated `FarmerDetailsScreen` to reactively reflect database changes.
- **Robustness**: Added tests for sync race conditions and startup auto-resume.
- Tests: Verified with updated `background_sync_service_test.dart` and `offline_first_farmer_repository_test.dart`.

## Sprint 9.1 — IN PROGRESS
Implemented User Management and Regional Scoping:
- **Backend Core**: New `AppRoles` registry and `RoleScopeType` enum (Global, Governorate, Directorate) for multi-level geographic validation.
- **Security**: Hardened `CreateUserCommand` with 3-level scope validation and safe DTO exposure (no sensitive fields).
- **Mobile Admin**: New `admin` feature module with `UsersScreen` and `CreateUserScreen`.
- **Dynamic UI**: User creation form adapts automatically to selected roles, enforcing mandatory geographic assignments (e.g., Engineer requires Directorate).
- **Session Scoping**: `AuthSession` extended to include `userId`, `governorateId`, and `directorateId`, enabling offline-ready regional isolation.
- **Localization**: Full Arabic/English support for all new administrative interfaces.
- Tests: Added 20+ unit/widget tests for user management logic and security.

## Sprint 8 — COMPLETED
Implemented Evidence & Attachment Management module:
- **Attachment Domain**: New `DamageReportAttachment` entity with support for
  local/remote paths, file metadata, and upload status.
- **Storage Abstraction**: `IFileStorageService` implemented with local disk
  storage as a default, ready for Azure/S3 transition.
- **Backend API**: `UploadAttachmentCommand` (idempotent) and endpoints for
  managing multi-part file uploads within damage reports.
- **Mobile Persistence**: Drift schema upgraded to **v6** to support attachment
  metadata and background upload status.
- **Upload Engine**: Extended `BackgroundSyncService` to handle binary file
  uploads with existing retry and backoff logic.
- **UI/UX**: `AttachmentGalleryScreen` for capturing (camera) and managing
  damage evidence photos.
- Tests: Verified with 45 backend and 44 mobile tests.

## Sprint 7 — COMPLETED
Implemented Farm Management module with offline-first support:
- **Farm Domain**: New `Farm` entity with `ClientId`, `FarmerId`, and optimistic
  concurrency (`RowVersion`).
- **Backend API**: Full CRUD support with `FarmsController` and RBAC.
  Idempotent creation and versioned updates.
- **Mobile Persistence**: Drift schema v4 adding `Farms` table with migration
  strategy.
- **Sync Integration**: `BackgroundSyncService` updated to support `Farm`
  entity with automatic background synchronization and conflict resolution.
- **UI/UX**: `FarmsListScreen` and `FarmFormScreen` with RTL (Arabic) support,
  localized validation, and integration into existing navigation flow.
- Tests: Added backend unit tests and mobile widget tests for Farm features.

## Sprint 5 — COMPLETED
Complete synchronization robustness and infrastructure hardening:
- **Backend Idempotency**: `Farmer` entity updated with `ClientId` (unique index);
  `CreateFarmerCommand` implements check-and-create logic to prevent duplicates.
- **Optimistic Concurrency**: `RowVersion` added to `Farmer` for conflict
  detection; `UpdateFarmerCommand` returns `409 Conflict` on version mismatch.
- **Drift Migrations**: Mobile schema upgraded to v3; implemented `onUpgrade`
  strategy for `rowVersion` and `lastAttemptAt` columns.
- **Sync Engine**: `BackgroundSyncService` enhanced with retry backoff policy
  (1, 5, 15 min), detailed status tracking (Pending, Syncing, Completed,
  Failed, Conflict), and "Server Wins" resolution for 409 errors.
- Tests: Added backend tests for idempotency/concurrency and mobile unit
  tests for conflict resolution.
- Delivered via direct implementation and verification.

## Sprint 4 — COMPLETED
Complete production-ready authentication subsystem delivered and merged
(PR #31, tag `sprint-0`, GitHub Release published): secure configuration,
JWT hardening (issuer/audience, 1h tokens, externalized key), persisted
refresh tokens with rotation and family revocation, login hardening
(401 semantics, rate limiting, lockout), configurable seed admin.
Verification: unit tests, full auth E2E, both CI workflows green on the PR
and on `main` post-merge. Milestone closed (5/5 issues).

## Sprint 1 — COMPLETED
- MediatR pinned to 12.5.0 (Apache-2.0) per approved Option B (ADR 0008).
- C7 (#17): InMemory-safe database initialization with explicit
  migration/seeding logging and fail-fast error reporting.
- H1 (#18): migration history squashed into a single verified `InitialCreate`.
- H3 (#20): FluentValidation pipeline behavior + Login/Refresh/Logout
  validators; validation failures return `400` with error details.
- M2 (#25): ITokenService extraction verified complete (delivered in Sprint 0).
- Tests: 25 backend unit tests (11 added this sprint).
- Delivered via PR #33, tag `sprint-1`, GitHub Release published.

## Sprint 2 — COMPLETED
- C6 (#16): fail-fast `EnvironmentConfig` initialized in `main()` before
  `runApp()`; login-time crash eliminated.
- M1 (#24): LoginScreen rewritten — proper controller lifecycle, client-side
  validation, localized (en/ar) errors, loading state.
- M3 (#26): logout with server-side revocation, single-flight token refresh
  with rotation, transparent 401 retry via `AuthInterceptor`, session
  restoration on app start. (Drift sync-queue remains a post-remediation
  epic per the issue.)
- L3 (#30): auth-guarded GoRouter with `/login`, `/home`, splash, and
  auth-state-driven redirects.
- Tests: 22 mobile unit/widget tests + opt-in live E2E auth lifecycle test.
- Delivered via PR #34 (tag `sprint-2`, Release published) plus follow-up
  PR #35 hardening auth error handling against malformed backend payloads
  (fixes both post-merge review findings). First alpha tagged: `v0.3.0-alpha`.

## Sprint 3 — Testing & Code Coverage (this sprint)
- #19: expanded `Hasad.Application.Tests` — LogoutCommandHandler tests and
  DbInitializer seeding tests (roles idempotency, SuperAdmin creation/skip,
  password-policy failure); 31 backend tests total (6 added this sprint).
- #29: Flutter widget-test suite expanded — LoginScreen loading state and
  Arabic/RTL rendering + localized validation, HomeScreen (welcome, logout,
  RTL), and router auth-guard tests (splash hold, login redirect, session
  restoration to home, login navigation, logout return); 38 mobile tests
  total (11 added this sprint).
- No production code changes; tests only.

## Sprint 4 — CI/CD Hardening (this sprint)
- #22: CI hardening — `actions/checkout@v4` and `actions/setup-dotnet@v4`/
  `actions/setup-dotnet` caching; .NET SDK pinned to `8.0.422` (also via new
  `hasad/backend/global.json`); Flutter pinned to `3.41.2` (matches the
  project's `.metadata`, replacing the floating `3.x`); concurrency
  cancellation on both workflows; `dotnet format --verify-no-changes` gate
  added; coverage published as build artifacts (Cobertura for backend, LCOV
  for mobile); backend build uses `-p:ContinuousIntegrationBuild=true` for
  deterministic output.
- #23: `hasad/backend/docker-compose.yml` — `postgres:alpine` pinned to
  `postgres:16-alpine`, obsolete `version` key removed, `pg_isready`
  healthcheck and a named volume added.
- No application code, business logic, API, or architecture changes.
- Validated locally end-to-end (SDK 8.0.422 / Flutter 3.41.2, installed
  fresh in the build sandbox): `dotnet restore/format/build/test` (31/31
  passing) and `flutter pub get`/`dart format`/`flutter analyze`/
  `flutter test --coverage` (38/38 passing) and `flutter build web`
  (informational only, not added to CI) all green.

## Open Issues (remediation backlog)
- Sprint 5 (Repository Cleanup): #21, #28
- Sprint 6 (Documentation Sync): #27

## Completed Issues
- Sprint 0: #11, #12, #13, #14, #15 — closed via PR #31.
- Sprint 1: #17, #18, #20, #25 — closed via PR #33.
- Sprint 2: #16, #24, #26, #30 — closed via PR #34 (+ hardening PR #35).
- Sprint 3: #19, #29 — closing via this sprint's PR.
- Sprint 4: #22, #23 — closing via this sprint's PR.

## Current Risks
- Sessions issued before the JWT key rotation are invalidated (expected; users
  must log in again).
- Rate limiting is per-instance in-memory; multi-instance deployments need a
  distributed limiter (tracked for the production roadmap).

## Technical Debt
- No backend integration-test project yet (unit + live E2E coverage only;
  a dedicated WebApplicationFactory-based suite remains future work).
- Drift sync-queue (offline persistence) implemented with v3 schema and background sync service.
- Junk files (`Class1.cs`, `build_output.txt`) outstanding (Sprint 5).

## CI Status
- Green: .NET CI and Flutter CI on `main` and on the Sprint 4 branch (hardened workflows: pinned toolchains, format gates, coverage artifacts, concurrency cancellation).

## Next Sprint
- Sprint 5 — Repository Cleanup (requires explicit user approval).
