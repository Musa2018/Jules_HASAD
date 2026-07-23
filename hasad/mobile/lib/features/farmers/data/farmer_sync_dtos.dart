import 'package:intl/intl.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/features/farmers/domain/damage_item.dart';
import 'package:mobile/features/farmers/domain/damage_report.dart';
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

class DamageReportSyncDto {
  static Map<String, dynamic> toCreateJson(DamageReport report) {
    return {
      'clientId': report.id,
      'farmId': report.farmId,
      'farmerId': report.farmerId,
      'damageDate': report.damageDate.toIso8601String(),
      'governorateId': report.governorateId,
      'localityId': report.localityId,
      'latitude': report.latitude,
      'longitude': report.longitude,
      'notes': report.notes,
      'items': report.items.map((i) => _itemToCreateJson(i)).toList(),
    };
  }

  static Map<String, dynamic> toUpdateJson(DamageReport report) {
    if (report.serverId == null) {
      throw ArgumentError('ServerId is required for update synchronization.');
    }
    return {
      'id': report.serverId,
      'damageDate': report.damageDate.toIso8601String(),
      'governorateId': report.governorateId,
      'localityId': report.localityId,
      'latitude': report.latitude,
      'longitude': report.longitude,
      'notes': report.notes,
      'rowVersion': report.rowVersion,
    };
  }

  static Map<String, dynamic> _itemToCreateJson(DamageItem item) {
    return {
      'clientId': item.id,
      'agriculturalSectorId': item.agriculturalSectorId,
      'subSectorId': item.subSectorId,
      'cropId': item.cropId,
      'damageTypeId': item.damageTypeId,
      'affectedArea': item.affectedArea,
      'damagePercentage': item.damagePercentage,
      'quantity': item.quantity,
      'estimatedLoss': item.estimatedLoss,
    };
  }

  static Map<String, dynamic> itemToCreateJson(DamageItem item) {
    return {
      'clientId': item.id,
      'agriculturalSectorId': item.agriculturalSectorId,
      'subSectorId': item.subSectorId,
      'cropId': item.cropId,
      'damageTypeId': item.damageTypeId,
      'affectedArea': item.affectedArea,
      'damagePercentage': item.damagePercentage,
      'quantity': item.quantity,
      'estimatedLoss': item.estimatedLoss,
    };
  }

  static Map<String, dynamic> itemToUpdateJson(DamageItem item) {
    if (item.serverId == null) {
      throw ArgumentError('ServerId is required for update synchronization.');
    }
    return {
      'id': item.serverId,
      'agriculturalSectorId': item.agriculturalSectorId,
      'subSectorId': item.subSectorId,
      'cropId': item.cropId,
      'damageTypeId': item.damageTypeId,
      'affectedArea': item.affectedArea,
      'damagePercentage': item.damagePercentage,
      'quantity': item.quantity,
      'estimatedLoss': item.estimatedLoss,
      'rowVersion': item.rowVersion,
    };
  }
}
