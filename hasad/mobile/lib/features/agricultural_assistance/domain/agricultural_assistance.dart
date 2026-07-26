import 'package:freezed_annotation/freezed_annotation.dart';

part 'agricultural_assistance.freezed.dart';
part 'agricultural_assistance.g.dart';

@freezed
class AgriculturalAssistance with _$AgriculturalAssistance {
  const factory AgriculturalAssistance({
    required String id,
    required String clientId,
    required String damageReportId,
    required double calculatedAmount,
    required double approvedAmount,
    required String status,
    required String remarks,
    required String rowVersion,
  }) = _AgriculturalAssistance;

  factory AgriculturalAssistance.fromJson(Map<String, dynamic> json) =>
      _$AgriculturalAssistanceFromJson(json);
}
