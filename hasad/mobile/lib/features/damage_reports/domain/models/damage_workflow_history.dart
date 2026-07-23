// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'damage_workflow_history.freezed.dart';
part 'damage_workflow_history.g.dart';

@freezed
class DamageWorkflowHistory with _$DamageWorkflowHistory {
  const factory DamageWorkflowHistory({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'serverId') String? serverId,
    required String damageReportId,
    required String fromStatus,
    required String toStatus,
    required String changedByUserId,
    required DateTime changedAt,
    String? comment,
    @Default(false) bool isOverride,
  }) = _DamageWorkflowHistory;

  factory DamageWorkflowHistory.fromJson(Map<String, dynamic> json) =>
      _$DamageWorkflowHistoryFromJson(json);
}
