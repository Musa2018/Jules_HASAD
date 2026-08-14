// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_status.dart';

part 'damage_report.freezed.dart';
part 'damage_report.g.dart';

@freezed
class DamageReport with _$DamageReport {
  const factory DamageReport({
    @JsonKey(name: 'clientId') @Default('') String id, // ClientId
    @JsonKey(name: 'id') String? serverId,
    @Default('') String reportNumber,
    @Default('') String permanentFormNumber,
    @Default('') String temporaryFormNumber,
    @Default(0) int damageYear,
    @Default('') String farmId,
    @Default('') String farmerId,
    DateTime? damageDate,
    DateTime? documentationDate,
    @Default(0) int agriculturalSectorId,
    @Default(0) int damageCauseCategoryId,
    @Default(0) int damageCauseId,
    @Default('') String governorateId,
    @Default('') String directorateId,
    @Default('') String localityId,
    @Default(DamageReportStatus.pendingTechnicalVerification) String statusId,
    @JsonKey(name: 'totalDamage') @Default(0.0) double totalDamage,
    @Default('') String notes,
    @Default('') String createdBy,
    @Default('') String rowVersion,
    @Default([]) List<DamageItem> items,
    @Default('completed') String syncStatus,
    String? lastSyncError,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
  }) = _DamageReport;

  factory DamageReport.fromJson(Map<String, dynamic> json) =>
      _$DamageReportFromJson(json);
}

extension DamageReportWorkflowX on DamageReport {
  bool get isHeaderSynced => serverId != null && serverId!.isNotEmpty && reportNumber.isNotEmpty;

  bool get areItemsSynced => items.every((item) => item.syncStatus == 'completed');

  bool get hasItems => items.isNotEmpty;

  bool get isReadyForReview {
    return isHeaderSynced &&
        hasItems &&
        areItemsSynced &&
        statusId != DamageReportStatus.completed &&
        statusId != 'Submitted'; // Check for legacy status if any
  }

  String get workflowStateKey {
    if (statusId == 'Submitted' || statusId == DamageReportStatus.techReview) return 'status_TechReview';
    if (statusId == DamageReportStatus.completed) return 'status_Completed';

    if (!isHeaderSynced) {
      return syncStatus == 'failed' ? 'workflowState_HeaderSyncFailed' : 'workflowState_DraftHeader';
    }

    if (!hasItems) return 'workflowState_HeaderSynced';

    if (!areItemsSynced) return 'workflowState_AssessmentPendingSync';

    if (isReadyForReview) return 'workflowState_ReadyForReview';

    return 'workflowState_AssessmentInProgress';
  }
}
