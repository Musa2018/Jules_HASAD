import 'package:freezed_annotation/freezed_annotation.dart';

part 'farm.freezed.dart';
part 'farm.g.dart';

@freezed
class Farm with _$Farm {
  const factory Farm({
    required String id, // ClientId
    String? serverId,
    required String farmerId,
    required String name,
    required String governorateId,
    required String localityId,
    required double landArea,
    required String landAreaUnit,
    double? latitude,
    double? longitude,
    required String ownershipTypeId,
    @Default('') String rowVersion,
    @Default('completed') String syncStatus,
    String? lastSyncError,
  }) = _Farm;

  factory Farm.fromJson(Map<String, dynamic> json) => _$FarmFromJson(json);
}
