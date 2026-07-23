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
      agriculturalSectorId: json['agriculturalSectorId'] as String,
      subSectorId: json['subSectorId'] as String,
      cropId: json['cropId'] as String,
      damageTypeId: json['damageTypeId'] as String,
      affectedArea: (json['affectedArea'] as num).toDouble(),
      damagePercentage: (json['damagePercentage'] as num).toDouble(),
      quantity: (json['quantity'] as num).toDouble(),
      estimatedLoss: (json['estimatedLoss'] as num).toDouble(),
      rowVersion: json['rowVersion'] as String? ?? '',
      syncStatus: json['syncStatus'] as String? ?? 'completed',
      lastSyncError: json['lastSyncError'] as String?,
    );

Map<String, dynamic> _$$DamageItemImplToJson(_$DamageItemImpl instance) =>
    <String, dynamic>{
      'clientId': instance.id,
      'id': instance.serverId,
      'damageReportId': instance.damageReportId,
      'agriculturalSectorId': instance.agriculturalSectorId,
      'subSectorId': instance.subSectorId,
      'cropId': instance.cropId,
      'damageTypeId': instance.damageTypeId,
      'affectedArea': instance.affectedArea,
      'damagePercentage': instance.damagePercentage,
      'quantity': instance.quantity,
      'estimatedLoss': instance.estimatedLoss,
      'rowVersion': instance.rowVersion,
      'syncStatus': instance.syncStatus,
      'lastSyncError': instance.lastSyncError,
    };
