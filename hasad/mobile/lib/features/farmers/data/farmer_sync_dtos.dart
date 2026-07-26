import 'package:intl/intl.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';

class FarmerSyncDto {
  static Map<String, dynamic> toCreateJson(Farmer farmer) {
    if (farmer.gender == Gender.unspecified) {
      throw SyncValidationException(['Gender must be Male or Female.']);
    }

    return {
      'clientId': farmer.id,
      'idTypeId': farmer.idTypeId,
      'idNumber': farmer.idNumber,
      'firstNameAr': farmer.firstNameAr,
      'fatherNameAr': farmer.fatherNameAr,
      'grandfatherNameAr': farmer.grandfatherNameAr,
      'familyNameAr': farmer.familyNameAr,
      'firstNameEn': farmer.firstNameEn,
      'fatherNameEn': farmer.fatherNameEn,
      'grandfatherNameEn': farmer.grandfatherNameEn,
      'familyNameEn': farmer.familyNameEn,
      'birthDate': DateFormat('yyyy-MM-dd').format(farmer.birthDate),
      'gender': farmer.gender.index,
      'phoneNumber': farmer.phoneNumber,
      'familySize': farmer.familySize,
      'governorateId': farmer.governorateId,
      'localityId': farmer.localityId,
      'address': farmer.address,
    };
  }

  static Map<String, dynamic> toUpdateJson(Farmer farmer) {
    if (farmer.gender == Gender.unspecified) {
      throw SyncValidationException(['Gender must be Male or Female.']);
    }
    if (farmer.serverId == null) {
      throw ArgumentError('ServerId is required for update synchronization.');
    }

    return {
      'id': farmer.serverId,
      'clientId': farmer.id,
      'idTypeId': farmer.idTypeId,
      'idNumber': farmer.idNumber,
      'firstNameAr': farmer.firstNameAr,
      'fatherNameAr': farmer.fatherNameAr,
      'grandfatherNameAr': farmer.grandfatherNameAr,
      'familyNameAr': farmer.familyNameAr,
      'firstNameEn': farmer.firstNameEn,
      'fatherNameEn': farmer.fatherNameEn,
      'grandfatherNameEn': farmer.grandfatherNameEn,
      'familyNameEn': farmer.familyNameEn,
      'birthDate': DateFormat('yyyy-MM-dd').format(farmer.birthDate),
      'gender': farmer.gender.index,
      'phoneNumber': farmer.phoneNumber,
      'familySize': farmer.familySize,
      'governorateId': farmer.governorateId,
      'localityId': farmer.localityId,
      'address': farmer.address,
      'rowVersion': farmer.rowVersion,
    };
  }
}
