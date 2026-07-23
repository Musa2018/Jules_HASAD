import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/farms/domain/farm.dart';

class FarmValidator {
  static List<String> validate(Farm farm, {AuthSession? session}) {
    final errors = <String>[];

    if (farm.localFarmName.isEmpty) {
      errors.add('Local Farm Name is required.');
    }

    if (farm.farmerId.isEmpty) {
      errors.add('Farmer is required.');
    }

    // Ownership: If OwnershipType is not "ملك" (Owned, usually ID 1)
    if (farm.ownershipTypeId != 1) {
      if (farm.ownerFarmerId == null || farm.ownerFarmerId!.isEmpty) {
        errors.add('Owner Farmer is required when ownership type is not Owned (ملك).');
      }
      if (farm.relationshipToOwnerId == null) {
        errors.add('Relationship to Owner is required when ownership type is not Owned (ملك).');
      }
    }

    // Geography
    if (farm.governorateId.isEmpty) {
      errors.add('Governorate is required.');
    }
    if (farm.directorateId.isEmpty) {
      errors.add('Directorate is required.');
    }
    if (farm.localityId.isEmpty) {
      errors.add('Locality is required.');
    }

    if (farm.area <= 0) {
      errors.add('Farm Area must be greater than 0.');
    }

    // User Scope Validation
    if (session != null) {
      final isEngineer = session.roles.contains('AgriculturalEngineer');
      final isSurveyor = session.roles.contains('FieldSurveyor');
      final isDirector = session.roles.contains('Director');

      if (isEngineer || isSurveyor) {
        if (session.directorateId != null && farm.directorateId != session.directorateId) {
          errors.add('Access Denied: You can only manage farms within your assigned directorate.');
        }
      } else if (isDirector) {
        if (session.governorateId != null && farm.governorateId != session.governorateId) {
          errors.add('Access Denied: You can only manage farms within your assigned governorate.');
        }
      }
    }

    return errors;
  }
}
