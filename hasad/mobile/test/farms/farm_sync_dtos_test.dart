import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/farms/data/farm_sync_dtos.dart';
import 'package:mobile/features/farms/domain/farm.dart';

void main() {
  group('FarmSyncDto', () {
    final baseFarm = Farm(
      id: 'local-f1',
      farmerId: 'farmer-1',
      localFarmName: 'Farm 1',
      governorateId: 'G1',
      directorateId: 'D1',
      localityId: 'L1',
      basin: 'B1',
      parcel: 'P1',
      area: 10.5,
      areaUnitId: 1,
      ownershipTypeId: 1,
      agriculturalSectorId: 1,
      politicalClassificationId: 1,
    );

    test('toCreateJson maps all required fields for backend', () {
      final json = FarmSyncDto.toCreateJson(baseFarm);

      expect(json['clientId'], 'local-f1');
      expect(json['farmerId'], 'farmer-1');
      expect(json['localFarmName'], 'Farm 1');
      expect(json['governorateId'], 'G1');
      expect(json['directorateId'], 'D1');
      expect(json['localityId'], 'L1');
      expect(json['basin'], 'B1');
      expect(json['parcel'], 'P1');
      expect(json['area'], 10.5);
      expect(json['areaUnitId'], 1);
      expect(json['ownershipTypeId'], 1);
      expect(json['agriculturalSectorId'], 1);
      expect(json['politicalClassificationId'], 1);
      
      expect(json.containsKey('syncStatus'), isFalse);
      expect(json.containsKey('isDeleted'), isFalse);
    });

    test('toUpdateJson includes serverId and rowVersion', () {
      final farm = baseFarm.copyWith(serverId: 'remote-f1', rowVersion: 'v1');
      final json = FarmSyncDto.toUpdateJson(farm);

      expect(json['id'], 'remote-f1');
      expect(json['clientId'], 'local-f1');
      expect(json['rowVersion'], 'v1');
    });

    test('toUpdateJson throws ArgumentError when serverId is null', () {
      expect(() => FarmSyncDto.toUpdateJson(baseFarm), throwsArgumentError);
    });
  });
}
