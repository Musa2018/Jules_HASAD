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

@freezed
class DamageNature with _$DamageNature {
  const factory DamageNature({
    required int id,
    required String nameAr,
    required String nameEn,
  }) = _DamageNature;

  factory DamageNature.fromJson(Map<String, dynamic> json) =>
      _$DamageNatureFromJson(json);
}

@freezed
class DamageCategory with _$DamageCategory {
  const factory DamageCategory({
    required int id,
    required int parentId,
    required String nameAr,
    required String nameEn,
  }) = _DamageCategory;

  factory DamageCategory.fromJson(Map<String, dynamic> json) =>
      _$DamageCategoryFromJson(json);
}

@freezed
class DamageSubCategory with _$DamageSubCategory {
  const factory DamageSubCategory({
    required int id,
    required int parentId,
    required String nameAr,
    required String nameEn,
  }) = _DamageSubCategory;

  factory DamageSubCategory.fromJson(Map<String, dynamic> json) =>
      _$DamageSubCategoryFromJson(json);
}

@freezed
class DamageClassification with _$DamageClassification {
  const factory DamageClassification({
    required int id,
    required int parentId,
    required String nameAr,
    required String nameEn,
  }) = _DamageClassification;

  factory DamageClassification.fromJson(Map<String, dynamic> json) =>
      _$DamageClassificationFromJson(json);
}

@freezed
class DamageCauseCategory with _$DamageCauseCategory {
  const factory DamageCauseCategory({
    required int id,
    required String nameAr,
    required String nameEn,
  }) = _DamageCauseCategory;

  factory DamageCauseCategory.fromJson(Map<String, dynamic> json) =>
      _$DamageCauseCategoryFromJson(json);
}

@freezed
class DamageCause with _$DamageCause {
  const factory DamageCause({
    required int id,
    required int parentId,
    required String nameAr,
    required String nameEn,
  }) = _DamageCause;

  factory DamageCause.fromJson(Map<String, dynamic> json) =>
      _$DamageCauseFromJson(json);
}

@freezed
class CostingSheetVersion with _$CostingSheetVersion {
  const factory CostingSheetVersion({
    required String id,
    required int classificationId,
    required double unitPrice,
    required DateTime effectiveFrom,
    DateTime? effectiveTo,
    @Default(true) bool isActive,
    required int versionNumber,
  }) = _CostingSheetVersion;

  factory CostingSheetVersion.fromJson(Map<String, dynamic> json) =>
      _$CostingSheetVersionFromJson(json);
}
