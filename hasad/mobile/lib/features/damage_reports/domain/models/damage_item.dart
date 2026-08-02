// ignore_for_file: invalid_annotation_target, deprecated_member_use_from_same_package
import 'package:freezed_annotation/freezed_annotation.dart';

part 'damage_item.freezed.dart';
part 'damage_item.g.dart';

@freezed
class DamageItem with _$DamageItem {
  const factory DamageItem({
    @JsonKey(name: 'clientId') @Default('') String id, // ClientId
    @JsonKey(name: 'id') String? serverId,
    @Default('') String damageReportId,
    @Default(0) int damageNatureId,
    @Default(0) int damageActionId,
    @Default(0) int classificationId,
    @Deprecated('Use costingSheetItemId. Kept for backend sync compatibility.')
    @Default('') String costingSheetId,
    String? costingSheetItemId,
    @Default(0.0) double calculatedUnitPrice,
    @Default('') String measurementUnitSnapshot,
    @Default(0.0) double affectedArea,
    @Default(0.0) double damagePercentage,
    @Default(0.0) double quantity,
    @Default(0.0) double estimatedLoss,
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
