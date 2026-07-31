// ignore_for_file: deprecated_member_use_from_same_package
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart' as item_domain;
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart' as report_domain;
import 'package:mobile/features/damage_reports/domain/models/damage_workflow_history.dart' as domain_history;
import 'package:uuid/uuid.dart';

class OfflineFirstDamageReportRepository implements DamageReportRepository {
  final AppDatabase _db;
  final Ref _ref;
  final AuthSession? _session;
  final DamageReportRepository _remoteRepository;

  OfflineFirstDamageReportRepository(this._db, this._ref, this._session, this._remoteRepository);

  BackgroundSyncService get _syncService => _ref.read(syncServiceProvider);

  @override
  Future<List<report_domain.DamageReport>> getDamageReports() async {
    final query = _db.select(_db.damageReports)
      ..where((t) => t.isPendingDelete.equals(false));

    // Regional scoping based on session
    if (_session != null) {
      if (_session.directorateId != null && _session.directorateId!.isNotEmpty) {
        query.where((t) => t.directorateId.equals(_session.directorateId!));
      } else if (_session.governorateId != null && _session.governorateId!.isNotEmpty) {
        query.where((t) => t.governorateId.equals(_session.governorateId!));
      }
    }

    query.orderBy([(t) => OrderingTerm.desc(t.damageDate)]);

    final reports = await query.get();

    List<report_domain.DamageReport> results = [];
    for (var r in reports) {
      final items = await (_db.select(_db.damageItems)
            ..where((t) => t.damageReportId.equals(r.id)))
          .get();
      results.add(_mapToDomain(r, items));
    }
    return results;
  }

  @override
  Stream<List<report_domain.DamageReport>> watchDamageReports() {
    final query = _db.select(_db.damageReports)
      ..where((t) => t.isPendingDelete.equals(false));

    // Regional scoping based on session
    if (_session != null) {
      if (_session.directorateId != null && _session.directorateId!.isNotEmpty) {
        query.where((t) => t.directorateId.equals(_session.directorateId!));
      } else if (_session.governorateId != null && _session.governorateId!.isNotEmpty) {
        query.where((t) => t.governorateId.equals(_session.governorateId!));
      }
    }

    query.orderBy([(t) => OrderingTerm.desc(t.damageDate)]);

    return query.watch().asyncMap((reports) async {
      List<report_domain.DamageReport> results = [];
      for (var r in reports) {
        final items = await (_db.select(_db.damageItems)
              ..where((t) => t.damageReportId.equals(r.id)))
            .get();
        results.add(_mapToDomain(r, items));
      }
      return results;
    });
  }

  @override
  Future<List<report_domain.DamageReport>> getDamageReportsByFarm(
    String farmId,
  ) async {
    final reports =
        await (_db.select(_db.damageReports)
              ..where((t) => t.farmId.equals(farmId) & t.isPendingDelete.equals(false))
              ..orderBy([(t) => OrderingTerm.desc(t.damageDate)]))
            .get();

    List<report_domain.DamageReport> results = [];
    for (var r in reports) {
      final items = await (_db.select(
        _db.damageItems,
      )..where((t) => t.damageReportId.equals(r.id))).get();

      results.add(_mapToDomain(r, items));
    }
    return results;
  }

  @override
  Stream<List<report_domain.DamageReport>> watchDamageReportsByFarm(String farmId) {
    final query = _db.select(_db.damageReports)
      ..where((t) => t.farmId.equals(farmId) & t.isPendingDelete.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.damageDate)]);

    return query.watch().asyncMap((reports) async {
      List<report_domain.DamageReport> results = [];
      for (var r in reports) {
        final items = await (_db.select(_db.damageItems)
              ..where((t) => t.damageReportId.equals(r.id)))
            .get();
        results.add(_mapToDomain(r, items));
      }
      return results;
    });
  }

  @override
  Future<report_domain.DamageReport> getDamageReport(String id) async {
    final r = await (_db.select(
      _db.damageReports,
    )..where((t) => t.id.equals(id))).getSingle();
    final items = await (_db.select(
      _db.damageItems,
    )..where((t) => t.damageReportId.equals(r.id))).get();

    return _mapToDomain(r, items);
  }

  report_domain.DamageReport _mapToDomain(DamageReportLocal r, List<DamageItemLocal> items) {
    return report_domain.DamageReport(
      id: r.id,
      serverId: r.serverId ?? '',
      reportNumber: r.reportNumber,
      permanentFormNumber: r.permanentFormNumber,
      temporaryFormNumber: r.temporaryFormNumber,
      damageYear: r.damageYear,
      farmId: r.farmId,
      farmerId: r.farmerId,
      damageDate: r.damageDate,
      documentationDate: r.documentationDate,
      agriculturalSectorId: r.agriculturalSectorId,
      damageCauseCategoryId: r.damageCauseCategoryId,
      damageCauseId: r.damageCauseId,
      governorateId: r.governorateId,
      directorateId: r.directorateId,
      localityId: r.localityId,
      statusId: r.statusId,
      notes: r.notes,
      createdBy: r.createdBy,
      rowVersion: r.rowVersion,
      syncStatus: r.syncStatus,
      lastSyncError: r.lastSyncError,
      items: items
          .map(
            (i) => item_domain.DamageItem(
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

  DamageReportsCompanion _mapReportToCompanion(report_domain.DamageReport report) {
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
      governorateId: Value(report.governorateId),
      directorateId: Value(report.directorateId),
      localityId: Value(report.localityId),
      statusId: report.statusId,
      notes: report.notes,
      createdBy: Value(report.createdBy),
      rowVersion: Value(report.rowVersion),
      lastSyncError: Value(report.lastSyncError),
    );
  }

  DamageItemsCompanion _mapItemToCompanion(item_domain.DamageItem item) {
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
  Future<report_domain.DamageReport> createDamageReport(
    report_domain.DamageReport report,
  ) async {
    // 1. Duplicate check (Local)
    final normalizedDate = DateTime(report.damageDate.year, report.damageDate.month, report.damageDate.day);
    
    final existing = await (_db.select(_db.damageReports)
          ..where((t) => t.farmId.equals(report.farmId) & 
                         t.damageDate.equals(normalizedDate) &
                         t.isPendingDelete.equals(false)))
        .getSingleOrNull();
    
    if (existing != null) {
      throw Exception('CONFLICT: A damage report already exists for this farm on ${DateFormat('yyyy-MM-dd').format(normalizedDate)}.');
    }

    // 2. Fetch Farm for denormalization snapshot
    final farm = await (_db.select(_db.farms)
          ..where((t) => t.id.equals(report.farmId)))
        .getSingleOrNull();

    if (farm == null) {
      throw Exception('Parent farm not found locally. Cannot create damage report header.');
    }

    final localId = report.id.isEmpty ? const Uuid().v4() : report.id;
    final tempNumber = _generateTemporaryNumber();

    final finalReport = report.copyWith(
      id: localId,
      temporaryFormNumber: tempNumber,
      documentationDate: DateTime.now(),
      damageDate: normalizedDate,
      // Snapshots
      farmerId: farm.farmerId,
      governorateId: farm.governorateId,
      directorateId: farm.directorateId,
      localityId: farm.localityId,
      agriculturalSectorId: farm.agriculturalSectorId,
      damageYear: normalizedDate.year,
      createdBy: _session?.userId ?? 'System',
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

  @override
  Future<report_domain.DamageReport> createDamageReportFromJson(Map<String, dynamic> json) async {
     return createDamageReport(report_domain.DamageReport.fromJson(json));
  }

  String _generateTemporaryNumber() {
    final date = DateFormat('yyyyMMdd').format(DateTime.now());
    final random = Random().nextInt(10000).toString().padLeft(4, '0');
    return 'TEMP-$date-$random';
  }

  @override
  Future<report_domain.DamageReport> updateDamageReport(
    report_domain.DamageReport report,
  ) async {
    final normalizedDate = DateTime(report.damageDate.year, report.damageDate.month, report.damageDate.day);

    // Duplicate check on update
    final existing = await (_db.select(_db.damageReports)
          ..where((t) => t.id.equals(report.id).not() &
                         t.farmId.equals(report.farmId) & 
                         t.damageDate.equals(normalizedDate) &
                         t.isPendingDelete.equals(false)))
        .getSingleOrNull();
    
    if (existing != null) {
      throw Exception('CONFLICT: A damage report already exists for this farm on ${DateFormat('yyyy-MM-dd').format(normalizedDate)}.');
    }

    final finalReport = report.copyWith(damageDate: normalizedDate, damageYear: normalizedDate.year);

    await (_db.update(
      _db.damageReports,
    )..where((t) => t.id.equals(report.id))).write(
      _mapReportToCompanion(finalReport).copyWith(
        syncStatus: const Value('pending'),
        lastSyncError: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _syncService.addToQueue(
      localId: report.id,
      entityType: 'damage_report',
      operation: 'update',
      data: finalReport.toJson(),
    );

    return finalReport;
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
  Future<void> cancelDeleteDamageReport(String id) async {
    await (_db.update(_db.damageReports)..where((t) => t.id.equals(id))).write(
      const DamageReportsCompanion(
        isPendingDelete: Value(false),
        syncStatus: Value('completed'),
        lastSyncError: Value(null),
      ),
    );

    await (_db.delete(_db.syncQueue)
          ..where((t) =>
              t.localId.equals(id) &
              t.entityType.equals('damage_report') &
              t.operation.equals('delete')))
        .go();
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
  Future<item_domain.DamageItem> addDamageItem(item_domain.DamageItem item) async {
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
  Future<item_domain.DamageItem> updateDamageItem(item_domain.DamageItem item) async {
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

  @override
  Future<void> synchronize() async {
    // 1. Fetch from remote
    try {
      final remoteReports = await _remoteRepository.getDamageReports();

      await _db.transaction(() async {
        for (final remote in remoteReports) {
          final local = await (_db.select(_db.damageReports)
                ..where((t) => t.id.equals(remote.id)))
              .getSingleOrNull();

          if (local != null) {
            final isProtected = local.syncStatus == 'pending' ||
                local.syncStatus == 'syncing' ||
                local.syncStatus == 'conflict' ||
                local.isPendingDelete;

            if (isProtected) continue;
          }

          // Update header
          await _db.into(_db.damageReports).insertOnConflictUpdate(
                _mapReportToCompanion(remote).copyWith(
                  syncStatus: const Value('completed'),
                ),
              );

          // Update items
          for (final item in remote.items) {
            await _db.into(_db.damageItems).insertOnConflictUpdate(
                  _mapItemToCompanion(item).copyWith(
                    syncStatus: const Value('completed'),
                  ),
                );
          }
        }
      });
    } catch (e) {
      // Log or handle error
    }
  }
}
