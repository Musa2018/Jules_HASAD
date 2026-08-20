// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuditLogEntryImpl _$$AuditLogEntryImplFromJson(Map<String, dynamic> json) =>
    _$AuditLogEntryImpl(
      eventType: json['eventType'] as String,
      description: json['description'] as String,
      performedBy: json['performedBy'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      metadata: json['metadata'] as String?,
    );

Map<String, dynamic> _$$AuditLogEntryImplToJson(_$AuditLogEntryImpl instance) =>
    <String, dynamic>{
      'eventType': instance.eventType,
      'description': instance.description,
      'performedBy': instance.performedBy,
      'eventDate': instance.eventDate.toIso8601String(),
      'metadata': instance.metadata,
    };
