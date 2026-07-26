// ignore_for_file: deprecated_member_use_from_same_package
import 'package:mobile/features/farms/domain/farm.dart';

class FarmSyncDto {
  static Map<String, dynamic> toCreateJson(Farm farm) {
    return {
      'clientId': farm.id,
      'farmerId': farm.farmerId,
      'localFarmName': farm.localFarmName,
      'ownershipTypeId': farm.ownershipTypeId,
      'ownerFarmerId': farm.ownerFarmerId,
      'relationshipToOwnerId': farm.relationshipToOwnerId,
      'governorateId': farm.governorateId,
      'directorateId': farm.directorateId,
      'localityId': farm.localityId,
      'basin': farm.basin,
      'parcel': farm.parcel,
      'area': farm.area,
      'areaUnitId': farm.areaUnitId,
      if (farm.measurementUnitId != null) 'measurementUnitId': farm.measurementUnitId,
      'agriculturalSectorId': farm.agriculturalSectorId,
      'politicalClassificationId': farm.politicalClassificationId,
      'latitude': farm.latitude,
      'longitude': farm.longitude,
      'notes': farm.notes,
    };
  }

  static Map<String, dynamic> toUpdateJson(Farm farm) {
    if (farm.serverId == null) {
      throw ArgumentError('ServerId is required for update synchronization.');
    }
    return {
      'id': farm.serverId,
      'clientId': farm.id,
      'farmerId': farm.farmerId,
      'localFarmName': farm.localFarmName,
      'ownershipTypeId': farm.ownershipTypeId,
      'ownerFarmerId': farm.ownerFarmerId,
      'relationshipToOwnerId': farm.relationshipToOwnerId,
      'governorateId': farm.governorateId,
      'directorateId': farm.directorateId,
      'localityId': farm.localityId,
      'basin': farm.basin,
      'parcel': farm.parcel,
      'area': farm.area,
      'areaUnitId': farm.areaUnitId,
      if (farm.measurementUnitId != null) 'measurementUnitId': farm.measurementUnitId,
      'agriculturalSectorId': farm.agriculturalSectorId,
      'politicalClassificationId': farm.politicalClassificationId,
      'latitude': farm.latitude,
      'longitude': farm.longitude,
      'notes': farm.notes,
      'rowVersion': farm.rowVersion,
    };
  }
}
