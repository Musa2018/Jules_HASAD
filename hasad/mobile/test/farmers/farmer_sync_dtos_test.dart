import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/features/farmers/data/farmer_sync_dtos.dart';
import 'package:mobile/features/farmers/domain/damage_item.dart';
import 'package:mobile/features/farmers/domain/damage_report.dart';
import 'package:mobile/features/farmers/domain/farm.dart';
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

  group('FarmSyncDto', () {
    final baseFarm = Farm(
      id: 'local-f1',
      farmerId: 'farmer-1',
      name: 'Farm 1',
      governorateId: 'G1',
      localityId: 'L1',
      landArea: 10.5,
      landAreaUnit: 'Dunum',
      ownershipTypeId: 'Owned',
    );

    test('toUpdateJson uses serverId when available', () {
      final farm = baseFarm.copyWith(serverId: 'remote-f1', rowVersion: 'v1');
      final json = FarmSyncDto.toUpdateJson(farm);

      expect(json['id'], 'remote-f1');
      expect(json['clientId'], 'local-f1');
      expect(json['rowVersion'], 'v1');
    });

    test('toUpdateJson falls back to id when serverId is null', () {
      final json = FarmSyncDto.toUpdateJson(baseFarm);
      expect(json['id'], 'local-f1');
    });
  });

  group('DamageReportSyncDto', () {
    final baseReport = DamageReport(
      id: 'local-r1',
      farmId: 'f1',
      farmerId: 'farmer1',
      damageDate: DateTime(2026, 7, 20),
      documentationDate: DateTime.now(),
      governorateId: 'G1',
      localityId: 'L1',
      statusId: 'Submitted',
      notes: 'Test',
      items: [
        DamageItem(
          id: 'local-i1',
          damageReportId: 'local-r1',
          agriculturalSectorId: 'S1',
          subSectorId: 'SS1',
          cropId: 'C1',
          damageTypeId: 'DT1',
          affectedArea: 5,
          damagePercentage: 50,
          quantity: 100,
          estimatedLoss: 1000,
        ),
      ],
    );

    test('toUpdateJson uses serverId and excludes items', () {
      final report = baseReport.copyWith(serverId: 'remote-r1', rowVersion: 'vr1');
      final json = DamageReportSyncDto.toUpdateJson(report);

      expect(json['id'], 'remote-r1');
      expect(json['rowVersion'], 'vr1');
      expect(json.containsKey('items'), isFalse);
    });

    test('itemToUpdateJson uses serverId', () {
      final item = baseReport.items.first.copyWith(serverId: 'remote-i1', rowVersion: 'vi1');
      final json = DamageReportSyncDto.itemToUpdateJson(item);

      expect(json['id'], 'remote-i1');
      expect(json['rowVersion'], 'vi1');
    });
  });
}
