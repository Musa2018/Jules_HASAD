import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/data/farm_repository.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farm.dart' as farm_domain;
import 'package:mobile/features/farmers/domain/farmer.dart' as domain;
import 'package:uuid/uuid.dart';

class BackgroundSyncService {
  final AppDatabase _db;
  final FarmerRepository _remoteFarmerRepository;
  final FarmRepository _remoteFarmRepository;
  final Connectivity _connectivity;
  
  StreamSubscription? _connectivitySubscription;
  bool _isProcessing = false;

  BackgroundSyncService(
    this._db, 
    this._remoteFarmerRepository, 
    this._remoteFarmRepository,
    this._connectivity
  ) {
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
      final now = DateTime.now();
      final pendingItems = await (_db.select(_db.syncQueue)
            ..where((t) => t.status.equals('pending') | t.status.equals('failed'))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

      for (final item in pendingItems) {
        if (item.retryCount >= 3) continue;

        // Simple backoff: 0, 5, 15 minutes
        if (item.lastAttemptAt != null) {
          final waitMinutes = item.retryCount == 1 ? 5 : (item.retryCount == 2 ? 15 : 0);
          if (now.difference(item.lastAttemptAt!).inMinutes < waitMinutes) {
            continue;
          }
        }

        await _processItem(item);
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _processItem(SyncQueueData item) async {
    final now = DateTime.now();
    try {
      await _db.update(_db.syncQueue).replace(
        item.copyWith(status: 'syncing', lastAttemptAt: Value(now))
      );

      if (item.entityType == 'farmer') {
        await _syncFarmer(item);
      } else if (item.entityType == 'farm') {
        await _syncFarm(item);
      }

      await _db.update(_db.syncQueue).replace(item.copyWith(status: 'completed'));
    } on FarmerException catch (e) {
      if (e.errors.any((err) => err.contains('CONFLICT'))) {
        await _db.update(_db.syncQueue).replace(
          item.copyWith(status: 'conflict', lastError: Value(e.toString()))
        );
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
    } on FarmException catch (e) {
      if (e.errors.any((err) => err.contains('CONFLICT'))) {
        await _db.update(_db.syncQueue).replace(
          item.copyWith(status: 'conflict', lastError: Value(e.toString()))
        );
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
      final result = await _remoteFarmerRepository.createFarmer(farmer);
      await (_db.update(_db.farmers)..where((t) => t.id.equals(item.localId))).write(
        FarmersCompanion(
          serverId: Value(result.id),
          rowVersion: Value(result.rowVersion),
          syncStatus: const Value('completed'),
        ),
      );
    } else if (item.operation == 'update') {
      final result = await _remoteFarmerRepository.updateFarmer(farmer);
      await (_db.update(_db.farmers)..where((t) => t.id.equals(item.localId))).write(
        FarmersCompanion(
          rowVersion: Value(result.rowVersion),
          syncStatus: const Value('completed'),
        ),
      );
    } else if (item.operation == 'delete') {
       final localFarmer = await (_db.select(_db.farmers)..where((t) => t.id.equals(item.localId))).getSingleOrNull();
       if (localFarmer?.serverId != null) {
         await _remoteFarmerRepository.deleteFarmer(localFarmer!.serverId!);
       }
    }
  }

  Future<void> _syncFarm(SyncQueueData item) async {
    final data = jsonDecode(item.data) as Map<String, dynamic>;
    final farm = farm_domain.Farm.fromJson(data);

    if (item.operation == 'create') {
      final result = await _remoteFarmRepository.createFarm(farm);
      await (_db.update(_db.farms)..where((t) => t.id.equals(item.localId))).write(
        FarmsCompanion(
          serverId: Value(result.id),
          rowVersion: Value(result.rowVersion),
          syncStatus: const Value('completed'),
        ),
      );
    } else if (item.operation == 'update') {
      final result = await _remoteFarmRepository.updateFarm(farm);
      await (_db.update(_db.farms)..where((t) => t.id.equals(item.localId))).write(
        FarmsCompanion(
          rowVersion: Value(result.rowVersion),
          syncStatus: const Value('completed'),
        ),
      );
    } else if (item.operation == 'delete') {
       final localFarm = await (_db.select(_db.farms)..where((t) => t.id.equals(item.localId))).getSingleOrNull();
       if (localFarm?.serverId != null) {
         await _remoteFarmRepository.deleteFarm(localFarm!.serverId!);
       }
    }
  }

  Future<void> _resolveConflict(SyncQueueData item) async {
    if (item.entityType == 'farmer') {
      try {
        final localFarmer = await (_db.select(_db.farmers)..where((t) => t.id.equals(item.localId))).getSingle();
        final remoteFarmer = await _remoteFarmerRepository.getFarmer(localFarmer.serverId ?? item.localId);
        
        // Server Wins: Update local record with remote data
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
        
        await _db.update(_db.syncQueue).replace(item.copyWith(status: 'completed'));
      } catch (e) {
        // Log failure to resolve
      }
    } else if (item.entityType == 'farm') {
      try {
        final localFarm = await (_db.select(_db.farms)..where((t) => t.id.equals(item.localId))).getSingle();
        final remoteFarm = await _remoteFarmRepository.getFarm(localFarm.serverId ?? item.localId);
        
        await (_db.update(_db.farms)..where((t) => t.id.equals(item.localId))).write(
          FarmsCompanion(
            name: Value(remoteFarm.name),
            governorateId: Value(remoteFarm.governorateId),
            localityId: Value(remoteFarm.localityId),
            landArea: Value(remoteFarm.landArea),
            landAreaUnit: Value(remoteFarm.landAreaUnit),
            latitude: Value(remoteFarm.latitude),
            longitude: Value(remoteFarm.longitude),
            ownershipTypeId: Value(remoteFarm.ownershipTypeId),
            rowVersion: Value(remoteFarm.rowVersion),
            syncStatus: const Value('completed'),
          ),
        );
        
        await _db.update(_db.syncQueue).replace(item.copyWith(status: 'completed'));
      } catch (e) {
        // Log
      }
    }
  }
}
