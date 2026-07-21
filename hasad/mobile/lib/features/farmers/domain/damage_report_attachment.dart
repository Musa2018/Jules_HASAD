import 'package:freezed_annotation/freezed_annotation.dart';

part 'damage_report_attachment.freezed.dart';
part 'damage_report_attachment.g.dart';

@freezed
class DamageReportAttachment with _$DamageReportAttachment {
  const factory DamageReportAttachment({
    required String id, // ClientId
    String? serverId,
    required String damageReportId,
    required String localPath,
    String? remotePath,
    @Default('pending') String uploadStatus,
    @Default('pending') String syncStatus,
    String? lastSyncError,
  }) = _DamageReportAttachment;

  factory DamageReportAttachment.fromJson(Map<String, dynamic> json) =>
      _$DamageReportAttachmentFromJson(json);
}
