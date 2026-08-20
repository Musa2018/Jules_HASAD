import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log_entry.freezed.dart';
part 'audit_log_entry.g.dart';

@freezed
class AuditLogEntry with _$AuditLogEntry {
  const factory AuditLogEntry({
    required String eventType,
    required String description,
    required String performedBy,
    required DateTime eventDate,
    String? metadata,
  }) = _AuditLogEntry;

  factory AuditLogEntry.fromJson(Map<String, dynamic> json) =>
      _$AuditLogEntryFromJson(json);
}
