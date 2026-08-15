import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_workflow_history.dart';

abstract class DamageReportRepository {
  Future<List<DamageReport>> getDamageReports();
  Stream<List<DamageReport>> watchDamageReports();
  Future<List<DamageReport>> getDamageReportsByFarm(String farmId);
  Stream<List<DamageReport>> watchDamageReportsByFarm(String farmId);
  Future<DamageReport> getDamageReport(String id);
  Future<DamageReport> createDamageReport(DamageReport report);
  Future<DamageReport> createDamageReportFromJson(Map<String, dynamic> json);
  Future<DamageReport> updateDamageReport(DamageReport report);
  Future<void> deleteDamageReport(String id);
  Future<void> cancelDeleteDamageReport(String id);

  Future<void> submitReport(String id);
  Future<void> transitionReport(String id, String toStatus, {String? comment, bool isOverride});
  Future<List<DamageWorkflowHistory>> getReportHistory(String id);
  Stream<List<DamageWorkflowHistory>> watchReportHistory(String id);
  Future<void> syncWorkflowHistory(String localId, String serverId);

  Future<DamageItem> addDamageItem(DamageItem item);
  Future<DamageItem> updateDamageItem(DamageItem item);
  Future<void> deleteDamageItem(String id);
  Future<void> retrySync(String id);
  Future<void> retryAllFailedSyncs();
  Future<void> synchronize({DateTime? updatedSince});
  Future<void> refreshReport(String id);
}
