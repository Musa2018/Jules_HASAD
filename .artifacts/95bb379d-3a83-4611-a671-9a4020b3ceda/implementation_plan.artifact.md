# Implementation Plan - Fix Display Labels and Lookups in Damage Report Form

The user reported that the "Agricultural Sector" shows an ID (0) instead of a name in the Damage Report Details section. Additionally, the label for "Damage Date" is incorrectly showing as "Date of Birth" (تاريخ الميلاد).

## Proposed Changes

### [Damage Reports Feature]

#### [MODIFY] [damage_report_form_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/screens/damage_report_form_screen.dart)
- Update `_buildHeaderSummary` to use `ref.watch(referenceDataProvider)` to resolve names for:
    - **Agricultural Sector**: Look up name from `agriculturalSectors` using `report.agriculturalSectorId`.
    - **Damage Cause**: Look up name from `damageCauses` using `report.damageCauseId`.
- Fix the label for Damage Date from `l10n.dateOfBirth` to `l10n.damageDate`.
- Ensure localized names (Arabic/English) are used based on the current locale.

## Verification Plan

### Manual Verification
- Open an existing damage report or create a new one to reach the "Edit Assessment" screen.
- Verify that the label is now "تاريخ الضرر" (Damage Date).
- Verify that "القطاع الزراعي" (Agricultural Sector) shows the name (e.g., "نباتي") instead of "0".
- Verify that "سبب الضرر" (Damage Cause) shows the name instead of "1".
