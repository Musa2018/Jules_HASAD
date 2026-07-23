import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/domain/farm_validator.dart';

void main() {
  group('FarmValidator', () {
    final baseFarm = Farm(
      id: '1',
      farmerId: 'f1',
      localFarmName: 'Test Farm',
      ownershipTypeId: 1, // Owned
      governorateId: 'g1',
      directorateId: 'd1',
      localityId: 'l1',
      basin: 'B1',
      parcel: 'P1',
      area: 10.0,
      areaUnitId: 1,
      agriculturalSectorId: 1,
      politicalClassificationId: 1,
    );

    test('validates a correct farm', () {
      final errors = FarmValidator.validate(baseFarm);
      expect(errors, isEmpty);
    });

    test('requires farm name', () {
      final errors = FarmValidator.validate(baseFarm.copyWith(localFarmName: ''));
      expect(errors, contains('Local Farm Name is required.'));
    });

    test('requires OwnerFarmerId and RelationshipToOwnerId if not owned', () {
      final errors = FarmValidator.validate(baseFarm.copyWith(ownershipTypeId: 2, ownerFarmerId: null, relationshipToOwnerId: null));
      expect(errors, contains('Owner Farmer is required when ownership type is not Owned (ملك).'));
      expect(errors, contains('Relationship to Owner is required when ownership type is not Owned (ملك).'));
    });

    test('validates directorate scope for engineers', () {
      const session = AuthSession(
        token: '',
        refreshToken: '',
        userId: 'u1',
        email: 'e',
        fullName: 'Eng',
        directorateId: 'd1',
        roles: ['AgriculturalEngineer'],
      );

      final errors = FarmValidator.validate(baseFarm.copyWith(directorateId: 'd2'), session: session);
      expect(errors, contains('Access Denied: You can only manage farms within your assigned directorate.'));
    });
  });
}
