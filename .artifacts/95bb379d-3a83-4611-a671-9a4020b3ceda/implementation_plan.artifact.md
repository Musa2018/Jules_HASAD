# Implementation Plan - Fix Agricultural Sector Input in Damage Report Header

The user reported a bug where the `AgriculturalSector` is being requested as an input in the Damage Report Header screen, even though it should be automatically retrieved from the `Farm` data and remain non-editable.

## Proposed Changes

### [Damage Reports Feature]

#### [MODIFY] [damage_report_header_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/screens/damage_report_header_screen.dart)
- Change the `AgriculturalSector` field from a `DropdownButtonFormField` to a read-only display.
- Use `_buildReadOnlyField` to display the sector name (Arabic/English based on locale).
- Ensure `_selectedSector` is still populated from `widget.farm.agriculturalSectorId` to maintain the data flow for saving the report.

## Verification Plan

### Manual Verification
- Navigate to the "New Damage Report" screen for a specific farm.
- Observe that the "Agricultural Sector" is displayed as read-only text.
- Verify that the value matches the farm's sector.
- Complete the form and save to ensure the `agriculturalSectorId` is correctly persisted in the `DamageReport` object.
