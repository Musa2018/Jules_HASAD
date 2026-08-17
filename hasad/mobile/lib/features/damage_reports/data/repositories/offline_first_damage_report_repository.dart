import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/utils/debug_logger.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart' as item_domain;
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart' as report_domain;
import 'package:mobile/features/damage_reports/domain/models/damage_report_attachment.dart' as attachment_domain;
import 'package:mobile/features/damage_reports/domain/models/damage_report_status.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_workflow_history.dart' as domain_history;
import 'package:mobile/features/damage_reports/domain/models/audit_log_entry.dart';
import 'package:uuid/uuid.dart';

class OfflineFirstDamageReportRepository implements DamageReportRepository {
  final AppDatabase _db;
  final Ref _ref;
  final AuthSession? _session;
  final DamageReportRepository _remoteRepository;
  final Connectivity _connectivity;

  OfflineFirstDamageReportRepository(this._db, this._ref, this._session, this._remoteRepository, this._connectivity);

  BackgroundSyncService get _syncService => _ref.read(syncServiceProvider);

  @override
  Future<List<report_domain.DamageReport>> getDamageReports({
    int pageNumber = 1,
    int pageSize = 10,
    String? searchText,
    DateTime? updatedSince,
  }) async {
    final query = _db.select(_db.damageReports)
      ..where((t) => t.isPendingDelete.equals(false));

    if (searchText != null && searchText.isNotEmpty) {
      final search = '%$searchText%';
      query.where((t) => t.reportNumber.like(search) | 
                         t.permanentFormNumber.like(search) | 
                         t.temporaryFormNumber.like(search));
    }

    // Regional scoping based on session
    if (_session != null) {
      if (_session.directorateId != null && _session.directorateId!.isNotEmpty) {
        // Use lowercase comparison for GUID stability across platforms
        query.where((t) => t.directorateId.lower().equals(_session.directorateId!.toLowerCase()));
      } else if (_session.governorateId != null && _session.governorateId!.isNotEmpty) {
        query.where((t) => t.governorateId.lower().equals(_session.governorateId!.toLowerCase()));
      }
    }

    query.orderBy([(t) => OrderingTerm.desc(t.damageDate)]);

    final reports = await query.get();

    List<report_domain.DamageReport> results = [];
    for (var r in reports) {
      final items = await (_db.select(_db.damageItems)
        ..where((t) => t.damageReportId.lower().equals(r.id.toLowerCase())))
          .get();
      final attachments = await (_db.select(_db.damageReportAttachments)
        ..where((t) => t.damageReportId.lower().equals(r.id.toLowerCase())))
          .get();
      results.add(_mapToDomain(r, items, attachments));
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
        // Use lowercase comparison for GUID stability across platforms
        query.where((t) => t.directorateId.lower().equals(_session.directorateId!.toLowerCase()));
      } else if (_session.governorateId != null && _session.governorateId!.isNotEmpty) {
        query.where((t) => t.governorateId.lower().equals(_session.governorateId!.toLowerCase()));
      }
    }

    query.orderBy([(t) => OrderingTerm.desc(t.damageDate)]);

    return query.watch().asyncMap((reports) async {
      List<report_domain.DamageReport> results = [];
      for (var r in reports) {
        final items = await (_db.select(_db.damageItems)
          ..where((t) => t.damageReportId.lower().equals(r.id.toLowerCase())))
            .get();
        final attachments = await (_db.select(_db.damageReportAttachments)
          ..where((t) => t.damageReportId.lower().equals(r.id.toLowerCase())))
            .get();
        results.add(_mapToDomain(r, items, attachments));
      }
      return results;
    });
  }

  @override
  Future<List<report_domain.DamageReport>> getDamageReportsByFarm(
      String farmId,
      ) async {
    final query = _db.select(_db.damageReports)
      ..where((t) => t.farmId.lower().equals(farmId.toLowerCase()) & t.isPendingDelete.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.damageDate)]);
    
    final reports = await query.get();

    List<report_domain.DamageReport> results = [];
    for (var r in reports) {
      final items = await (_db.select(
        _db.damageItems,
      )..where((t) => t.damageReportId.lower().equals(r.id.toLowerCase()))).get();
      final attachments = await (_db.select(
        _db.damageReportAttachments,
      )..where((t) => t.damageReportId.lower().equals(r.id.toLowerCase()))).get();

      results.add(_mapToDomain(r, items, attachments));
    }
    return results;
  }

  @override
  Stream<List<report_domain.DamageReport>> watchDamageReportsByFarm(String farmId) {
    final query = _db.select(_db.damageReports)
      ..where((t) => t.farmId.lower().equals(farmId.toLowerCase()) & t.isPendingDelete.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.damageDate)]);

    return query.watch().asyncMap((reports) async {
      List<report_domain.DamageReport> results = [];
      for (var r in reports) {
        final items = await (_db.select(_db.damageItems)
          ..where((t) => t.damageReportId.lower().equals(r.id.toLowerCase())))
            .get();
        final attachments = await (_db.select(_db.damageReportAttachments)
          ..where((t) => t.damageReportId.lower().equals(r.id.toLowerCase())))
            .get();
        results.add(_mapToDomain(r, items, attachments));
      }
      return results;
    });
  }

  @override
  Future<report_domain.DamageReport> getDamageReport(String id) async {
    final r = await (_db.select(
      _db.damageReports,
    )..where((t) => t.id.lower().equals(id.toLowerCase()))).getSingle();
    final items = await (_db.select(
      _db.damageItems,
    )..where((t) => t.damageReportId.lower().equals(r.id.toLowerCase()))).get();
    final attachments = await (_db.select(
      _db.damageReportAttachments,
    )..where((t) => t.damageReportId.lower().equals(r.id.toLowerCase()))).get();

    return _mapToDomain(r, items, attachments);
  }

  report_domain.DamageReport _mapToDomain(DamageReportLocal r, List<DamageItemLocal> items, List<DamageReportAttachmentLocal> attachments) {
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
      totalDamage: r.totalDamage,
      notes: r.notes,
      createdBy: r.createdBy,
      rowVersion: r.rowVersion,
      syncStatus: r.syncStatus,
      lastSyncError: r.lastSyncError,
      updatedAt: r.updatedAt,
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
          updatedAt: i.updatedAt,
        ),
      )
          .toList(),
      attachments: attachments.map((a) => attachment_domain.DamageReportAttachment(
        id: a.id,
        serverId: a.serverId,
        damageReportId: a.damageReportId,
        documentName: a.documentName,
        documentDate: a.documentDate,
        documentTypeId: a.documentTypeId,
        localPath: a.localPath,
        remotePath: a.remotePath,
        uploadStatus: a.uploadStatus,
        syncStatus: a.syncStatus,
        lastSyncError: a.lastSyncError,
      )).toList(),
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
      damageDate: report.damageDate ?? DateTime.now(),
      documentationDate: report.documentationDate ?? DateTime.now(),
      agriculturalSectorId: Value(report.agriculturalSectorId),
      damageCauseCategoryId: Value(report.damageCauseCategoryId),
      damageCauseId: Value(report.damageCauseId),
      governorateId: Value(report.governorateId),
      directorateId: Value(report.directorateId),
      localityId: Value(report.localityId),
      statusId: report.statusId,
      totalDamage: Value(report.totalDamage),
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

  DamageReportAttachmentsCompanion _mapAttachmentToCompanion(attachment_domain.DamageReportAttachment attachment) {
    return DamageReportAttachmentsCompanion.insert(
      id: attachment.id,
      serverId: Value(attachment.serverId),
      damageReportId: attachment.damageReportId,
      documentName: Value(attachment.documentName),
      documentDate: Value(attachment.documentDate),
      documentTypeId: Value(attachment.documentTypeId),
      localPath: attachment.localPath,
      remotePath: Value(attachment.remotePath),
      uploadStatus: Value(attachment.uploadStatus),
      syncStatus: Value(attachment.syncStatus),
      lastSyncError: Value(attachment.lastSyncError),
    );
  }

  @override
  Future<report_domain.DamageReport> createDamageReport(
      report_domain.DamageReport report,
      ) async {
    // 1. Duplicate check (Local)
    final dDate = report.damageDate ?? DateTime.now();
    final normalizedDate = DateTime(dDate.year, dDate.month, dDate.day);

    final existing = await (_db.select(_db.damageReports)
      ..where((t) => t.farmId.equals(report.farmId) &
      t.damageDate.equals(normalizedDate) &
      t.isPendingDelete.equals(false)))
        .getSingleOrNull();

    if (existing != null) {
      throw DamageReportException(['duplicateReportError']);
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
    final dDate = report.damageDate ?? DateTime.now();
    final normalizedDate = DateTime(dDate.year, dDate.month, dDate.day);

    // Duplicate check on update
    final existing = await (_db.select(_db.damageReports)
      ..where((t) => t.id.equals(report.id).not() &
      t.farmId.equals(report.farmId) &
      t.damageDate.equals(normalizedDate) &
      t.isPendingDelete.equals(false)))
        .getSingleOrNull();

    if (existing != null) {
      throw DamageReportException(['duplicateReportError']);
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
    // Locally predict state and CLEAR any previous sync errors
    await (_db.update(_db.damageReports)..where((t) => t.id.equals(id))).write(
      const DamageReportsCompanion(
        statusId: Value(DamageReportStatus.techReview),
        syncStatus: Value('pending'),
        lastSyncError: Value(null), // Clear error on new attempt
      ),
    );

    await (_db.update(_db.damageReports)..where((t) => t.id.equals(id))).write(
      DamageReportsCompanion(
        updatedAt: Value(DateTime.now()),
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

    // Locally predict state and CLEAR any previous sync errors
    await (_db.update(_db.damageReports)..where((t) => t.id.equals(id))).write(
      DamageReportsCompanion(
        statusId: Value(toStatus),
        syncStatus: const Value('pending'),
        lastSyncError: const Value(null), // Clear error on new attempt
        updatedAt: Value(DateTime.now()),
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
      changedByUserName: h.changedByUserName,
      changedAt: h.changedAt,
      comment: h.comment,
      isOverride: h.isOverride,
    ))
        .toList();
  }

  @override
  Stream<List<domain_history.DamageWorkflowHistory>> watchReportHistory(String id) {
    return (_db.select(_db.damageWorkflowHistories)
      ..where((t) => t.damageReportId.equals(id))
      ..orderBy([(t) => OrderingTerm.desc(t.changedAt)]))
        .watch()
        .map((histories) => histories
        .map((h) => domain_history.DamageWorkflowHistory(
      id: h.id,
      serverId: h.serverId,
      damageReportId: h.damageReportId,
      fromStatus: h.fromStatus,
      toStatus: h.toStatus,
      changedByUserId: h.changedByUserId,
      changedByUserName: h.changedByUserName,
      changedAt: h.changedAt,
      comment: h.comment,
      isOverride: h.isOverride,
    ))
        .toList());
  }

  // دالة لجلب وتخزين سجل الحركات محلياً من السيرفر وتحديث الواجهة تلقائياً
  @override
  Future<void> syncWorkflowHistory(String localId, String serverId) async {
    try {
      final remoteHistories = await _remoteRepository.getReportHistory(serverId);

      await _db.transaction(() async {
        for (var h in remoteHistories) {
          final serverIdValue = h.serverId;
          if (serverIdValue == null) continue;

          final existing = await (_db.select(_db.damageWorkflowHistories)
                ..where((t) => t.serverId.equals(serverIdValue)))
              .getSingleOrNull();

          await _db.into(_db.damageWorkflowHistories).insert(
            DamageWorkflowHistoriesCompanion.insert(
              id: existing?.id ?? const Uuid().v4(),
              serverId: Value(serverIdValue),
              damageReportId: localId,
              fromStatus: h.fromStatus,
              toStatus: h.toStatus,
              changedByUserId: h.changedByUserId,
              changedByUserName: Value(h.changedByUserName),
              changedAt: h.changedAt ?? DateTime.now(),
              comment: Value(h.comment),
              isOverride: Value(h.isOverride),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });
    } catch (e) {
      DebugLogger.log('Error in syncWorkflowHistory: $e');
      rethrow;
    }
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
  Future<void> retrySync(String id) async {
    // 1. Reset ALL related items in sync queue (create, update, workflow_action)
    // CRITICAL: We reset retryCount and lastAttemptAt to 0/null to BYPASS backoff logic
    // and force an immediate retry in the next processQueue() call.
    await (_db.update(_db.syncQueue)
      ..where((t) => t.localId.equals(id) & t.entityType.equals('damage_report')))
        .write(
      const SyncQueueCompanion(
        status: Value('pending'),
        retryCount: Value(0),
        lastError: Value(null),
        lastAttemptAt: Value(null),
      ),
    );

    // Also reset any associated damage items if they failed
    await (_db.update(_db.syncQueue)
      ..where((t) => t.entityType.equals('damage_item') & t.status.isNotIn(['completed', 'syncing'])))
        .write(
      const SyncQueueCompanion(
        status: Value('pending'),
        retryCount: Value(0),
        lastError: Value(null),
        lastAttemptAt: Value(null),
      ),
    );

    // 2. Reset entity status and CLEAR error
    await (_db.update(_db.damageReports)..where((t) => t.id.equals(id))).write(
      const DamageReportsCompanion(
        syncStatus: Value('pending'),
        lastSyncError: Value(null),
      ),
    );

    // 3. Trigger processing
    await _syncService.processQueue();
  }

  @override
  Future<void> retryAllFailedSyncs() async {
    // 1. Reset all failed/invalid items in sync queue for damage_report
    await (_db.update(_db.syncQueue)
      ..where((t) =>
      t.entityType.equals('damage_report') &
      (t.status.equals('failed') | t.status.equals('invalid'))))
        .write(
      const SyncQueueCompanion(
        status: Value('pending'),
        retryCount: Value(0),
        lastError: Value(null),
        lastAttemptAt: Value(null),
      ),
    );

    // 2. Reset all damage reports with failed/invalid status
    await (_db.update(_db.damageReports)
      ..where((t) => t.syncStatus.equals('failed') | t.syncStatus.equals('invalid')))
        .write(
      const DamageReportsCompanion(
        syncStatus: Value('pending'),
        lastSyncError: Value(null),
      ),
    );

    // 3. Trigger processing
    await _syncService.processQueue();
  }

  @override
  Future<void> synchronize({DateTime? updatedSince}) async {
    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) return;

    int page = 1;
    bool hasMore = true;

    while (hasMore) {
      final remoteItems = await _remoteRepository.getDamageReports(
        pageNumber: page,
        pageSize: 50,
        updatedSince: updatedSince,
      );

      if (remoteItems.isEmpty) break;

      await _db.transaction(() async {
        for (final remote in remoteItems) {
          // PROTECTION: Skip if local record has unsynced changes
          // We search by serverId to find matching local records
          final local = await (_db.select(_db.damageReports)
            ..where((t) => t.serverId.lower().equals(remote.serverId?.toLowerCase() ?? ''))).getSingleOrNull();

          if (local != null && local.syncStatus != 'completed') {
            continue; // Skip records with pending/failed local changes
          }

          final localId = local?.id ?? remote.id;

          // 1. Upsert header
          await _db.into(_db.damageReports).insert(
            _mapReportToCompanion(remote).copyWith(
              id: Value(localId),
              syncStatus: const Value('completed'),
              lastSyncError: const Value(null),
              updatedAt: Value(DateTime.now()),
            ),
            mode: InsertMode.insertOrReplace,
          );

          // 2. Full Sync Items: Clear and replace
          await (_db.delete(_db.damageItems)..where((t) => t.damageReportId.lower().equals(localId.toLowerCase()))).go();
          for (var item in remote.items) {
            await _db.into(_db.damageItems).insert(
              _mapItemToCompanion(item).copyWith(
                damageReportId: Value(localId),
                syncStatus: const Value('completed'),
                lastSyncError: const Value(null),
                updatedAt: Value(DateTime.now()),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }

          // 3. Full Sync Attachments: Clear and replace
          await (_db.delete(_db.damageReportAttachments)..where((t) => t.damageReportId.lower().equals(localId.toLowerCase()))).go();
          for (var attachment in remote.attachments) {
            await _db.into(_db.damageReportAttachments).insert(
              _mapAttachmentToCompanion(attachment).copyWith(
                id: Value(attachment.id), // Use server provided GUID if available or generate new one
                damageReportId: Value(localId),
                syncStatus: const Value('completed'),
                uploadStatus: const Value('completed'),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        }
      });

      if (remoteItems.length < 50) {
        hasMore = false;
      } else {
        page++;
      }
    }
  }

  @override
  Future<void> refreshReport(String id) async {
    try {
      final local = await (_db.select(_db.damageReports)..where((t) => t.id.equals(id))).getSingleOrNull();
      if (local == null) return;

      final serverId = local.serverId;
      if (serverId == null || serverId.isEmpty) return;

      // 1. Fetch from remote
      final remote = await _remoteRepository.getDamageReport(serverId);

      // 2. Update local DB
      await _db.transaction(() async {
        // Update header
        await (_db.update(_db.damageReports)..where((t) => t.id.equals(id))).write(
          _mapReportToCompanion(remote).copyWith(
            id: Value(id),
            syncStatus: const Value('completed'),
            lastSyncError: const Value(null),
            updatedAt: Value(DateTime.now()),
          ),
        );

        // Update items: delete local and insert remote for full sync
        await (_db.delete(_db.damageItems)..where((t) => t.damageReportId.lower().equals(id.toLowerCase()))).go();
        for (var item in remote.items) {
          await _db.into(_db.damageItems).insert(
            _mapItemToCompanion(item).copyWith(
              damageReportId: Value(id),
              syncStatus: const Value('completed'),
              lastSyncError: const Value(null),
              updatedAt: Value(DateTime.now()),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }

        // Update attachments: delete local and insert remote for full sync
        await (_db.delete(_db.damageReportAttachments)..where((t) => t.damageReportId.lower().equals(id.toLowerCase()))).go();
        for (var attachment in remote.attachments) {
          await _db.into(_db.damageReportAttachments).insert(
            _mapAttachmentToCompanion(attachment).copyWith(
              id: Value(attachment.id),
              damageReportId: Value(id),
              syncStatus: const Value('completed'),
              uploadStatus: const Value('completed'),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });

      // 3. Sync workflow history
      await syncWorkflowHistory(id, serverId);

    } catch (e) {
      DebugLogger.log('Error refreshing report $id: $e');
      rethrow;
    }
  }

  @override
  Future<List<AuditLogEntry>> getIntegratedAuditLog(String id) async {
    final local = await (_db.select(_db.damageReports)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (local == null) return [];

    final serverId = local.serverId;
    if (serverId == null || serverId.isEmpty) {
      return [
        AuditLogEntry(
          eventType: 'Report',
          description: 'تم إنشاء التقرير محلياً (قيد المزامنة)',
          performedBy: local.createdBy,
          eventDate: local.damageDate,
        )
      ];
    }

    try {
      return await _remoteRepository.getIntegratedAuditLog(serverId);
    } catch (_) {
      return [
        AuditLogEntry(
          eventType: 'Offline',
          description: 'تعذر جلب سجل العمليات المتكامل من السيرفر',
          performedBy: 'System',
          eventDate: DateTime.now(),
        )
      ];
    }
  }
}
