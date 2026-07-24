import 'dart:math';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart' as domain;
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart' as domain;
import 'package:mobile/features/damage_reports/domain/models/damage_workflow_history.dart' as domain_history;
import 'package:uuid/uuid.dart';

class OfflineFirstDamageReportRepository implements DamageReportRepository {
  final AppDatabase _db;
  final BackgroundSyncService _syncService;

  OfflineFirstDamageReportRepository(this._db, this._syncService);

  @override
  Future<List<domain.DamageReport>> getDamageReportsByFarm(
    String farmId,
  ) async {
    final reports =
        await (_db.select(_db.damageReports)
              ..where((t) => t.farmId.equals(farmId) & t.isPendingDelete.equals(false))
              ..orderBy([(t) => OrderingTerm.desc(t.damageDate)]))
            .get();

    List<domain.DamageReport> results = [];
    for (var r in reports) {
      final items = await (_db.select(
        _db.damageItems,
      )..where((t) => t.damageReportId.equals(r.id))).get();

      results.add(_mapToDomain(r, items));
    }
    return results;
  }

  @override
  Future<domain.DamageReport> getDamageReport(String id) async {
    final r = await (_db.select(
      _db.damageReports,
    )..where((t) => t.id.equals(id))).getSingle();
    final items = await (_db.select(
      _db.damageItems,
    )..where((t) => t.damageReportId.equals(r.id))).get();

    return _mapToDomain(r, items);
  }

  domain.DamageReport _mapToDomain(DamageReportLocal r, List<DamageItemLocal> items) {
    return domain.DamageReport(
      id: r.id,
      serverId: r.serverId ?? '',
      reportNumber: r.reportNumber,
      permanentFormNumber: r.permanentFormNumber,
      temporaryFormNumber: r.temporaryFormNumber,
      farmId: r.farmId,
      damageDate: r.damageDate,
      documentationDate: r.documentationDate,
      agriculturalSectorId: r.agriculturalSectorId,
      damageCauseCategoryId: r.damageCauseCategoryId,
      damageCauseId: r.damageCauseId,
      settlementName: r.settlementName,
      companyName: r.companyName,
      statusId: r.statusId,
      notes: r.notes,
      rowVersion: r.rowVersion,
      syncStatus: r.syncStatus,
      lastSyncError: r.lastSyncError,
      items: items
          .map(
            (i) => domain.DamageItem(
              id: i.id,
              serverId: i.serverId,
              damageReportId: i.damageReportId,
              damageNatureId: i.damageNatureId,
              damageActionId: i.damageActionId,
              classificationId: i.classificationId,
              costingSheetId: i.costingSheetId,
              costingSheetItemId: i.costingSheetItemId,
              calculatedUnitPrice: i.calculatedUnitPrice,
              measurementUnitSnapshot: i.measurementUnitSnapshot,
              affectedArea: i.affectedArea,
              damagePercentage: i.damagePercentage,
              quantity: i.quantity,
              estimatedLoss: i.estimatedLoss,
              rowVersion: i.rowVersion,
              syncStatus: i.syncStatus,
              lastSyncError: i.lastSyncError,
            ),
          )
          .toList(),
    );
  }

  DamageReportsCompanion _mapReportToCompanion(domain.DamageReport report) {
    return DamageReportsCompanion.insert(
      id: report.id,
      serverId: Value(report.serverId),
      permanentFormNumber: Value(report.permanentFormNumber),
      temporaryFormNumber: Value(report.temporaryFormNumber),
      reportNumber: Value(report.reportNumber),
      farmId: report.farmId,
      farmerId: Value(report.farmerId),
      damageYear: Value(report.damageYear),
      damageDate: report.damageDate,
      documentationDate: report.documentationDate,
      agriculturalSectorId: Value(report.agriculturalSectorId),
      damageCauseCategoryId: Value(report.damageCauseCategoryId),
      damageCauseId: Value(report.damageCauseId),
      settlementName: Value(report.settlementName),
      companyName: Value(report.companyName),
      governorateId: Value(report.governorateId),
      directorateId: Value(report.directorateId),
      localityId: Value(report.localityId),
      latitude: Value(report.latitude),
      longitude: Value(report.longitude),
      statusId: report.statusId,
      notes: report.notes,
      rowVersion: Value(report.rowVersion),
      lastSyncError: Value(report.lastSyncError),
    );
  }

  DamageItemsCompanion _mapItemToCompanion(domain.DamageItem item) {
    return DamageItemsCompanion.insert(
      id: item.id,
      serverId: Value(item.serverId),
      damageReportId: item.damageReportId,
      damageNatureId: Value(item.damageNatureId),
      damageActionId: Value(item.damageActionId),
      classificationId: Value(item.classificationId),
      costingSheetId: Value(item.costingSheetId),
      costingSheetItemId: Value(item.costingSheetItemId),
      calculatedUnitPrice: Value(item.calculatedUnitPrice),
      measurementUnitSnapshot: Value(item.measurementUnitSnapshot),
      affectedArea: item.affectedArea,
      damagePercentage: item.damagePercentage,
      quantity: item.quantity,
      estimatedLoss: item.estimatedLoss,
      rowVersion: Value(item.rowVersion),
      lastSyncError: Value(item.lastSyncError),
    );
  }

  @override
  Future<domain.DamageReport> createDamageReport(
    domain.DamageReport report,
  ) async {
    // 1. Duplicate check (Local)
    final existing = await (_db.select(_db.damageReports)
          ..where((t) => t.farmId.equals(report.farmId) & 
                         t.damageDate.equals(report.damageDate) &
                         t.isPendingDelete.equals(false)))
        .getSingleOrNull();
    
    if (existing != null) {
      throw Exception('A damage report already exists for this farm and date.');
    }

    final localId = report.id.isEmpty ? const Uuid().v4() : report.id;
    final tempNumber = _generateTemporaryNumber();

    final finalReport = report.copyWith(
      id: localId,
      temporaryFormNumber: tempNumber,
      documentationDate: DateTime.now(),
    );

    await _db.transaction(() async {
      await _db
          .into(_db.damageReports)
          .insert(
            _mapReportToCompanion(finalReport).copyWith(
              id: Value(localId),
              syncStatus: const Value('pending'),
            ),
          );

      for (var item in report.items) {
        final itemId = item.id.isEmpty ? const Uuid().v4() : item.id;
        await _db
            .into(_db.damageItems)
            .insert(
              _mapItemToCompanion(item).copyWith(
                id: Value(itemId),
                damageReportId: Value(localId),
                syncStatus: const Value('pending'),
              ),
            );
      }
    });

    final createdReport = finalReport.copyWith(
      items: report.items
          .map((e) => e.copyWith(damageReportId: localId))
          .toList(),
    );

    await _syncService.addToQueue(
      localId: localId,
      entityType: 'damage_report',
      operation: 'create',
      data: createdReport.toJson(),
    );

    return createdReport;
  }

  String _generateTemporaryNumber() {
    final date = DateFormat('yyyyMMdd').format(DateTime.now());
    final random = Random().nextInt(10000).toString().padLeft(4, '0');
    return 'TEMP-$date-$random';
  }

  @override
  Future<domain.DamageReport> updateDamageReport(
    domain.DamageReport report,
  ) async {
    // Duplicate check on update
    final existing = await (_db.select(_db.damageReports)
          ..where((t) => t.id.equals(report.id).not() &
                         t.farmId.equals(report.farmId) & 
                         t.damageDate.equals(report.damageDate) &
                         t.isPendingDelete.equals(false)))
        .getSingleOrNull();
    
    if (existing != null) {
      throw Exception('A damage report already exists for this farm and date.');
    }

    await (_db.update(
      _db.damageReports,
    )..where((t) => t.id.equals(report.id))).write(
      _mapReportToCompanion(report).copyWith(
        syncStatus: const Value('pending'),
        lastSyncError: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _syncService.addToQueue(
      localId: report.id,
      entityType: 'damage_report',
      operation: 'update',
      data: report.toJson(),
    );

    return report;
  }

  @override
  Future<void> deleteDamageReport(String id) async {
    final local = await (_db.select(_db.damageReports)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (local == null) return;

    await (_db.update(_db.damageReports)..where((t) => t.id.equals(id))).write(
      const DamageReportsCompanion(
        isPendingDelete: Value(true),
        syncStatus: Value('pending'),
      ),
    );

    await _syncService.addToQueue(
      localId: id,
      entityType: 'damage_report',
      operation: 'delete',
      data: {
        'id': local.serverId ?? local.id,
        'serverId': local.serverId,
        'clientId': local.id,
      },
    );
  }

  @override
  Future<void> submitReport(String id) async {
    final report = await getDamageReport(id);
    // Locally predict state
    await (_db.update(_db.damageReports)..where((t) => t.id.equals(id))).write(
      const DamageReportsCompanion(
        statusId: Value('Submitted'),
        syncStatus: Value('pending'),
      ),
    );

    await _syncService.addToQueue(
      localId: id,
      entityType: 'damage_report',
      operation: 'workflow_action',
      data: {
        'id': report.serverId ?? report.id,
        'action': 'submit',
      },
    );
  }

  @override
  Future<void> transitionReport(String id, String toStatus,
      {String? comment, bool isOverride = false}) async {
    final report = await getDamageReport(id);

    // Locally predict state
    await (_db.update(_db.damageReports)..where((t) => t.id.equals(id))).write(
      DamageReportsCompanion(
        statusId: Value(toStatus),
        syncStatus: const Value('pending'),
      ),
    );

    await _syncService.addToQueue(
      localId: id,
      entityType: 'damage_report',
      operation: 'workflow_action',
      data: {
        'id': report.serverId ?? report.id,
        'action': 'transition',
        'toStatus': toStatus,
        'comment': comment,
        'isOverride': isOverride,
      },
    );
  }

  @override
  Future<List<domain_history.DamageWorkflowHistory>> getReportHistory(
      String id) async {
    // Fetch from local DB
    final histories = await (_db.select(_db.damageWorkflowHistories)
          ..where((t) => t.damageReportId.equals(id))
          ..orderBy([(t) => OrderingTerm.desc(t.changedAt)]))
        .get();

    return histories
        .map((h) => domain_history.DamageWorkflowHistory(
              id: h.id,
              serverId: h.serverId,
              damageReportId: h.damageReportId,
              fromStatus: h.fromStatus,
              toStatus: h.toStatus,
              changedByUserId: h.changedByUserId,
              changedAt: h.changedAt,
              comment: h.comment,
              isOverride: h.isOverride,
            ))
        .toList();
  }

  @override
  Future<domain.DamageItem> addDamageItem(domain.DamageItem item) async {
    final localId = item.id.isEmpty ? const Uuid().v4() : item.id;
    await _db
        .into(_db.damageItems)
        .insert(
          _mapItemToCompanion(item).copyWith(
            id: Value(localId),
            syncStatus: const Value('pending'),
          ),
        );

    final createdItem = item.copyWith(id: localId);

    await _syncService.addToQueue(
      localId: localId,
      entityType: 'damage_item',
      operation: 'create',
      data: createdItem.toJson(),
    );

    return createdItem;
  }

  @override
  Future<domain.DamageItem> updateDamageItem(domain.DamageItem item) async {
    await (_db.update(
      _db.damageItems,
    )..where((t) => t.id.equals(item.id))).write(
      _mapItemToCompanion(item).copyWith(
        syncStatus: const Value('pending'),
        lastSyncError: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _syncService.addToQueue(
      localId: item.id,
      entityType: 'damage_item',
      operation: 'update',
      data: item.toJson(),
    );

    return item;
  }

  @override
  Future<void> deleteDamageItem(String id) async {
    final local = await (_db.select(_db.damageItems)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (local == null) return;

    await (_db.update(_db.damageItems)..where((t) => t.id.equals(id))).write(
      const DamageItemsCompanion(
        isPendingDelete: Value(true),
        syncStatus: Value('pending'),
      ),
    );

    await _syncService.addToQueue(
      localId: id,
      entityType: 'damage_item',
      operation: 'delete',
      data: {
        'id': local.serverId ?? local.id,
        'serverId': local.serverId,
        'clientId': local.id,
      },
    );
  }
}
