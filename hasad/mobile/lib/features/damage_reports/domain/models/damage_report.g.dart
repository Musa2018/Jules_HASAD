// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DamageReportImpl _$$DamageReportImplFromJson(Map<String, dynamic> json) =>
    _$DamageReportImpl(
      id: json['clientId'] as String,
      serverId: json['id'] as String?,
      reportNumber: json['reportNumber'] as String? ?? '',
      permanentFormNumber: json['permanentFormNumber'] as String? ?? '',
      temporaryFormNumber: json['temporaryFormNumber'] as String? ?? '',
      farmId: json['farmId'] as String,
      damageDate: DateTime.parse(json['damageDate'] as String),
      documentationDate: DateTime.parse(json['documentationDate'] as String),
      damageNatureId: (json['damageNatureId'] as num?)?.toInt() ?? 0,
      damageCauseCategoryId:
          (json['damageCauseCategoryId'] as num?)?.toInt() ?? 0,
      damageCauseId: (json['damageCauseId'] as num?)?.toInt() ?? 0,
      settlementName: json['settlementName'] as String?,
      companyName: json['companyName'] as String?,
      statusId:
          json['statusId'] as String? ??
          DamageReportStatus.pendingTechnicalVerification,
      notes: json['notes'] as String,
      rowVersion: json['rowVersion'] as String? ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => DamageItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      syncStatus: json['syncStatus'] as String? ?? 'completed',
      lastSyncError: json['lastSyncError'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      deletedBy: json['deletedBy'] as String?,
    );

Map<String, dynamic> _$$DamageReportImplToJson(_$DamageReportImpl instance) =>
    <String, dynamic>{
      'clientId': instance.id,
      'id': instance.serverId,
      'reportNumber': instance.reportNumber,
      'permanentFormNumber': instance.permanentFormNumber,
      'temporaryFormNumber': instance.temporaryFormNumber,
      'farmId': instance.farmId,
      'damageDate': instance.damageDate.toIso8601String(),
      'documentationDate': instance.documentationDate.toIso8601String(),
      'damageNatureId': instance.damageNatureId,
      'damageCauseCategoryId': instance.damageCauseCategoryId,
      'damageCauseId': instance.damageCauseId,
      'settlementName': instance.settlementName,
      'companyName': instance.companyName,
      'statusId': instance.statusId,
      'notes': instance.notes,
      'rowVersion': instance.rowVersion,
      'items': instance.items,
      'syncStatus': instance.syncStatus,
      'lastSyncError': instance.lastSyncError,
      'isDeleted': instance.isDeleted,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'deletedBy': instance.deletedBy,
    };
