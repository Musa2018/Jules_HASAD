// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agricultural_assistance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AgriculturalAssistanceImpl _$$AgriculturalAssistanceImplFromJson(
  Map<String, dynamic> json,
) => _$AgriculturalAssistanceImpl(
  id: json['id'] as String,
  clientId: json['clientId'] as String,
  damageReportId: json['damageReportId'] as String,
  calculatedAmount: (json['calculatedAmount'] as num).toDouble(),
  approvedAmount: (json['approvedAmount'] as num).toDouble(),
  status: json['status'] as String,
  remarks: json['remarks'] as String,
  rowVersion: json['rowVersion'] as String,
);

Map<String, dynamic> _$$AgriculturalAssistanceImplToJson(
  _$AgriculturalAssistanceImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'clientId': instance.clientId,
  'damageReportId': instance.damageReportId,
  'calculatedAmount': instance.calculatedAmount,
  'approvedAmount': instance.approvedAmount,
  'status': instance.status,
  'remarks': instance.remarks,
  'rowVersion': instance.rowVersion,
};
