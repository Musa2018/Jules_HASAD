import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';

class PullSyncService {
  final Ref _ref;

  PullSyncService(this._ref);

  Future<void> syncAll() async {
    final coordinator = _ref.read(pullSyncCoordinatorProvider);
    
    // 1. Reference Data (Smallest and foundational)
    await coordinator.synchronizeEntity(
      'referencedata', 
      ({DateTime? updatedSince}) => _ref.read(referenceDataRepositoryProvider).synchronize(updatedSince: updatedSince)
    );

    // 2. Farmers
    await coordinator.synchronizeEntity(
      'farmer', 
      ({DateTime? updatedSince}) => _ref.read(farmerRepositoryProvider).synchronize(updatedSince: updatedSince)
    );

    // 3. Farms
    await coordinator.synchronizeEntity(
      'farm', 
      ({DateTime? updatedSince}) => _ref.read(farmRepositoryProvider).synchronize(updatedSince: updatedSince)
    );
    // 4. DamageReport
    await coordinator.synchronizeEntity(
      'damageReport',
      ({DateTime? updatedSince}) => _ref.read(damageReportRepositoryProvider).synchronize(updatedSince: updatedSince)
    );
  }
}

final pullSyncServiceProvider = Provider<PullSyncService>((ref) {
  return PullSyncService(ref);
});
