# Implementation Plan - Farmers List Redesign & Management UI

Redesign the Farmers List screen into a production-ready management interface with card-based layout, advanced filtering, and a soft-delete workflow.

## User Review Required

> [!IMPORTANT]
> The current `farmersListProvider` will be replaced by a more dynamic `farmersListProvider` that supports real-time filtering and local search. Deletion will be strictly "Soft Delete" (marking as pending delete and syncing with backend).

## Proposed Changes

### 1. Domain & Data Layer
- **[MODIFY] [farmer_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/farmer_repository.dart)**:
    - Enhance `getFarmers` to support all filters (Gender, Sync Status, Location).
    - Ensure it returns a `Stream<List<Farmer>>` or use a `watchFarmers` method for real-time UI updates.

### 2. Presentation Layer - Providers
- **[MODIFY] [farmers_providers.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/farmers_providers.dart)**:
    - Create `FarmerFilterState` class (searchText, gender, syncStatus, governorateId, localityId).
    - Create `farmerFiltersProvider` (StateProvider).
    - Create `farmersListProvider` as a `StreamProvider` that watches the filters and repository.

### 3. Presentation Layer - UI Components
- **[NEW] [farmer_card.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/widgets/farmer_card.dart)**:
    - Implement the redesigned Card UI showing: Name, ID, Phone, Location, and Sync Status badge.
    - Add action buttons: View (Details), Edit (Form), and Delete (Soft-delete with confirmation).
- **[NEW] [farmer_filters_section.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/widgets/farmer_filters_section.dart)**:
    - Implement the search bar and filter chips for status, gender, and location.

### 4. Farmers List Screen Redesign
- **[MODIFY] [farmers_list_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/farmers_list_screen.dart)**:
    - Integrate `FarmerFiltersSection` at the top.
    - Use `ListView.separated` with `FarmerCard`.
    - Implement pull-to-refresh and empty/loading states.

## Verification Plan

### Automated Tests
- **UI Tests**: Verify card rendering and action button presence.
- **Provider Tests**: Verify filtering logic (e.g., searching for a name returns only matching farmers).
- **Regression Tests**: Ensure editing from the card preserves `rowVersion` and triggers a successful sync.

### Manual Verification
- Create a farmer -> Confirm sync status "Pending" then "Synced".
- Search by partial name or ID.
- Filter by "Male" or "Pending Sync".
- Delete a farmer -> Confirm it disappears from the list and appears in the sync queue as a delete task.
