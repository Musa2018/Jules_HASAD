import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';

class DamageReportSyncDto {
  static Map<String, dynamic> toCreateJson(DamageReport report) {
    return {
      'clientId': report.id,
      'temporaryFormNumber': report.temporaryFormNumber,
      'damageYear': report.damageYear,
      'farmId': report.farmId,
      'farmerId': report.farmerId,
      'damageDate': report.damageDate.toIso8601String(),
      'damageCauseCategoryId': report.damageCauseCategoryId,
      'damageCauseId': report.damageCauseId,
      'settlementName': report.settlementName,
      'companyName': report.companyName,
      'governorateId': report.governorateId,
      'directorateId': report.directorateId,
      'localityId': report.localityId,
      'latitude': report.latitude,
      'longitude': report.longitude,
      'notes': report.notes,
      'items': report.items.map((i) => itemToCreateJson(i)).toList(),
    };
  }

  static Map<String, dynamic> toUpdateJson(DamageReport report) {
    if (report.serverId == null) {
      throw ArgumentError('ServerId is required for update synchronization.');
    }
    return {
      'id': report.serverId,
      'damageDate': report.damageDate.toIso8601String(),
      'damageCauseCategoryId': report.damageCauseCategoryId,
      'damageCauseId': report.damageCauseId,
      'settlementName': report.settlementName,
      'companyName': report.companyName,
      'governorateId': report.governorateId,
      'directorateId': report.directorateId,
      'localityId': report.localityId,
      'latitude': report.latitude,
      'longitude': report.longitude,
      'notes': report.notes,
      'rowVersion': report.rowVersion,
    };
  }

  static Map<String, dynamic> itemToCreateJson(DamageItem item) {
    return {
      'clientId': item.id,
      'classificationId': item.classificationId,
      'costingSheetId': item.costingSheetId,
      'calculatedUnitPrice': item.calculatedUnitPrice,
      'measurementUnitSnapshot': item.measurementUnitSnapshot,
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
      'classificationId': item.classificationId,
      'costingSheetId': item.costingSheetId,
      'calculatedUnitPrice': item.calculatedUnitPrice,
      'measurementUnitSnapshot': item.measurementUnitSnapshot,
      'affectedArea': item.affectedArea,
      'damagePercentage': item.damagePercentage,
      'quantity': item.quantity,
      'estimatedLoss': item.estimatedLoss,
      'rowVersion': item.rowVersion,
    };
  }
}
