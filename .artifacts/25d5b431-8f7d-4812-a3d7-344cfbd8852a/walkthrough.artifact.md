# Walkthrough: Damage Assessment Items & Home Screen Integration

I have successfully implemented the "Damage Reports" entry point on the Home Screen, added regional filtering for the global list, and hardened the Damage Assessment workflow with Nature Locking and Sync Gating.

## Key Accomplishments

### 1. Home Screen Integration
- Added a new card "استمارات الضرر" (Damage Reports) to the Home Screen Dashboard.
- Navigates to a global list of damage reports filtered by the user's operational scope (Directorate/Governorate).

### 2. Regional Scoping & Global List
- **Scoping**: Agricultural Engineers and Field Surveyors only see reports within their assigned **Directorate**.
- **Global View**: The `DamageReportsListScreen` now supports a global mode where it displays all authorized reports with farm identification.
- **Resilience**: The list resolves the associated `Farm` object from the local database when a report is selected, ensuring the details screen has full context even when starting from the global list.

### 3. Assessment Workflow Hardening
- **Sync Gating**: Assessment items can only be added AFTER the report header has synchronized with the backend. This ensures each item is linked to a valid server record and has a proper report number.
- **Nature Locking**: Following ADR-0015, the `Damage Nature` is locked after the first item is added. Subsequent items in the same report will automatically inherit this nature, ensuring categorization consistency.
- **UX Improvements**:
    - Implemented `FormSaveFooter` in `DamageReportFormScreen` and `DamageItemFormSheet` for sticky actions.
    - Added visual validation feedback (Save button turns **RED** on error) per project standards.
    - Full Arabic/English localization for all new components.

## Technical Details

### Modified Files
- [app_ar.arb](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/l10n/app_ar.arb) & [app_en.arb](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/l10n/app_en.arb): New localization keys.
- [DamageReportRepository](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/data/repositories/damage_report_repository.dart): Added `getDamageReports()`.
- [OfflineFirstDamageReportRepository](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/data/repositories/offline_first_damage_report_repository.dart): Implemented regional filtering.
- [HomeScreen](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/home/presentation/home_screen.dart): Added "Damage Reports" card.
- [DamageReportsListScreen](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/screens/damage_reports_list_screen.dart): Global mode support.
- [DamageReportFormScreen](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/screens/damage_report_form_screen.dart): Sync gating & sticky footer.
- [DamageItemFormSheet](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/widgets/damage_item_form_sheet.dart): Nature locking & sticky footer.
- [ClassificationWizardProvider](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/providers/classification_wizard_provider.dart): Added locking state support.

## Verification Results

### Manual Verification Path
1. **Home Entry**: Login and verify "استمارات الضرر" card exists.
2. **Directorate Scoping**: Verify only reports from the user's Directorate are listed.
3. **Sync Gating**: Create a new header offline. Verify "Add Item" button is hidden until sync (or simulated sync).
4. **Nature Locking**: Add a "Plant" item. Verify that the second item skip the "Nature" selection step.
5. **UX Check**: Verify Save button color change and sticky behavior.

> [!NOTE]
> The workflow for creating a report still begins from the **Farm** details/card to ensure correct geographic and sector context, as requested.
