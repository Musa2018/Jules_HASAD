# Farm (Land) Management Module Implementation Plan

This document outlines the engineering audit, gap analysis, and implementation roadmap for the Farm module, ensuring it meets the high-quality standards established during the Farmers module development.

## 1. Audit Report

### Current State Assessment
The existing Farm module is a rudimentary implementation from an earlier sprint (Sprint 7). While basic CRUD and offline sync exist, it lacks the robustness and business depth required for production.

**Backend Status:**
- `Farm` entity is missing critical agricultural and ownership fields.
- No Soft Delete support (Global Query Filters).
- Basic validation only.
- Relationships (OwnerFarmer) are not enforced or optimized.

**Flutter Status:**
- `Farm` domain model is out of sync with requirements.
- UI is basic (rudimentary forms, simple list).
- Lacks reactive filtering and advanced geographic lookups (Directorates).
- Under `lib/features/farmers` instead of its own feature folder.

## 2. Gap Analysis

| Category | Missing / Required | Impact |
| :--- | :--- | :--- |
| **Domain** | Basin, Parcel, Ownership Details, Agricultural Sector, Political Classification | **High**: Critical for reporting and damage assessment. |
| **Relationships** | OwnerFarmer (Conditional selection from Farmers table) | **High**: Farms must be linked to both an operator and an owner. |
| **Geography** | Directorate lookup integration | **Medium**: Required for localized assessment. |
| **Soft Delete** | Backend Global Query Filters and partial unique indexes | **Medium**: Required for data recovery and ID reuse. |
| **UI/UX** | Card-based UI, reactive filtering, cascading lookups | **Medium**: Consistency with Farmer module UX. |
| **Validation** | Conditional OwnerFarmer mandatory rule | **High**: Prevents invalid data entry for non-owned farms. |

## 3. Architecture Recommendations

1.  **Feature Isolation**: Move all farm-related code to `mobile/lib/features/farms/`.
2.  **Lookup Standardization**: Implement `OwnershipType`, `AgriculturalSector`, `PoliticalClassification`, `AreaUnit`, and `RelationshipToOwner` as backend entities with seeding.
3.  **Owner Selection**: Reuse `FarmerSearchScreen` logic to allow searching and selecting an existing farmer as the owner, with a fallback to create a new farmer.
4.  **Sync Hardening**: Ensure `FarmSyncDto` strictly maps to the new backend contract.

## 4. Proposed Sprint Roadmap

### Sprint 11.1: Backend Farm Foundation
- Update `Farm` entity with all missing fields.
- Implement Soft Delete (`IsDeleted`) with Global Query Filters.
- Add Partial Unique Index for `ClientId`.
- **Files**: `Farm.cs`, `ApplicationDbContext.cs`, `FarmsController.cs`.

### Sprint 11.2: Database & Lookup Tables
- Create entities for `OwnershipType`, `AgriculturalSector`, `PoliticalClassification`, `AreaUnit`, and `RelationshipToOwner`.
- Seed data for all lookups.
- Migrate Drift schema to **v10** in Flutter.
- **Files**: New Entities, `database.dart`.

### Sprint 11.3: Farm CRUD & Sync Hardening
- Update `CreateFarmCommand` and `UpdateFarmCommand` validators.
- Refactor `OfflineFirstFarmRepository` for new fields.
- Update `FarmSyncDto` and `RemoteFarmRepository`.
- **Files**: `CreateFarmCommand.cs`, `OfflineFirstFarmRepository.dart`, `farm_sync_dtos.dart`.

### Sprint 11.4: Farm Card UI & List Redesign
- Implement `FarmCard` with sync status, location details, and area.
- Implement `FarmsListScreen` with reactive filtering (name/basin/parcel).
- **Files**: `farm_card.dart`, `farms_list_screen.dart`.

### Sprint 11.5: Advanced Farm Form
- Implement cascading lookups (Gov -> Dir -> Loc).
- Add `OwnerFarmer` search/select workflow.
- Implement conditional validation (Owner required if Ownership != ملك).
- **Files**: `farm_form_screen.dart`.

### Sprint 11.6: Conflict & Error Handling
- Implement conflict resolution UI for Farms (409 Conflict).
- Harden `lastSyncError` propagation to UI.
- **Files**: `farm_details_screen.dart`.

### Sprint 11.7: Search First Workflow for Owners
- Deep integration between Farm creation and Farmer search.
- Support "Return to Farm" after creating a new Owner Farmer.
- **Files**: `farmer_search_screen.dart`, `farm_form_screen.dart`.

### Sprint 11.8: Soft Delete Workflow Hardening
- Verify "Delete then Re-create" scenario for Farms.
- Filter out pending-delete farms from lookups.
- **Files**: `OfflineFirstFarmRepository.dart`.

### Sprint 11.9: Production Testing & Documentation
- Comprehensive regression testing.
- Update `ARCHITECTURE.md` and `DOMAIN_DOCS.md`.

## 5. Testing Strategy

- **Unit Tests**:
  - `FarmValidator` tests for conditional rules.
  - `FarmSyncDto` payload verification.
- **Integration Tests**:
  - Offline creation -> Sync -> Server success.
  - Conflict resolution (Server Wins).
  - Soft delete local/remote synchronization.
- **UI Tests**:
  - Geographic dropdown cascading logic.
  - Owner selection return value.

## 6. User Review Required

> [!IMPORTANT]
> **Owner Farmer Selection**: The workflow will allow selecting any existing farmer as an owner. If the owner is not in the system, the user will be redirected to the "Create Farmer" form. Upon success, they will be returned to the "Farm" form with the new owner auto-selected.

> [!WARNING]
> **Drift Migration v10**: This migration adds several non-nullable columns with defaults to the `Farms` table. Existing local data will be preserved but initialized with default values.
