# Implementation Plan - DamageReport Correction: Damage Nature Placement

Refine the `DamageReport` domain model to move `DamageNatureId` from the report header to individual damage items, and add `AgriculturalSectorId` to the header.

## User Review Required

> [!IMPORTANT]
> **Schema Correction**: `DamageNatureId` will be removed from `DamageReport` and added to `DamageItem`. This is a breaking change for the recently introduced Sprint 14.2.2 structure. Existing data will need to be migrated by assigning the report's nature to its items.

> [!NOTE]
> **Agricultural Sector**: Adding `AgriculturalSectorId` to `DamageReport` header to allow specifying the incident sector independently of the farm's default sector.

## Proposed Changes

### Backend (Hasad.Domain & Hasad.Infrastructure)

#### [MODIFY] [DamageReport.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Domain/Entities/DamageReport.cs)
- Remove `DamageNatureId` and `DamageNature`.
- Add `AgriculturalSectorId` and `AgriculturalSector`.

#### [MODIFY] [DamageItem.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Domain/Entities/DamageItem.cs)
- Add `DamageNatureId` and `DamageNature`.

#### [MODIFY] [ApplicationDbContext.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Persistence/ApplicationDbContext.cs)
- Update model configurations for `DamageReport` and `DamageItem`.

#### [NEW] [Migration_Sprint14_2_2_DamageNatureCorrection](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Migrations/)
- Add a new EF Core migration.

### Application Layer (Hasad.Application)

#### [MODIFY] [CreateDamageReportCommand.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/DamageReports/Commands/CreateDamageReport/CreateDamageReportCommand.cs)
- Update command to include `AgriculturalSectorId` and remove `DamageNatureId`.
- Update item input to include `DamageNatureId`.

#### [MODIFY] [UpdateDamageReportCommand.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/DamageReports/Commands/UpdateDamageReport/UpdateDamageReportCommand.cs)
- Update command to include `AgriculturalSectorId` and remove `DamageNatureId`.

#### [MODIFY] [DamageReportDto.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/DamageReports/Models/DamageReportDto.cs)
- Update DTO to reflect field changes.

#### [MODIFY] [DamageItemDto.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/DamageReports/Models/DamageItemDto.cs)
- Add `DamageNatureId` to DTO.

### Mobile (Hasad.Mobile)

#### [MODIFY] [database.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/database.dart)
- Move `damageNatureId` from `DamageReports` table to `DamageItems` table.
- Add `agriculturalSectorId` to `DamageReports` table.
- Add Drift migration (v19).

#### [MODIFY] [damage_report.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/domain/models/damage_report.dart)
- Update domain model and JSON mapping.

#### [MODIFY] [damage_item.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/domain/models/damage_item.dart)
- Add `damageNatureId` to domain model.

#### [MODIFY] [DamageReportFormScreen](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/screens/damage_report_form_screen.dart)
- Update Header form: Remove Nature, Add Agricultural Sector (pre-filled from Farm).

#### [MODIFY] [DamageItemFormSheet](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/widgets/damage_item_form_sheet.dart)
- Add Damage Nature selector to the item form.

### Documentation

#### [MODIFY] [ADR-0015.md](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/ADR-0015.md)
- Update the "Decision" section to reflect that `DamageNature` is item-level.

---

## Verification Plan

### Automated Tests
- **Backend**: Update `CreateDamageReportCommandHandlerTests` and `UpdateDamageReportCommandHandlerTests`.
- **Mobile**: Update unit tests for models and repositories.

### Manual Verification
- Verify Header creation with Agricultural Sector.
- Verify Assessment phase where Nature is selected per item.
- Verify sync compatibility.
