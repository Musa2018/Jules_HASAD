// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'damage_item.freezed.dart';
part 'damage_item.g.dart';

@freezed
class DamageItem with _$DamageItem {
  const factory DamageItem({
    @JsonKey(name: 'clientId') required String id, // ClientId
    @JsonKey(name: 'id') String? serverId,
    required String damageReportId,
    @Default(0) int classificationId,
    @Default('') String costingSheetId,
    String? costingSheetItemId,
    @Default(0.0) double calculatedUnitPrice,
    @Default('') String measurementUnitSnapshot,
    required double affectedArea,
    required double damagePercentage,
    required double quantity,
    required double estimatedLoss,
    @Default('') String rowVersion,
    @Default('completed') String syncStatus,
    String? lastSyncError,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
  }) = _DamageItem;

  factory DamageItem.fromJson(Map<String, dynamic> json) =>
      _$DamageItemFromJson(json);
}
