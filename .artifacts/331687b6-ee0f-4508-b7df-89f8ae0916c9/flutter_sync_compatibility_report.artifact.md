# Flutter Sync Compatibility Report - Sprint 13.2 Phase 2B.3

This report provides an evidence-based verification of the synchronization contracts between the Flutter mobile application and the Backend following the **Costing Catalog** migration.

## Executive Summary

The synchronization contract is **mostly compatible**, with one **critical mismatch** identified in the Farm synchronization flow. The Backend successfully implements a compatibility layer for Damage Reports and Reference Data, but the Farm Creation/Update commands lack the necessary JSON aliases to support legacy Flutter field names.

> [!CAUTION]
> **CRITICAL MISMATCH**: Farm synchronization (Sync Up) will fail due to a field name mismatch (`areaUnitId` vs `MeasurementUnitId`).

---

## 1. DTO Compatibility Matrix

| Feature | Flutter Key | Backend Key | Status | Verification Evidence |
| :--- | :--- | :--- | :--- | :--- |
| **Farm Sync Up (Create)** | `areaUnitId` | `MeasurementUnitId` | ❌ **FAIL** | [CreateFarmCommand.cs:L24](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farms/Commands/CreateFarm/CreateFarmCommand.cs#L24) |
| **Farm Sync Up (Update)** | `areaUnitId` | `MeasurementUnitId` | ❌ **FAIL** | [UpdateFarmCommand.cs:L25](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farms/Commands/UpdateFarm/UpdateFarmCommand.cs#L25) |
| **Farm Sync Down** | `areaUnitId` | `AreaUnitId` | ✅ **PASS** | [FarmSyncDto.cs:L22](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farms/Models/FarmSyncDto.cs#L22) |
| **Damage Item Sync Up** | `costingSheetId` | `CostingSheetId` | ✅ **PASS** | [CreateDamageReportCommand.cs:L19](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/DamageReports/Commands/CreateDamageReport/CreateDamageReportCommand.cs#L19) |
| **Reference Data (Area)** | `areaUnits` | `AreaUnits` | ✅ **PASS** | [GetReferenceDataQueryHandler.cs:L55](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/ReferenceData/Queries/GetReferenceData/GetReferenceDataQueryHandler.cs#L55) |
| **Reference Data (Price)** | `costingSheets` | `CostingSheets` | ✅ **PASS** | [ReferenceDataDto.cs:L25](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/ReferenceData/Queries/GetReferenceData/ReferenceDataDto.cs#L25) |

---

## 2. Serialization Analysis

### Farm Sync Up Flow
- **Flutter**: `FarmSyncDto.toCreateJson` produces `{ "areaUnitId": 1 }`.
- **Backend**: `CreateFarmCommand` expects `MeasurementUnitId`.
- **Result**: `System.Text.Json` fails to map `areaUnitId` to `MeasurementUnitId` because no alias exists. The value defaults to `0`, triggering a validation error in `CreateFarmCommandValidator`.

### Damage Report Sync Up Flow
- **Flutter**: `DamageReportSyncDto.itemToCreateJson` produces `{ "costingSheetId": "GUID" }`.
- **Backend**: `CreateDamageItemInput` record has property `CostingSheetId`.
- **Result**: **Compatible**. Case-insensitive mapping works correctly.

---

## 3. Compatibility Layer Verification

### Pricing Resolution (Legacy ID Support)
The Backend migration `20260723210333_Sprint13_2_CostingCatalog.cs` preserves the primary keys of the legacy `CostingSheets` when moving data to `CostingSheetItems`.
- **Evidence**: `migrationBuilder.Sql("INSERT INTO CostingSheetItems (Id, ...) SELECT Id, ... FROM CostingSheets");`
- **Result**: Old Flutter drafts containing legacy `costingSheetId` will resolve correctly in the new `CostingService`.

### Reference Data (Multi-Version Support)
The Backend `GetReferenceDataQuery` provides both legacy and modern keys.
- **Evidence**: `dto.AreaUnits` is populated from `MeasurementUnits` where `Category == "Area"`.
- **Result**: The app can continue using `areaUnits` for selection while transitioning to `measurementUnits`.

---

## 4. Required Changes

| Level | Recommended Action | Justification |
| :--- | :--- | :--- |
| **Backend** | Add `[JsonPropertyName("areaUnitId")]` to `MeasurementUnitId` in `CreateFarmCommand` and `UpdateFarmCommand`. | Restores backward compatibility for Farm synchronization without requiring a mobile app update. |
| **Flutter** | Update `FarmSyncDto` to use `measurementUnitId` in the next release. | Aligns with the new domain terminology. |

---

## 5. Verification Verdict

**Verdict**: **PARTIAL COMPATIBILITY**

**Recommendation**: **DTO Update (Backend Alias) Required.**
While Damage Reports and Reference Data are fully compatible, the Farm synchronization is currently broken. Adding JSON aliases to the Backend commands is the safest and most immediate fix.

**Safe Next Sprint**: Phase 2C (Client-side terminology update) can proceed once the Backend alias is added.
