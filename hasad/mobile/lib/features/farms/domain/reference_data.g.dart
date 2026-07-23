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
  relationshipToOwners: (json['relationshipToOwners'] as List<dynamic>)
      .map((e) => RelationshipToOwner.fromJson(e as Map<String, dynamic>))
      .toList(),
  damageNatures: (json['damageNatures'] as List<dynamic>)
      .map((e) => DamageNature.fromJson(e as Map<String, dynamic>))
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
  costingSheets: (json['costingSheets'] as List<dynamic>)
      .map((e) => CostingSheetVersion.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$ReferenceDataImplToJson(_$ReferenceDataImpl instance) =>
    <String, dynamic>{
      'ownershipTypes': instance.ownershipTypes,
      'agriculturalSectors': instance.agriculturalSectors,
      'politicalClassifications': instance.politicalClassifications,
      'areaUnits': instance.areaUnits,
      'relationshipToOwners': instance.relationshipToOwners,
      'damageNatures': instance.damageNatures,
      'damageCategories': instance.damageCategories,
      'damageSubCategories': instance.damageSubCategories,
      'damageClassifications': instance.damageClassifications,
      'damageCauseCategories': instance.damageCauseCategories,
      'damageCauses': instance.damageCauses,
      'costingSheets': instance.costingSheets,
    };
