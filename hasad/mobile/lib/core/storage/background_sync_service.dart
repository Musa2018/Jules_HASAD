import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farmer.dart' as domain;
import 'package:uuid/uuid.dart';

class BackgroundSyncService {
  final AppDatabase _db;
  final FarmerRepository _remoteRepository;
  final Connectivity _connectivity;
  
  StreamSubscription? _connectivitySubscription;
  bool _isProcessing = false;

  BackgroundSyncService(this._db, this._remoteRepository, this._connectivity) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
      if (results.any((result) => result != ConnectivityResult.none)) {
        processQueue();
      }
    });
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }

  Future<void> addToQueue({
    required String localId,
    required String entityType,
    required String operation,
    required Map<String, dynamic> data,
  }) async {
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
    processQueue();
  }

  Future<void> processQueue() async {
    if (_isProcessing) return;
    
    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity.any((result) => result == ConnectivityResult.none)) return;

    _isProcessing = true;
    try {
      final pendingItems = await (_db.select(_db.syncQueue)
            ..where((t) => t.status.equals('pending') | t.status.equals('failed'))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

      for (final item in pendingItems) {
        if (item.retryCount >= 5) continue; // Max retries

        await _processItem(item);
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _processItem(SyncQueueData item) async {
    try {
      await _db.update(_db.syncQueue).replace(item.copyWith(status: 'syncing'));

      if (item.entityType == 'farmer') {
        await _syncFarmer(item);
      }

      await _db.update(_db.syncQueue).replace(item.copyWith(status: 'completed'));
    } on FarmerException catch (e) {
      if (e.errors.any((err) => err.contains('CONFLICT'))) {
        await _resolveConflict(item);
      } else {
        await _db.update(_db.syncQueue).replace(
          item.copyWith(
            status: 'failed',
            retryCount: item.retryCount + 1,
            lastError: Value(e.toString()),
          ),
        );
      }
    } catch (e) {
      await _db.update(_db.syncQueue).replace(
        item.copyWith(
          status: 'failed',
          retryCount: item.retryCount + 1,
          lastError: Value(e.toString()),
        ),
      );
    }
  }

  Future<void> _syncFarmer(SyncQueueData item) async {
    final data = jsonDecode(item.data) as Map<String, dynamic>;
    final farmer = domain.Farmer.fromJson(data);

    if (item.operation == 'create') {
      final result = await _remoteRepository.createFarmer(farmer);
      await (_db.update(_db.farmers)..where((t) => t.id.equals(item.localId))).write(
        FarmersCompanion(
          serverId: Value(result.id),
          rowVersion: Value(result.rowVersion),
          syncStatus: const Value('completed'),
        ),
      );
    } else if (item.operation == 'update') {
      final result = await _remoteRepository.updateFarmer(farmer);
      await (_db.update(_db.farmers)..where((t) => t.id.equals(item.localId))).write(
        FarmersCompanion(
          rowVersion: Value(result.rowVersion),
          syncStatus: const Value('completed'),
        ),
      );
    } else if (item.operation == 'delete') {
       // Best effort delete on remote
       await _remoteRepository.deleteFarmer(item.localId);
    }
  }

  Future<void> _resolveConflict(SyncQueueData item) async {
    if (item.entityType == 'farmer') {
      // Server Wins: Fetch the remote record and overwrite local
      try {
        final remoteFarmer = await _remoteRepository.getFarmer(item.localId);
        await (_db.update(_db.farmers)..where((t) => t.id.equals(item.localId))).write(
          FarmersCompanion(
            name: Value(remoteFarmer.name),
            nationalId: Value(remoteFarmer.nationalId),
            phoneNumber: Value(remoteFarmer.phoneNumber),
            address: Value(remoteFarmer.address),
            rowVersion: Value(remoteFarmer.rowVersion),
            syncStatus: const Value('completed'),
          ),
        );
        // Mark sync item as completed since we've resolved it
        await _db.update(_db.syncQueue).replace(item.copyWith(status: 'completed'));
      } catch (e) {
        // If resolution fails, keep as failed to retry later
        await _db.update(_db.syncQueue).replace(
          item.copyWith(
            status: 'failed',
            lastError: Value('Conflict resolution failed: $e'),
          ),
        );
      }
    }
  }
}
