# Walkthrough - Fixing Agricultural Sector in Damage Report Header

I have updated the Damage Report Header screen to ensure that the Agricultural Sector is displayed as a read-only field, as it is a property of the farm and should not be re-entered by the user.

## Changes Made

### Damage Reports Feature
- **Updated [damage_report_header_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/screens/damage_report_header_screen.dart)**:
    - Replaced the `AgriculturalSector` dropdown with a read-only display.
    - Used `ref.watch(referenceDataProvider)` to reactively fetch the sector name (Arabic/English) based on the current locale.
    - Simplified the state management by removing redundant variables (`_selectedSector`, `_initialized`) and initialization logic.
    - Updated the `_save` method to directly use the `agriculturalSectorId` from the `Farm` object.

## Fixed Damage Report Form Display Labels & Data Integrity

I have corrected the display of metadata in the "Edit Assessment" screen (`DamageReportFormScreen`) and hardened the data snapshotting process.

### Changes Made
- **[offline_first_damage_report_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/data/repositories/offline_first_damage_report_repository.dart)**:
    - Added explicit snapshotting of `agriculturalSectorId` from the `Farm` object during report creation. This ensures that the report always carries the correct sector from its parent farm.
- **[damage_report_form_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/screens/damage_report_form_screen.dart)**:
    - Fixed a compilation error by using the correct `farmStreamProvider` instead of the non-existent `farmProvider`.
    - Updated the "Agricultural Sector" display to fetch the latest data from the linked **Farm** instead of relying solely on the report's snapshot. This provides a reliable source of truth for the sector name.
    - Integrated `referenceDataProvider` to resolve human-readable names for both **Agricultural Sector** and **Damage Cause**.
    - Fixed the label for the incident date to "تاريخ الضرر" (Damage Date).
