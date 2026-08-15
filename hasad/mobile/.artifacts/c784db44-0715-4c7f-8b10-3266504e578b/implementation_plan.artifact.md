# Fix Test Suite Errors

The test suite in the HASAD mobile project has numerous compilation errors due to model changes, missing imports, and Drift companion type mismatches.

## User Review Required

> [!IMPORTANT]
> Some exceptions used in tests (`ConflictException`, `PermanentSyncException`) were renamed or replaced with `SyncConflictException` and `SyncValidationException`. I will update the tests to use the new names and signatures.

## Proposed Changes

### Core Storage Tests
#### [MODIFY] [background_sync_service_test.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/test/core/storage/background_sync_service_test.dart)
- Update `DamageReportAttachment` constructor: rename `reportId` to `damageReportId`.
- Wrap optional fields in `FarmersCompanion.insert`, `DamageReportsCompanion.insert`, etc. with `Value()`.
- Add missing required fields `documentationDate` and `notes` to `DamageReportsCompanion.insert`.
- Replace `ConflictException` with `SyncConflictException` and `PermanentSyncException` with `SyncValidationException`.

#### [MODIFY] [late_binding_sync_test.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/test/core/storage/late_binding_sync_test.dart)
- Similar fixes for `Value` wrappers and `DamageReportsCompanion.insert` required fields.

### Farmer Feature Tests
#### [MODIFY] [search_workflow_test.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/test/farmers/search_workflow_test.dart)
#### [MODIFY] [offline_first_farmer_repository_test.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/test/farmers/offline_first_farmer_repository_test.dart)
#### [MODIFY] [farmer_visibility_regression_test.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/test/farmers/farmer_visibility_regression_test.dart)
- Add missing imports for `OfflineFirstFarmerRepository`, `FarmerException`, `connectivity_plus`, and `drift`.
- Wrap fields in `Value()` where necessary.

### Farm Feature Tests
#### [MODIFY] [farm_edit_navigation_test.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/test/farms/farm_edit_navigation_test.dart)
- Resolve undefined `AuthState`, `AuthStatus`, and `authProvider` by adding correct imports or updating to the new auth state model.

### Helpers
#### [MODIFY] [mocks.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/test/helpers/mocks.dart)
- Add missing import for `DamageReport`.
- Fix `MockDamageReportAttachmentRepository` signature or usages.

## Verification Plan

### Automated Tests
- Run `flutter test` to verify all fixed test files compile and pass.
- Specific command: `flutter test test/core/storage/background_sync_service_test.dart`
