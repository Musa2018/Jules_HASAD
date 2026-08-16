// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_report_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DamageReportAttachmentImpl _$$DamageReportAttachmentImplFromJson(
  Map<String, dynamic> json,
) => _$DamageReportAttachmentImpl(
  id: json['clientId'] as String,
  serverId: json['id'] as String?,
  damageReportId: json['damageReportId'] as String,
  documentName: json['documentName'] as String? ?? '',
  documentDate: json['documentDate'] == null
      ? null
      : DateTime.parse(json['documentDate'] as String),
  documentTypeId: (json['documentTypeId'] as num?)?.toInt() ?? 0,
  localPath: json['localPath'] as String,
  remotePath: json['remotePath'] as String?,
  uploadStatus: json['uploadStatus'] as String? ?? 'pending',
  syncStatus: json['syncStatus'] as String? ?? 'pending',
  lastSyncError: json['lastSyncError'] as String?,
);

Map<String, dynamic> _$$DamageReportAttachmentImplToJson(
  _$DamageReportAttachmentImpl instance,
) => <String, dynamic>{
  'clientId': instance.id,
  'id': instance.serverId,
  'damageReportId': instance.damageReportId,
  'documentName': instance.documentName,
  'documentDate': instance.documentDate?.toIso8601String(),
  'documentTypeId': instance.documentTypeId,
  'localPath': instance.localPath,
  'remotePath': instance.remotePath,
  'uploadStatus': instance.uploadStatus,
  'syncStatus': instance.syncStatus,
  'lastSyncError': instance.lastSyncError,
};
