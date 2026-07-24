import 'package:freezed_annotation/freezed_annotation.dart';
import 'lookup_entities.dart';

part 'reference_data.freezed.dart';
part 'reference_data.g.dart';

@freezed
class ReferenceData with _$ReferenceData {
  const factory ReferenceData({
    required List<OwnershipType> ownershipTypes,
    required List<AgriculturalSector> agriculturalSectors,
    required List<PoliticalClassification> politicalClassifications,
    required List<AreaUnit> areaUnits,
    required List<MeasurementUnit> measurementUnits,
    required List<RelationshipToOwner> relationshipToOwners,

    // Damage Hierarchy
    required List<DamageNature> damageNatures,
    required List<DamageAction> damageActions,
    required List<DamageCategory> damageCategories,
    required List<DamageSubCategory> damageSubCategories,
    required List<DamageClassification> damageClassifications,

    // Damage Causes
    required List<DamageCauseCategory> damageCauseCategories,
    required List<DamageCause> damageCauses,

    @Default([]) List<CostingSheetCatalog> costingSheetCatalogs,
    @Default([]) List<CostingSheetVersion> costingSheetVersions,
    @Default([]) List<CostingSheetItem> costingSheetItems,
    
    // Kept for backward compatibility during transition
    @JsonKey(name: 'costingSheets') @Default([]) List<CostingSheetItem> legacyCostingSheets,
  }) = _ReferenceData;

  factory ReferenceData.fromJson(Map<String, dynamic> json) =>
      _$ReferenceDataFromJson(json);
}
