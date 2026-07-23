// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DamageItemImpl _$$DamageItemImplFromJson(Map<String, dynamic> json) =>
    _$DamageItemImpl(
      id: json['clientId'] as String,
      serverId: json['id'] as String?,
      damageReportId: json['damageReportId'] as String,
      classificationId: (json['classificationId'] as num?)?.toInt() ?? 0,
      costingSheetId: json['costingSheetId'] as String? ?? '',
      calculatedUnitPrice:
          (json['calculatedUnitPrice'] as num?)?.toDouble() ?? 0.0,
      measurementUnitSnapshot: json['measurementUnitSnapshot'] as String? ?? '',
      affectedArea: (json['affectedArea'] as num).toDouble(),
      damagePercentage: (json['damagePercentage'] as num).toDouble(),
      quantity: (json['quantity'] as num).toDouble(),
      estimatedLoss: (json['estimatedLoss'] as num).toDouble(),
      rowVersion: json['rowVersion'] as String? ?? '',
      syncStatus: json['syncStatus'] as String? ?? 'completed',
      lastSyncError: json['lastSyncError'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      deletedBy: json['deletedBy'] as String?,
    );

Map<String, dynamic> _$$DamageItemImplToJson(_$DamageItemImpl instance) =>
    <String, dynamic>{
      'clientId': instance.id,
      'id': instance.serverId,
      'damageReportId': instance.damageReportId,
      'classificationId': instance.classificationId,
      'costingSheetId': instance.costingSheetId,
      'calculatedUnitPrice': instance.calculatedUnitPrice,
      'measurementUnitSnapshot': instance.measurementUnitSnapshot,
      'affectedArea': instance.affectedArea,
      'damagePercentage': instance.damagePercentage,
      'quantity': instance.quantity,
      'estimatedLoss': instance.estimatedLoss,
      'rowVersion': instance.rowVersion,
      'syncStatus': instance.syncStatus,
      'lastSyncError': instance.lastSyncError,
      'isDeleted': instance.isDeleted,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'deletedBy': instance.deletedBy,
    };
