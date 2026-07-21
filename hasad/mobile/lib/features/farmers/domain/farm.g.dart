// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FarmImpl _$$FarmImplFromJson(Map<String, dynamic> json) => _$FarmImpl(
  id: json['id'] as String,
  serverId: json['serverId'] as String?,
  farmerId: json['farmerId'] as String,
  name: json['name'] as String,
  governorateId: json['governorateId'] as String,
  localityId: json['localityId'] as String,
  landArea: (json['landArea'] as num).toDouble(),
  landAreaUnit: json['landAreaUnit'] as String,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  ownershipTypeId: json['ownershipTypeId'] as String,
  rowVersion: json['rowVersion'] as String? ?? '',
  syncStatus: json['syncStatus'] as String? ?? 'completed',
  lastSyncError: json['lastSyncError'] as String?,
);

Map<String, dynamic> _$$FarmImplToJson(_$FarmImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serverId': instance.serverId,
      'farmerId': instance.farmerId,
      'name': instance.name,
      'governorateId': instance.governorateId,
      'localityId': instance.localityId,
      'landArea': instance.landArea,
      'landAreaUnit': instance.landAreaUnit,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'ownershipTypeId': instance.ownershipTypeId,
      'rowVersion': instance.rowVersion,
      'syncStatus': instance.syncStatus,
      'lastSyncError': instance.lastSyncError,
    };
