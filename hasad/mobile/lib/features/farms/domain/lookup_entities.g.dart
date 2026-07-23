// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lookup_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OwnershipTypeImpl _$$OwnershipTypeImplFromJson(Map<String, dynamic> json) =>
    _$OwnershipTypeImpl(
      id: (json['id'] as num).toInt(),
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
    );

Map<String, dynamic> _$$OwnershipTypeImplToJson(_$OwnershipTypeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
    };

_$AgriculturalSectorImpl _$$AgriculturalSectorImplFromJson(
  Map<String, dynamic> json,
) => _$AgriculturalSectorImpl(
  id: (json['id'] as num).toInt(),
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
);

Map<String, dynamic> _$$AgriculturalSectorImplToJson(
  _$AgriculturalSectorImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
};

_$PoliticalClassificationImpl _$$PoliticalClassificationImplFromJson(
  Map<String, dynamic> json,
) => _$PoliticalClassificationImpl(
  id: (json['id'] as num).toInt(),
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
);

Map<String, dynamic> _$$PoliticalClassificationImplToJson(
  _$PoliticalClassificationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
};

_$AreaUnitImpl _$$AreaUnitImplFromJson(Map<String, dynamic> json) =>
    _$AreaUnitImpl(
      id: (json['id'] as num).toInt(),
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
    );

Map<String, dynamic> _$$AreaUnitImplToJson(_$AreaUnitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
    };

_$MeasurementUnitImpl _$$MeasurementUnitImplFromJson(
  Map<String, dynamic> json,
) => _$MeasurementUnitImpl(
  id: (json['id'] as num).toInt(),
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
  code: json['code'] as String?,
  category: json['category'] as String,
);

Map<String, dynamic> _$$MeasurementUnitImplToJson(
  _$MeasurementUnitImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
  'code': instance.code,
  'category': instance.category,
};

_$RelationshipToOwnerImpl _$$RelationshipToOwnerImplFromJson(
  Map<String, dynamic> json,
) => _$RelationshipToOwnerImpl(
  id: (json['id'] as num).toInt(),
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
);

Map<String, dynamic> _$$RelationshipToOwnerImplToJson(
  _$RelationshipToOwnerImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
};

_$DamageNatureImpl _$$DamageNatureImplFromJson(Map<String, dynamic> json) =>
    _$DamageNatureImpl(
      id: (json['id'] as num).toInt(),
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
    );

Map<String, dynamic> _$$DamageNatureImplToJson(_$DamageNatureImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
    };

_$DamageCategoryImpl _$$DamageCategoryImplFromJson(Map<String, dynamic> json) =>
    _$DamageCategoryImpl(
      id: (json['id'] as num).toInt(),
      parentId: (json['parentId'] as num).toInt(),
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
    );

Map<String, dynamic> _$$DamageCategoryImplToJson(
  _$DamageCategoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'parentId': instance.parentId,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
};

_$DamageSubCategoryImpl _$$DamageSubCategoryImplFromJson(
  Map<String, dynamic> json,
) => _$DamageSubCategoryImpl(
  id: (json['id'] as num).toInt(),
  parentId: (json['parentId'] as num).toInt(),
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
);

Map<String, dynamic> _$$DamageSubCategoryImplToJson(
  _$DamageSubCategoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'parentId': instance.parentId,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
};

_$DamageClassificationImpl _$$DamageClassificationImplFromJson(
  Map<String, dynamic> json,
) => _$DamageClassificationImpl(
  id: (json['id'] as num).toInt(),
  parentId: (json['parentId'] as num).toInt(),
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
);

Map<String, dynamic> _$$DamageClassificationImplToJson(
  _$DamageClassificationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'parentId': instance.parentId,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
};

_$DamageCauseCategoryImpl _$$DamageCauseCategoryImplFromJson(
  Map<String, dynamic> json,
) => _$DamageCauseCategoryImpl(
  id: (json['id'] as num).toInt(),
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
);

Map<String, dynamic> _$$DamageCauseCategoryImplToJson(
  _$DamageCauseCategoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
};

_$DamageCauseImpl _$$DamageCauseImplFromJson(Map<String, dynamic> json) =>
    _$DamageCauseImpl(
      id: (json['id'] as num).toInt(),
      parentId: (json['parentId'] as num).toInt(),
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
    );

Map<String, dynamic> _$$DamageCauseImplToJson(_$DamageCauseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
    };

_$CostingSheetCatalogImpl _$$CostingSheetCatalogImplFromJson(
  Map<String, dynamic> json,
) => _$CostingSheetCatalogImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  createdBy: json['createdBy'] as String,
);

Map<String, dynamic> _$$CostingSheetCatalogImplToJson(
  _$CostingSheetCatalogImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'createdAt': instance.createdAt.toIso8601String(),
  'createdBy': instance.createdBy,
};

_$CostingSheetVersionImpl _$$CostingSheetVersionImplFromJson(
  Map<String, dynamic> json,
) => _$CostingSheetVersionImpl(
  id: json['id'] as String,
  catalogId: json['catalogId'] as String,
  versionNumber: (json['versionNumber'] as num).toInt(),
  status: (json['status'] as num).toInt(),
  effectiveFrom: DateTime.parse(json['effectiveFrom'] as String),
  effectiveTo: json['effectiveTo'] == null
      ? null
      : DateTime.parse(json['effectiveTo'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  createdBy: json['createdBy'] as String,
  approvedAt: json['approvedAt'] == null
      ? null
      : DateTime.parse(json['approvedAt'] as String),
  approvedBy: json['approvedBy'] as String?,
);

Map<String, dynamic> _$$CostingSheetVersionImplToJson(
  _$CostingSheetVersionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'catalogId': instance.catalogId,
  'versionNumber': instance.versionNumber,
  'status': instance.status,
  'effectiveFrom': instance.effectiveFrom.toIso8601String(),
  'effectiveTo': instance.effectiveTo?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'createdBy': instance.createdBy,
  'approvedAt': instance.approvedAt?.toIso8601String(),
  'approvedBy': instance.approvedBy,
};

_$CostingSheetItemImpl _$$CostingSheetItemImplFromJson(
  Map<String, dynamic> json,
) => _$CostingSheetItemImpl(
  id: json['id'] as String,
  versionId: json['versionId'] as String,
  classificationId: (json['classificationId'] as num).toInt(),
  measurementUnitId: (json['measurementUnitId'] as num?)?.toInt(),
  unitPrice: (json['unitPrice'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$CostingSheetItemImplToJson(
  _$CostingSheetItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'versionId': instance.versionId,
  'classificationId': instance.classificationId,
  'measurementUnitId': instance.measurementUnitId,
  'unitPrice': instance.unitPrice,
  'createdAt': instance.createdAt.toIso8601String(),
};
