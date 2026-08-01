import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/auth/authorization_service.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/farmers/domain/farmer.dart' as farmer_domain;
import 'package:mobile/features/farmers/domain/farmer_exceptions.dart';
import 'package:mobile/features/farmers/domain/farmer_validator.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:uuid/uuid.dart';


import 'package:mobile/features/farmers/domain/farmer_filter.dart';

abstract class FarmerRepository {
  Future<List<farmer_domain.Farmer>> getFarmers({
    int pageNumber = 1,
    int pageSize = 10,
    String? idNumber,
    String? name,
    String? searchText,
    DateTime? updatedSince,
    bool isOperational = false,
  });

  Stream<List<farmer_domain.Farmer>> watchFarmers({FarmerFilter filter = const FarmerFilter()});

  Future<farmer_domain.Farmer?> findByIdNumber(String idNumber);
  Future<farmer_domain.Farmer> getFarmer(String id);
  Stream<farmer_domain.Farmer?> watchFarmer(String id);
  Future<farmer_domain.Farmer> createFarmer(farmer_domain.Farmer farmer);
  Future<farmer_domain.Farmer> updateFarmer(farmer_domain.Farmer farmer);
  Future<void> deleteFarmer(String id);
  Future<void> cancelDeleteFarmer(String id);
  Future<void> synchronize({DateTime? updatedSince});
}

class OfflineFirstFarmerRepository implements FarmerRepository {
  final AppDatabase _db;
  final Ref _ref;
  final FarmerRepository _remoteRepository;
  final Connectivity _connectivity;
  final AuthorizationService _authService;
  final AuthSession? _session;

  OfflineFirstFarmerRepository(
    this._db,
    this._ref,
    this._remoteRepository,
    this._connectivity,
    this._authService,
    this._session,
  );

  BackgroundSyncService get _syncService => _ref.read(syncServiceProvider);

  void _validate(farmer_domain.Farmer farmer) {
    if (!_authService.canManageFarmers()) {
      throw FarmerException(['Access Denied: You do not have permission to manage farmers.']);
    }
    final errors = FarmerValidator.validate(farmer);
    if (errors.isNotEmpty) {
      throw FarmerException(errors);
    }
  }

  Future<void> _checkUniqueness(farmer_domain.Farmer farmer) async {
    final query = _db.select(_db.farmers)
      ..where((t) => Expression.and([
          t.idNumber.equals(farmer.idNumber),
          t.isPendingDelete.equals(false),
          t.id.isNotValue(farmer.id)
      ]));
    
    final count = await query.get().then((v) => v.length);
    if (count > 0) {
      throw FarmerException(['A farmer with this ID Number already exists and is active.']);
    }
  }

  @override
  Future<List<farmer_domain.Farmer>> getFarmers({
    int pageNumber = 1,
    int pageSize = 10,
    String? idNumber,
    String? name,
    String? searchText,
    DateTime? updatedSince,
    bool isOperational = false,
  }) async {
    final farmers = _db.farmers;
    final farms = _db.farms;

    // 1. Determine Authorization Scope
    final session = _session;
    final bool isEngineerOrSurveyor = session != null &&
        (session.roles.contains('AgriculturalEngineer') ||
            session.roles.contains('FieldSurveyor'));

    final bool applyOperationalScoping = isEngineerOrSurveyor && 
                                        isOperational && 
                                        session.directorateId != null;
    
    final query = applyOperationalScoping
        ? _db.select(farmers).join([
            innerJoin(
              farms,
              farms.farmerId.equalsExp(farmers.id) |
                  farms.farmerId.equalsExp(farmers.serverId),
            ),
          ])
        : _db.select(farmers).join([]);

    final List<Expression<bool>> predicates = [];
    predicates.add(farmers.isPendingDelete.equals(false));

    // Apply Operational Scoping (Filter by Farm's Directorate)
    if (isOperational && isEngineerOrSurveyor && session.directorateId != null) {
      predicates.add(farms.directorateId.equals(session.directorateId!));
    }

    if (idNumber != null && idNumber.isNotEmpty) {
      predicates.add(farmers.idNumber.contains(idNumber));
    }

    if (name != null && name.isNotEmpty) {
      final search = '%$name%';
      predicates.add(Expression.or([
        farmers.firstNameAr.like(search),
        farmers.fatherNameAr.like(search),
        farmers.grandfatherNameAr.like(search),
        farmers.familyNameAr.like(search),
        farmers.firstNameEn.like(search),
        farmers.fatherNameEn.like(search),
        farmers.grandfatherNameEn.like(search),
        farmers.familyNameEn.like(search)
      ]));
    }

    if (searchText != null && searchText.isNotEmpty) {
      final search = '%$searchText%';
      predicates.add(farmers.firstNameAr.like(search) |
          farmers.fatherNameAr.like(search) |
          farmers.grandfatherNameAr.like(search) |
          farmers.familyNameAr.like(search) |
          farmers.firstNameEn.like(search) |
          farmers.fatherNameEn.like(search) |
          farmers.grandfatherNameEn.like(search) |
          farmers.familyNameEn.like(search) |
          farmers.idNumber.like(search) |
          farmers.phoneNumber.like(search));
    }

    query.where(Expression.and(predicates));

    if (applyOperationalScoping) {
      query.groupBy([farmers.id]);
    }

    query.orderBy([OrderingTerm.desc(farmers.createdAt)]);
    query.limit(pageSize, offset: (pageNumber - 1) * pageSize);

    final rows = await query.get();
    return rows.map((row) => _mapToDomain(row.readTable(farmers))).toList();
  }

  @override
  Future<farmer_domain.Farmer?> findByIdNumber(String idNumber) async {
    // 1. Search local Drift database first (exclude records pending deletion)
    final local = await (_db.select(_db.farmers)
          ..where((t) => Expression.and([
              t.idNumber.equals(idNumber),
              t.isPendingDelete.equals(false)
          ])))
        .getSingleOrNull();

    if (local != null) {
      return _mapToDomain(local);
    }

    // 2. If not found locally, check connectivity
    final connectivity = await _connectivity.checkConnectivity();
    final isOnline = connectivity.isNotEmpty && !connectivity.contains(ConnectivityResult.none);

    if (isOnline) {
      // 3. Search backend
      try {
        final remote = await _remoteRepository.findByIdNumber(idNumber);
        if (remote != null) {
          // 4. Save/update local database if found remotely
          // We use ClientId (remote.id or remote.clientId) as local 'id'
          final companion = _mapToCompanion(remote).copyWith(
            syncStatus: const Value('completed'),
          );
          
          await _db.into(_db.farmers).insertOnConflictUpdate(companion);
          return remote;
        }
      } catch (e) {
        // Log or handle error (e.g. timeout)
      }
    }

    return null;
  }

  @override
  Future<farmer_domain.Farmer> getFarmer(String id) async {
    final e = await (_db.select(_db.farmers)..where((t) => t.id.equals(id) | t.serverId.equals(id))).getSingle();
    return _mapToDomain(e);
  }

  @override
  Stream<farmer_domain.Farmer?> watchFarmer(String id) {
    return (_db.select(_db.farmers)..where((t) => Expression.and([
        t.id.equals(id) | t.serverId.equals(id),
        t.isPendingDelete.equals(false)
    ])))
        .watchSingleOrNull()
        .map((e) => e != null ? _mapToDomain(e) : null);
  }

  @override
  Stream<List<farmer_domain.Farmer>> watchFarmers({
    FarmerFilter filter = const FarmerFilter(),
  }) {
    final farmers = _db.farmers;
    final farms = _db.farms;

    final session = _session;
    final bool isEngineerOrSurveyor = session != null &&
        (session.roles.contains('AgriculturalEngineer') ||
            session.roles.contains('FieldSurveyor'));

    // 1. Determine if we need to apply Directorate-level operational filtering via FARMS.
    final bool applyOperationalScoping = isEngineerOrSurveyor && 
                                        filter.isOperational && 
                                        session.directorateId != null;

    final query = applyOperationalScoping
        ? _db.select(farmers).join([
            innerJoin(
              farms,
              farms.farmerId.equalsExp(farmers.id) |
                  farms.farmerId.equalsExp(farmers.serverId),
            ),
          ])
        : _db.select(farmers).join([]);

    final List<Expression<bool>> predicates = [];
    predicates.add(farmers.isPendingDelete.equals(false));

    // 2. Apply Operational Scoping (Filter by Farm's Directorate)
    if (filter.isOperational && isEngineerOrSurveyor && session.directorateId != null) {
      predicates.add(farms.directorateId.equals(session.directorateId!));
    }

    if (filter.searchText.isNotEmpty) {
      final search = '%${filter.searchText}%';
      predicates.add(Expression.or([
        farmers.firstNameAr.like(search),
        farmers.fatherNameAr.like(search),
        farmers.grandfatherNameAr.like(search),
        farmers.familyNameAr.like(search),
        farmers.firstNameEn.like(search),
        farmers.fatherNameEn.like(search),
        farmers.grandfatherNameEn.like(search),
        farmers.familyNameEn.like(search),
        farmers.idNumber.like(search),
        farmers.phoneNumber.like(search)
      ]));
    }

    if (filter.gender != null) {
      predicates.add(farmers.gender.equals(filter.gender!.index));
    }

    if (filter.syncStatus != null) {
      predicates.add(farmers.syncStatus.equals(filter.syncStatus!));
    }

    if (filter.governorateId != null) {
      predicates.add(farmers.governorateId.equals(filter.governorateId!));
    }

    if (filter.localityId != null) {
      predicates.add(farmers.localityId.equals(filter.localityId!));
    }

    query.where(Expression.and(predicates));

    if (applyOperationalScoping) {
      query.groupBy([farmers.id]);
    }

    query.orderBy([OrderingTerm.desc(farmers.createdAt)]);

    if (!filter.isOperational) {
      query.limit(10);
    }

    return query.watch().map((rows) => rows.map((row) => _mapToDomain(row.readTable(farmers))).toList());
  }

  farmer_domain.Farmer _mapToDomain(FarmerLocal e) {
    return farmer_domain.Farmer(
      id: e.id,
      serverId: e.serverId,
      idTypeId: e.idTypeId,
      idNumber: e.idNumber,
      firstNameAr: e.firstNameAr,
      fatherNameAr: e.fatherNameAr,
      grandfatherNameAr: e.grandfatherNameAr,
      familyNameAr: e.familyNameAr,
      firstNameEn: e.firstNameEn,
      fatherNameEn: e.fatherNameEn,
      grandfatherNameEn: e.grandfatherNameEn,
      familyNameEn: e.familyNameEn,
      birthDate: e.birthDate ?? DateTime(1900),
      gender: Gender.values[e.gender],
      phoneNumber: e.phoneNumber,
      familySize: e.familySize,
      governorateId: e.governorateId,
      directorateId: e.directorateId,
      localityId: e.localityId,
      legacyGovernorateId: e.legacyGovernorateId,
      legacyLocalityId: e.legacyLocalityId,
      address: e.address,
      rowVersion: e.rowVersion,
      syncStatus: e.syncStatus,
      lastSyncError: e.lastSyncError,
      isPendingDelete: e.isPendingDelete,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  FarmersCompanion _mapToCompanion(farmer_domain.Farmer farmer) {
    return FarmersCompanion.insert(
      id: farmer.id,
      serverId: Value(farmer.serverId),
      idTypeId: Value(farmer.idTypeId),
      idNumber: Value(farmer.idNumber),
      firstNameAr: Value(farmer.firstNameAr),
      fatherNameAr: Value(farmer.fatherNameAr),
      grandfatherNameAr: Value(farmer.grandfatherNameAr),
      familyNameAr: Value(farmer.familyNameAr),
      firstNameEn: Value(farmer.firstNameEn),
      fatherNameEn: Value(farmer.fatherNameEn),
      grandfatherNameEn: Value(farmer.grandfatherNameEn),
      familyNameEn: Value(farmer.familyNameEn),
      birthDate: Value(farmer.birthDate),
      gender: Value(farmer.gender.index),
      phoneNumber: Value(farmer.phoneNumber),
      familySize: Value(farmer.familySize),
      governorateId: Value(farmer.governorateId),
      directorateId: Value(farmer.directorateId),
      localityId: Value(farmer.localityId),
      legacyGovernorateId: Value(farmer.legacyGovernorateId),
      legacyLocalityId: Value(farmer.legacyLocalityId),
      address: Value(farmer.address),
      rowVersion: Value(farmer.rowVersion),
      lastSyncError: Value(farmer.lastSyncError),
      updatedAt: Value(farmer.updatedAt),
    );
  }

  @override
  Future<farmer_domain.Farmer> createFarmer(farmer_domain.Farmer farmer) async {
    _validate(farmer);
    await _checkUniqueness(farmer);
    final localId = farmer.id.isEmpty ? const Uuid().v4() : farmer.id;
    final companion = _mapToCompanion(farmer).copyWith(
      id: Value(localId),
      syncStatus: const Value('pending'),
    );

    await _db.into(_db.farmers).insert(companion);

    final createdFarmer = farmer.copyWith(id: localId);

    await _syncService.addToQueue(
      localId: localId,
      entityType: 'farmer',
      operation: 'create',
      data: createdFarmer.toJson(),
    );

    return createdFarmer;
  }

  @override
  Future<farmer_domain.Farmer> updateFarmer(farmer_domain.Farmer farmer) async {
    _validate(farmer);
    await _checkUniqueness(farmer);
    final companion = _mapToCompanion(farmer).copyWith(
      updatedAt: Value(DateTime.now()),
      syncStatus: const Value('pending'),
      lastSyncError: const Value(null),
    );

    await (_db.update(_db.farmers)..where((t) => t.id.equals(farmer.id)))
        .write(companion);

    await _syncService.addToQueue(
      localId: farmer.id,
      entityType: 'farmer',
      operation: 'update',
      data: farmer.toJson(),
    );

    return farmer;
  }

  @override
  Future<void> deleteFarmer(String id) async {
    if (!_authService.canManageFarmers()) {
      throw FarmerException(['Access Denied: You do not have permission to manage farmers.']);
    }
    final local = await (_db.select(_db.farmers)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (local == null) return;

    // Integrity check: Farmer cannot be deleted if linked to any local Farm
    final hasFarms = await (_db.select(_db.farms)
          ..where((t) => Expression.and([
            Expression.or([
              t.farmerId.equals(id),
              t.ownerFarmerId.equals(id),
            ]),
            t.isPendingDelete.equals(false),
          ]))
          ..limit(1))
        .getSingleOrNull() != null;

    if (hasFarms) {
      throw FarmerHasDependenciesException(['Cannot delete farmer because they have linked farms.']);
    }

    await (_db.update(_db.farmers)..where((t) => t.id.equals(id))).write(
      const FarmersCompanion(
        isPendingDelete: Value(true),
        syncStatus: Value('pending'),
      ),
    );

    await _syncService.addToQueue(
      localId: id,
      entityType: 'farmer',
      operation: 'delete',
      data: {
        'id': local.serverId ?? local.id,
        'serverId': local.serverId,
        'clientId': local.id,
      },
    );
  }

  @override
  Future<void> cancelDeleteFarmer(String id) async {
    await (_db.update(_db.farmers)..where((t) => t.id.equals(id))).write(
      const FarmersCompanion(
        isPendingDelete: Value(false),
        syncStatus: Value('completed'),
        lastSyncError: Value(null),
      ),
    );

    await (_db.delete(_db.syncQueue)
          ..where((t) => t.localId.equals(id) & t.entityType.equals('farmer') & t.operation.equals('delete')))
        .go();
  }

  @override
  Future<void> synchronize({DateTime? updatedSince}) async {
    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) return;

    int page = 1;
    bool hasMore = true;

    while (hasMore) {
      final remoteItems = await _remoteRepository.getFarmers(
        pageNumber: page,
        pageSize: 50,
        // ignore: avoid_redundant_argument_values
        name: null,
        // ignore: avoid_redundant_argument_values
        idNumber: null,
        // ignore: avoid_redundant_argument_values
        searchText: null,
        updatedSince: updatedSince,
      );

      if (remoteItems.isEmpty) break;

      await _db.transaction(() async {
        for (final remote in remoteItems) {
          // PROTECTION: Check if local record has unsynced changes
          // Use ClientId (remote.id) as the local primary key
          final local = await (_db.select(_db.farmers)
                ..where((t) => t.id.equals(remote.id)))
              .getSingleOrNull();

          if (local != null) {
            final isProtected = local.syncStatus == 'pending' ||
                local.syncStatus == 'syncing' ||
                local.syncStatus == 'conflict' ||
                local.isPendingDelete;

            if (isProtected) {
              // Skip overwriting local changes
              continue;
            }
          }

          // Idempotent Update
          final companion = _mapToCompanion(remote).copyWith(
            syncStatus: const Value('completed'),
            lastSyncError: const Value(null),
          );

          await _db.into(_db.farmers).insertOnConflictUpdate(companion);
        }
      });

      page++;
      hasMore = remoteItems.length == 50;
    }
  }
}
