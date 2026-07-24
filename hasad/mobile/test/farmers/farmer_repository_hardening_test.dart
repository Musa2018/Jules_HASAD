import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/auth/authorization_service.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/farmers/domain/farmer_filter.dart';

class MockSyncService extends Mock implements BackgroundSyncService {}
class MockRemoteRepository extends Mock implements FarmerRepository {}
class MockConnectivity extends Mock implements Connectivity {}
class MockAuthorizationService extends Mock implements AuthorizationService {}

void main() {
  late AppDatabase db;
  late MockSyncService mockSyncService;
  late MockRemoteRepository mockRemoteRepository;
  late MockConnectivity mockConnectivity;
  late MockAuthorizationService mockAuthService;
  late OfflineFirstFarmerRepository repository;

  final adminSession = const AuthSession(
    token: 't', refreshToken: 'r', userId: 'u', email: 'e', fullName: 'n',
    roles: ['Administrator'],
  );

  setUpAll(() {
    registerFallbackValue(
      Farmer(
        id: '', idTypeId: 1, idNumber: '', firstNameAr: '', fatherNameAr: '',
        grandfatherNameAr: '', familyNameAr: '', firstNameEn: '', fatherNameEn: '',
        grandfatherNameEn: '', familyNameEn: '', birthDate: DateTime(1900),
        gender: Gender.unspecified, phoneNumber: '', familySize: 1,
        governorateId: '', localityId: '', address: '', rowVersion: '',
      ),
    );
  });

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    mockSyncService = MockSyncService();
    mockRemoteRepository = MockRemoteRepository();
    mockConnectivity = MockConnectivity();
    mockAuthService = MockAuthorizationService();
    
    when(() => mockAuthService.canManageFarmers()).thenReturn(true);
    
    repository = OfflineFirstFarmerRepository(
      db, mockSyncService, mockRemoteRepository, mockConnectivity, mockAuthService, adminSession,
    );
  });

  tearDown(() async => await db.close());

  group('Uniqueness Check', () {
    test('createFarmer throws exception if active farmer with same ID exists', () async {
      final farmer1 = Farmer(
        id: 'f1', idTypeId: 1, idNumber: '12345', firstNameAr: 'N1',
        fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '',
        firstNameEn: '', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '',
        birthDate: DateTime(1980), gender: Gender.male, phoneNumber: '',
        familySize: 1, governorateId: 'G1', localityId: 'L1', address: '',
      );
      
      when(() => mockSyncService.addToQueue(
        localId: any(named: 'localId'),
        entityType: any(named: 'entityType'),
        operation: any(named: 'operation'),
        data: any(named: 'data'),
      )).thenAnswer((_) async {});

      await repository.createFarmer(farmer1);

      final farmer2 = farmer1.copyWith(id: 'f2', firstNameAr: 'N2');
      
      expect(
        () => repository.createFarmer(farmer2),
        throwsA(isA<FarmerException>().having(
            (e) => e.errors, 'errors', contains('A farmer with this ID Number and ID Type already exists and is active.'))),
      );
    });

    test('createFarmer succeeds if same ID exists but is soft deleted', () async {
       final farmer1 = Farmer(
        id: 'f1', idTypeId: 1, idNumber: '12345', firstNameAr: 'N1',
        fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '',
        firstNameEn: '', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '',
        birthDate: DateTime(1980), gender: Gender.male, phoneNumber: '',
        familySize: 1, governorateId: 'G1', localityId: 'L1', address: '',
      );
      
      when(() => mockSyncService.addToQueue(
        localId: any(named: 'localId'),
        entityType: any(named: 'entityType'),
        operation: any(named: 'operation'),
        data: any(named: 'data'),
      )).thenAnswer((_) async {});

      await repository.createFarmer(farmer1);
      
      // Mark as pending delete (isDeleted column in Drift is not used yet, we use isPendingDelete)
      // Wait, the business rule says IsDeleted = 0.
      // In mobile we use isPendingDelete for soft delete flow.
      await db.update(db.farmers).write(const FarmersCompanion(isPendingDelete: Value(true)));

      final farmer2 = farmer1.copyWith(id: 'f2', firstNameAr: 'N2');
      
      final result = await repository.createFarmer(farmer2);
      expect(result.id, 'f2');
    });
  });

  group('Authorization', () {
    test('createFarmer throws exception if authorization fails', () async {
      when(() => mockAuthService.canManageFarmers()).thenReturn(false);
      
      final farmer = Farmer(
        id: 'f1', idTypeId: 1, idNumber: '1', firstNameAr: 'N1',
        fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '',
        firstNameEn: '', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '',
        birthDate: DateTime(1980), gender: Gender.male, phoneNumber: '',
        familySize: 1, governorateId: 'G1', localityId: 'L1', address: '',
      );

      expect(
        () => repository.createFarmer(farmer),
        throwsA(isA<FarmerException>().having(
            (e) => e.errors, 'errors', contains('Access Denied: You do not have permission to manage farmers.'))),
      );
    });
  });

  group('Operational Filtering', () {
    test('watchFarmers filters by Directorate when isOperational is true', () async {
      // 1. Setup session for Engineer in D1
      final engineerSession = adminSession.copyWith(roles: ['AgriculturalEngineer'], directorateId: 'D1');
      repository = OfflineFirstFarmerRepository(
        db, mockSyncService, mockRemoteRepository, mockConnectivity, mockAuthService, engineerSession,
      );

      // 2. Add two farmers
      final farmer1 = Farmer(
        id: 'f1', idTypeId: 1, idNumber: '1', firstNameAr: 'F1',
        fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '',
        firstNameEn: '', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '',
        birthDate: DateTime(1980), gender: Gender.male, phoneNumber: '',
        familySize: 1, governorateId: 'G1', localityId: 'L1', address: '',
      );
      final farmer2 = farmer1.copyWith(id: 'f2', idNumber: '2', firstNameAr: 'F2');

      when(() => mockSyncService.addToQueue(
        localId: any(named: 'localId'),
        entityType: any(named: 'entityType'),
        operation: any(named: 'operation'),
        data: any(named: 'data'),
      )).thenAnswer((_) async {});

      await repository.createFarmer(farmer1);
      await repository.createFarmer(farmer2);

      // 3. Add a farm for F1 in D1
      await db.into(db.farms).insert(FarmsCompanion.insert(
        id: 'farm1',
        farmerId: 'f1',
        localFarmName: 'Farm 1',
        governorateId: 'G1',
        directorateId: 'D1',
        localityId: 'L1',
        basin: 'B',
        parcel: 'P',
        area: 10,
      ));

      // 4. Add a farm for F2 in D2
      await db.into(db.farms).insert(FarmsCompanion.insert(
        id: 'farm2',
        farmerId: 'f2',
        localFarmName: 'Farm 2',
        governorateId: 'G1',
        directorateId: 'D2', // Different directorate
        localityId: 'L1',
        basin: 'B',
        parcel: 'P',
        area: 10,
      ));

      // 5. Add a damage report for farm1
      await db.into(db.damageReports).insert(DamageReportsCompanion.insert(
        id: 'report1',
        farmId: 'farm1',
        damageDate: DateTime.now(),
        documentationDate: DateTime.now(),
        statusId: 'Draft',
        notes: '',
      ));

      // 6. Watch with isOperational: true
      final stream = repository.watchFarmers(filter: const FarmerFilter(isOperational: true));
      final result = await stream.first;

      // Should only contain f1 because f2's farm is in D2
      expect(result.length, 1);
      expect(result.first.id, 'f1');
    });
  });
}
