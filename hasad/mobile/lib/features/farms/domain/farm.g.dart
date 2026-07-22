// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FarmImpl _$$FarmImplFromJson(Map<String, dynamic> json) => _$FarmImpl(
  id: json['id'] as String,
  serverId: json['serverId'] as String?,
  farmerId: json['farmerId'] as String,
  localFarmName: json['localFarmName'] as String,
  ownershipTypeId: (json['ownershipTypeId'] as num).toInt(),
  ownerFarmerId: json['ownerFarmerId'] as String?,
  relationshipToOwnerId: (json['relationshipToOwnerId'] as num?)?.toInt(),
  governorateId: json['governorateId'] as String,
  directorateId: json['directorateId'] as String,
  localityId: json['localityId'] as String,
  basin: json['basin'] as String,
  parcel: json['parcel'] as String,
  area: (json['area'] as num).toDouble(),
  areaUnitId: (json['areaUnitId'] as num).toInt(),
  agriculturalSectorId: (json['agriculturalSectorId'] as num).toInt(),
  politicalClassificationId: (json['politicalClassificationId'] as num).toInt(),
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
  rowVersion: json['rowVersion'] as String? ?? '',
  syncStatus: json['syncStatus'] as String? ?? 'completed',
  lastSyncError: json['lastSyncError'] as String?,
  isPendingDelete: json['isPendingDelete'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  isDeleted: json['isDeleted'] as bool? ?? false,
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  deletedBy: json['deletedBy'] as String?,
);

Map<String, dynamic> _$$FarmImplToJson(_$FarmImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serverId': instance.serverId,
      'farmerId': instance.farmerId,
      'localFarmName': instance.localFarmName,
      'ownershipTypeId': instance.ownershipTypeId,
      'ownerFarmerId': instance.ownerFarmerId,
      'relationshipToOwnerId': instance.relationshipToOwnerId,
      'governorateId': instance.governorateId,
      'directorateId': instance.directorateId,
      'localityId': instance.localityId,
      'basin': instance.basin,
      'parcel': instance.parcel,
      'area': instance.area,
      'areaUnitId': instance.areaUnitId,
      'agriculturalSectorId': instance.agriculturalSectorId,
      'politicalClassificationId': instance.politicalClassificationId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notes': instance.notes,
      'rowVersion': instance.rowVersion,
      'syncStatus': instance.syncStatus,
      'lastSyncError': instance.lastSyncError,
      'isPendingDelete': instance.isPendingDelete,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'deletedBy': instance.deletedBy,
    };
