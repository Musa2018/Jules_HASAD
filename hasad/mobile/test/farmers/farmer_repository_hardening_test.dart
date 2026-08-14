import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/auth/authorization_service.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/farmers/domain/farmer_filter.dart';

import '../helpers/mocks.dart';

void main() {
  late AppDatabase db;
  late MockBackgroundSyncService mockSyncService;
  late MockRef mockRef;
  late MockFarmerRepository mockRemoteRepository;
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
    mockSyncService = MockBackgroundSyncService();
    mockRemoteRepository = MockFarmerRepository();
    mockConnectivity = MockConnectivity();
    mockAuthService = MockAuthorizationService();
    
    when(() => mockAuthService.canManageFarmers()).thenReturn(true);
    mockRef = MockRef();
    when(() => mockRef.read(syncServiceProvider)).thenReturn(mockSyncService);
    
    repository = OfflineFirstFarmerRepository(
      db, mockRef, mockRemoteRepository, mockConnectivity, mockAuthService, adminSession,
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
            (e) => e.errors, 'errors', contains('A farmer with this ID Number already exists and is active.'))),
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
        db, mockRef, mockRemoteRepository, mockConnectivity, mockAuthService, engineerSession,
      );

      // 2. Add two localities
      await db.into(db.localities).insert(LocalitiesCompanion.insert(
        id: 'L1',
        nameAr: 'Locality 1',
        nameEn: 'Locality 1',
        governorateId: 'G1',
        directorateId: 'D1',
      ));
      await db.into(db.localities).insert(LocalitiesCompanion.insert(
        id: 'L2',
        nameAr: 'Locality 2',
        nameEn: 'Locality 2',
        governorateId: 'G1',
        directorateId: 'D2',
      ));

      // 3. Add two farmers (one in D1 locality, one in D2)
      final farmer1 = Farmer(
        id: 'f1', idTypeId: 1, idNumber: '1', firstNameAr: 'F1',
        fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '',
        firstNameEn: '', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '',
        birthDate: DateTime(1980), gender: Gender.male, phoneNumber: '',
        familySize: 1, governorateId: 'G1', localityId: 'L1', address: '',
      );
      final farmer2 = farmer1.copyWith(id: 'f2', idNumber: '2', firstNameAr: 'F2', localityId: 'L2');

      when(() => mockSyncService.addToQueue(
        localId: any(named: 'localId'),
        entityType: any(named: 'entityType'),
        operation: any(named: 'operation'),
        data: any(named: 'data'),
      )).thenAnswer((_) async {});

      await repository.createFarmer(farmer1);
      await repository.createFarmer(farmer2);

      // 3.5 Add a farm for farmer1 in D1
      await db.into(db.farms).insert(FarmsCompanion.insert(
        id: 'farm1',
        farmerId: 'f1',
        localFarmName: 'Farm 1',
        governorateId: 'G1',
        directorateId: 'D1',
        localityId: 'L1',
        basin: 'B1',
        parcel: 'P1',
        area: 10,
      ));

      // 4. Watch with isOperational: true
      final streamOp = repository.watchFarmers(filter: const FarmerFilter(isOperational: true));
      final resultOp = await streamOp.first;

      // Should only contain f1 because f2's locality is in D2
      expect(resultOp.length, 1);
      expect(resultOp.first.id, 'f1');

      // 5. Watch with isOperational: false (All View)
      final streamAll = repository.watchFarmers(filter: const FarmerFilter(isOperational: false));
      final resultAll = await streamAll.first;

      // Should contain both because they are in G1 (Authorization Scope)
      expect(resultAll.length, 2);
      expect(resultAll.any((e) => e.id == 'f1'), isTrue);
      expect(resultAll.any((e) => e.id == 'f2'), isTrue);
    });

    test('watchFarmers allows SuperAdmin to see all regardless of isOperational', () async {
       // 1. Setup session for SuperAdmin
      final superSession = adminSession.copyWith(roles: ['SuperAdmin'], directorateId: null);
      repository = OfflineFirstFarmerRepository(
        db, mockRef, mockRemoteRepository, mockConnectivity, mockAuthService, superSession,
      );

      // 2. Add two farmers in different governorates
      final farmer1 = Farmer(
        id: 'f1', idTypeId: 1, idNumber: '1', firstNameAr: 'F1',
        fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '',
        firstNameEn: '', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '',
        birthDate: DateTime(1980), gender: Gender.male, phoneNumber: '',
        familySize: 1, governorateId: 'G1', localityId: 'L1', address: '',
      );
      final farmer2 = farmer1.copyWith(id: 'f2', idNumber: '2', firstNameAr: 'F2', governorateId: 'G2');

      when(() => mockSyncService.addToQueue(
        localId: any(named: 'localId'),
        entityType: any(named: 'entityType'),
        operation: any(named: 'operation'),
        data: any(named: 'data'),
      )).thenAnswer((_) async {});

      await repository.createFarmer(farmer1);
      await repository.createFarmer(farmer2);

      // 3. Watch
      final stream = repository.watchFarmers(filter: const FarmerFilter(isOperational: true));
      final result = await stream.first;

      expect(result.length, 2);
    });
  });
}
