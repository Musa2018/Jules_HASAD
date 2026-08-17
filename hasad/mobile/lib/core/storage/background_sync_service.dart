import 'dart:async';
// ignore_for_file: deprecated_member_use_from_same_package
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/utils/debug_logger.dart';
import 'package:mobile/features/damage_reports/data/dto/damage_report_sync_dto.dart';
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
import 'package:mobile/features/damage_reports/domain/models/damage_workflow_history.dart' as domain_history;
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
            (t) => Expression.or([
                t.status.equals('pending'),
                t.status.equals('failed'),
                t.status.equals('invalid'),
            ]),
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
      // CRITICAL: We MUST also preserve the 'create' operation if the new operation is 'workflow_action'.
      // If we overwrite 'create' with 'workflow_action', we lose the entity data and sync will fail with 404/dependency error.
      final finalOperation =
          existing.operation == 'create' && (operation == 'update' || operation == 'workflow_action')
              ? 'create'
              : operation;

      // 3. For 'create' entities, if a workflow action is added, we should merge the action into the data
      // so that _syncDamageReport can handle both create and immediate submission if needed.
      Map<String, dynamic> mergedData = Map.from(data);
      if (existing.operation == 'create' && operation == 'workflow_action') {
        final existingData = jsonDecode(existing.data) as Map<String, dynamic>;
        mergedData = Map.from(existingData);
        mergedData['pendingWorkflowAction'] = data; // Action: submit/transition + metadata
      }

      await (_db.update(_db.syncQueue)
            ..where((t) => t.id.equals(existing.id)))
          .write(
            SyncQueueCompanion(
              operation: Value(finalOperation),
              data: Value(jsonEncode(mergedData)),
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
                  final isPendingOrFailed = Expression.or([
                      t.status.equals('pending'),
                      t.status.equals('failed'),
                  ]);
                  // On startup, we include all 'syncing' items for recovery.
                  // During session, we only include 'syncing' items that are "stuck" (> 5 mins).
                  final isStuckSyncing = Expression.and([
                      t.status.equals('syncing'),
                      isStartup
                          ? const Constant(true)
                          : t.lastAttemptAt.isSmallerThanValue(
                            now.subtract(const Duration(minutes: 5)),
                          )
                  ]);
                  return Expression.or([isPendingOrFailed, isStuckSyncing]);
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
    // 1. Verify item still exists (it might have been pruned by a preceding bulk sync task)
    final fresh = await (_db.select(_db.syncQueue)..where((t) => t.id.equals(item.id))).getSingleOrNull();
    if (fresh == null) {
      if (DebugLogger.enableSyncDebug) {
        DebugLogger.log('Sync task ${item.id} (${item.entityType}) no longer exists. Skipping.');
      }
      return;
    }

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
        if (item.operation == 'workflow_action') {
          await _syncDamageReportWorkflow(item);
        } else {
          await _syncDamageReport(item);
        }
      } else if (item.entityType == 'damage_item') {
        await _syncDamageItem(item);
      } else if (item.entityType == 'attachment') {
        await _syncAttachment(item);
      }

      await _db
          .update(_db.syncQueue)
          .replace(item.copyWith(
            status: 'completed', 
            lastError: const Value(null),
            retryCount: 0,
            lastAttemptAt: Value(now),
          ));
      await _updateEntitySyncStatus(item.entityType, item.localId, 'completed', error: null);
    } on SyncNotFoundException catch (e) {
      // For NON-DELETE operations, 404 is an error.
      // For DELETE, it is handled within the sync method itself to allow cleanup.
      await _db.update(_db.syncQueue).replace(
        item.copyWith(status: 'failed', lastError: Value(e.toString())),
      );
      await _updateEntitySyncStatus(
        item.entityType,
        item.localId,
        'failed',
        error: e.toString(),
      );
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
      final isDependencyConflict = e.code == 'FARMER_HAS_DEPENDENCIES' || e.code == 'FARM_HAS_DEPENDENCIES';
      
      final errorMessage = e.code == 'DAMAGE_REPORT_DUPLICATE' 
          ? 'duplicateReportError' 
          : e.toString();

      await _db.update(_db.syncQueue).replace(
        item.copyWith(status: 'conflict', lastError: Value(errorMessage)),
      );

      if (item.operation == 'delete' && isDependencyConflict) {
        await _updateEntitySyncStatus(
          item.entityType,
          item.localId,
          'conflict',
          error: errorMessage,
          clearPendingDelete: true,
        );
      } else {
        await _updateEntitySyncStatus(item.entityType, item.localId, 'conflict', error: errorMessage);
        
        // For new entities (create), do NOT automatically resolve conflicts.
        // Let the user decide how to handle the duplicate.
        if (item.operation != 'create') {
          await _resolveConflict(item);
        }
      }
    } on FarmerException catch (e) {
      if (e.errors.any((err) => err.contains('CONFLICT'))) {
        await _db.update(_db.syncQueue).replace(
          item.copyWith(status: 'conflict', lastError: Value(e.toString())),
        );
        await _updateEntitySyncStatus(item.entityType, item.localId, 'conflict', error: e.toString());
        if (item.operation != 'create') {
          await _resolveConflict(item);
        }
      } else {
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
      }
    } on FarmException catch (e) {
      if (e.errors.any((err) => err.contains('CONFLICT'))) {
        await _db.update(_db.syncQueue).replace(
          item.copyWith(status: 'conflict', lastError: Value(e.toString())),
        );
        await _updateEntitySyncStatus(item.entityType, item.localId, 'conflict', error: e.toString());
        if (item.operation != 'create') {
          await _resolveConflict(item);
        }
      } else {
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
      }
    } on DamageReportException catch (e) {
      if (e.errors.any((err) => err.contains('CONFLICT'))) {
        await _db.update(_db.syncQueue).replace(
          item.copyWith(status: 'conflict', lastError: Value(e.toString())),
        );
        await _updateEntitySyncStatus(item.entityType, item.localId, 'conflict', error: e.toString());
        if (item.operation != 'create') {
          await _resolveConflict(item);
        }
      } else {
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
      }
    } on SyncException catch (e) {
      final errorMessage = e.toString();
      DebugLogger.log('SyncException during _processItem: $errorMessage');
      
      await _db.update(_db.syncQueue).replace(
        item.copyWith(
          status: 'failed',
          retryCount: item.retryCount + 1,
          lastAttemptAt: Value(now),
          lastError: Value(errorMessage),
        ),
      );
      await _updateEntitySyncStatus(
        item.entityType,
        item.localId,
        'failed',
        error: errorMessage,
      );
    } catch (e, stackTrace) {
      final errorMessage = e.toString();
      if (DebugLogger.enableSyncDebug) {
        DebugLogger.logHeader('SYNC ERROR TRACE');
        DebugLogger.log('Exception Type: ${e.runtimeType}');
        DebugLogger.log('Message: $errorMessage');
        DebugLogger.log('Stack Trace:\n$stackTrace');
        DebugLogger.logFooter();
      }
      
      await _db.update(_db.syncQueue).replace(
        item.copyWith(
          status: 'failed',
          retryCount: item.retryCount + 1,
          lastAttemptAt: Value(now),
          lastError: Value(errorMessage),
        ),
      );
      await _updateEntitySyncStatus(
        item.entityType,
        item.localId,
        'failed',
        error: errorMessage,
      );
    }
  }

  Future<void> _updateEntitySyncStatus(
    String entityType,
    String localId,
    String status, {
    String? error,
    bool clearPendingDelete = false,
  }) async {
    final pendingDelete = clearPendingDelete ? const Value(false) : const Value<bool>.absent();

    if (entityType == 'farmer') {
      await (_db.update(_db.farmers)..where((t) => t.id.equals(localId))).write(
        FarmersCompanion(
          syncStatus: Value(status),
          lastSyncError: Value(error),
          isPendingDelete: pendingDelete,
        ),
      );
    } else if (entityType == 'farm') {
      await (_db.update(_db.farms)..where((t) => t.id.equals(localId))).write(
        FarmsCompanion(
          syncStatus: Value(status),
          lastSyncError: Value(error),
          isPendingDelete: pendingDelete,
        ),
      );
    } else if (entityType == 'damage_report') {
      await (_db.update(
        _db.damageReports,
      )..where((t) => t.id.equals(localId))).write(
        DamageReportsCompanion(
          syncStatus: Value(status),
          lastSyncError: Value(error),
          isPendingDelete: pendingDelete,
        ),
      );
    } else if (entityType == 'damage_item') {
      await (_db.update(
        _db.damageItems,
      )..where((t) => t.id.equals(localId))).write(
        DamageItemsCompanion(
          syncStatus: Value(status),
          lastSyncError: Value(error),
          isPendingDelete: pendingDelete,
        ),
      );
    } else if (entityType == 'attachment') {
      await (_db.update(
        _db.damageReportAttachments,
      )..where((t) => t.id.equals(localId))).write(
        DamageReportAttachmentsCompanion(
          syncStatus: Value(status),
          lastSyncError: Value(error),
          isPendingDelete: pendingDelete,
        ),
      );
    }
  }

  Future<void> _syncAttachment(SyncQueueData item) async {
    final data = jsonDecode(item.data) as Map<String, dynamic>;

    if (item.operation == 'delete') {
      final serverId = data['serverId'] ?? data['id'];
      final clientId = data['clientId'] ?? item.localId;

      _logDeleteAttempt(item, serverId, clientId);

      if (serverId != null) {
        try {
          await _remoteAttachmentRepository.deleteAttachment(serverId.toString());
        } on SyncNotFoundException {
          DebugLogger.log('DELETE 404 handled: Attachment $serverId already deleted on server.');
        } catch (e) {
          rethrow;
        }
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
          serverId: Value(result.serverId ?? result.id), 
          damageReportId: Value(attachment.damageReportId),
          remotePath: Value(result.remotePath),
          uploadStatus: const Value('completed'),
          syncStatus: const Value('completed'),
          lastSyncError: const Value(null),
        ),
      );
    }
  }

  Future<void> _syncFarmer(SyncQueueData item) async {
    final data = jsonDecode(item.data) as Map<String, dynamic>;

    if (item.operation == 'delete') {
      final serverId = data['serverId'] ?? data['id'];
      final clientId = data['clientId'] ?? item.localId;
      
      _logDeleteAttempt(item, serverId, clientId);

      if (serverId != null) {
        try {
          await _remoteFarmerRepository.deleteFarmer(serverId.toString());
        } on SyncNotFoundException {
          // If we have a serverId and it 404s, it means it's already deleted.
          DebugLogger.log('DELETE 404 handled: Farmer $serverId already deleted on server.');
        } catch (e) {
          rethrow;
        }
      } else {
        DebugLogger.log('DELETE skipped remote: Farmer $clientId has no serverId.');
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
      final clientId = data['clientId'] ?? item.localId;

      _logDeleteAttempt(item, serverId, clientId);

      if (serverId != null) {
        try {
          await _remoteFarmRepository.deleteFarm(serverId.toString());
        } on SyncNotFoundException {
          DebugLogger.log('DELETE 404 handled: Farm $serverId already deleted on server.');
        } catch (e) {
          rethrow;
        }
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
          farmerId: Value(farm.farmerId),
          ownerFarmerId: Value(farm.ownerFarmerId),
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
      final clientId = data['clientId'] ?? item.localId;

      _logDeleteAttempt(item, serverId, clientId);

      if (serverId != null) {
        try {
          await _remoteDamageReportRepository.deleteDamageReport(serverId.toString());
        } on SyncNotFoundException {
          DebugLogger.log('DELETE 404 handled: Damage Report $serverId already deleted on server.');
        } catch (e) {
          rethrow;
        }
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

    final farm = await (_db.select(_db.farms)..where((t) => t.id.equals(originalFarmId))).getSingleOrNull();
    final report = report_domain.DamageReport.fromJson(data);

    if (item.operation == 'create') {
      final payload = DamageReportSyncDto.toCreateJson(
        report, 
        latitude: farm?.latitude, 
        longitude: farm?.longitude
      );
      final result = await _remoteDamageReportRepository.createDamageReportFromJson(payload);
      
      // If there was a pending workflow action (e.g. submit) that was merged during offline edit, 
      // execute it now after successful creation.
      final serverId = result.serverId;
      if (data.containsKey('pendingWorkflowAction') && serverId != null) {
        final actionData = data['pendingWorkflowAction'] as Map<String, dynamic>;
        try {
          if (actionData['action'] == 'submit') {
            await _remoteDamageReportRepository.submitReport(serverId);
          } else if (actionData['action'] == 'transition') {
            await _remoteDamageReportRepository.transitionReport(
              serverId,
              actionData['toStatus'] as String,
              comment: actionData['comment'] as String?,
              isOverride: actionData['isOverride'] as bool? ?? false,
            );
          }
        } catch (e) {
          // If the workflow action fails, we still consider the 'create' part successful 
          // but we might need to add the workflow action back to the queue.
          // For now, we'll let it fail and the user can retry the action.
          DebugLogger.log('Post-create workflow action failed: $e');
        }
      }

      await _db.transaction(() async {
        await (_db.update(
          _db.damageReports,
        )..where((t) => t.id.equals(item.localId))).write(
          DamageReportsCompanion(
            serverId: Value(result.serverId),
            farmId: Value(report.farmId),
            farmerId: Value(report.farmerId),
            reportNumber: Value(result.reportNumber),
            permanentFormNumber: Value(result.permanentFormNumber),
            rowVersion: Value(result.rowVersion),
            syncStatus: const Value('completed'),
            lastSyncError: const Value(null),
            updatedAt: Value(DateTime.now()),
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
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      });

      // --- PERSIST HISTORY ---
      final syncServerId = result.serverId;
      if (syncServerId != null) {
        try {
          final history = await _remoteDamageReportRepository.getReportHistory(syncServerId);
          await _persistHistory(item.localId, history);
        } catch (e) {
          DebugLogger.log('Error fetching history after sync: $e');
        }
      }

      // Cleanup redundant item tasks after bulk creation
      // Only prune items that were actually included in the successful creation payload
      final syncedItemIds = report.items.map((i) => i.id).toList();
      await _pruneDamageItemTasks(item.localId, specificItemIds: syncedItemIds);
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
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<void> _syncDamageReportWorkflow(SyncQueueData item) async {
    final data = jsonDecode(item.data) as Map<String, dynamic>;
    final originalReportId = item.localId;
    final resolvedReportId = await _resolveDamageReportId(originalReportId);

    if (DebugLogger.enableSyncDebug) {
      DebugLogger.log('Starting Workflow Sync for Report: $originalReportId (Server: $resolvedReportId)');
      DebugLogger.log('Workflow Action: ${data['action']}');
    }

    if (resolvedReportId == null) {
      throw SyncDependencyException(
          ['Waiting for Damage Report ($originalReportId) to synchronize.']);
    }

    try {
      if (data['action'] == 'submit') {
        await _remoteDamageReportRepository.submitReport(resolvedReportId);
      } else if (data['action'] == 'transition') {
        await _remoteDamageReportRepository.transitionReport(
          resolvedReportId,
          data['toStatus'] as String,
          comment: data['comment'] as String?,
          isOverride: data['isOverride'] as bool? ?? false,
        );
      }
    } on SyncException catch (e) {
      // Idempotency: Handle cases where the action was already performed on the server.
      final errorStr = e.toString();
      final isAlreadySubmitted = errorStr.contains('Only draft or pending reports can be submitted');
      final isInvalidTransition = errorStr.contains('Invalid transition');
      
      if (isAlreadySubmitted || isInvalidTransition) {
        if (DebugLogger.enableSyncDebug) {
          DebugLogger.log('Workflow action rejected by server: $errorStr. Verifying current state...');
        }
        // We will proceed to refresh the report from the server.
        // If the server status matches our expectation, we treat it as success.
      } else {
        rethrow;
      }
    }

    // Refresh history and report state after successful transition (or if already processed)
    if (DebugLogger.enableSyncDebug) {
      DebugLogger.log('Workflow action successful or already processed, refreshing report and history for $originalReportId...');
    }

    try {
      final updatedReport = await _remoteDamageReportRepository.getDamageReport(resolvedReportId);
      
      await _db.transaction(() async {
        if (DebugLogger.enableSyncDebug) {
          DebugLogger.log('Updating local status to: ${updatedReport.statusId} for $originalReportId');
        }

        // Update report status and metadata
        await (_db.update(_db.damageReports)
              ..where((t) => t.id.equals(item.localId)))
            .write(
          DamageReportsCompanion(
            serverId: Value(updatedReport.serverId),
            reportNumber: Value(updatedReport.reportNumber),
            permanentFormNumber: Value(updatedReport.permanentFormNumber),
            statusId: Value(updatedReport.statusId),
            totalDamage: Value(updatedReport.totalDamage),
            rowVersion: Value(updatedReport.rowVersion),
            syncStatus: const Value('completed'),
            lastSyncError: const Value(null),
            updatedAt: Value(DateTime.now()),
          ),
        );
      });

      // --- PERSIST HISTORY ---
      final history = await _remoteDamageReportRepository.getReportHistory(resolvedReportId);
      if (DebugLogger.enableSyncDebug) {
        DebugLogger.log('Fetched ${history.length} history items for $originalReportId');
      }
      await _persistHistory(item.localId, history);

    } catch (e) {
      if (DebugLogger.enableSyncDebug) {
        DebugLogger.log('Error during post-workflow data refresh for $originalReportId: $e');
      }
      // If refresh fails, we still consider the workflow action successful if it reached here
      // but we update the entity status with the error so user knows data might be stale
      await _updateEntitySyncStatus(
        item.entityType, 
        item.localId, 
        'failed', 
        error: 'Workflow successful but failed to refresh data: $e'
      );
      rethrow; // Rethrow to mark the queue item as failed so it retries the refresh
    }

    if (DebugLogger.enableSyncDebug) {
      DebugLogger.log('Workflow Sync Completed Successfully for Report: $originalReportId');
    }
  }

  Future<void> _syncDamageItem(SyncQueueData item) async {
    final data = jsonDecode(item.data) as Map<String, dynamic>;

    if (item.operation == 'delete') {
      final serverId = data['serverId'] ?? data['id'];
      final clientId = data['clientId'] ?? item.localId;

      _logDeleteAttempt(item, serverId, clientId);

      if (serverId != null) {
        try {
          await _remoteDamageReportRepository.deleteDamageItem(serverId.toString());
        } on SyncNotFoundException {
          DebugLogger.log('DELETE 404 handled: Damage Item $serverId already deleted on server.');
        } catch (e) {
          rethrow;
        }
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
          updatedAt: Value(DateTime.now()),
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
          updatedAt: Value(DateTime.now()),
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
            lastSyncError: const Value(null),
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
            lastSyncError: const Value(null),
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
              damageDate: Value(remoteReport.damageDate ?? DateTime.now()),
              damageCauseCategoryId: Value(remoteReport.damageCauseCategoryId),
              damageCauseId: Value(remoteReport.damageCauseId),
              farmerId: Value(remoteReport.farmerId),
              governorateId: Value(remoteReport.governorateId),
              directorateId: Value(remoteReport.directorateId),
              localityId: Value(remoteReport.localityId),
              statusId: Value(remoteReport.statusId),
              totalDamage: Value(remoteReport.totalDamage),
              notes: Value(remoteReport.notes),
              rowVersion: Value(remoteReport.rowVersion),
              syncStatus: const Value('completed'),
              lastSyncError: const Value(null),
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
            lastSyncError: const Value(null),
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
    final farmer = await (_db.select(_db.farmers)..where((t) => t.id.lower().equals(localId.toLowerCase()))).getSingleOrNull();
    if (farmer == null) {
      // Not found in local DB. Assume it's already a server ID (e.g. from previously synced session)
      return localId;
    }
    // Found locally. If serverId exists, use it. If not, it's a pending dependency.
    return farmer.serverId;
  }

  Future<String?> _resolveFarmId(String localId) async {
    final farm = await (_db.select(_db.farms)..where((t) => t.id.lower().equals(localId.toLowerCase()))).getSingleOrNull();
    if (farm == null) return localId;
    return farm.serverId;
  }

  Future<String?> _resolveDamageReportId(String localId) async {
    final report = await (_db.select(_db.damageReports)..where((t) => t.id.lower().equals(localId.toLowerCase()))).getSingleOrNull();
    if (report == null) return localId;
    return report.serverId;
  }

  Future<void> _pruneDamageItemTasks(String reportId, {List<String>? specificItemIds}) async {
    try {
      final List<String> itemIds;
      if (specificItemIds != null) {
        itemIds = specificItemIds;
      } else {
        final items = await (_db.select(_db.damageItems)
              ..where((t) => t.damageReportId.equals(reportId)))
            .get();
        itemIds = items.map((i) => i.id).toList();
      }

      if (itemIds.isNotEmpty) {
        final count = await (_db.delete(_db.syncQueue)
              ..where((t) =>
                  t.entityType.equals('damage_item') & t.localId.isIn(itemIds)))
            .go();
        if (DebugLogger.enableSyncDebug) {
          DebugLogger.log('Pruned $count redundant damage_item tasks for Report $reportId');
        }
      }
    } catch (e) {
      DebugLogger.log('Error pruning damage_item tasks: $e');
    }
  }

  void _logDeleteAttempt(SyncQueueData item, dynamic serverId, dynamic clientId) {
    DebugLogger.logHeader('DELETE SYNC ATTEMPT');
    DebugLogger.log('Operation ID: ${item.id}');
    DebugLogger.log('Entity Type: ${item.entityType}');
    DebugLogger.log('Local ID: ${item.localId}');
    DebugLogger.log('Mapped Server ID: $serverId');
    DebugLogger.log('Mapped Client ID: $clientId');
    DebugLogger.logFooter();
  }

  Future<void> _persistHistory(String localReportId, List<domain_history.DamageWorkflowHistory> history) async {
    for (var h in history) {
      final serverIdValue = h.serverId;
      if (serverIdValue == null) continue;

      final existing = await (_db.select(_db.damageWorkflowHistories)
            ..where((t) => t.serverId.equals(serverIdValue)))
          .getSingleOrNull();

      final companion = DamageWorkflowHistoriesCompanion.insert(
        id: existing?.id ?? const Uuid().v4(),
        serverId: Value(serverIdValue),
        damageReportId: localReportId,
        fromStatus: h.fromStatus,
        toStatus: h.toStatus,
        changedByUserId: h.changedByUserId,
        changedByUserName: Value(h.changedByUserName),
        changedAt: h.changedAt ?? DateTime.now(),
        comment: Value(h.comment),
        isOverride: Value(h.isOverride),
      );

      await _db.into(_db.damageWorkflowHistories).insertOnConflictUpdate(companion);
    }

    // Optional: Cleanup local records for this report that are NOT in the server response
    final serverIds = history.map((h) => h.serverId).whereType<String>().toList();
    if (serverIds.isNotEmpty) {
      await (_db.delete(_db.damageWorkflowHistories)
            ..where((t) => t.damageReportId.equals(localReportId) & t.serverId.isNotIn(serverIds)))
          .go();
    }
  }
}
