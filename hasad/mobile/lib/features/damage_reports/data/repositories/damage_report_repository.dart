import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';

abstract class DamageReportRepository {
  Future<List<DamageReport>> getDamageReportsByFarm(String farmId);
  Future<DamageReport> getDamageReport(String id);
  Future<DamageReport> createDamageReport(DamageReport report);
  Future<DamageReport> updateDamageReport(DamageReport report);
  Future<void> deleteDamageReport(String id);

  Future<DamageItem> addDamageItem(DamageItem item);
  Future<DamageItem> updateDamageItem(DamageItem item);
  Future<void> deleteDamageItem(String id);
}
