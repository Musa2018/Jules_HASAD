import 'package:drift/drift.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/data/farm_repository.dart';
import 'package:mobile/features/farmers/domain/farm.dart' as domain;
import 'package:uuid/uuid.dart';

class OfflineFirstFarmRepository implements FarmRepository {
  final AppDatabase _db;
  final BackgroundSyncService _syncService;

  OfflineFirstFarmRepository(this._db, this._syncService);

  @override
  Future<List<domain.Farm>> getFarmsByFarmer(String farmerId) async {
    final items =
        await (_db.select(_db.farms)
              ..where((t) => t.farmerId.equals(farmerId) & t.isPendingDelete.equals(false))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();

    return items
        .map(
          (e) => domain.Farm(
            id: e.id,
            serverId: e.serverId,
            farmerId: e.farmerId,
            name: e.name,
            governorateId: e.governorateId,
            localityId: e.localityId,
            landArea: e.landArea,
            landAreaUnit: e.landAreaUnit,
            latitude: e.latitude,
            longitude: e.longitude,
            ownershipTypeId: e.ownershipTypeId,
            rowVersion: e.rowVersion,
            syncStatus: e.syncStatus,
            lastSyncError: e.lastSyncError,
          ),
        )
        .toList();
  }

  @override
  Future<domain.Farm> getFarm(String id) async {
    final e = await (_db.select(
      _db.farms,
    )..where((t) => t.id.equals(id))).getSingle();
    return domain.Farm(
      id: e.id,
      serverId: e.serverId,
      farmerId: e.farmerId,
      name: e.name,
      governorateId: e.governorateId,
      localityId: e.localityId,
      landArea: e.landArea,
      landAreaUnit: e.landAreaUnit,
      latitude: e.latitude,
      longitude: e.longitude,
      ownershipTypeId: e.ownershipTypeId,
      rowVersion: e.rowVersion,
      syncStatus: e.syncStatus,
      lastSyncError: e.lastSyncError,
    );
  }

  FarmsCompanion _mapToCompanion(domain.Farm farm) {
    return FarmsCompanion.insert(
      id: farm.id,
      serverId: Value(farm.serverId),
      farmerId: farm.farmerId,
      name: farm.name,
      governorateId: farm.governorateId,
      localityId: farm.localityId,
      landArea: farm.landArea,
      landAreaUnit: farm.landAreaUnit,
      latitude: Value(farm.latitude),
      longitude: Value(farm.longitude),
      ownershipTypeId: farm.ownershipTypeId,
      rowVersion: Value(farm.rowVersion),
      lastSyncError: Value(farm.lastSyncError),
    );
  }

  @override
  Future<domain.Farm> createFarm(domain.Farm farm) async {
    final localId = farm.id.isEmpty ? const Uuid().v4() : farm.id;
    final companion = _mapToCompanion(farm).copyWith(
      id: Value(localId),
      syncStatus: const Value('pending'),
    );

    await _db.into(_db.farms).insert(companion);

    final createdFarm = farm.copyWith(id: localId);

    await _syncService.addToQueue(
      localId: localId,
      entityType: 'farm',
      operation: 'create',
      data: createdFarm.toJson(),
    );

    return createdFarm;
  }

  @override
  Future<domain.Farm> updateFarm(domain.Farm farm) async {
    await (_db.update(_db.farms)..where((t) => t.id.equals(farm.id))).write(
      _mapToCompanion(farm).copyWith(
        syncStatus: const Value('pending'),
        lastSyncError: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _syncService.addToQueue(
      localId: farm.id,
      entityType: 'farm',
      operation: 'update',
      data: farm.toJson(),
    );

    return farm;
  }

  @override
  Future<void> deleteFarm(String id) async {
    final local = await (_db.select(_db.farms)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (local == null) return;

    await (_db.update(_db.farms)..where((t) => t.id.equals(id))).write(
      const FarmsCompanion(
        isPendingDelete: Value(true),
        syncStatus: Value('pending'),
      ),
    );

    await _syncService.addToQueue(
      localId: id,
      entityType: 'farm',
      operation: 'delete',
      data: {
        'id': local.serverId ?? local.id,
        'serverId': local.serverId,
        'clientId': local.id,
      },
    );
  }
}
