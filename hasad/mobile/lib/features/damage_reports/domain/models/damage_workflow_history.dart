// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'damage_workflow_history.freezed.dart';
part 'damage_workflow_history.g.dart';

@freezed
class DamageWorkflowHistory with _$DamageWorkflowHistory {
  const factory DamageWorkflowHistory({
    @JsonKey(name: 'id') @Default('') String id, // Local Drift ID
    @JsonKey(name: 'serverId') String? serverId, // Authority ID from server
    @Default('') String damageReportId,
    @Default('') String fromStatus,
    @Default('') String toStatus,
    @Default('') String changedByUserId,
    @Default('') String changedByUserName,
    DateTime? changedAt,
    String? comment,
    @Default(false) bool isOverride,
  }) = _DamageWorkflowHistory;

  factory DamageWorkflowHistory.fromJson(Map<String, dynamic> json) =>
      _$DamageWorkflowHistoryFromJson(json);
}
