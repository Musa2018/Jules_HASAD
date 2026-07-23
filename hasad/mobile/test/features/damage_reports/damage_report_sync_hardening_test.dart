import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_attachment_repository.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/damage_reports/data/repositories/offline_first_damage_report_repository.dart';

class MockFarmerRepo extends Mock implements FarmerRepository {}
class MockFarmRepo extends Mock implements FarmRepository {}
class MockReportRepo extends Mock implements DamageReportRepository {}
class MockAttachmentRepo extends Mock implements DamageReportAttachmentRepository {}
class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late AppDatabase db;
  late MockFarmerRepo farmerRepo;
  late MockFarmRepo farmRepo;
  late MockReportRepo reportRepo;
  late MockAttachmentRepo attachmentRepo;
  late MockConnectivity connectivity;
  late BackgroundSyncService syncService;
  late OfflineFirstDamageReportRepository localRepo;

  setUpAll(() {
    registerFallbackValue(
      Farmer(
        id: '', idTypeId: 1, idNumber: '', firstNameAr: '', fatherNameAr: '',
        grandfatherNameAr: '', familyNameAr: '', firstNameEn: '', fatherNameEn: '',
        grandfatherNameEn: '', familyNameEn: '', birthDate: DateTime(1990),
        gender: Gender.male, phoneNumber: '', familySize: 1, governorateId: '',
        localityId: '', address: '',
      ),
    );
    registerFallbackValue(
      Farm(
        id: '', farmerId: '', localFarmName: '', ownershipTypeId: 1,
        governorateId: '', directorateId: '', localityId: '',
        basin: '', parcel: '', area: 1, areaUnitId: 1,
        agriculturalSectorId: 1, politicalClassificationId: 1,
      ),
    );
    registerFallbackValue(
      DamageReport(
        id: '', farmId: '', farmerId: '', damageDate: DateTime.now(),
        documentationDate: DateTime.now(), governorateId: '', localityId: '',
        statusId: '', notes: '',
      ),
    );
  });

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    farmerRepo = MockFarmerRepo();
    farmRepo = MockFarmRepo();
    reportRepo = MockReportRepo();
    attachmentRepo = MockAttachmentRepo();
    connectivity = MockConnectivity();

    syncService = BackgroundSyncService(
      db, farmerRepo, farmRepo, reportRepo, attachmentRepo, connectivity,
    );
    localRepo = OfflineFirstDamageReportRepository(db, syncService);
  });

  tearDown(() async {
    await db.close();
  });

  group('Damage Report Sync Hardening', () {
    test('Offline Creation generates temporary number and prevents local duplicates', () async {
      when(() => connectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.none]);

      final report = DamageReport(
        id: 'r1',
        farmId: 'f1',
        farmerId: 'far1',
        damageDate: DateTime(2026, 7, 23),
        documentationDate: DateTime.now(),
        damageCauseId: 1,
        governorateId: 'G1',
        localityId: 'L1',
        statusId: 'Draft',
        notes: 'Notes',
      );

      // 1. Create first report
      final created = await localRepo.createDamageReport(report);
      expect(created.temporaryFormNumber, startsWith('TEMP-2026'));

      // 2. Attempt duplicate creation (Same farm, date, cause)
      expect(
        () => localRepo.createDamageReport(report.copyWith(id: 'r2')),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('already exists'))),
      );
    });

    test('Late Binding Deferral: DamageReport waits for Farm ServerId', () async {
       when(() => connectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);

       // Create dependencies in DB but NOT synced
       await db.into(db.farmers).insert(FarmersCompanion.insert(id: 'f1', firstNameAr: const drift.Value('F'), serverId: const drift.Value('server-f1')));
       await db.into(db.farms).insert(FarmsCompanion.insert(
         id: 'farm1', farmerId: 'f1', localFarmName: 'Farm',
         governorateId: 'G1', directorateId: 'D1', localityId: 'L1',
         basin: 'B1', parcel: 'P1', area: 10,
         serverId: const drift.Value(null), // NOT SYNCED
       ));
       
       final report = DamageReport(
        id: 'r1', farmId: 'farm1', farmerId: 'f1',
        damageDate: DateTime.now(), documentationDate: DateTime.now(),
        governorateId: 'G1', localityId: 'L1', statusId: 'Draft', notes: '',
      );
      await localRepo.createDamageReport(report);

      // Process Sync
      await syncService.processQueue();

      // Report should be deferred
      final reportState = await localRepo.getDamageReport('r1');
      expect(reportState.syncStatus, 'pending');
      expect(reportState.lastSyncError, contains('Waiting for Farm'));
    });
  });
}
