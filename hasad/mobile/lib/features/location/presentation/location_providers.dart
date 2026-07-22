import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/location/data/location_repository.dart';
import 'package:mobile/features/location/data/offline_first_location_repository.dart';
import 'package:mobile/features/location/domain/directorate.dart';
import 'package:mobile/features/location/domain/governorate.dart';
import 'package:mobile/features/location/domain/locality.dart';

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return OfflineFirstLocationRepository(
    ref.watch(databaseProvider),
    LocationRepositoryImpl(ref.watch(apiDioProvider)),
  );
});

final governoratesProvider = FutureProvider<List<Governorate>>((ref) async {
  return ref.watch(locationRepositoryProvider).getGovernorates();
});

final directoratesProvider = FutureProvider.family<List<Directorate>, String?>((
  ref,
  governorateId,
) async {
  return ref
      .watch(locationRepositoryProvider)
      .getDirectorates(governorateId: governorateId);
});

final localitiesProvider = FutureProvider.family<List<Locality>, (String?, String?)>((
  ref,
  params,
) async {
  return ref
      .watch(locationRepositoryProvider)
      .getLocalities(governorateId: params.$1, directorateId: params.$2);
});
