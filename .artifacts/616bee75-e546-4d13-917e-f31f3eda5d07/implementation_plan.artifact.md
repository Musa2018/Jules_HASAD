# Resolve Deprecation Warnings in Generated Code

The `DamageItem` model has a `costingSheetId` field marked as `@Deprecated` for backend synchronization compatibility. This triggers `deprecated_member_use_from_same_package` info messages in the generated `damage_item.g.dart` file.

Since this field is explicitly kept for compatibility, we should suppress these warnings in the generated code by adding the appropriate ignore rule to the source file.

## Proposed Changes

### Damage Reports Feature

#### [MODIFY] [damage_item.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/domain/models/damage_item.dart)
- Update the `ignore_for_file` header to include `deprecated_member_use_from_same_package`.

## Verification Plan

### Automated Checks
- Verify that the analyzer no longer reports the `deprecated_member_use_from_same_package` info messages for `damage_item.g.dart`.
- Run `flutter pub run build_runner build` to ensure the project remains in a consistent state (though no code changes are being made to the generation logic itself).

### Manual Verification
- Confirm that `costingSheetId` is still available and functioning as expected for backward compatibility.
