import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/storage/pull_sync_coordinator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';

import '../../helpers/mocks.dart';

void main() {
  late AppDatabase db;
  late MockFarmerRepository mockFarmerRepo;
  late MockFarmRepository mockFarmRepo;
  late PullSyncCoordinator coordinator;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    mockFarmerRepo = MockFarmerRepository();
    mockFarmRepo = MockFarmRepository();
    
    container = ProviderContainer(
      overrides: [
        farmerRepositoryProvider.overrideWithValue(mockFarmerRepo),
        farmRepositoryProvider.overrideWithValue(mockFarmRepo),
      ],
    );

    coordinator = PullSyncCoordinator(db);
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  group('PullSyncCoordinator Idempotency & Watermarking', () {
    test('Initial pull updates watermark and status', () async {
      when(() => mockFarmerRepo.synchronize(updatedSince: any(named: 'updatedSince')))
          .thenAnswer((_) async => {});
      when(() => mockFarmRepo.synchronize(updatedSince: any(named: 'updatedSince')))
          .thenAnswer((_) async => {});

      await coordinator.synchronizeEntity('farmer', mockFarmerRepo.synchronize);
      await coordinator.synchronizeEntity('farm', mockFarmRepo.synchronize);

      final farmerMeta = await (db.select(db.syncMetadata)..where((t) => t.entity.equals('farmer'))).getSingle();
      expect(farmerMeta.lastSyncStatus, 'completed');
      expect(farmerMeta.lastSyncedAt, isA<DateTime>());

      final farmMeta = await (db.select(db.syncMetadata)..where((t) => t.entity.equals('farm'))).getSingle();
      expect(farmMeta.lastSyncStatus, 'completed');
    });

    test('Incremental pull uses existing watermark', () async {
      final lastYear = DateTime(2025);
      await db.into(db.syncMetadata).insert(SyncMetadataCompanion.insert(
        entity: 'farmer',
        lastSyncedAt: Value(lastYear),
        lastSyncStatus: const Value('completed'),
      ));

      when(() => mockFarmerRepo.synchronize(updatedSince: lastYear))
          .thenAnswer((_) async => {});

      await coordinator.synchronizeEntity('farmer', mockFarmerRepo.synchronize);

      verify(() => mockFarmerRepo.synchronize(updatedSince: lastYear)).called(1);
    });
  });

  group('Repository Protection during Synchronize', () {
     // Note: These tests verify logic inside the repository implementations
     // since PullSyncCoordinator just calls repo.synchronize()
  });
}
