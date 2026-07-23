import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/utils/debug_logger.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_attachment_repository.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart' as item_domain;
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart'
    as report_domain;
import 'package:mobile/features/damage_reports/domain/models/damage_report_attachment.dart'
    as attachment_domain;
import 'package:mobile/features/farms/domain/farm.dart' as farm_domain;
import 'package:mobile/features/farmers/domain/farmer.dart' as domain;
import 'package:uuid/uuid.dart';

class BackgroundSyncService {
  final AppDatabase _db;
  final FarmerRepository _remoteFarmerRepository;
  final FarmRepository _remoteFarmRepository;
  final DamageReportRepository _remoteDamageReportRepository;
  final DamageReportAttachmentRepository _remoteAttachmentRepository;
  final Connectivity _connectivity;

  StreamSubscription? _connectivitySubscription;
  bool _isProcessing = false;

  BackgroundSyncService(
    this._db,
    this._remoteFarmerRepository,
    this._remoteFarmRepository,
    this._remoteDamageReportRepository,
    this._remoteAttachmentRepository,
    this._connectivity,
  );

  Future<void> initialize() async {
    _connectivitySubscription ??= _connectivity.onConnectivityChanged.listen((
      results,
    ) {
      if (results.any((result) => result != ConnectivityResult.none)) {
        processQueue();
      }
    });
    // Trigger initial sync on startup
    await processQueue();
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  Future<void> addToQueue({
    required String localId,
    required String entityType,
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    final existing = await (_db.select(_db.syncQueue)
          ..where(
            (t) =>
                t.localId.equals(localId) & t.entityType.equals(entityType),
          )
          ..where(
            (t) =>
                t.status.equals('pending') |
                t.status.equals('failed') |
                t.status.equals('invalid'),
          ))
        .getSingleOrNull();

    if (existing != null) {
      // COLLAPSING RULES
      
      // 1. DELETE after CREATE (not yet synced) -> Remove both record and task
      if (existing.operation == 'create' && operation == 'delete') {
        await (_db.delete(_db.syncQueue)..where((t) => t.id.equals(existing.id))).go();
        await _hardDeleteLocalEntity(entityType, localId);
        return;
      }

      // 2. Preserve 'create' operation during offline edits to avoid 404s
      final finalOperation =
          existing.operation == 'create' && operation == 'update'
              ? 'create'
              : operation;

      await (_db.update(_db.syncQueue)
            ..where((t) => t.id.equals(existing.id)))
          .write(
            SyncQueueCompanion(
              operation: Value(finalOperation),
              data: Value(jsonEncode(data)),
              status: const Value('pending'),
              retryCount: const Value(0),
              lastError: const Value(null),
              lastAttemptAt: const Value(null),
              createdAt: Value(DateTime.now()),
            ),
          );
    } else {
      await _db.into(_db.syncQueue).insert(
        SyncQueueCompanion.insert(
          id: const Uuid().v4(),
          localId: localId,
          entityType: entityType,
          operation: operation,
          data: jsonEncode(data),
          createdAt: Value(DateTime.now()),
        ),
      );
    }
    processQueue();
  }

  Future<void> _hardDeleteLocalEntity(String entityType, String localId) async {
    if (entityType == 'farmer') {
      await (_db.delete(_db.farmers)..where((t) => t.id.equals(localId))).go();
    } else if (entityType == 'farm') {
      await (_db.delete(_db.farms)..where((t) => t.id.equals(localId))).go();
    } else if (entityType == 'damage_report') {
      // Manual cascade for Damage Report
      await _db.transaction(() async {
        // 1. Delete items
        await (_db.delete(_db.damageItems)..where((t) => t.damageReportId.equals(localId))).go();
        
        // 2. Delete attachments (including local files)
        final attachments = await (_db.select(_db.damageReportAttachments)
              ..where((t) => t.damageReportId.equals(localId)))
            .get();
        for (var a in attachments) {
          try {
            final file = File(a.localPath);
            if (await file.exists()) {
              await file.delete();
            }
          } catch (_) {
            // Ignore file deletion errors
          }
        }
        await (_db.delete(_db.damageReportAttachments)..where((t) => t.damageReportId.equals(localId))).go();
        
        // 3. Delete report itself
        await (_db.delete(_db.damageReports)..where((t) => t.id.equals(localId))).go();
      });
    } else if (entityType == 'damage_item') {
      await (_db.delete(_db.damageItems)..where((t) => t.id.equals(localId))).go();
    } else if (entityType == 'attachment') {
      final attachment = await (_db.select(_db.damageReportAttachments)
            ..where((t) => t.id.equals(localId)))
          .getSingleOrNull();
      if (attachment != null) {
        try {
          final file = File(attachment.localPath);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (_) {}
      }
      await (_db.delete(_db.damageReportAttachments)..where((t) => t.id.equals(localId))).go();
    }
  }

  Future<void> processQueue() async {
    if (_isProcessing) return;

    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity.any((result) => result == ConnectivityResult.none)) return;

    _isProcessing = true;
    try {
      bool isStartup = true;
      while (true) {
        final now = DateTime.now();
        final pendingItems = await (_db.select(_db.syncQueue)
              ..where(
                (t) {
                  final isPendingOrFailed =
                      t.status.equals('pending') | t.status.equals('failed');
                  // On startup, we include all 'syncing' items for recovery.
                  // During session, we only include 'syncing' items that are "stuck" (> 5 mins).
                  final isStuckSyncing = t.status.equals('syncing') &
                      (isStartup
                          ? const Constant(true)
                          : t.lastAttemptAt.isSmallerThanValue(
                            now.subtract(const Duration(minutes: 5)),
                          ));
                  return isPendingOrFailed | isStuckSyncing;
                },
              )
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();
        isStartup = false;

        if (pendingItems.isEmpty) break;

        bool itemsProcessedInThisBatch = false;

        for (final item in pendingItems) {
          if (item.retryCount >= 3) continue;

          // Simple backoff: 0, 5, 15 minutes
          // skip backoff for dependency errors to allow fast resolution in same loop
          final isDependencyError = item.lastError?.contains('Waiting for') ?? false;
          if (item.lastAttemptAt != null && !isDependencyError) {
            final waitMinutes =
                item.retryCount == 1 ? 5 : (item.retryCount == 2 ? 15 : 0);
            if (now.difference(item.lastAttemptAt!).inMinutes < waitMinutes) {
              continue;
            }
          }

          await _processItem(item);
          itemsProcessedInThisBatch = true;
        }

        // If no items were processed in this pass (all skipped due to backoff or retry limit),
        // we must break to avoid an infinite loop.
        if (!itemsProcessedInThisBatch) break;
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _processItem(SyncQueueData item) async {
    final now = DateTime.now();
    try {
      if (DebugLogger.enableSyncDebug) {
        DebugLogger.logHeader('Sync Processing');
        DebugLogger.log('Entity Type: ${item.entityType}');
        DebugLogger.log('Operation: ${item.operation}');
        DebugLogger.log('Queue Item ID: ${item.id}');
        DebugLogger.log('Local ID: ${item.localId}');
        DebugLogger.log('Retry Count: ${item.retryCount}');
        DebugLogger.logFooter();
      }

      await _db
          .update(_db.syncQueue)
          .replace(item.copyWith(status: 'syncing', lastAttemptAt: Value(now)));
      await _updateEntitySyncStatus(item.entityType, item.localId, 'syncing');

      if (item.entityType == 'farmer') {
        await _syncFarmer(item);
      } else if (item.entityType == 'farm') {
        await _syncFarm(item);
      } else if (item.entityType == 'damage_report') {
        await _syncDamageReport(item);
      } else if (item.entityType == 'damage_item') {
        await _syncDamageItem(item);
      } else if (item.entityType == 'attachment') {
        await _syncAttachment(item);
      }

      await _db
          .update(_db.syncQueue)
          .replace(item.copyWith(status: 'completed'));
      await _updateEntitySyncStatus(item.entityType, item.localId, 'completed');
    } on SyncDependencyException catch (e) {
      // Defer sync: Increase retry count and set back to pending for next loop
      await _db.update(_db.syncQueue).replace(
        item.copyWith(
          status: 'pending',
          retryCount: item.retryCount + 1,
          lastAttemptAt: Value(now),
          lastError: Value(e.toString()),
        ),
      );
      await _updateEntitySyncStatus(
        item.entityType,
        item.localId,
        'pending',
        error: e.toString(),
      );
    } on SyncValidationException catch (e) {
      await _db.update(_db.syncQueue).replace(
        item.copyWith(status: 'invalid', lastError: Value(e.toString())),
      );
      await _updateEntitySyncStatus(
        item.entityType,
        item.localId,
        'invalid',
        error: e.toString(),
      );
    } on SyncConflictException catch (e) {
      await _db.update(_db.syncQueue).replace(
        item.copyWith(status: 'conflict', lastError: Value(e.toString())),
      );
      await _updateEntitySyncStatus(item.entityType, item.localId, 'conflict');
      await _resolveConflict(item);
    } on FarmerException catch (e) {
      if (e.errors.any((err) => err.contains('CONFLICT'))) {
        await _db.update(_db.syncQueue).replace(
          item.copyWith(status: 'conflict', lastError: Value(e.toString())),
        );
        await _updateEntitySyncStatus(item.entityType, item.localId, 'conflict');
        await _resolveConflict(item);
      } else {
        await _db.update(_db.syncQueue).replace(
          item.copyWith(
            status: 'failed',
            retryCount: item.retryCount + 1,
            lastError: Value(e.toString()),
          ),
        );
        await _updateEntitySyncStatus(item.entityType, item.localId, 'failed');
      }
    } on FarmException catch (e) {
      if (e.errors.any((err) => err.contains('CONFLICT'))) {
        await _db.update(_db.syncQueue).replace(
          item.copyWith(status: 'conflict', lastError: Value(e.toString())),
        );
        await _updateEntitySyncStatus(item.entityType, item.localId, 'conflict');
        await _resolveConflict(item);
      } else {
        await _db.update(_db.syncQueue).replace(
          item.copyWith(
            status: 'failed',
            retryCount: item.retryCount + 1,
            lastError: Value(e.toString()),
          ),
        );
        await _updateEntitySyncStatus(item.entityType, item.localId, 'failed');
      }
    } on DamageReportException catch (e) {
      if (e.errors.any((err) => err.contains('CONFLICT'))) {
        await _db.update(_db.syncQueue).replace(
          item.copyWith(status: 'conflict', lastError: Value(e.toString())),
        );
        await _updateEntitySyncStatus(item.entityType, item.localId, 'conflict');
        await _resolveConflict(item);
      } else {
        await _db.update(_db.syncQueue).replace(
          item.copyWith(
            status: 'failed',
            retryCount: item.retryCount + 1,
            lastError: Value(e.toString()),
          ),
        );
        await _updateEntitySyncStatus(item.entityType, item.localId, 'failed');
      }
    } on SyncException catch (e) {
      await _db.update(_db.syncQueue).replace(
        item.copyWith(
          status: 'failed',
          retryCount: item.retryCount + 1,
          lastError: Value(e.toString()),
        ),
      );
      await _updateEntitySyncStatus(
        item.entityType,
        item.localId,
        'failed',
        error: e.toString(),
      );
    } catch (e, stackTrace) {
      if (DebugLogger.enableSyncDebug) {
        DebugLogger.logHeader('SYNC ERROR TRACE');
        DebugLogger.log('Exception Type: ${e.runtimeType}');
        DebugLogger.log('Message: $e');
        DebugLogger.log('Stack Trace:\n$stackTrace');
        DebugLogger.logFooter();
      }
      await _db.update(_db.syncQueue).replace(
        item.copyWith(
          status: 'failed',
          retryCount: item.retryCount + 1,
          lastAttemptAt: Value(now),
          lastError: Value(e.toString()),
        ),
      );
      await _updateEntitySyncStatus(
        item.entityType,
        item.localId,
        'failed',
        error: e.toString(),
      );
    }
  }

  Future<void> _updateEntitySyncStatus(
    String entityType,
    String localId,
    String status, {
    String? error,
  }) async {
    if (entityType == 'farmer') {
      await (_db.update(_db.farmers)..where((t) => t.id.equals(localId))).write(
        FarmersCompanion(
          syncStatus: Value(status),
          lastSyncError: Value(error),
        ),
      );
    } else if (entityType == 'farm') {
      await (_db.update(_db.farms)..where((t) => t.id.equals(localId))).write(
        FarmsCompanion(
          syncStatus: Value(status),
          lastSyncError: Value(error),
        ),
      );
    } else if (entityType == 'damage_report') {
      await (_db.update(
        _db.damageReports,
      )..where((t) => t.id.equals(localId))).write(
        DamageReportsCompanion(
          syncStatus: Value(status),
          lastSyncError: Value(error),
        ),
      );
    } else if (entityType == 'damage_item') {
      await (_db.update(
        _db.damageItems,
      )..where((t) => t.id.equals(localId))).write(
        DamageItemsCompanion(
          syncStatus: Value(status),
          lastSyncError: Value(error),
        ),
      );
    } else if (entityType == 'attachment') {
      await (_db.update(
        _db.damageReportAttachments,
      )..where((t) => t.id.equals(localId))).write(
        DamageReportAttachmentsCompanion(
          syncStatus: Value(status),
          lastSyncError: Value(error),
        ),
      );
    }
  }

  Future<void> _syncAttachment(SyncQueueData item) async {
    final data = jsonDecode(item.data) as Map<String, dynamic>;

    if (item.operation == 'delete') {
      final serverId = data['serverId'] ?? data['id'];
      if (serverId != null) {
        await _remoteAttachmentRepository.deleteAttachment(serverId.toString());
      }
      await _hardDeleteLocalEntity(item.entityType, item.localId);
      return;
    }

    // --- ID RESOLUTION (Late Binding) ---
    final originalReportId = data['damageReportId'] as String;
    final resolvedReportId = await _resolveDamageReportId(originalReportId);
    if (resolvedReportId != null) {
      data['damageReportId'] = resolvedReportId;
    } else {
      throw SyncDependencyException(['Waiting for Damage Report ($originalReportId) to synchronize.']);
    }

    final attachment = attachment_domain.DamageReportAttachment.fromJson(data);

    if (item.operation == 'upload') {
      final result = await _remoteAttachmentRepository.uploadAttachment(
        attachment,
      );
      await (_db.update(
        _db.damageReportAttachments,
      )..where((t) => t.id.equals(item.localId))).write(
        DamageReportAttachmentsCompanion(
          serverId: Value(result.serverId ?? result.id), // For attachments, sometimes id is used
          remotePath: Value(result.remotePath),
          uploadStatus: const Value('completed'),
          syncStatus: const Value('completed'),
          lastSyncError: const Value(null),
        ),
      );
    } else if (item.operation == 'delete') {
      await _remoteAttachmentRepository.deleteAttachment(item.localId);
      await _hardDeleteLocalEntity(item.entityType, item.localId);
    }
  }

  Future<void> _syncFarmer(SyncQueueData item) async {
    final data = jsonDecode(item.data) as Map<String, dynamic>;

    if (item.operation == 'delete') {
      final serverId = data['serverId'] ?? data['id'];
      if (serverId != null) {
        await _remoteFarmerRepository.deleteFarmer(serverId.toString());
      }
      await _hardDeleteLocalEntity(item.entityType, item.localId);
      return;
    }

    final farmer = domain.Farmer.fromJson(data);

    if (item.operation == 'create') {
      final result = await _remoteFarmerRepository.createFarmer(farmer);
      await (_db.update(
        _db.farmers,
      )..where((t) => t.id.equals(item.localId))).write(
        FarmersCompanion(
          serverId: Value(result.serverId),
          rowVersion: Value(result.rowVersion),
          syncStatus: const Value('completed'),
          lastSyncError: const Value(null),
        ),
      );
    } else if (item.operation == 'update') {
      final result = await _remoteFarmerRepository.updateFarmer(farmer);
      await (_db.update(
        _db.farmers,
      )..where((t) => t.id.equals(item.localId))).write(
        FarmersCompanion(
          rowVersion: Value(result.rowVersion),
          syncStatus: const Value('completed'),
          lastSyncError: const Value(null),
        ),
      );
    }
  }

  Future<void> _syncFarm(SyncQueueData item) async {
    final data = jsonDecode(item.data) as Map<String, dynamic>;

    if (item.operation == 'delete') {
      final serverId = data['serverId'] ?? data['id'];
      if (serverId != null) {
        await _remoteFarmRepository.deleteFarm(serverId.toString());
      }
      await _hardDeleteLocalEntity(item.entityType, item.localId);
      return;
    }

    // --- ID RESOLUTION (Late Binding) ---
    final originalFarmerId = data['farmerId'] as String;
    final resolvedFarmerId = await _resolveFarmerId(originalFarmerId);
    if (resolvedFarmerId != null) {
      data['farmerId'] = resolvedFarmerId;
    } else {
      // If we can't resolve a mandatory ID, we must wait for the parent to sync
      throw SyncDependencyException(['Waiting for Farmer ($originalFarmerId) to synchronize.']);
    }

    final originalOwnerId = data['ownerFarmerId'] as String?;
    if (originalOwnerId != null && originalOwnerId.isNotEmpty) {
      final resolvedOwnerId = await _resolveFarmerId(originalOwnerId);
      if (resolvedOwnerId != null) {
        data['ownerFarmerId'] = resolvedOwnerId;
      } else {
        throw SyncDependencyException(['Waiting for Owner Farmer ($originalOwnerId) to synchronize.']);
      }
    }

    final farm = farm_domain.Farm.fromJson(data);

    if (item.operation == 'create') {
      final result = await _remoteFarmRepository.createFarm(farm);
      await (_db.update(
        _db.farms,
      )..where((t) => t.id.equals(item.localId))).write(
        FarmsCompanion(
          serverId: Value(result.serverId),
          rowVersion: Value(result.rowVersion),
          syncStatus: const Value('completed'),
          lastSyncError: const Value(null),
        ),
      );
    } else if (item.operation == 'update') {
      final result = await _remoteFarmRepository.updateFarm(farm);
      await (_db.update(
        _db.farms,
      )..where((t) => t.id.equals(item.localId))).write(
        FarmsCompanion(
          rowVersion: Value(result.rowVersion),
          syncStatus: const Value('completed'),
          lastSyncError: const Value(null),
        ),
      );
    }
  }

  Future<void> _syncDamageReport(SyncQueueData item) async {
    final data = jsonDecode(item.data) as Map<String, dynamic>;

    if (item.operation == 'delete') {
      final serverId = data['serverId'] ?? data['id'];
      if (serverId != null) {
        await _remoteDamageReportRepository.deleteDamageReport(serverId.toString());
      }
      await _hardDeleteLocalEntity(item.entityType, item.localId);
      return;
    }

    // --- ID RESOLUTION (Late Binding) ---
    final originalFarmId = data['farmId'] as String;
    final resolvedFarmId = await _resolveFarmId(originalFarmId);
    if (resolvedFarmId != null) {
      data['farmId'] = resolvedFarmId;
    } else {
      throw SyncDependencyException(['Waiting for Farm ($originalFarmId) to synchronize.']);
    }

    final originalFarmerId = data['farmerId'] as String;
    final resolvedFarmerId = await _resolveFarmerId(originalFarmerId);
    if (resolvedFarmerId != null) {
      data['farmerId'] = resolvedFarmerId;
    } else {
      throw SyncDependencyException(['Waiting for Farmer ($originalFarmerId) to synchronize.']);
    }

    final report = report_domain.DamageReport.fromJson(data);

    if (item.operation == 'create') {
      final result = await _remoteDamageReportRepository.createDamageReport(
        report,
      );
      await _db.transaction(() async {
        await (_db.update(
          _db.damageReports,
        )..where((t) => t.id.equals(item.localId))).write(
          DamageReportsCompanion(
            serverId: Value(result.serverId),
            permanentFormNumber: Value(result.permanentFormNumber),
            rowVersion: Value(result.rowVersion),
            syncStatus: const Value('completed'),
            lastSyncError: const Value(null),
          ),
        );
        for (var i in result.items) {
          await (_db.update(
            _db.damageItems,
          )..where((t) => t.id.equals(i.id) | t.serverId.equals(i.serverId!))).write(
            DamageItemsCompanion(
              serverId: Value(i.serverId),
              rowVersion: Value(i.rowVersion),
              syncStatus: const Value('completed'),
              lastSyncError: const Value(null),
            ),
          );
        }
      });
    } else if (item.operation == 'update') {
      final result = await _remoteDamageReportRepository.updateDamageReport(
        report,
      );
      await (_db.update(
        _db.damageReports,
      )..where((t) => t.id.equals(item.localId))).write(
        DamageReportsCompanion(
          rowVersion: Value(result.rowVersion),
          syncStatus: const Value('completed'),
          lastSyncError: const Value(null),
        ),
      );
    }
  }

  Future<void> _syncDamageItem(SyncQueueData item) async {
    final data = jsonDecode(item.data) as Map<String, dynamic>;

    if (item.operation == 'delete') {
      final serverId = data['serverId'] ?? data['id'];
      if (serverId != null) {
        await _remoteDamageReportRepository.deleteDamageItem(serverId.toString());
      }
      await _hardDeleteLocalEntity(item.entityType, item.localId);
      return;
    }

    // --- ID RESOLUTION (Late Binding) ---
    final originalReportId = data['damageReportId'] as String;
    final resolvedReportId = await _resolveDamageReportId(originalReportId);
    if (resolvedReportId != null) {
      data['damageReportId'] = resolvedReportId;
    } else {
      throw SyncDependencyException(['Waiting for Damage Report ($originalReportId) to synchronize.']);
    }

    final damageItem = item_domain.DamageItem.fromJson(data);

    if (item.operation == 'create') {
      final result = await _remoteDamageReportRepository.addDamageItem(
        damageItem,
      );
      await (_db.update(
        _db.damageItems,
      )..where((t) => t.id.equals(item.localId))).write(
        DamageItemsCompanion(
          serverId: Value(result.serverId),
          rowVersion: Value(result.rowVersion),
          syncStatus: const Value('completed'),
          lastSyncError: const Value(null),
        ),
      );
    } else if (item.operation == 'update') {
      final result = await _remoteDamageReportRepository.updateDamageItem(
        damageItem,
      );
      await (_db.update(
        _db.damageItems,
      )..where((t) => t.id.equals(item.localId))).write(
        DamageItemsCompanion(
          rowVersion: Value(result.rowVersion),
          syncStatus: const Value('completed'),
          lastSyncError: const Value(null),
        ),
      );
    }
  }

  Future<void> _resolveConflict(SyncQueueData item) async {
    if (item.entityType == 'farmer') {
      try {
        final localFarmer = await (_db.select(
          _db.farmers,
        )..where((t) => t.id.equals(item.localId))).getSingle();
        final remoteFarmer = await _remoteFarmerRepository.getFarmer(
          localFarmer.serverId ?? item.localId,
        );

        // Server Wins: Update local record with remote data
        await (_db.update(
          _db.farmers,
        )..where((t) => t.id.equals(item.localId))).write(
          FarmersCompanion(
            serverId: Value(remoteFarmer.serverId),
            idTypeId: Value(remoteFarmer.idTypeId),
            idNumber: Value(remoteFarmer.idNumber),
            firstNameAr: Value(remoteFarmer.firstNameAr),
            fatherNameAr: Value(remoteFarmer.fatherNameAr),
            grandfatherNameAr: Value(remoteFarmer.grandfatherNameAr),
            familyNameAr: Value(remoteFarmer.familyNameAr),
            firstNameEn: Value(remoteFarmer.firstNameEn),
            fatherNameEn: Value(remoteFarmer.fatherNameEn),
            grandfatherNameEn: Value(remoteFarmer.grandfatherNameEn),
            familyNameEn: Value(remoteFarmer.familyNameEn),
            birthDate: Value(remoteFarmer.birthDate),
            gender: Value(remoteFarmer.gender.index),
            phoneNumber: Value(remoteFarmer.phoneNumber),
            familySize: Value(remoteFarmer.familySize),
            governorateId: Value(remoteFarmer.governorateId),
            localityId: Value(remoteFarmer.localityId),
            address: Value(remoteFarmer.address),
            rowVersion: Value(remoteFarmer.rowVersion),
            updatedAt: Value(remoteFarmer.updatedAt),
            syncStatus: const Value('completed'),
          ),
        );

        await _db
            .update(_db.syncQueue)
            .replace(item.copyWith(status: 'completed'));
      } on SyncException catch (e) {
      await _db.update(_db.syncQueue).replace(
        item.copyWith(
          status: 'failed',
          retryCount: item.retryCount + 1,
          lastError: Value(e.toString()),
        ),
      );
      await _updateEntitySyncStatus(item.entityType, item.localId, 'failed');
    } catch (e) {
        // Log failure to resolve
      }
    } else if (item.entityType == 'farm') {
      try {
        final localFarm = await (_db.select(
          _db.farms,
        )..where((t) => t.id.equals(item.localId))).getSingle();
        final remoteFarm = await _remoteFarmRepository.getFarm(
          localFarm.serverId ?? item.localId,
        );

        await (_db.update(
          _db.farms,
        )..where((t) => t.id.equals(item.localId))).write(
          FarmsCompanion(
            serverId: Value(remoteFarm.serverId),
            farmerId: Value(remoteFarm.farmerId),
            ownerFarmerId: Value(remoteFarm.ownerFarmerId),
            localFarmName: Value(remoteFarm.localFarmName),
            ownershipTypeId: Value(remoteFarm.ownershipTypeId),
            relationshipToOwnerId: Value(remoteFarm.relationshipToOwnerId),
            governorateId: Value(remoteFarm.governorateId),
            directorateId: Value(remoteFarm.directorateId),
            localityId: Value(remoteFarm.localityId),
            basin: Value(remoteFarm.basin),
            parcel: Value(remoteFarm.parcel),
            area: Value(remoteFarm.area),
            areaUnitId: Value(remoteFarm.areaUnitId),
            agriculturalSectorId: Value(remoteFarm.agriculturalSectorId),
            politicalClassificationId: Value(remoteFarm.politicalClassificationId),
            latitude: Value(remoteFarm.latitude),
            longitude: Value(remoteFarm.longitude),
            notes: Value(remoteFarm.notes),
            rowVersion: Value(remoteFarm.rowVersion),
            updatedAt: Value(remoteFarm.updatedAt),
            syncStatus: const Value('completed'),
          ),
        );

        await _db
            .update(_db.syncQueue)
            .replace(item.copyWith(status: 'completed'));
      } on SyncException catch (e) {
      await _db.update(_db.syncQueue).replace(
        item.copyWith(
          status: 'failed',
          retryCount: item.retryCount + 1,
          lastError: Value(e.toString()),
        ),
      );
      await _updateEntitySyncStatus(item.entityType, item.localId, 'failed');
    } catch (e) {
        // Log
      }
    } else if (item.entityType == 'damage_report') {
      try {
        final localReport = await (_db.select(
          _db.damageReports,
        )..where((t) => t.id.equals(item.localId))).getSingle();
        final remoteReport = await _remoteDamageReportRepository
            .getDamageReport(localReport.serverId ?? item.localId);

        await _db.transaction(() async {
          await (_db.update(
            _db.damageReports,
          )..where((t) => t.id.equals(item.localId))).write(
            DamageReportsCompanion(
              permanentFormNumber: Value(remoteReport.permanentFormNumber),
              temporaryFormNumber: Value(remoteReport.temporaryFormNumber),
              damageYear: Value(remoteReport.damageYear),
              damageDate: Value(remoteReport.damageDate),
              damageCauseCategoryId: Value(remoteReport.damageCauseCategoryId),
              damageCauseId: Value(remoteReport.damageCauseId),
              settlementName: Value(remoteReport.settlementName),
              companyName: Value(remoteReport.companyName),
              governorateId: Value(remoteReport.governorateId),
              localityId: Value(remoteReport.localityId),
              latitude: Value(remoteReport.latitude),
              longitude: Value(remoteReport.longitude),
              statusId: Value(remoteReport.statusId),
              notes: Value(remoteReport.notes),
              rowVersion: Value(remoteReport.rowVersion),
              syncStatus: const Value('completed'),
            ),
          );
          // Items might be complex to merge, overwrite local items with remote for "Server Wins"
          await (_db.delete(
            _db.damageItems,
          )..where((t) => t.damageReportId.equals(item.localId))).go();
          for (var ri in remoteReport.items) {
            await _db
                .into(_db.damageItems)
                .insert(
                  DamageItemsCompanion.insert(
                    id: ri.id,
                    serverId: Value(ri.serverId),
                    damageReportId: item.localId,
                    classificationId: Value(ri.classificationId),
                    costingSheetId: Value(ri.costingSheetId),
                    calculatedUnitPrice: Value(ri.calculatedUnitPrice),
                    measurementUnitSnapshot: Value(ri.measurementUnitSnapshot),
                    affectedArea: ri.affectedArea,
                    damagePercentage: ri.damagePercentage,
                    quantity: ri.quantity,
                    estimatedLoss: ri.estimatedLoss,
                    rowVersion: Value(ri.rowVersion),
                    syncStatus: const Value('completed'),
                  ),
                );
          }
        });
        await _db
            .update(_db.syncQueue)
            .replace(item.copyWith(status: 'completed'));
      } on SyncException catch (e) {
      await _db.update(_db.syncQueue).replace(
        item.copyWith(
          status: 'failed',
          retryCount: item.retryCount + 1,
          lastError: Value(e.toString()),
        ),
      );
      await _updateEntitySyncStatus(item.entityType, item.localId, 'failed');
    } catch (e) {
        // Log
      }
    } else if (item.entityType == 'damage_item') {
      try {
        final localItem = await (_db.select(
          _db.damageItems,
        )..where((t) => t.id.equals(item.localId))).getSingle();
        // Item get remote might need authority ID
        // Simplified: Fetch report and find item
        final remoteReport = await _remoteDamageReportRepository
            .getDamageReport(localItem.damageReportId);
        final remoteItem = remoteReport.items.firstWhere(
          (i) => i.id == localItem.serverId || i.id == localItem.id,
        );

        await (_db.update(
          _db.damageItems,
        )..where((t) => t.id.equals(item.localId))).write(
          DamageItemsCompanion(
            classificationId: Value(remoteItem.classificationId),
            costingSheetId: Value(remoteItem.costingSheetId),
            calculatedUnitPrice: Value(remoteItem.calculatedUnitPrice),
            measurementUnitSnapshot: Value(remoteItem.measurementUnitSnapshot),
            affectedArea: Value(remoteItem.affectedArea),
            damagePercentage: Value(remoteItem.damagePercentage),
            quantity: Value(remoteItem.quantity),
            estimatedLoss: Value(remoteItem.estimatedLoss),
            rowVersion: Value(remoteItem.rowVersion),
            syncStatus: const Value('completed'),
          ),
        );
        await _db
            .update(_db.syncQueue)
            .replace(item.copyWith(status: 'completed'));
      } on SyncException catch (e) {
      await _db.update(_db.syncQueue).replace(
        item.copyWith(
          status: 'failed',
          retryCount: item.retryCount + 1,
          lastError: Value(e.toString()),
        ),
      );
      await _updateEntitySyncStatus(item.entityType, item.localId, 'failed');
    } catch (e) {
        // Log
      }
    }
  }

  // --- ID RESOLUTION HELPERS (Late Binding) ---

  Future<String?> _resolveFarmerId(String localId) async {
    final farmer = await (_db.select(_db.farmers)..where((t) => t.id.equals(localId))).getSingleOrNull();
    if (farmer == null) {
      // Not found in local DB. Assume it's already a server ID (e.g. from previously synced session)
      return localId;
    }
    // Found locally. If serverId exists, use it. If not, it's a pending dependency.
    return farmer.serverId;
  }

  Future<String?> _resolveFarmId(String localId) async {
    final farm = await (_db.select(_db.farms)..where((t) => t.id.equals(localId))).getSingleOrNull();
    if (farm == null) return localId;
    return farm.serverId;
  }

  Future<String?> _resolveDamageReportId(String localId) async {
    final report = await (_db.select(_db.damageReports)..where((t) => t.id.equals(localId))).getSingleOrNull();
    if (report == null) return localId;
    return report.serverId;
  }
}
