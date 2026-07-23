import 'package:drift/drift.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/farms/domain/farm.dart' as domain;
import 'package:mobile/features/farms/domain/farm_filter.dart';
import 'package:mobile/features/farms/domain/farm_validator.dart';
import 'package:uuid/uuid.dart';

class OfflineFirstFarmRepository implements FarmRepository {
  final AppDatabase _db;
  final BackgroundSyncService _syncService;

  OfflineFirstFarmRepository(this._db, this._syncService);

  void _validate(domain.Farm farm, AuthSession? session) {
    final errors = FarmValidator.validate(farm, session: session);
    if (errors.isNotEmpty) {
      throw FarmException(errors);
    }
  }

  @override
  Future<List<domain.Farm>> getFarmsByFarmer(String farmerId) async {
    final items = await (_db.select(_db.farms)
          ..where((t) =>
              t.farmerId.equals(farmerId) & t.isPendingDelete.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();

    return items.map((e) => mapToDomain(e)).toList();
  }

  @override
  Future<domain.Farm> getFarm(String id) async {
    final e = await (_db.select(_db.farms)..where((t) => t.id.equals(id)))
        .getSingle();
    return mapToDomain(e);
  }

  @override
  Stream<List<domain.Farm>> watchFarms({
    FarmFilter filter = const FarmFilter(),
    AuthSession? session,
  }) {
    final operatorFarmer = _db.alias(_db.farmers, 'op');
    final ownerFarmer = _db.alias(_db.farmers, 'ow');

    final query = _db.select(_db.farms).join([
      leftOuterJoin(operatorFarmer, operatorFarmer.id.equalsExp(_db.farms.farmerId)),
      leftOuterJoin(ownerFarmer, ownerFarmer.id.equalsExp(_db.farms.ownerFarmerId)),
    ]);

    // Enforcement of user scope
    if (session != null) {
      final roles = session.roles;
      if (roles.contains('AgriculturalEngineer') || roles.contains('FieldSurveyor')) {
        if (session.directorateId != null) {
          query.where(_db.farms.directorateId.equals(session.directorateId!));
        }
      } else if (roles.contains('Director')) {
        if (session.governorateId != null) {
          query.where(_db.farms.governorateId.equals(session.governorateId!));
        }
      }
    }

    if (filter.searchText.isNotEmpty) {
      final search = '%${filter.searchText}%';
      query.where(
          _db.farms.localFarmName.like(search) |
          _db.farms.basin.like(search) |
          _db.farms.parcel.like(search) |
          operatorFarmer.firstNameAr.like(search) |
          operatorFarmer.familyNameAr.like(search) |
          ownerFarmer.firstNameAr.like(search) |
          ownerFarmer.familyNameAr.like(search)
      );
    }

    if (filter.syncStatus != null) {
      query.where(_db.farms.syncStatus.equals(filter.syncStatus!));
    }

    if (filter.governorateId != null) {
      query.where(_db.farms.governorateId.equals(filter.governorateId!));
    }
    if (filter.directorateId != null) {
      query.where(_db.farms.directorateId.equals(filter.directorateId!));
    }
    if (filter.localityId != null) {
      query.where(_db.farms.localityId.equals(filter.localityId!));
    }
    if (filter.ownershipTypeId != null) {
      query.where(_db.farms.ownershipTypeId.equals(filter.ownershipTypeId!));
    }
    if (filter.agriculturalSectorId != null) {
      query.where(_db.farms.agriculturalSectorId.equals(filter.agriculturalSectorId!));
    }

    query.orderBy([OrderingTerm.desc(_db.farms.createdAt)]);

    return query.watch().map((rows) {
      return rows.map((row) => mapToDomain(row.readTable(_db.farms))).toList();
    });
  }

  @override
  Stream<domain.Farm?> watchFarm(String id) {
    return (_db.select(_db.farms)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .map((e) => e != null ? mapToDomain(e) : null);
  }

  domain.Farm mapToDomain(FarmLocal e) {
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
      measurementUnitId: e.measurementUnitId,
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
      measurementUnitId: Value(farm.measurementUnitId),
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
  Future<domain.Farm> createFarm(domain.Farm farm, {AuthSession? session}) async {
    _validate(farm, session);
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
  Future<domain.Farm> updateFarm(domain.Farm farm, {AuthSession? session}) async {
    _validate(farm, session);
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
  Future<void> deleteFarm(String id, {AuthSession? session}) async {
    final local = await (_db.select(_db.farms)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (local == null) return;

    if (session != null) {
      final isEngineer = session.roles.contains('AgriculturalEngineer');
      final isSurveyor = session.roles.contains('FieldSurveyor');
      if (isEngineer || isSurveyor) {
        if (local.directorateId != session.directorateId) {
          throw FarmException(['Access Denied: You can only delete farms within your assigned directorate.']);
        }
      }
    }

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

  @override
  Future<void> cancelDeleteFarm(String id) async {
    await (_db.update(_db.farms)..where((t) => t.id.equals(id))).write(
      const FarmsCompanion(
        isPendingDelete: Value(false),
        syncStatus: Value('completed'),
        lastSyncError: Value(null),
      ),
    );

    await (_db.delete(_db.syncQueue)
          ..where((t) => t.localId.equals(id) & t.entityType.equals('farm') & t.operation.equals('delete')))
        .go();
  }
}
