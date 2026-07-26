// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_status.dart';

part 'damage_report.freezed.dart';
part 'damage_report.g.dart';

@freezed
class DamageReport with _$DamageReport {
  const factory DamageReport({
    @JsonKey(name: 'clientId') required String id, // ClientId
    @JsonKey(name: 'id') String? serverId,
    @Default('') String reportNumber,
    @Default('') String permanentFormNumber,
    @Default('') String temporaryFormNumber,
    @Default(0) int damageYear,
    required String farmId,
    @Default('') String farmerId,
    required DateTime damageDate,
    required DateTime documentationDate,
    @Default(0) int agriculturalSectorId,
    @Default(0) int damageCauseCategoryId,
    @Default(0) int damageCauseId,
    String? settlementName,
    String? companyName,
    @Default('') String governorateId,
    @Default('') String directorateId,
    @Default('') String localityId,
    double? latitude,
    double? longitude,
    @Default(DamageReportStatus.pendingTechnicalVerification) String statusId,
    required String notes,
    @Default('') String rowVersion,
    @Default([]) List<DamageItem> items,
    @Default('completed') String syncStatus,
    String? lastSyncError,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
  }) = _DamageReport;

  factory DamageReport.fromJson(Map<String, dynamic> json) =>
      _$DamageReportFromJson(json);
}
