import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_attachment.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import '../../helpers/mocks.dart';

void main() {
  late AppDatabase db;
  late MockFarmerRepository mockFarmerRepo;
  late MockFarmRepository mockFarmRepo;
  late MockDamageReportRepository mockDamageRepo;
  late MockDamageReportAttachmentRepository mockAttachmentRepo;
  late MockConnectivity mockConnectivity;
  late BackgroundSyncService syncService;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    mockFarmerRepo = MockFarmerRepository();
    mockFarmRepo = MockFarmRepository();
    mockDamageRepo = MockDamageReportRepository();
    mockAttachmentRepo = MockDamageReportAttachmentRepository();
    mockConnectivity = MockConnectivity();

    when(
      () => mockConnectivity.onConnectivityChanged,
    ).thenAnswer((_) => const Stream.empty());

    when(
      () => mockConnectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.none]);

    syncService = BackgroundSyncService(
      db,
      mockFarmerRepo,
      mockFarmRepo,
      mockDamageRepo,
      mockAttachmentRepo,
      mockConnectivity,
    );

    registerFallbackValue(
      Farmer(
        id: '',
        idTypeId: 1,
        idNumber: '',
        firstNameAr: '',
        fatherNameAr: '',
        grandfatherNameAr: '',
        familyNameAr: '',
        firstNameEn: '',
        fatherNameEn: '',
        grandfatherNameEn: '',
        familyNameEn: '',
        birthDate: DateTime(1900),
        gender: Gender.unspecified,
        phoneNumber: '',
        familySize: 1,
        governorateId: '',
        localityId: '',
        address: '',
        rowVersion: '',
      ),
    );
    registerFallbackValue(
      const Farm(
        id: '',
        farmerId: '',
        localFarmName: '',
        ownershipTypeId: 1,
        governorateId: '',
        directorateId: '',
        localityId: '',
        basin: '',
        parcel: '',
        area: 0.0,
        areaUnitId: 1,
        agriculturalSectorId: 1,
        politicalClassificationId: 1,
      ),
    );
    registerFallbackValue(
      DamageReport(
        id: '',
        serverId: '',
        reportNumber: '',
        permanentFormNumber: '',
        temporaryFormNumber: '',
        damageYear: 2026,
        farmId: '',
        farmerId: '',
        governorateId: '',
        directorateId: '',
        localityId: '',
        agriculturalSectorId: 1,
        damageDate: DateTime.now(),
        statusId: 'Draft',
        syncStatus: 'pending',
        items: [],
      ),
    );
    registerFallbackValue(
      const DamageReportAttachment(
        id: '',
        damageReportId: '',
        localPath: '',
        syncStatus: 'pending',
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('BackgroundSyncService Queue Processing', () {
    test('processQueue skips when no internet', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      await syncService.processQueue();

      verifyNever(() => mockFarmerRepo.createFarmer(any()));
    });

    test('processQueue processes CREATE farmer task', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      
      final farmer = Farmer(
        id: 'local-1',
        idTypeId: 1,
        idNumber: '123',
        firstNameAr: 'Ar',
        fatherNameAr: '',
        grandfatherNameAr: '',
        familyNameAr: '',
        firstNameEn: 'En',
        fatherNameEn: '',
        grandfatherNameEn: '',
        familyNameEn: '',
        birthDate: DateTime(1990),
        gender: Gender.male,
        phoneNumber: '555',
        familySize: 4,
        governorateId: 'gov-1',
        localityId: 'loc-1',
        address: 'Addr',
        rowVersion: '',
      );

      await db.into(db.farmers).insert(FarmersCompanion.insert(
        id: farmer.id,
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
        address: Value(farmer.address),
        syncStatus: const Value('pending'),
      ));

      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
            localId: 'local-1',
            entityType: 'farmer',
            operation: 'create',
            data: jsonEncode(farmer.toJson()),
            status: 'pending',
            createdAt: DateTime.now(),
          ));

      when(() => mockFarmerRepo.createFarmer(any()))
          .thenAnswer((_) async => farmer.copyWith(serverId: 'server-1'));

      await syncService.processQueue();

      final updatedFarmer = await (db.select(db.farmers)
            ..where((t) => t.id.equals('local-1')))
          .getSingle();
      expect(updatedFarmer.serverId, 'server-1');

      final task = await (db.select(db.syncQueue)..where((t) => t.localId.equals('local-1'))).getSingle();
      expect(task.status, 'completed');
    });

    test('processQueue processes CREATE farm task', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.mobile]);

      final farm = const Farm(
        id: 'local-f1',
        farmerId: 'farmer-1',
        localFarmName: 'My Farm',
        ownershipTypeId: 1,
        governorateId: 'gov-1',
        directorateId: 'dir-1',
        localityId: 'loc-1',
        basin: 'b1',
        parcel: 'p1',
        area: 10.5,
        areaUnitId: 1,
        agriculturalSectorId: 1,
        politicalClassificationId: 1,
      );

      await db.into(db.farms).insert(FarmsCompanion.insert(
        id: farm.id,
        farmerId: farm.farmerId,
        localFarmName: farm.localFarmName,
        ownershipTypeId: Value(farm.ownershipTypeId),
        governorateId: farm.governorateId,
        directorateId: farm.directorateId,
        localityId: farm.localityId,
        basin: farm.basin,
        parcel: farm.parcel,
        area: farm.area,
        areaUnitId: Value(farm.areaUnitId),
        agriculturalSectorId: Value(farm.agriculturalSectorId),
        politicalClassificationId: Value(farm.politicalClassificationId),
        syncStatus: const Value('pending'),
      ));

      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
            localId: 'local-f1',
            entityType: 'farm',
            operation: 'create',
            data: jsonEncode(farm.toJson()),
            status: 'pending',
            createdAt: DateTime.now(),
          ));

      when(() => mockFarmRepo.createFarm(any()))
          .thenAnswer((_) async => farm.copyWith(serverId: 'server-f1'));

      await syncService.processQueue();

      final updatedFarm = await (db.select(db.farms)
            ..where((t) => t.id.equals('local-f1')))
          .getSingle();
      expect(updatedFarm.serverId, 'server-f1');
    });

    test('processQueue handles CREATE report task', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final report = DamageReport(
        id: 'local-r1',
        serverId: '',
        reportNumber: 'R001',
        permanentFormNumber: '',
        temporaryFormNumber: 'T001',
        damageYear: 2026,
        farmId: 'farm-1',
        farmerId: 'farmer-1',
        governorateId: 'gov-1',
        directorateId: 'dir-1',
        localityId: 'loc-1',
        agriculturalSectorId: 1,
        damageDate: DateTime.now(),
        statusId: 'Draft',
        syncStatus: 'pending',
        items: [],
      );

      await db.into(db.damageReports).insert(DamageReportsCompanion.insert(
        id: 'local-r1',
        farmId: report.farmId,
        farmerId: Value(report.farmerId),
        damageYear: Value(report.damageYear),
        governorateId: Value(report.governorateId),
        directorateId: Value(report.directorateId),
        localityId: Value(report.localityId),
        agriculturalSectorId: Value(report.agriculturalSectorId),
        damageDate: report.damageDate ?? DateTime.now(),
        documentationDate: report.documentationDate ?? DateTime.now(),
        notes: report.notes,
        statusId: 'Draft',
        syncStatus: const Value('pending'),
      ));

      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
            localId: 'local-r1',
            entityType: 'damage_report',
            operation: 'create',
            data: jsonEncode(report.toJson()),
            status: 'pending',
            createdAt: DateTime.now(),
          ));

      when(() => mockDamageRepo.createDamageReport(any()))
          .thenAnswer((_) async => report.copyWith(serverId: 'server-r1'));

      await syncService.processQueue();

      final updated = await (db.select(db.damageReports)
            ..where((t) => t.id.equals('local-r1')))
          .getSingle();
      expect(updated.serverId, 'server-r1');
    });

    test('processQueue handles ATTACHMENT task', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      const attachment = DamageReportAttachment(
        id: 'local-a1',
        damageReportId: 'report-1',
        localPath: '/path/to/file.jpg',
        syncStatus: 'pending',
      );

      await db.into(db.damageReportAttachments).insert(DamageReportAttachmentsCompanion.insert(
        id: attachment.id,
        damageReportId: attachment.damageReportId,
        localPath: attachment.localPath,
        syncStatus: const Value('pending'),
      ));

      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
            localId: 'local-a1',
            entityType: 'attachment',
            operation: 'create',
            data: jsonEncode(attachment.toJson()),
            status: 'pending',
            createdAt: DateTime.now(),
          ));

      when(() => mockAttachmentRepo.uploadAttachment(any()))
          .thenAnswer((_) async => attachment.copyWith(serverId: 'server-a1'));

      await syncService.processQueue();

      final updated = await (db.select(db.damageReportAttachments)
            ..where((t) => t.id.equals('local-a1')))
          .getSingle();
      expect(updated.serverId, 'server-a1');
    });

    test('processQueue handles ConflictException by marking task as conflict', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final farmer = Farmer(
        id: 'local-c1',
        idTypeId: 1,
        idNumber: 'CONFLICT',
        firstNameAr: 'Ar',
        fatherNameAr: '',
        grandfatherNameAr: '',
        familyNameAr: '',
        firstNameEn: 'En',
        fatherNameEn: '',
        grandfatherNameEn: '',
        familyNameEn: '',
        birthDate: DateTime(1990),
        gender: Gender.male,
        phoneNumber: '555',
        familySize: 4,
        governorateId: 'gov-1',
        localityId: 'loc-1',
        address: 'Addr',
        rowVersion: '',
      );

      await db.into(db.farmers).insert(FarmersCompanion.insert(
        id: farmer.id,
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
        address: Value(farmer.address),
        syncStatus: const Value('pending'),
      ));

      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
            localId: 'local-c1',
            entityType: 'farmer',
            operation: 'create',
            data: jsonEncode(farmer.toJson()),
            status: 'pending',
            createdAt: DateTime.now(),
          ));

      when(() => mockFarmerRepo.createFarmer(any()))
          .thenThrow(SyncConflictException(['Already exists'], code: 'CONFLICT'));

      await syncService.processQueue();

      final task = await (db.select(db.syncQueue)..where((t) => t.localId.equals('local-c1'))).getSingle();
      expect(task.status, 'conflict');
      
      final updatedFarmer = await (db.select(db.farmers)..where((t) => t.id.equals('local-c1'))).getSingle();
      expect(updatedFarmer.syncStatus, 'conflict');
    });

    test('processQueue handles PermanentSyncException by marking task as invalid', () async {
        when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final farmer = Farmer(
        id: 'local-i1',
        idTypeId: 1,
        idNumber: 'INVALID',
        firstNameAr: 'Ar',
        fatherNameAr: '',
        grandfatherNameAr: '',
        familyNameAr: '',
        firstNameEn: 'En',
        fatherNameEn: '',
        grandfatherNameEn: '',
        familyNameEn: '',
        birthDate: DateTime(1990),
        gender: Gender.male,
        phoneNumber: '555',
        familySize: 4,
        governorateId: 'gov-1',
        localityId: 'loc-1',
        address: 'Addr',
        rowVersion: '',
      );

      await db.into(db.farmers).insert(FarmersCompanion.insert(
        id: farmer.id,
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
        address: Value(farmer.address),
        syncStatus: const Value('pending'),
      ));

      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
            localId: 'local-i1',
            entityType: 'farmer',
            operation: 'create',
            data: jsonEncode(farmer.toJson()),
            status: 'pending',
            createdAt: DateTime.now(),
          ));

      when(() => mockFarmerRepo.createFarmer(any()))
          .thenThrow(SyncValidationException(['Validation failed']));

      await syncService.processQueue();

      final task = await (db.select(db.syncQueue)..where((t) => t.localId.equals('local-i1'))).getSingle();
      expect(task.status, 'invalid');
      expect(task.lastError, contains('Validation failed'));
    });

    test('processQueue respects task order (createdAt)', () async {
       when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final now = DateTime.now();
      
      // Task 1: Create Farmer
      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
            localId: 'f1',
            entityType: 'farmer',
            operation: 'create',
            data: '{}',
            status: 'pending',
            createdAt: now.subtract(const Duration(minutes: 5)),
          ));
      
      // Task 2: Create Farm (depends on Farmer)
      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
            localId: 'farm1',
            entityType: 'farm',
            operation: 'create',
            data: '{}',
            status: 'pending',
            createdAt: now,
          ));

      final sequence = [];
      
      when(() => mockFarmerRepo.createFarmer(any())).thenAnswer((_) async {
        sequence.add('farmer');
        return Farmer(id: 'f1', serverId: 'sf1', idNumber: '', firstNameAr: '', fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '', firstNameEn: '', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '', birthDate: DateTime(2000), gender: Gender.male, phoneNumber: '', familySize: 1, governorateId: '', localityId: '', address: '', rowVersion: '', idTypeId: 1);
      });

      when(() => mockFarmRepo.createFarm(any())).thenAnswer((_) async {
        sequence.add('farm');
        return const Farm(id: 'farm1', serverId: 'sfarm1', farmerId: 'sf1', localFarmName: '', ownershipTypeId: 1, governorateId: '', directorateId: '', localityId: '', basin: '', parcel: '', area: 1.0, areaUnitId: 1, agriculturalSectorId: 1, politicalClassificationId: 1);
      });

      await syncService.processQueue();

      expect(sequence, ['farmer', 'farm']);
    });
  });
}
