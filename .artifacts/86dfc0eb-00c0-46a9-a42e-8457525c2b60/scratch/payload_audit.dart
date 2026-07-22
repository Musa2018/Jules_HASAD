import 'dart:convert';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/data/farm_sync_dtos.dart';

void main() {
  final farm = Farm(
    id: 'local-uuid-123',
    serverId: 'server-uuid-456',
    farmerId: 'farmer-1',
    localFarmName: 'Green Valley',
    ownershipTypeId: 2, // Leased
    ownerFarmerId: 'owner-1',
    relationshipToOwnerId: 2, // Tenant
    governorateId: 'gov-1',
    directorateId: 'dir-1',
    localityId: 'loc-1',
    basin: '10',
    parcel: '5',
    area: 50.5,
    areaUnitId: 1, // Dunum
    agriculturalSectorId: 1, // Plant
    politicalClassificationId: 1, // A
    notes: 'Some notes',
    rowVersion: 'AAAAAAA=',
    syncStatus: 'pending',
    isPendingDelete: false,
  );

  print('--- CREATE PAYLOAD ---');
  print(jsonEncode(FarmSyncDto.toCreateJson(farm)));
  
  print('\n--- UPDATE PAYLOAD ---');
  print(jsonEncode(FarmSyncDto.toUpdateJson(farm)));
}
