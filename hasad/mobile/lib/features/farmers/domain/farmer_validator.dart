import 'package:mobile/core/utils/validators.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';

class FarmerValidator {
  static List<String> validate(Farmer farmer) {
    final errors = <String>[];

    if (farmer.idTypeId <= 0) {
      errors.add('IdType is required.');
    }

    if (!Validators.isAtLeast18(farmer.birthDate)) {
      errors.add('Farmer must be at least 18 years old.');
    }

    if (farmer.gender == Gender.unspecified) {
      errors.add('Gender must be Male or Female.');
    }

    if (farmer.familySize < 1) {
      errors.add('Family Size must be at least 1.');
    }

    return errors;
  }
}
