// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DamageReportImpl _$$DamageReportImplFromJson(Map<String, dynamic> json) =>
    _$DamageReportImpl(
      id: json['clientId'] as String,
      serverId: json['id'] as String?,
      permanentFormNumber: json['permanentFormNumber'] as String? ?? '',
      temporaryFormNumber: json['temporaryFormNumber'] as String? ?? '',
      damageYear: (json['damageYear'] as num?)?.toInt() ?? 0,
      farmId: json['farmId'] as String,
      farmerId: json['farmerId'] as String,
      damageDate: DateTime.parse(json['damageDate'] as String),
      documentationDate: DateTime.parse(json['documentationDate'] as String),
      damageCauseCategoryId:
          (json['damageCauseCategoryId'] as num?)?.toInt() ?? 0,
      damageCauseId: (json['damageCauseId'] as num?)?.toInt() ?? 0,
      settlementName: json['settlementName'] as String?,
      companyName: json['companyName'] as String?,
      governorateId: json['governorateId'] as String,
      directorateId: json['directorateId'] as String,
      localityId: json['localityId'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      statusId: json['statusId'] as String,
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
      'permanentFormNumber': instance.permanentFormNumber,
      'temporaryFormNumber': instance.temporaryFormNumber,
      'damageYear': instance.damageYear,
      'farmId': instance.farmId,
      'farmerId': instance.farmerId,
      'damageDate': instance.damageDate.toIso8601String(),
      'documentationDate': instance.documentationDate.toIso8601String(),
      'damageCauseCategoryId': instance.damageCauseCategoryId,
      'damageCauseId': instance.damageCauseId,
      'settlementName': instance.settlementName,
      'companyName': instance.companyName,
      'governorateId': instance.governorateId,
      'directorateId': instance.directorateId,
      'localityId': instance.localityId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
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
