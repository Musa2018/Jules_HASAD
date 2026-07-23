// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_workflow_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DamageWorkflowHistoryImpl _$$DamageWorkflowHistoryImplFromJson(
  Map<String, dynamic> json,
) => _$DamageWorkflowHistoryImpl(
  id: json['id'] as String,
  serverId: json['serverId'] as String?,
  damageReportId: json['damageReportId'] as String,
  fromStatus: json['fromStatus'] as String,
  toStatus: json['toStatus'] as String,
  changedByUserId: json['changedByUserId'] as String,
  changedAt: DateTime.parse(json['changedAt'] as String),
  comment: json['comment'] as String?,
  isOverride: json['isOverride'] as bool? ?? false,
);

Map<String, dynamic> _$$DamageWorkflowHistoryImplToJson(
  _$DamageWorkflowHistoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'serverId': instance.serverId,
  'damageReportId': instance.damageReportId,
  'fromStatus': instance.fromStatus,
  'toStatus': instance.toStatus,
  'changedByUserId': instance.changedByUserId,
  'changedAt': instance.changedAt.toIso8601String(),
  'comment': instance.comment,
  'isOverride': instance.isOverride,
};
