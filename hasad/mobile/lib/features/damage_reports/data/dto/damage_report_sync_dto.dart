// ignore_for_file: deprecated_member_use_from_same_package
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';

class DamageReportSyncDto {
  static String? _guidOrNull(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed == 'null') return null;
    return trimmed;
  }

  static Map<String, dynamic> toCreateJson(DamageReport report, {double? latitude, double? longitude}) {
    return {
      'clientId': report.id,
      'temporaryFormNumber': report.temporaryFormNumber,
      'damageYear': report.damageYear,
      'farmId': _guidOrNull(report.farmId),
      'farmerId': _guidOrNull(report.farmerId),
      'damageDate': (report.damageDate ?? DateTime.now()).toIso8601String(),
      'agriculturalSectorId': report.agriculturalSectorId,
      'damageCauseCategoryId': report.damageCauseCategoryId,
      'damageCauseId': report.damageCauseId,
      'governorateId': _guidOrNull(report.governorateId),
      'directorateId': _guidOrNull(report.directorateId),
      'localityId': _guidOrNull(report.localityId),
      'latitude': latitude,
      'longitude': longitude,
      'notes': report.notes,
      'items': report.items.isEmpty ? null : report.items.map((i) => itemToCreateJson(i)).toList(),
    };
  }

  static Map<String, dynamic> toUpdateJson(DamageReport report) {
    if (report.serverId == null) {
      throw ArgumentError('ServerId is required for update synchronization.');
    }
    return {
      'id': report.serverId,
      'damageDate': (report.damageDate ?? DateTime.now()).toIso8601String(),
      'agriculturalSectorId': report.agriculturalSectorId,
      'damageCauseCategoryId': report.damageCauseCategoryId,
      'damageCauseId': report.damageCauseId,
      'notes': report.notes,
      'rowVersion': report.rowVersion,
    };
  }

  static Map<String, dynamic> itemToCreateJson(DamageItem item) {
    final costingId = _guidOrNull(item.costingSheetItemId ?? item.costingSheetId);
    return {
      'clientId': item.id,
      'damageNatureId': item.damageNatureId,
      'damageActionId': item.damageActionId,
      'classificationId': item.classificationId,
      'costingSheetId': costingId,
      'calculatedUnitPrice': item.calculatedUnitPrice > 0 ? item.calculatedUnitPrice : 0.01, // Avoid validation error if backend recalculates
      'measurementUnitSnapshot': item.measurementUnitSnapshot.isNotEmpty ? item.measurementUnitSnapshot : 'Unit',
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
      'damageNatureId': item.damageNatureId,
      'damageActionId': item.damageActionId,
      'classificationId': item.classificationId,
      'costingSheetId': _guidOrNull(item.costingSheetItemId ?? item.costingSheetId),
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
