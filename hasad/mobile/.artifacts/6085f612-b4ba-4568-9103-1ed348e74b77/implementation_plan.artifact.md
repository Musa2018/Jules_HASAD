# Centralize Mock Definitions

This plan centralizes the mock definitions for repositories and services used across the test suite to improve maintainability and follow the DRY principle.

## Proposed Changes

### Test Utilities

#### [NEW] [mocks.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/test/helpers/mocks.dart)
Create a centralized file to hold all common mocks using `mocktail`.

### Refactor Tests
Update existing tests to remove local mock definitions and import the centralized `mocks.dart`.

#### [MODIFY] [damage_reports_navigation_test.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/test/features/damage_reports/damage_reports_navigation_test.dart)
#### [MODIFY] [background_sync_service_test.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/test/core/storage/background_sync_service_test.dart)
#### [MODIFY] [multi_farm_offline_sync_test.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/test/core/storage/multi_farm_offline_sync_test.dart)
#### [MODIFY] [farms_list_screen_test.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/test/farms/farms_list_screen_test.dart)
... and other files identified.

## Verification Plan

### Automated Tests
- Run all tests to ensure they still pass with the centralized mocks.
  `flutter test`
