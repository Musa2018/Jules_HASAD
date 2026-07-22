import 'package:freezed_annotation/freezed_annotation.dart';

part 'farm.freezed.dart';
part 'farm.g.dart';

@freezed
class Farm with _$Farm {
  const factory Farm({
    required String id, // ClientId
    String? serverId,
    required String farmerId,
    required String localFarmName,
    required int ownershipTypeId,
    String? ownerFarmerId,
    int? relationshipToOwnerId,
    
    // Geography
    required String governorateId,
    required String directorateId,
    required String localityId,
    required String basin,
    required String parcel,
    
    // Area
    required double area,
    required int areaUnitId,
    
    // Agriculture
    required int agriculturalSectorId,
    required int politicalClassificationId,
    
    // Location
    double? latitude,
    double? longitude,
    
    String? notes,
    
    // Sync & Metadata
    @Default('') String rowVersion,
    @Default('completed') String syncStatus,
    String? lastSyncError,
    @Default(false) bool isPendingDelete,
    DateTime? createdAt,
    DateTime? updatedAt,
    
    // Soft Delete from backend
    @Default(false) bool isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
  }) = _Farm;

  factory Farm.fromJson(Map<String, dynamic> json) => _$FarmFromJson(json);
}
