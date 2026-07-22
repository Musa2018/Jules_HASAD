# Walkthrough - Fix missing 'directorate' localization

I have added the missing `directorate` key to the localization files to resolve the compilation errors in `create_user_screen.dart`.

## Changes

### Localization

#### [app_en.arb](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/l10n/app_en.arb)
- Added `"directorate": "Directorate"`

#### [app_ar.arb](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/l10n/app_ar.arb)
- Added `"directorate": "مديرية"`

## Verification Results

### Automated Tests
- Ran `flutter gen-l10n` to regenerate the localization classes. The command completed successfully, ensuring the `directorate` getter is now available in `AppLocalizations`.

### Manual Verification
- The compilation errors in `lib/features/admin/presentation/create_user_screen.dart` should now be resolved as the getter `l10n.directorate` is defined.
