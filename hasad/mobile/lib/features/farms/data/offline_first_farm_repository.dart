// ignore_for_file: deprecated_member_use_from_same_package
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/auth/authorization_service.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/farms/domain/farm.dart' as farm_domain;
import 'package:mobile/features/farms/domain/farm_filter.dart';
import 'package:mobile/features/farms/domain/farm_validator.dart';
import 'package:uuid/uuid.dart';

class OfflineFirstFarmRepository implements FarmRepository {
  final AppDatabase _db;
  final Ref _ref;
  final FarmRepository _remoteRepository;
  final Connectivity _connectivity;
  final AuthorizationService _authService;

  OfflineFirstFarmRepository(
    this._db,
    this._ref,
    this._remoteRepository,
    this._connectivity,
    this._authService,
  );

  BackgroundSyncService get _syncService => _ref.read(syncServiceProvider);

  void _validate(farm_domain.Farm farm, AuthSession? session) {
    if (!_authService.canManageFarms()) {
      throw FarmException(['Access Denied: You do not have permission to manage farms.']);
    }
    final errors = FarmValidator.validate(farm, session: session);
    if (errors.isNotEmpty) {
      throw FarmException(errors);
    }
  }

  @override
  Future<List<farm_domain.Farm>> getFarmsByFarmer(String farmerId) async {
    final items = await (_db.select(_db.farms)
          ..where((t) => Expression.and([
              t.farmerId.equals(farmerId),
              t.isPendingDelete.equals(false)
          ]))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();

    return items.map((e) => mapToDomain(e)).toList();
  }

  @override
  Future<farm_domain.Farm> getFarm(String id) async {
    final e = await (_db.select(_db.farms)..where((t) => t.id.equals(id)))
        .getSingle();
    return mapToDomain(e);
  }

  @override
  Stream<List<farm_domain.Farm>> watchFarms({
    FarmFilter filter = const FarmFilter(),
    AuthSession? session,
  }) {
    final operatorFarmer = _db.alias(_db.farmers, 'op');
    final ownerFarmer = _db.alias(_db.farmers, 'ow');

    final query = _db.select(_db.farms).join([
      leftOuterJoin(operatorFarmer, operatorFarmer.id.equalsExp(_db.farms.farmerId)),
      leftOuterJoin(ownerFarmer, ownerFarmer.id.equalsExp(_db.farms.ownerFarmerId)),
    ]);

    final List<Expression<bool>> predicates = [];
    predicates.add(_db.farms.isPendingDelete.equals(false));

    // Enforcement of user scope
    if (session != null) {
      final roles = session.roles;
      if (roles.contains('AgriculturalEngineer') || roles.contains('FieldSurveyor')) {
        if (session.directorateId != null) {
          predicates.add(_db.farms.directorateId.equals(session.directorateId!));
        }
      } else if (roles.contains('Director')) {
        if (session.governorateId != null) {
          predicates.add(_db.farms.governorateId.equals(session.governorateId!));
        }
      }
    }

    if (filter.searchText.isNotEmpty) {
      final search = '%${filter.searchText}%';
      predicates.add(
          Expression.or([
            _db.farms.localFarmName.like(search),
            _db.farms.basin.like(search),
            _db.farms.parcel.like(search),
            operatorFarmer.firstNameAr.like(search),
            operatorFarmer.familyNameAr.like(search),
            ownerFarmer.firstNameAr.like(search),
            ownerFarmer.familyNameAr.like(search)
          ])
      );
    }

    if (filter.syncStatus != null) {
      predicates.add(_db.farms.syncStatus.equals(filter.syncStatus!));
    }

    if (filter.governorateId != null) {
      predicates.add(_db.farms.governorateId.equals(filter.governorateId!));
    }
    if (filter.directorateId != null) {
      predicates.add(_db.farms.directorateId.equals(filter.directorateId!));
    }
    if (filter.localityId != null) {
      predicates.add(_db.farms.localityId.equals(filter.localityId!));
    }
    if (filter.ownershipTypeId != null) {
      predicates.add(_db.farms.ownershipTypeId.equals(filter.ownershipTypeId!));
    }
    if (filter.agriculturalSectorId != null) {
      predicates.add(_db.farms.agriculturalSectorId.equals(filter.agriculturalSectorId!));
    }

    query.where(Expression.and(predicates));
    query.orderBy([OrderingTerm.desc(_db.farms.createdAt)]);

    return query.watch().map((rows) {
      return rows.map((row) => mapToDomain(row.readTable(_db.farms))).toList();
    });
  }

  @override
  Stream<farm_domain.Farm?> watchFarm(String id) {
    return (_db.select(_db.farms)..where((t) => t.id.equals(id) & t.isPendingDelete.equals(false)))
        .watchSingleOrNull()
        .map((e) => e != null ? mapToDomain(e) : null);
  }

  farm_domain.Farm mapToDomain(FarmLocal e) {
    return farm_domain.Farm(
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

  FarmsCompanion _mapToCompanion(farm_domain.Farm farm) {
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
  Future<farm_domain.Farm> createFarm(farm_domain.Farm farm, {AuthSession? session}) async {
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
  Future<farm_domain.Farm> updateFarm(farm_domain.Farm farm, {AuthSession? session}) async {
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
    if (!_authService.canManageFarms()) {
      throw FarmException(['Access Denied: You do not have permission to manage farms.']);
    }
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

  @override
  Future<List<farm_domain.Farm>> getFarms({
    int pageNumber = 1,
    int pageSize = 10,
    String? searchText,
    DateTime? updatedSince,
  }) async {
    // Note: getFarms implementation for local query
    final query = _db.select(_db.farms);
    final List<Expression<bool>> predicates = [];
    predicates.add(_db.farms.isPendingDelete.equals(false));

    if (searchText != null && searchText.isNotEmpty) {
      final search = '%$searchText%';
      predicates.add(_db.farms.localFarmName.like(search) |
          _db.farms.basin.like(search) |
          _db.farms.parcel.like(search));
    }

    query.where((t) => Expression.and(predicates));
    query.limit(pageSize, offset: (pageNumber - 1) * pageSize);

    final items = await query.get();
    return items.map((e) => mapToDomain(e)).toList();
  }

  @override
  Future<void> synchronize({DateTime? updatedSince}) async {
    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) return;

    int page = 1;
    bool hasMore = true;

    while (hasMore) {
      final remoteItems = await _remoteRepository.getFarms(
        pageNumber: page,
        pageSize: 50,
        updatedSince: updatedSince,
      );

      if (remoteItems.isEmpty) break;

      await _db.transaction(() async {
        for (final remote in remoteItems) {
          // PROTECTION: Skip if local record has unsynced changes
          final local = await (_db.select(_db.farms)
                ..where((t) => t.id.equals(remote.id)))
              .getSingleOrNull();

          if (local != null) {
            final isProtected = local.syncStatus == 'pending' ||
                local.syncStatus == 'syncing' ||
                local.syncStatus == 'conflict' ||
                local.isPendingDelete;

            if (isProtected) continue;
          }

          final companion = _mapToCompanion(remote).copyWith(
            syncStatus: const Value('completed'),
            lastSyncError: const Value(null),
          );

          await _db.into(_db.farms).insertOnConflictUpdate(companion);
        }
      });

      page++;
      hasMore = remoteItems.length == 50;
    }
  }
}
