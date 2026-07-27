import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/location/data/location_repository.dart';
import 'package:mobile/features/location/domain/directorate.dart';
import 'package:mobile/features/location/domain/governorate.dart';
import 'package:mobile/features/location/domain/locality.dart';

class OfflineFirstLocationRepository implements LocationRepository {
  final AppDatabase _db;
  final LocationRepository _remote;
  final Connectivity _connectivity;

  OfflineFirstLocationRepository(this._db, this._remote, this._connectivity);

  @override
  Future<List<Governorate>> getGovernorates() async {
    final local = await _db.select(_db.governorates).get();
    if (local.isNotEmpty) {
      return local
          .map((e) => Governorate(
                id: e.id,
                nameAr: e.nameAr,
                nameEn: e.nameEn,
                code: e.code,
              ))
          .toList();
    }

    try {
      final connectivity = await _connectivity.checkConnectivity();
      if (connectivity.contains(ConnectivityResult.none)) return [];

      final remote = await _remote.getGovernorates();
      await _db.batch((batch) {
        batch.insertAll(
          _db.governorates,
          remote.map((e) => GovernoratesCompanion.insert(
                id: e.id,
                nameAr: e.nameAr,
                nameEn: e.nameEn,
                code: e.code,
              )),
          mode: InsertMode.insertOrReplace,
        );
      });
      return remote;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<Directorate>> getDirectorates({String? governorateId}) async {
    final query = _db.select(_db.directorates);
    if (governorateId != null) {
      query.where((t) => t.governorateId.equals(governorateId));
    }
    final local = await query.get();
    if (local.isNotEmpty) {
      return local
          .map((e) => Directorate(
                id: e.id,
                nameAr: e.nameAr,
                nameEn: e.nameEn,
                governorateId: e.governorateId,
              ))
          .toList();
    }

    try {
      final connectivity = await _connectivity.checkConnectivity();
      if (connectivity.contains(ConnectivityResult.none)) return [];

      final remote = await _remote.getDirectorates(governorateId: governorateId);
      await _db.batch((batch) {
        batch.insertAll(
          _db.directorates,
          remote.map((e) => DirectoratesCompanion.insert(
                id: e.id,
                nameAr: e.nameAr,
                nameEn: e.nameEn,
                governorateId: e.governorateId,
              )),
          mode: InsertMode.insertOrReplace,
        );
      });
      return remote;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<Locality>> getLocalities({String? governorateId, String? directorateId}) async {
    final query = _db.select(_db.localities);
    if (directorateId != null) {
      query.where((t) => t.directorateId.equals(directorateId));
    } else if (governorateId != null) {
      query.where((t) => t.governorateId.equals(governorateId));
    }
    
    final local = await query.get();
    if (local.isNotEmpty) {
      return local
          .map((e) => Locality(
                id: e.id,
                nameAr: e.nameAr,
                nameEn: e.nameEn,
                governorateId: e.governorateId,
                directorateId: e.directorateId,
              ))
          .toList();
    }

    try {
      final connectivity = await _connectivity.checkConnectivity();
      if (connectivity.contains(ConnectivityResult.none)) return [];

      var remote = await _remote.getLocalities(
        governorateId: governorateId,
        directorateId: directorateId,
      );

      // Fallback: If filtered by Directorate and got nothing, try broader Governorate filter
      if (remote.isEmpty && directorateId != null && governorateId != null) {
        remote = await _remote.getLocalities(governorateId: governorateId);
      }
      
      if (remote.isNotEmpty) {
        await _db.batch((batch) {
          batch.insertAll(
            _db.localities,
            remote.map((e) => LocalitiesCompanion.insert(
                  id: e.id,
                  nameAr: e.nameAr,
                  nameEn: e.nameEn,
                  governorateId: e.governorateId,
                  directorateId: e.directorateId,
                )),
            mode: InsertMode.insertOrReplace,
          );
        });
      }
      
      // Re-query local to ensure we return the items actually matching the request
      return await query.get().then((rows) => rows
          .map((e) => Locality(
                id: e.id,
                nameAr: e.nameAr,
                nameEn: e.nameEn,
                governorateId: e.governorateId,
                directorateId: e.directorateId,
              ))
          .toList());
    } catch (_) {
      return [];
    }
  }
}
