# Engineering Audit Report: DamageReport Module

## 1. Current State Assessment

The existing codebase contains a baseline implementation for Damage Reports, which was likely used as a placeholder or initial proof-of-concept. While it follows the project's Clean Architecture and Offline-First patterns, it lacks the depth required for the production-grade Sprint 12 requirements.

### Backend Infrastructure
- **Entities**: `DamageReport` and `DamageItem` exist with basic fields.
- **Persistence**: EF Core configurations and migrations are present.
- **CQRS**: Commands and Queries for basic CRUD are implemented.
- **Authorization**: Simple role-based access (Engineer/Surveyor) with governorate-level scoping.
- **Sync**: Idempotency via `ClientId` and concurrency via `RowVersion` are supported.

### Mobile Infrastructure (Flutter)
- **Data Layer**: Drift tables and Offline-First repositories are implemented.
- **Domain**: Freezed models for reports and items.
- **Sync Engine**: Integrated with `BackgroundSyncService` for eventual consistency.
- **UI**: Basic form and list screens exist but are insufficient for the new requirements.

---

## 2. Gap Analysis

| Feature Area | Current Implementation | Sprint 12 Requirement | Gap / Missing |
| :--- | :--- | :--- | :--- |
| **Identification** | Manual UUID | Automatic Form Number (Sequential + Directorate + Year) | Missing numbering logic & persistence |
| **Categorization** | Basic Sector/Crop | Political vs Natural + Cause Hierarchy | Missing DamageCause domain models |
| **Classification** | Flat list of items | 5-level Hierarchy (Nature -> Main -> Sub -> Final -> Costing) | Missing classification system & lookup data |
| **Pricing** | Manual `EstimatedLoss` | Dynamic Costing Sheet with versioning & effective dates | Missing CostingSheet architecture |
| **Calculations** | Manual entry | `Quantity × Unit Cost × Damage Percentage` | Missing calculation engine |
| **Workflow** | Simple `StatusId` string | 10-stage State Machine with Role-based transitions | Missing Workflow Engine & Transition Rules |
| **Audit Trail** | Basic `CreatedAt/UpdatedAt` | Detailed Workflow History (From, To, User, Reason) | Missing WorkflowHistory entity |
| **Roles** | 4-5 basic roles | 10+ granular Ministry & Directorate roles | Missing role definitions & scoping |
| **Attachments** | Generic upload | Archive-role-only management | Missing role-specific attachment permissions |
| **Validation** | Basic field checks | Duplicate Prevention (Farm + Date) | Missing backend & offline duplicate check |

---

## 3. Structural Problems

1. **Flat Data Structure**: The current `DamageItem` is too simple. It cannot support the hierarchical classification and dynamic costing requirements.
2. **Missing State Management**: The "Workflow" is currently anemic. Moving to a real state machine requires a fundamental change in how status updates are handled (Transitions vs direct updates).
3. **Numbering Conflict**: The automatic form number must be unique and sequential. Generating this in an offline-first environment is a significant challenge (risk of collisions).
4. **Lookup Data Bloat**: The 5-level classification system will require thousands of lookup entries. The current Drift sync strategy for lookups needs to be optimized for this volume.

---

## 4. Risks & Mitigations

| Risk | Impact | Mitigation Strategy |
| :--- | :--- | :--- |
| **Offline Sequential Numbers** | High | Use a "Temporary Number" pattern offline, replaced by a "Final Number" upon first server sync. |
| **Sync Conflicts on Workflow** | High | Implement "Stage Locking". Only the current owner of the stage can edit. |
| **Data Volume (Costing Sheets)** | Medium | Use a versioned "Price Snapshot" stored directly on the DamageItem to prevent future price changes from altering historical reports. |
| **Role Proliferation** | Medium | Use a permission-based claim system instead of hardcoded role checks in controllers. |

---

## 5. Certification

The current `DamageReport` module is **NOT** production-ready for Sprint 12 and requires a significant architectural overhaul as detailed in the Proposed Design.
