# Implementation Plan: Damage Assessment Items & Home Screen Integration (Sprint 15.1)

This plan focuses on completing the **Damage Assessment Items** implementation, adding the **Damage Reports** entry point to the Home Screen, and aligning the UI with the **General UX Principles**.

## User Review Required

> [!IMPORTANT]
> **Global Damage Reports View**: Adding "Damage Reports" to the Home Screen requires a global list view. I will modify the existing `DamageReportsListScreen` to support a "Global Mode" when no farm is provided.

> [!IMPORTANT]
> **Directorate-Based Scoping**: As per the project's security rules, Agricultural Engineers and Field Surveyors will only see damage reports within their assigned **Directorate**. Supervisors and Directors will see reports within their **Governorate**. This will be enforced in the `getDamageReports()` repository method using the denormalized `directorateId` field.

> [!IMPORTANT]
> **Nature Locking Rule**: Following ADR-0015, the `Damage Nature` will be locked after the first item is added to a report to ensure workflow consistency.

## Proposed Changes

### 1. Localization Layer

#### [MODIFY] [app_ar.arb](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/l10n/app_ar.arb)
#### [MODIFY] [app_en.arb](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/l10n/app_en.arb)
- Add/Update keys:
    - `damageReportsForms`: "استمارات الضرر" (Arabic) / "Damage Reports" (English)
    - `allDamageReports`: "كافة استمارات الضرر"
    - `awaitingSyncToAddItems`: "بانتظار المزامنة لإضافة البنود"
    - `natureLockedInfo`: "تم تثبيت طبيعة الضرر بناءً على البند الأول"
    - `technicalLoss`: "الخسارة الفنية"

---

### 2. Data & Navigation Layer

#### [MODIFY] [damage_report_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/data/repositories/damage_report_repository.dart)
- Add `Future<List<DamageReport>> getDamageReports();` to the interface.

#### [MODIFY] [offline_first_damage_report_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/data/repositories/offline_first_damage_report_repository.dart)
- Implement `getDamageReports()` with regional filtering:
    - If `session.directorateId` is present: Filter by `directorateId`.
    - If `session.governorateId` is present (and no directorate): Filter by `governorateId`.
    - Handle `isPendingDelete == false`.

#### [MODIFY] [damage_reports_providers.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/providers/damage_reports_providers.dart)
- Add `allDamageReportsProvider` to fetch the global list.

#### [MODIFY] [app_router.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/router/app_router.dart)
- Update `AppRoutes.damageReports` route to accept an optional `Farm`.

---

### 3. UI Layer

#### [MODIFY] [home_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/home/presentation/home_screen.dart)
- Add the `_FeatureCard` for Damage Reports using the `Icons.assignment` icon.

#### [MODIFY] [damage_reports_list_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/screens/damage_reports_list_screen.dart)
- Update to handle `farm == null`.
- If global: Show a search bar (search by farmer name or report number).
- If global: The list item must show the farm name and location (Directorate/Governorate).
- If global: The FAB (+) should be hidden (Creation should still happen from the Farm details/card to ensure context).

#### [MODIFY] [damage_report_form_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/screens/damage_report_form_screen.dart)
- Implement gating and localization as per the previous plan.

#### [MODIFY] [remote_damage_report_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/data/repositories/remote_damage_report_repository.dart)
- Implement `getDamageReports()` to satisfy the updated interface.

#### [MODIFY] [classification_wizard_test.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/test/features/damage_reports/classification_wizard_test.dart)
- Update provider family parameters from `int` to `Map<String, int?>`.

#### [MODIFY] [damage_report_form_workflow_test.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/test/features/damage_reports/damage_report_form_workflow_test.dart)
- Fix type casting error in `InheritedGoRouter`.


## Verification Plan

### Automated Tests
- `flutter test hasad/mobile/test/features/home/home_screen_test.dart`: Verify the new card exists and navigates correctly.
- `flutter test hasad/mobile/test/features/damage_reports/damage_reports_list_screen_test.dart`: Verify global vs farm-scoped views and regional filtering.

### Manual Verification
1. Login with a user assigned to a specific Directorate.
2. Verify "استمارات الضرر" card on Home Screen.
3. Click the card and verify only reports from the user's Directorate are shown.
4. Verify "Nature Locking" and "Sync Gating" as per previous plan.

