import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';

class MockFarmerRepository extends Mock implements FarmerRepository {}
class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late AppDatabase db;
  late MockFarmerRepository mockRemoteRepo;
  late MockConnectivity mockConnectivity;
  late BackgroundSyncService syncService;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    mockRemoteRepo = MockFarmerRepository();
    mockConnectivity = MockConnectivity();
    
    when(() => mockConnectivity.onConnectivityChanged).thenAnswer((_) => const Stream.empty());
    
    syncService = BackgroundSyncService(db, mockRemoteRepo, mockConnectivity);
    
    registerFallbackValue(const Farmer(id: '', name: '', nationalId: '', phoneNumber: '', address: '', rowVersion: ''));
  });

  tearDown(() async {
    syncService.dispose();
    await db.close();
  });

  test('processQueue syncs create farmer item to remote', () async {
    const localId = 'local-123';
    const farmer = Farmer(
      id: localId,
      name: 'John Doe',
      nationalId: '12345',
      phoneNumber: '555',
      address: 'Gaza',
      rowVersion: '',
    );

    await db.into(db.farmers).insert(FarmersCompanion.insert(
      id: localId,
      name: farmer.name,
      nationalId: farmer.nationalId,
      phoneNumber: farmer.phoneNumber,
      address: farmer.address,
      syncStatus: const Value('pending'),
    ));

    await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
      id: 'queue-1',
      localId: localId,
      entityType: 'farmer',
      operation: 'create',
      data: jsonEncode(farmer.toJson()),
    ));

    when(() => mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
    when(() => mockRemoteRepo.createFarmer(any())).thenAnswer((_) async => farmer.copyWith(id: localId, rowVersion: 'v1'));

    await syncService.processQueue();

    final localFarmer = await (db.select(db.farmers)..where((t) => t.id.equals(localId))).getSingle();
    expect(localFarmer.rowVersion, 'v1');
    expect(localFarmer.syncStatus, 'completed');

    final queueItem = await db.select(db.syncQueue).getSingle();
    expect(queueItem.status, 'completed');
  });

  test('processQueue handles conflict by Server Wins resolution', () async {
    const localId = 'local-123';
    const farmer = Farmer(
      id: localId,
      name: 'Local Name',
      nationalId: '12345',
      phoneNumber: '555',
      address: 'Gaza',
      rowVersion: 'v1',
    );

    await db.into(db.farmers).insert(FarmersCompanion.insert(
      id: localId,
      name: farmer.name,
      nationalId: farmer.nationalId,
      phoneNumber: farmer.phoneNumber,
      address: farmer.address,
      rowVersion: const Value('v1'),
      syncStatus: const Value('pending'),
    ));

    await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
      id: 'queue-1',
      localId: localId,
      entityType: 'farmer',
      operation: 'update',
      data: jsonEncode(farmer.toJson()),
    ));

    when(() => mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
    
    // Simulate conflict on update
    when(() => mockRemoteRepo.updateFarmer(any())).thenThrow(FarmerException(['CONFLICT']));
    
    // Remote record that should win
    final remoteFarmer = farmer.copyWith(name: 'Remote Name', rowVersion: 'v2');
    when(() => mockRemoteRepo.getFarmer(localId)).thenAnswer((_) async => remoteFarmer);

    await syncService.processQueue();

    final localFarmer = await (db.select(db.farmers)..where((t) => t.id.equals(localId))).getSingle();
    expect(localFarmer.name, 'Remote Name');
    expect(localFarmer.rowVersion, 'v2');
    expect(localFarmer.syncStatus, 'completed');

    final queueItem = await db.select(db.syncQueue).getSingle();
    expect(queueItem.status, 'completed');
  });
}
