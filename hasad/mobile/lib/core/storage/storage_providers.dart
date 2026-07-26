import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/pull_sync_coordinator.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_attachment_repository.dart';
import 'package:mobile/features/damage_reports/data/repositories/remote_damage_report_repository.dart';
import 'package:mobile/features/farms/data/remote_farm_repository.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/features/farmers/data/remote_farmer_repository.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final remoteFarmerRepositoryProvider = Provider<RemoteFarmerRepository>((ref) {
  return RemoteFarmerRepository(ref.watch(apiDioProvider));
});

final pullSyncCoordinatorProvider = Provider<PullSyncCoordinator>((ref) {
  return PullSyncCoordinator(ref.watch(databaseProvider));
});

final Provider<BackgroundSyncService> syncServiceProvider = Provider<BackgroundSyncService>((ref) {
  final service = BackgroundSyncService(
    ref.watch(databaseProvider),
    ref.watch(remoteFarmerRepositoryProvider),
    RemoteFarmRepository(ref.watch(apiDioProvider)),
    RemoteDamageReportRepository(ref.watch(apiDioProvider)),
    RemoteDamageReportAttachmentRepository(ref.watch(apiDioProvider)),
    ref.watch(connectivityProvider),
    () async {
       final coordinator = ref.read(pullSyncCoordinatorProvider);
       await coordinator.synchronizeEntity('farmer', ref.read(farmerRepositoryProvider).synchronize);
       await coordinator.synchronizeEntity('farm', ref.read(farmRepositoryProvider).synchronize);
    },
  );
  ref.onDispose(() => service.dispose());
  // Trigger initialization safely.
  service.initialize();
  return service;
});
