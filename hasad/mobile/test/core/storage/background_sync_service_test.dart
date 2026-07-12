import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/data/damage_report_attachment_repository.dart';
import 'package:mobile/features/farmers/data/damage_report_repository.dart';
import 'package:mobile/features/farmers/data/farm_repository.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/damage_report_attachment.dart';
import 'package:mobile/features/farmers/domain/damage_report.dart';
import 'package:mobile/features/farmers/domain/farm.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';

class MockFarmerRepository extends Mock implements FarmerRepository {}
class MockFarmRepository extends Mock implements FarmRepository {}
class MockDamageReportRepository extends Mock implements DamageReportRepository {}
class MockAttachmentRepository extends Mock implements DamageReportAttachmentRepository {}
class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late AppDatabase db;
  late MockFarmerRepository mockFarmerRepo;
  late MockFarmRepository mockFarmRepo;
  late MockDamageReportRepository mockDamageRepo;
  late MockAttachmentRepository mockAttachmentRepo;
  late MockConnectivity mockConnectivity;
  late BackgroundSyncService syncService;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    mockFarmerRepo = MockFarmerRepository();
    mockFarmRepo = MockFarmRepository();
    mockDamageRepo = MockDamageReportRepository();
    mockAttachmentRepo = MockAttachmentRepository();
    mockConnectivity = MockConnectivity();
    
    when(() => mockConnectivity.onConnectivityChanged).thenAnswer((_) => const Stream.empty());
    
    syncService = BackgroundSyncService(db, mockFarmerRepo, mockFarmRepo, mockDamageRepo, mockAttachmentRepo, mockConnectivity);
    
    registerFallbackValue(const Farmer(id: '', name: '', nationalId: '', phoneNumber: '', address: '', rowVersion: ''));
    registerFallbackValue(const Farm(id: '', farmerId: '', name: '', governorateId: '', localityId: '', landArea: 0, landAreaUnit: '', ownershipTypeId: ''));
    registerFallbackValue(DamageReport(id: '', farmId: '', farmerId: '', damageDate: DateTime.now(), documentationDate: DateTime.now(), governorateId: '', localityId: '', statusId: '', notes: ''));
    registerFallbackValue(const DamageReportAttachment(id: '', damageReportId: '', localPath: ''));
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
    when(() => mockFarmerRepo.createFarmer(any())).thenAnswer((_) async => farmer.copyWith(id: localId, rowVersion: 'v1'));

    await syncService.processQueue();

    final localFarmer = await (db.select(db.farmers)..where((t) => t.id.equals(localId))).getSingle();
    expect(localFarmer.rowVersion, 'v1');
    expect(localFarmer.syncStatus, 'completed');

    final queueItem = await db.select(db.syncQueue).getSingle();
    expect(queueItem.status, 'completed');
  });
}
