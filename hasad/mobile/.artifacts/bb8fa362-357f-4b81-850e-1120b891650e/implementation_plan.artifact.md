# Implementation Plan - Fix Farmer Creation Navigation Regression

The goal is to fix the navigation regression where creating a new farmer returns the user to the search screen instead of the farmers list screen. After a successful creation, the app should navigate to the Farmers List Screen and refresh the list to show the new farmer.

## User Review Required

> [!IMPORTANT]
> The fix involves using `context.go(AppRoutes.farmers)` when a new farmer is created. This will reset the navigation stack to the Farmers List screen. If the user was in a sub-workflow (e.g., adding a farmer while creating a farm), the existing `pop` behavior is preserved to return the farmer object to the caller.

## Proposed Changes

### Farmer Feature

#### [MODIFY] [farmer_form_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/farmer_form_screen.dart)
- Add `package:go_router/go_router.dart` and `package:mobile/core/router/app_router.dart` imports.
- Update `_save` method:
    - If `widget.farmer == null` (creating) and `!widget.isSubWorkflow`, use `context.go(AppRoutes.farmers)`.
    - Otherwise, keep `Navigator.of(context).pop(...)`.

## Verification Plan

### Automated Tests
- Create a new test file [farmer_creation_navigation_test.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/test/farmers/farmer_creation_navigation_test.dart) that:
    - Mocks `FarmerRepository` and `LocationRepository`.
    - Uses `MaterialApp.router` with `appRouterProvider`.
    - Navigates to `FarmerSearchScreen`.
    - Searches for a non-existent ID.
    - Fills the `FarmerFormScreen` and saves.
    - Verifies that the final location is `/farmers`.
- Run all farmers tests: `flutter test test/farmers/`

### Manual Verification
1. Open the app and navigate to Farmers List.
2. Tap "Add Farmer" (FAB).
3. Search for a new ID.
4. Fill in the farmer details.
5. Tap "Save".
6. Verify the app navigates to the Farmers List screen and the new farmer is visible.
