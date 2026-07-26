// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReferenceDataImpl _$$ReferenceDataImplFromJson(
  Map<String, dynamic> json,
) => _$ReferenceDataImpl(
  ownershipTypes: (json['ownershipTypes'] as List<dynamic>)
      .map((e) => OwnershipType.fromJson(e as Map<String, dynamic>))
      .toList(),
  agriculturalSectors: (json['agriculturalSectors'] as List<dynamic>)
      .map((e) => AgriculturalSector.fromJson(e as Map<String, dynamic>))
      .toList(),
  politicalClassifications: (json['politicalClassifications'] as List<dynamic>)
      .map((e) => PoliticalClassification.fromJson(e as Map<String, dynamic>))
      .toList(),
  areaUnits: (json['areaUnits'] as List<dynamic>)
      .map((e) => AreaUnit.fromJson(e as Map<String, dynamic>))
      .toList(),
  measurementUnits: (json['measurementUnits'] as List<dynamic>)
      .map((e) => MeasurementUnit.fromJson(e as Map<String, dynamic>))
      .toList(),
  relationshipToOwners: (json['relationshipToOwners'] as List<dynamic>)
      .map((e) => RelationshipToOwner.fromJson(e as Map<String, dynamic>))
      .toList(),
  damageNatures: (json['damageNatures'] as List<dynamic>)
      .map((e) => DamageNature.fromJson(e as Map<String, dynamic>))
      .toList(),
  damageActions: (json['damageActions'] as List<dynamic>)
      .map((e) => DamageAction.fromJson(e as Map<String, dynamic>))
      .toList(),
  damageCategories: (json['damageCategories'] as List<dynamic>)
      .map((e) => DamageCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
  damageSubCategories: (json['damageSubCategories'] as List<dynamic>)
      .map((e) => DamageSubCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
  damageClassifications: (json['damageClassifications'] as List<dynamic>)
      .map((e) => DamageClassification.fromJson(e as Map<String, dynamic>))
      .toList(),
  damageCauseCategories: (json['damageCauseCategories'] as List<dynamic>)
      .map((e) => DamageCauseCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
  damageCauses: (json['damageCauses'] as List<dynamic>)
      .map((e) => DamageCause.fromJson(e as Map<String, dynamic>))
      .toList(),
  costingSheetCatalogs:
      (json['costingSheetCatalogs'] as List<dynamic>?)
          ?.map((e) => CostingSheetCatalog.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  costingSheetVersions:
      (json['costingSheetVersions'] as List<dynamic>?)
          ?.map((e) => CostingSheetVersion.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  costingSheetItems:
      (json['costingSheetItems'] as List<dynamic>?)
          ?.map((e) => CostingSheetItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  legacyCostingSheets:
      (json['costingSheets'] as List<dynamic>?)
          ?.map((e) => CostingSheetItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ReferenceDataImplToJson(_$ReferenceDataImpl instance) =>
    <String, dynamic>{
      'ownershipTypes': instance.ownershipTypes,
      'agriculturalSectors': instance.agriculturalSectors,
      'politicalClassifications': instance.politicalClassifications,
      'areaUnits': instance.areaUnits,
      'measurementUnits': instance.measurementUnits,
      'relationshipToOwners': instance.relationshipToOwners,
      'damageNatures': instance.damageNatures,
      'damageActions': instance.damageActions,
      'damageCategories': instance.damageCategories,
      'damageSubCategories': instance.damageSubCategories,
      'damageClassifications': instance.damageClassifications,
      'damageCauseCategories': instance.damageCauseCategories,
      'damageCauses': instance.damageCauses,
      'costingSheetCatalogs': instance.costingSheetCatalogs,
      'costingSheetVersions': instance.costingSheetVersions,
      'costingSheetItems': instance.costingSheetItems,
      'costingSheets': instance.legacyCostingSheets,
    };
