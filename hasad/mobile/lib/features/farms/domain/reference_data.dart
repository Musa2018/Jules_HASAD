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
    required List<RelationshipToOwner> relationshipToOwners,
  }) = _ReferenceData;

  factory ReferenceData.fromJson(Map<String, dynamic> json) =>
      _$ReferenceDataFromJson(json);
}
