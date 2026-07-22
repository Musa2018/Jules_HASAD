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
);

Map<String, dynamic> _$$ReferenceDataImplToJson(_$ReferenceDataImpl instance) =>
    <String, dynamic>{
      'ownershipTypes': instance.ownershipTypes,
      'agriculturalSectors': instance.agriculturalSectors,
      'politicalClassifications': instance.politicalClassifications,
      'areaUnits': instance.areaUnits,
      'relationshipToOwners': instance.relationshipToOwners,
    };
