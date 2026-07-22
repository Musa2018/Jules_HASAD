import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/domain/farmer.dart' as domain;
import 'package:mobile/features/farmers/domain/farmer_validator.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:uuid/uuid.dart';


import 'package:mobile/features/farmers/domain/farmer_filter.dart';

abstract class FarmerRepository {
  Future<List<domain.Farmer>> getFarmers({
    int pageNumber = 1,
    int pageSize = 10,
    String? idNumber,
    String? name,
  });

  Stream<List<domain.Farmer>> watchFarmers({FarmerFilter filter = const FarmerFilter()});

  Future<domain.Farmer?> findByIdNumber(String idNumber);
  Future<domain.Farmer> getFarmer(String id);
  Stream<domain.Farmer?> watchFarmer(String id);
  Future<domain.Farmer> createFarmer(domain.Farmer farmer);
  Future<domain.Farmer> updateFarmer(domain.Farmer farmer);
  Future<void> deleteFarmer(String id);
}

class OfflineFirstFarmerRepository implements FarmerRepository {
  final AppDatabase _db;
  final BackgroundSyncService _syncService;
  final FarmerRepository _remoteRepository;
  final Connectivity _connectivity;

  OfflineFirstFarmerRepository(
    this._db,
    this._syncService,
    this._remoteRepository,
    this._connectivity,
  );

  void _validate(domain.Farmer farmer) {
    final errors = FarmerValidator.validate(farmer);
    if (errors.isNotEmpty) {
      throw FarmerException(errors);
    }
  }

  @override
  Future<List<domain.Farmer>> getFarmers({
    int pageNumber = 1,
    int pageSize = 10,
    String? idNumber,
    String? name,
  }) async {
    // For the list, we currently only show local data or we could merge.
    // For Sprint 10.4, we focus on searchById.
    final query = _db.select(_db.farmers)
      ..where((t) => t.isPendingDelete.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(pageSize, offset: (pageNumber - 1) * pageSize);

    if (idNumber != null && idNumber.isNotEmpty) {
      query.where((t) => t.idNumber.contains(idNumber));
    }
    
    // Simplification: name search is complex across 8 fields, 
    // but we can implement basic contains if needed.
    // For now, let's just use the existing ordering.

    final items = await query.get();

    return items.map(_mapToDomain).toList();
  }

  @override
  Future<domain.Farmer?> findByIdNumber(String idNumber) async {
    // 1. Search local Drift database first (exclude records pending deletion)
    final local = await (_db.select(_db.farmers)
          ..where((t) => t.idNumber.equals(idNumber) & t.isPendingDelete.equals(false)))
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
  Future<domain.Farmer> getFarmer(String id) async {
    final e = await (_db.select(
      _db.farmers,
    )..where((t) => t.id.equals(id))).getSingle();
    return _mapToDomain(e);
  }

  @override
  Stream<domain.Farmer?> watchFarmer(String id) {
    return (_db.select(_db.farmers)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .map((e) => e != null ? _mapToDomain(e) : null);
  }

  @override
  Stream<List<domain.Farmer>> watchFarmers({FarmerFilter filter = const FarmerFilter()}) {
    final query = _db.select(_db.farmers)
      ..where((t) => t.isPendingDelete.equals(false));

    if (filter.searchText.isNotEmpty) {
      final search = '%${filter.searchText}%';
      query.where((t) =>
          t.firstNameAr.like(search) |
          t.fatherNameAr.like(search) |
          t.grandfatherNameAr.like(search) |
          t.familyNameAr.like(search) |
          t.firstNameEn.like(search) |
          t.fatherNameEn.like(search) |
          t.grandfatherNameEn.like(search) |
          t.familyNameEn.like(search) |
          t.idNumber.like(search) |
          t.phoneNumber.like(search));
    }

    if (filter.gender != null) {
      query.where((t) => t.gender.equals(filter.gender!.index));
    }

    if (filter.syncStatus != null) {
      query.where((t) => t.syncStatus.equals(filter.syncStatus!));
    }

    if (filter.governorateId != null) {
      query.where((t) => t.governorateId.equals(filter.governorateId!));
    }

    if (filter.localityId != null) {
      query.where((t) => t.localityId.equals(filter.localityId!));
    }

    query.orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    return query.watch().map((items) => items.map(_mapToDomain).toList());
  }

  domain.Farmer _mapToDomain(FarmerLocal e) {
    return domain.Farmer(
      id: e.id,
      serverId: e.serverId,
      clientId: e.id,
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
      localityId: e.localityId,
      address: e.address,
      rowVersion: e.rowVersion,
      syncStatus: e.syncStatus,
      lastSyncError: e.lastSyncError,
      isPendingDelete: e.isPendingDelete,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  FarmersCompanion _mapToCompanion(domain.Farmer farmer) {
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
      localityId: Value(farmer.localityId),
      address: Value(farmer.address),
      rowVersion: Value(farmer.rowVersion),
      lastSyncError: Value(farmer.lastSyncError),
      updatedAt: Value(farmer.updatedAt),
    );
  }

  @override
  Future<domain.Farmer> createFarmer(domain.Farmer farmer) async {
    _validate(farmer);
    final localId = farmer.id.isEmpty ? const Uuid().v4() : farmer.id;
    final companion = _mapToCompanion(farmer).copyWith(
      id: Value(localId),
      syncStatus: const Value('pending'),
    );

    await _db.into(_db.farmers).insert(companion);

    final createdFarmer = farmer.copyWith(id: localId, clientId: localId);

    await _syncService.addToQueue(
      localId: localId,
      entityType: 'farmer',
      operation: 'create',
      data: createdFarmer.toJson(),
    );

    return createdFarmer;
  }

  @override
  Future<domain.Farmer> updateFarmer(domain.Farmer farmer) async {
    _validate(farmer);
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
    final local = await (_db.select(_db.farmers)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (local == null) return;

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
}
