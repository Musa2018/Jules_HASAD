import 'package:drift/drift.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/farms/domain/farm.dart' as domain;
import 'package:uuid/uuid.dart';

class OfflineFirstFarmRepository implements FarmRepository {
  final AppDatabase _db;
  final BackgroundSyncService _syncService;

  OfflineFirstFarmRepository(this._db, this._syncService);

  @override
  Future<List<domain.Farm>> getFarmsByFarmer(String farmerId) async {
    final items = await (_db.select(_db.farms)
          ..where((t) =>
              t.farmerId.equals(farmerId) & t.isPendingDelete.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();

    return items.map((e) => _mapToDomain(e)).toList();
  }

  @override
  Future<domain.Farm> getFarm(String id) async {
    final e = await (_db.select(_db.farms)..where((t) => t.id.equals(id)))
        .getSingle();
    return _mapToDomain(e);
  }

  domain.Farm _mapToDomain(FarmLocal e) {
    return domain.Farm(
      id: e.id,
      serverId: e.serverId,
      farmerId: e.farmerId,
      ownerFarmerId: e.ownerFarmerId,
      localFarmName: e.localFarmName,
      ownershipTypeId: e.ownershipTypeId,
      relationshipToOwnerId: e.relationshipToOwnerId,
      governorateId: e.governorateId,
      directorateId: e.directorateId,
      localityId: e.localityId,
      basin: e.basin,
      parcel: e.parcel,
      area: e.area,
      areaUnitId: e.areaUnitId,
      agriculturalSectorId: e.agriculturalSectorId,
      politicalClassificationId: e.politicalClassificationId,
      latitude: e.latitude,
      longitude: e.longitude,
      notes: e.notes,
      rowVersion: e.rowVersion,
      syncStatus: e.syncStatus,
      lastSyncError: e.lastSyncError,
      isPendingDelete: e.isPendingDelete,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  FarmsCompanion _mapToCompanion(domain.Farm farm) {
    return FarmsCompanion.insert(
      id: farm.id,
      serverId: Value(farm.serverId),
      farmerId: farm.farmerId,
      ownerFarmerId: Value(farm.ownerFarmerId),
      localFarmName: farm.localFarmName,
      ownershipTypeId: Value(farm.ownershipTypeId),
      relationshipToOwnerId: Value(farm.relationshipToOwnerId),
      governorateId: farm.governorateId,
      directorateId: farm.directorateId,
      localityId: farm.localityId,
      basin: farm.basin,
      parcel: farm.parcel,
      area: farm.area,
      areaUnitId: Value(farm.areaUnitId),
      agriculturalSectorId: Value(farm.agriculturalSectorId),
      politicalClassificationId: Value(farm.politicalClassificationId),
      latitude: Value(farm.latitude),
      longitude: Value(farm.longitude),
      notes: Value(farm.notes),
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
      createdAt: Value(DateTime.now()),
    );

    await _db.into(_db.farms).insert(companion);

    final createdFarm = farm.copyWith(id: localId, syncStatus: 'pending');

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

    return farm.copyWith(syncStatus: 'pending', lastSyncError: null);
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
