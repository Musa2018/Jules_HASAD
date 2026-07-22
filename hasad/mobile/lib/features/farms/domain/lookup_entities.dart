import 'package:freezed_annotation/freezed_annotation.dart';

part 'lookup_entities.freezed.dart';
part 'lookup_entities.g.dart';

@freezed
class OwnershipType with _$OwnershipType {
  const factory OwnershipType({
    required int id,
    required String nameAr,
    required String nameEn,
  }) = _OwnershipType;

  factory OwnershipType.fromJson(Map<String, dynamic> json) =>
      _$OwnershipTypeFromJson(json);
}

@freezed
class AgriculturalSector with _$AgriculturalSector {
  const factory AgriculturalSector({
    required int id,
    required String nameAr,
    required String nameEn,
  }) = _AgriculturalSector;

  factory AgriculturalSector.fromJson(Map<String, dynamic> json) =>
      _$AgriculturalSectorFromJson(json);
}

@freezed
class PoliticalClassification with _$PoliticalClassification {
  const factory PoliticalClassification({
    required int id,
    required String nameAr,
    required String nameEn,
  }) = _PoliticalClassification;

  factory PoliticalClassification.fromJson(Map<String, dynamic> json) =>
      _$PoliticalClassificationFromJson(json);
}

@freezed
class AreaUnit with _$AreaUnit {
  const factory AreaUnit({
    required int id,
    required String nameAr,
    required String nameEn,
  }) = _AreaUnit;

  factory AreaUnit.fromJson(Map<String, dynamic> json) =>
      _$AreaUnitFromJson(json);
}

@freezed
class RelationshipToOwner with _$RelationshipToOwner {
  const factory RelationshipToOwner({
    required int id,
    required String nameAr,
    required String nameEn,
  }) = _RelationshipToOwner;

  factory RelationshipToOwner.fromJson(Map<String, dynamic> json) =>
      _$RelationshipToOwnerFromJson(json);
}
