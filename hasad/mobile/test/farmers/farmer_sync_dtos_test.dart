import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/features/farmers/data/farmer_sync_dtos.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';

void main() {
  group('FarmerSyncDto', () {
    final baseFarmer = Farmer(
      id: 'local-1',
      idTypeId: 1,
      idNumber: '1',
      firstNameAr: 'N1',
      fatherNameAr: 'N2',
      grandfatherNameAr: 'N3',
      familyNameAr: 'N4',
      firstNameEn: 'E1',
      fatherNameEn: 'E2',
      grandfatherNameEn: 'E3',
      familyNameEn: 'E4',
      birthDate: DateTime(1990, 5, 15),
      gender: Gender.male,
      phoneNumber: '123',
      familySize: 1,
      governorateId: 'G1',
      localityId: 'L1',
      address: 'A1',
    );

    test('toCreateJson maps required fields and formats date correctly', () {
      final json = FarmerSyncDto.toCreateJson(baseFarmer);

      expect(json['clientId'], 'local-1');
      expect(json['birthDate'], '1990-05-15'); // Normalize to YYYY-MM-DD
      expect(json['gender'], 1);
      expect(json.containsKey('syncStatus'), isFalse);
      expect(json.containsKey('lastSyncError'), isFalse);
    });

    test('toUpdateJson includes serverId and rowVersion', () {
      final farmer = baseFarmer.copyWith(serverId: 'remote-1', rowVersion: 'v1');
      final json = FarmerSyncDto.toUpdateJson(farmer);

      expect(json['id'], 'remote-1');
      expect(json['rowVersion'], 'v1');
    });

    test('toCreateJson throws SyncValidationException for Gender.unspecified', () {
      final invalidFarmer = baseFarmer.copyWith(gender: Gender.unspecified);

      expect(
        () => FarmerSyncDto.toCreateJson(invalidFarmer),
        throwsA(isA<SyncValidationException>()),
      );
    });
  });
}
