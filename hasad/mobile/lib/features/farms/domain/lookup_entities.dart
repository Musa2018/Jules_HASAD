import 'package:freezed_annotation/freezed_annotation.dart';

part 'lookup_entities.freezed.dart';
part 'lookup_entities.g.dart';

@freezed
class OwnershipType with _$OwnershipType {
  const factory OwnershipType({
    required int id,
    @Default('') String nameAr,
    @Default('') String nameEn,
  }) = _OwnershipType;

  factory OwnershipType.fromJson(Map<String, dynamic> json) =>
      _$OwnershipTypeFromJson(json);
}

@freezed
class AgriculturalSector with _$AgriculturalSector {
  const factory AgriculturalSector({
    required int id,
    @Default('') String nameAr,
    @Default('') String nameEn,
  }) = _AgriculturalSector;

  factory AgriculturalSector.fromJson(Map<String, dynamic> json) =>
      _$AgriculturalSectorFromJson(json);
}

@freezed
class PoliticalClassification with _$PoliticalClassification {
  const factory PoliticalClassification({
    required int id,
    @Default('') String nameAr,
    @Default('') String nameEn,
  }) = _PoliticalClassification;

  factory PoliticalClassification.fromJson(Map<String, dynamic> json) =>
      _$PoliticalClassificationFromJson(json);
}

@freezed
class AreaUnit with _$AreaUnit {
  const factory AreaUnit({
    required int id,
    @Default('') String nameAr,
    @Default('') String nameEn,
  }) = _AreaUnit;

  factory AreaUnit.fromJson(Map<String, dynamic> json) =>
      _$AreaUnitFromJson(json);
}

@freezed
class MeasurementUnit with _$MeasurementUnit {
  const factory MeasurementUnit({
    required int id,
    @Default('') String nameAr,
    @Default('') String nameEn,
    String? code,
    @Default('') String category,
  }) = _MeasurementUnit;

  factory MeasurementUnit.fromJson(Map<String, dynamic> json) =>
      _$MeasurementUnitFromJson(json);
}

@freezed
class RelationshipToOwner with _$RelationshipToOwner {
  const factory RelationshipToOwner({
    required int id,
    @Default('') String nameAr,
    @Default('') String nameEn,
  }) = _RelationshipToOwner;

  factory RelationshipToOwner.fromJson(Map<String, dynamic> json) =>
      _$RelationshipToOwnerFromJson(json);
}

@freezed
class DamageNature with _$DamageNature {
  const factory DamageNature({
    required int id,
    @Default('') String nameAr,
    @Default('') String nameEn,
  }) = _DamageNature;

  factory DamageNature.fromJson(Map<String, dynamic> json) =>
      _$DamageNatureFromJson(json);
}

@freezed
class DamageAction with _$DamageAction {
  const factory DamageAction({
    required int id,
    @Default('') String nameAr,
    @Default('') String nameEn,
  }) = _DamageAction;

  factory DamageAction.fromJson(Map<String, dynamic> json) =>
      _$DamageActionFromJson(json);
}

@freezed
class DamageCategory with _$DamageCategory {
  const factory DamageCategory({
    required int id,
    required int parentId,
    @Default('') String nameAr,
    @Default('') String nameEn,
  }) = _DamageCategory;

  factory DamageCategory.fromJson(Map<String, dynamic> json) =>
      _$DamageCategoryFromJson(json);
}

@freezed
class DamageSubCategory with _$DamageSubCategory {
  const factory DamageSubCategory({
    required int id,
    required int parentId,
    @Default('') String nameAr,
    @Default('') String nameEn,
  }) = _DamageSubCategory;

  factory DamageSubCategory.fromJson(Map<String, dynamic> json) =>
      _$DamageSubCategoryFromJson(json);
}

@freezed
class DamageClassification with _$DamageClassification {
  const factory DamageClassification({
    required int id,
    required int parentId,
    @Default('') String nameAr,
    @Default('') String nameEn,
  }) = _DamageClassification;

  factory DamageClassification.fromJson(Map<String, dynamic> json) =>
      _$DamageClassificationFromJson(json);
}

@freezed
class DamageCauseCategory with _$DamageCauseCategory {
  const factory DamageCauseCategory({
    required int id,
    @Default('') String nameAr,
    @Default('') String nameEn,
  }) = _DamageCauseCategory;

  factory DamageCauseCategory.fromJson(Map<String, dynamic> json) =>
      _$DamageCauseCategoryFromJson(json);
}

@freezed
class DamageCause with _$DamageCause {
  const factory DamageCause({
    required int id,
    required int parentId,
    @Default('') String nameAr,
    @Default('') String nameEn,
  }) = _DamageCause;

  factory DamageCause.fromJson(Map<String, dynamic> json) =>
      _$DamageCauseFromJson(json);
}

@freezed
class CostingSheetCatalog with _$CostingSheetCatalog {
  const factory CostingSheetCatalog({
    required String id,
    @Default('') String name,
    String? description,
    required DateTime createdAt,
    @Default('') String createdBy,
  }) = _CostingSheetCatalog;

  factory CostingSheetCatalog.fromJson(Map<String, dynamic> json) =>
      _$CostingSheetCatalogFromJson(json);
}

@freezed
class CostingSheetVersion with _$CostingSheetVersion {
  const factory CostingSheetVersion({
    required String id,
    required String catalogId,
    required int versionNumber,
    required int status, // 0: Draft, 1: PendingApproval, 2: Active, 3: Archived
    required DateTime effectiveFrom,
    DateTime? effectiveTo,
    required DateTime createdAt,
    @Default('') String createdBy,
    DateTime? approvedAt,
    String? approvedBy,
  }) = _CostingSheetVersion;

  factory CostingSheetVersion.fromJson(Map<String, dynamic> json) =>
      _$CostingSheetVersionFromJson(json);
}

@freezed
class CostingSheetItem with _$CostingSheetItem {
  const factory CostingSheetItem({
    required String id,
    required String versionId,
    required int classificationId,
    int? measurementUnitId,
    required double unitPrice,
    required DateTime createdAt,
  }) = _CostingSheetItem;

  factory CostingSheetItem.fromJson(Map<String, dynamic> json) =>
      _$CostingSheetItemFromJson(json);
}
