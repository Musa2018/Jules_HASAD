# Sprint 12.2 Implementation Plan — Hierarchical Classification UI

Implementation of the hierarchical classification selector and pricing snapshot engine for Damage Items, ensuring technical assessments are performed accurately and consistently offline.

## User Review Required

> [!IMPORTANT]
> The classification selection is a mandatory 4-step wizard:
> **Nature** → **Category** → **SubCategory** → **Classification**
> - **Costing Resolution** is automatic and happens immediately after Step 4.
> - **Manual Price Entry** is blocked to preserve assessment integrity.

## Proposed Changes

### 1. Presentation Layer (Mobile)

#### [NEW] [classification_wizard_provider.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/providers/classification_wizard_provider.dart)
- Manages the state of the 4-step selection flow.
- Implements **Cascading Reset** logic (changing parent clears all children).
- Resolves the active `CostingSheetVersion` automatically.

#### [NEW] [classification_selector.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/widgets/classification_selector.dart)
- 4-step cascading selector UI.
- Integrated Arabic/English search for long lists.
- Disabled state/Warning if no active costing sheet exists for the final classification.

#### [NEW] [damage_item_form_sheet.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/widgets/damage_item_form_sheet.dart)
- Modal Bottom Sheet hosting the wizard.
- Final step: Quantity, Percentage, and Affected Area input.
- Real-time Technical Valuation preview (Quantity × Snapshot Price × %).

### 2. Domain & Data Layer

#### [MODIFY] [reference_data_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farms/data/reference_data_repository.dart)
- Add granular methods for hierarchical lookups: `getNatures()`, `getCategories(parentId)`, etc.
- Add `getActiveCostingSheet(classificationId)`.

#### [NEW] [valuation_engine.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/domain/services/valuation_engine.dart)
- Pure logic for technical loss calculation: `EstimatedLoss = Quantity * Price * (Percentage / 100)`.

---

## Verification Plan

### Automated Tests
- `classification_wizard_test.dart`: Verify selection flow and cascading resets.
- `reference_data_hierarchy_test.dart`: Verify Drift queries for each level and Arabic search.
- `valuation_engine_test.dart`: Verify local calculation accuracy.
- `classification_selector_widget_test.dart`: Verify UI navigation and disabled states.

### Manual Verification
1. Open Damage Report Form.
2. Click "Add Item".
3. Traverse the 4-level hierarchy.
4. Verify parent change clears children.
5. Verify Price snapshot appears automatically.
6. Verify "Add" is disabled if no price exists.
