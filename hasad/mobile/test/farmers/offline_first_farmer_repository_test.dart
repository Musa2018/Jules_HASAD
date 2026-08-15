import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/farmer_exceptions.dart';
import 'package:mobile/features/farmers/domain/gender.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../helpers/mocks.dart';

void main() {
  late AppDatabase db;
  late MockBackgroundSyncService mockSyncService;
  late MockRef mockRef;
  late MockFarmerRepository mockRemoteRepository;
  late MockConnectivity mockConnectivity;
  late MockAuthorizationService mockAuthService;
  late OfflineFirstFarmerRepository repository;

  setUpAll(() {
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
  });

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    mockSyncService = MockBackgroundSyncService();
    mockRemoteRepository = MockFarmerRepository();
    mockConnectivity = MockConnectivity();
    mockAuthService = MockAuthorizationService();
    
    when(() => mockAuthService.canManageFarmers()).thenReturn(true);
    when(() => mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
    mockRef = MockRef();
    when(() => mockRef.read(syncServiceProvider)).thenReturn(mockSyncService);
    
    repository = OfflineFirstFarmerRepository(
      db,
      mockRef,
      mockRemoteRepository,
      mockConnectivity,
      mockAuthService,
      null, // No session
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('createFarmer saves locally and adds to sync queue', () async {
    when(
      () => mockSyncService.addToQueue(
        localId: any(named: 'localId'),
        entityType: any(named: 'entityType'),
        operation: any(named: 'operation'),
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async {});

    final farmer = Farmer(
      id: '',
      idTypeId: 1,
      idNumber: '12345',
      firstNameAr: 'أحمد',
      fatherNameAr: 'محمد',
      grandfatherNameAr: 'علي',
      familyNameAr: 'محمود',
      firstNameEn: 'Ahmed',
      fatherNameEn: 'Mohammed',
      grandfatherNameEn: 'Ali',
      familyNameEn: 'Mahmoud',
      birthDate: DateTime(1985, 5, 10),
      gender: Gender.male,
      phoneNumber: '0599',
      familySize: 5,
      governorateId: 'G1',
      localityId: 'L1',
      address: 'Test Address',
    );

    final result = await repository.createFarmer(farmer);

    expect(result.firstNameAr, farmer.firstNameAr);
    expect(result.id, isNotEmpty);

    final localFarmers = await db.select(db.farmers).get();
    expect(localFarmers.length, 1);
    expect(localFarmers.first.firstNameAr, farmer.firstNameAr);
    expect(localFarmers.first.syncStatus, 'pending');

    verify(
      () => mockSyncService.addToQueue(
        localId: result.id,
        entityType: 'farmer',
        operation: 'create',
        data: result.toJson(),
      ),
    ).called(1);
  });

  test('updateFarmer updates locally and adds to sync queue', () async {
    when(
      () => mockSyncService.addToQueue(
        localId: any(named: 'localId'),
        entityType: any(named: 'entityType'),
        operation: any(named: 'operation'),
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async {});

    final farmer = Farmer(
      id: '1',
      idTypeId: 1,
      idNumber: '12345',
      firstNameAr: 'أحمد',
      fatherNameAr: 'محمد',
      grandfatherNameAr: 'علي',
      familyNameAr: 'محمود',
      firstNameEn: 'Ahmed',
      fatherNameEn: 'Mohammed',
      grandfatherNameEn: 'Ali',
      familyNameEn: 'Mahmoud',
      birthDate: DateTime(1985, 5, 10),
      gender: Gender.male,
      phoneNumber: '0599',
      familySize: 5,
      governorateId: 'G1',
      localityId: 'L1',
      address: 'Test Address',
      syncStatus: 'completed',
    );

    // Initial insert using repository method
    await repository.createFarmer(farmer);

    final updatedFarmer = farmer.copyWith(firstNameAr: 'محمود', id: '1');
    final result = await repository.updateFarmer(updatedFarmer);

    expect(result.firstNameAr, 'محمود');

    final localFarmers = await db.select(db.farmers).get();
    expect(localFarmers.first.firstNameAr, 'محمود');
    expect(localFarmers.first.syncStatus, 'pending');

    verify(
      () => mockSyncService.addToQueue(
        localId: '1',
        entityType: 'farmer',
        operation: 'update',
        data: updatedFarmer.toJson(),
      ),
    ).called(1);
  });

  test('watchFarmer emits new values when local database is updated', () async {
    when(
      () => mockSyncService.addToQueue(
        localId: any(named: 'localId'),
        entityType: any(named: 'entityType'),
        operation: any(named: 'operation'),
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async {});

    final farmer = Farmer(
      id: 'watch-1',
      idTypeId: 1,
      idNumber: '1',
      firstNameAr: 'N1',
      fatherNameAr: '',
      grandfatherNameAr: '',
      familyNameAr: '',
      firstNameEn: '',
      fatherNameEn: '',
      grandfatherNameEn: '',
      familyNameEn: '',
      birthDate: DateTime(1990),
      gender: Gender.male,
      phoneNumber: '',
      familySize: 1,
      governorateId: 'G1',
      localityId: 'L1',
      address: '',
    );

    // Start watching
    final stream = repository.watchFarmer('watch-1');

    final expectation = expectLater(
      stream,
      emitsInOrder([
        null, // Initial emit if not found yet
        predicate<Farmer?>((f) => f?.firstNameAr == 'N1'),
        predicate<Farmer?>((f) => f?.firstNameAr == 'Updated'),
      ]),
    );

    // 1. Add it
    await repository.createFarmer(farmer);

    // 2. Update it
    await repository.updateFarmer(farmer.copyWith(firstNameAr: 'Updated'));

    await expectation;
  });

  group('Validation', () {
    final baseFarmer = Farmer(
      id: '',
      idTypeId: 1,
      idNumber: '12345',
      firstNameAr: 'أحمد',
      fatherNameAr: 'محمد',
      grandfatherNameAr: 'علي',
      familyNameAr: 'محمود',
      firstNameEn: 'Ahmed',
      fatherNameEn: 'Mohammed',
      grandfatherNameEn: 'Ali',
      familyNameEn: 'Mahmoud',
      birthDate: DateTime(1985, 5, 10),
      gender: Gender.male,
      phoneNumber: '0599',
      familySize: 5,
      governorateId: 'G1',
      localityId: 'L1',
      address: 'Test Address',
    );

    test('createFarmer throws FarmerException when idTypeId is 0', () async {
      final invalidFarmer = baseFarmer.copyWith(idTypeId: 0);

      expect(
        () => repository.createFarmer(invalidFarmer),
        throwsA(isA<FarmerException>().having(
            (e) => e.errors, 'errors', contains('IdType is required.'))),
      );

      final localFarmers = await db.select(db.farmers).get();
      expect(localFarmers, isEmpty);
      verifyNever(() => mockSyncService.addToQueue(
            localId: any(named: 'localId'),
            entityType: any(named: 'entityType'),
            operation: any(named: 'operation'),
            data: any(named: 'data'),
          ));
    });

    test('createFarmer throws FarmerException when age is below 18', () async {
      final underageFarmer = baseFarmer.copyWith(
        birthDate: DateTime.now().subtract(const Duration(days: 365 * 17)),
      );

      expect(
        () => repository.createFarmer(underageFarmer),
        throwsA(isA<FarmerException>().having((e) => e.errors, 'errors',
            contains('Farmer must be at least 18 years old.'))),
      );
    });

    test('createFarmer throws FarmerException when gender is unspecified',
        () async {
      final invalidFarmer = baseFarmer.copyWith(gender: Gender.unspecified);

      expect(
        () => repository.createFarmer(invalidFarmer),
        throwsA(isA<FarmerException>().having((e) => e.errors, 'errors',
            contains('Gender must be Male or Female.'))),
      );
    });

    test('createFarmer throws FarmerException when familySize is 0', () async {
      final invalidFarmer = baseFarmer.copyWith(familySize: 0);

      expect(
        () => repository.createFarmer(invalidFarmer),
        throwsA(isA<FarmerException>().having((e) => e.errors, 'errors',
            contains('Family Size must be at least 1.'))),
      );
    });
  });

  group('Search', () {
    final farmer1 = Farmer(
      id: 'f1',
      idTypeId: 1,
      idNumber: '12345',
      firstNameAr: 'أحمد',
      fatherNameAr: 'محمد',
      grandfatherNameAr: 'علي',
      familyNameAr: 'محمود',
      firstNameEn: 'Ahmed',
      fatherNameEn: 'Mohammed',
      grandfatherNameEn: 'Ali',
      familyNameEn: 'Mahmoud',
      birthDate: DateTime(1985, 5, 10),
      gender: Gender.male,
      phoneNumber: '0599111222',
      familySize: 5,
      governorateId: 'G1',
      localityId: 'L1',
      address: 'Test Address',
    );

    final farmer2 = farmer1.copyWith(
      id: 'f2',
      idNumber: '67890',
      firstNameAr: 'محمود',
      firstNameEn: 'Mahmoud',
      phoneNumber: '0598333444',
    );

    setUp(() async {
      when(() => mockSyncService.addToQueue(
        localId: any(named: 'localId'),
        entityType: any(named: 'entityType'),
        operation: any(named: 'operation'),
        data: any(named: 'data'),
      )).thenAnswer((_) async {});
      
      await repository.createFarmer(farmer1);
      await repository.createFarmer(farmer2);
    });

    test('getFarmers searches by partial Arabic name', () async {
      final results = await repository.getFarmers(name: 'أحم');
      expect(results.length, 1);
      expect(results.first.id, 'f1');
    });

    test('getFarmers searches by partial English name', () async {
      final results = await repository.getFarmers(name: 'Mah');
      expect(results.length, 2); // Both Ahmed Mahmoud and Mahmoud ...
    });

    test('getFarmers searches by exact ID number', () async {
      final results = await repository.getFarmers(idNumber: '67890');
      expect(results.length, 1);
      expect(results.first.id, 'f2');
    });

    test('getFarmers searches by partial ID number', () async {
      final results = await repository.getFarmers(idNumber: '234');
      expect(results.length, 1);
      expect(results.first.id, 'f1');
    });
  });

  group('Soft Delete', () {
    test('getFarmers and watchFarmers filter out farmers marked as pending delete', () async {
      when(
        () => mockSyncService.addToQueue(
          localId: any(named: 'localId'),
          entityType: any(named: 'entityType'),
          operation: any(named: 'operation'),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async {});

      final farmer1 = Farmer(
        id: 'f1',
        idTypeId: 1,
        idNumber: '1',
        firstNameAr: 'N1',
        fatherNameAr: '',
        grandfatherNameAr: '',
        familyNameAr: '',
        firstNameEn: '',
        fatherNameEn: '',
        grandfatherNameEn: '',
        familyNameEn: '',
        birthDate: DateTime(1990),
        gender: Gender.male,
        phoneNumber: '',
        familySize: 1,
        governorateId: 'G1',
        localityId: 'L1',
        address: '',
      );
      final farmer2 = farmer1.copyWith(id: 'f2', idNumber: '2');

      await repository.createFarmer(farmer1);
      await repository.createFarmer(farmer2);

      // Verify getFarmers
      var list = await repository.getFarmers();
      expect(list.length, 2);

      // Verify watchFarmers initial
      final stream = repository.watchFarmers();
      
      await expectLater(
        stream,
        emits(predicate<List<Farmer>>((l) => l.length == 2)),
      );

      await repository.deleteFarmer('f1');

      // Verify getFarmers after delete
      list = await repository.getFarmers();
      expect(list.length, 1);
      expect(list.first.id, 'f2');

      // Verify watchFarmers after delete
      await expectLater(
        stream,
        emits(predicate<List<Farmer>>((l) => l.length == 1 && l.first.id == 'f2')),
      );
    });

    test('deleteFarmer throws FarmerHasDependenciesException when farms exist', () async {
      when(
        () => mockSyncService.addToQueue(
          localId: any(named: 'localId'),
          entityType: any(named: 'entityType'),
          operation: any(named: 'operation'),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async {});

      final farmer = Farmer(
        id: 'f-deps',
        idTypeId: 1,
        idNumber: '1',
        firstNameAr: 'Farmer',
        fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '',
        firstNameEn: '', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '',
        birthDate: DateTime(1990),
        gender: Gender.male,
        phoneNumber: '',
        familySize: 1,
        governorateId: 'G1',
        localityId: 'L1',
        address: '',
      );

      await repository.createFarmer(farmer);

      // Add a farm linked to this farmer
      await db.into(db.farms).insert(
        FarmsCompanion.insert(
          id: 'farm-1',
          farmerId: 'f-deps',
          localFarmName: 'Test Farm',
          basin: 'B1',
          parcel: 'P1',
          area: 10.0,
          governorateId: 'G1',
          directorateId: 'D1',
          localityId: 'L1',
        ),
      );

      expect(
        () => repository.deleteFarmer('f-deps'),
        throwsA(isA<FarmerHasDependenciesException>()),
      );

      // Verify farmer is NOT marked for delete
      final local = await (db.select(db.farmers)..where((t) => t.id.equals('f-deps'))).getSingle();
      expect(local.isPendingDelete, false);

      // Verify no delete sync item created
      verifyNever(() => mockSyncService.addToQueue(
        localId: 'f-deps',
        entityType: 'farmer',
        operation: 'delete',
        data: any(named: 'data'),
      ));
    });

    test('deleteFarmer succeeds when no farms exist', () async {
      when(
        () => mockSyncService.addToQueue(
          localId: any(named: 'localId'),
          entityType: any(named: 'entityType'),
          operation: any(named: 'operation'),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async {});

      final farmer = Farmer(
        id: 'f-no-deps',
        idTypeId: 1,
        idNumber: '2',
        firstNameAr: 'Farmer No Deps',
        fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '',
        firstNameEn: '', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '',
        birthDate: DateTime(1990),
        gender: Gender.male,
        phoneNumber: '',
        familySize: 1,
        governorateId: 'G1',
        localityId: 'L1',
        address: '',
      );

      await repository.createFarmer(farmer);

      await repository.deleteFarmer('f-no-deps');

      final local = await (db.select(db.farmers)..where((t) => t.id.equals('f-no-deps'))).getSingle();
      expect(local.isPendingDelete, true);

      verify(() => mockSyncService.addToQueue(
        localId: 'f-no-deps',
        entityType: 'farmer',
        operation: 'delete',
        data: any(named: 'data'),
      )).called(1);
    });
  });

  group('Pull Synchronization', () {
    final farmer1 = Farmer(
      id: 'f1', idTypeId: 1, idNumber: '1', firstNameAr: 'N1',
      fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '',
      firstNameEn: '', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '',
      birthDate: DateTime(1990), gender: Gender.male, phoneNumber: '',
      familySize: 1, governorateId: 'G1', localityId: 'L1', address: '',
    );

    test('synchronize() upserts remote data and handles idempotency', () async {
      when(() => mockRemoteRepository.getFarmers(
        pageNumber: 1, pageSize: 50, updatedSince: any(named: 'updatedSince'),
      )).thenAnswer((_) async => [farmer1]);

      await repository.synchronize();

      final local = await db.select(db.farmers).get();
      expect(local.length, 1);
      expect(local.first.id, 'f1');
      expect(local.first.syncStatus, 'completed');

      // Run again - still 1
      await repository.synchronize();
      expect((await db.select(db.farmers).get()).length, 1);
    });

    test('synchronize() skips records with pending local changes', () async {
      // 1. Setup local record as pending update
      await db.into(db.farmers).insert(
        FarmersCompanion.insert(
          id: 'f1',
          firstNameAr: const Value('Local Original'),
          syncStatus: const Value('pending'),
        ),
      );

      // 2. Mock remote data having different name
      when(() => mockRemoteRepository.getFarmers(
        pageNumber: 1, pageSize: 50, updatedSince: any(named: 'updatedSince'),
      )).thenAnswer((_) async => [farmer1.copyWith(firstNameAr: 'Remote Change')]);

      await repository.synchronize();

      // 3. Verify local data PRESERVED
      final local = await db.select(db.farmers).getSingle();
      expect(local.firstNameAr, 'Local Original');
      expect(local.syncStatus, 'pending');
    });
  });
}
