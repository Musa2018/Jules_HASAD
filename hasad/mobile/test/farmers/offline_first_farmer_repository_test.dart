import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';

class MockSyncService extends Mock implements BackgroundSyncService {}

class MockRemoteRepository extends Mock implements FarmerRepository {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late AppDatabase db;
  late MockSyncService mockSyncService;
  late MockRemoteRepository mockRemoteRepository;
  late MockConnectivity mockConnectivity;
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
    mockSyncService = MockSyncService();
    mockRemoteRepository = MockRemoteRepository();
    mockConnectivity = MockConnectivity();
    repository = OfflineFirstFarmerRepository(
      db,
      mockSyncService,
      mockRemoteRepository,
      mockConnectivity,
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
}
