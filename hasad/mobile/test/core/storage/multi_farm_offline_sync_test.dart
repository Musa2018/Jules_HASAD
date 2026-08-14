import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_attachment_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert';

import '../../helpers/mocks.dart';

void main() {
  late AppDatabase db;
  late BackgroundSyncService syncService;
  late MockFarmerRepository mockFarmerRepo;
  late MockFarmRepository mockFarmRepo;
  late MockDamageReportRepository mockDamageRepo;
  late MockDamageReportAttachmentRepository mockAttachmentRepo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    mockFarmerRepo = MockFarmerRepository();
    mockFarmRepo = MockFarmRepository();
    mockDamageRepo = MockDamageReportRepository();
    mockAttachmentRepo = MockDamageReportAttachmentRepository();
    mockConnectivity = MockConnectivity();

    syncService = BackgroundSyncService(
      db,
      mockFarmerRepo,
      mockFarmRepo,
      mockDamageRepo,
      mockAttachmentRepo,
      mockConnectivity,
    );

    when(() => mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
    
    registerFallbackValue(Farmer(id: '', idTypeId: 1, idNumber: '', firstNameAr: '', fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '', firstNameEn: '', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '', birthDate: DateTime(1900), gender: Gender.unspecified, phoneNumber: '', familySize: 1, address: ''));
    registerFallbackValue(Farm(id: '', farmerId: '', localFarmName: '', ownershipTypeId: 1, governorateId: '', directorateId: '', localityId: '', basin: '', parcel: '', area: 0, areaUnitId: 1, agriculturalSectorId: 1, politicalClassificationId: 1));
  });

  tearDown(() async {
    await db.close();
  });

  test('Sync correctly handles 1 Farmer with multiple Farms in different Directorates', () async {
    // 1. Arrange: Create data locally (Airplane mode simulation)
    final farmerId = 'farmer-123';
    final farm1Id = 'farm-jenin';
    final farm2Id = 'farm-nablus';

    final farmer = Farmer(
      id: farmerId,
      idTypeId: 1,
      idNumber: '123456789',
      firstNameAr: 'Ahmed',
      fatherNameAr: 'M',
      grandfatherNameAr: 'M',
      familyNameAr: 'M',
      firstNameEn: 'Ahmed',
      fatherNameEn: 'M',
      grandfatherNameEn: 'M',
      familyNameEn: 'M',
      birthDate: DateTime(1980),
      gender: Gender.male,
      phoneNumber: '0599000000',
      familySize: 5,
      address: 'Jenin',
      syncStatus: 'pending',
    );

    final farm1 = Farm(
      id: farm1Id,
      farmerId: farmerId,
      localFarmName: 'Jenin Farm',
      ownershipTypeId: 1,
      governorateId: 'gov-jenin',
      directorateId: 'dir-jenin',
      localityId: 'loc-jenin',
      basin: '1',
      parcel: '1',
      area: 10.0,
      areaUnitId: 1,
      agriculturalSectorId: 1,
      politicalClassificationId: 1,
      syncStatus: 'pending',
    );

    final farm2 = farm1.copyWith(
      id: farm2Id,
      localFarmName: 'Nablus Farm',
      governorateId: 'gov-nablus',
      directorateId: 'dir-nablus',
      localityId: 'loc-nablus',
    );

    // Insert into local DB
    await db.into(db.farmers).insert(FarmersCompanion.insert(
      id: farmerId,
      idNumber: const Value('123456789'),
      firstNameAr: const Value('Ahmed'),
      fatherNameAr: const Value('M'),
      grandfatherNameAr: const Value('M'),
      familyNameAr: const Value('M'),
      firstNameEn: const Value('Ahmed'),
      fatherNameEn: const Value('M'),
      grandfatherNameEn: const Value('M'),
      familyNameEn: const Value('M'),
      birthDate: Value(DateTime(1980)),
      gender: const Value(1), // Male
      phoneNumber: const Value('0599000000'),
      familySize: const Value(5),
      address: const Value('Jenin'),
      syncStatus: const Value('pending'),
    ));

    await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
      id: 'q1',
      localId: farmerId,
      entityType: 'farmer',
      operation: 'create',
      data: jsonEncode(farmer.toJson()),
      createdAt: Value(DateTime.now()),
    ));

    await db.into(db.farms).insert(FarmsCompanion.insert(
      id: farm1Id,
      farmerId: farmerId,
      localFarmName: 'Jenin Farm',
      governorateId: 'gov-jenin',
      directorateId: 'dir-jenin',
      localityId: 'loc-jenin',
      basin: '1',
      parcel: '1',
      area: 10.0,
      syncStatus: const Value('pending'),
    ));

    await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
      id: 'q2',
      localId: farm1Id,
      entityType: 'farm',
      operation: 'create',
      data: jsonEncode(farm1.toJson()),
      createdAt: Value(DateTime.now()),
    ));

    await db.into(db.farms).insert(FarmsCompanion.insert(
      id: farm2Id,
      farmerId: farmerId,
      localFarmName: 'Nablus Farm',
      governorateId: 'gov-nablus',
      directorateId: 'dir-nablus',
      localityId: 'loc-nablus',
      basin: '2',
      parcel: '2',
      area: 20.0,
      syncStatus: const Value('pending'),
    ));

    await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
      id: 'q3',
      localId: farm2Id,
      entityType: 'farm',
      operation: 'create',
      data: jsonEncode(farm2.toJson()),
      createdAt: Value(DateTime.now()),
    ));

    // 2. Mock Remote Responses (Ordered sync)
    final serverFarmerId = 'server-farmer-id';
    when(() => mockFarmerRepo.createFarmer(any())).thenAnswer((_) async => farmer.copyWith(serverId: serverFarmerId));
    
    when(() => mockFarmRepo.createFarm(any())).thenAnswer((invocation) async {
      final f = invocation.positionalArguments[0] as Farm;
      return f.copyWith(serverId: 'server-${f.id}');
    });

    // 3. Act: Process Queue
    await syncService.processQueue();

    // 4. Assert: Relationships maintained and IDs resolved
    final syncedFarms = await db.select(db.farms).get();
    expect(syncedFarms.length, 2);
    expect(syncedFarms.every((f) => f.syncStatus == 'completed'), true);
    
    // Verify late binding: Remote repo should have received server IDs for farmerId
    verify(() => mockFarmRepo.createFarm(any(that: predicate<Farm>((f) => f.farmerId == serverFarmerId)))).called(2);
    
    // Verify directorates preserved
    expect(syncedFarms.any((f) => f.directorateId == 'dir-jenin'), true);
    expect(syncedFarms.any((f) => f.directorateId == 'dir-nablus'), true);
  });
}
