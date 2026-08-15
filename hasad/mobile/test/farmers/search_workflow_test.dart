import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:drift/native.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';

import '../helpers/mocks.dart';

void main() {
  late AppDatabase db;
  late MockBackgroundSyncService mockSyncService;
  late MockRef mockRef;
  late MockFarmerRepository mockRemoteRepository;
  late MockConnectivity mockConnectivity;
  late MockAuthorizationService mockAuthService;
  late OfflineFirstFarmerRepository repository;

  final testFarmer = Farmer(
    id: 'local-uuid',
    idTypeId: 1,
    idNumber: '123456789',
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
    address: 'Gaza',
  );

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
      db,
      mockRef,
      mockRemoteRepository,
      mockConnectivity,
      mockAuthService,
      null,
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('findByIdNumber returns local farmer if found', () async {
    // Insert into local DB
    await db.into(db.farmers).insert(
          FarmersCompanion.insert(
            id: testFarmer.id,
            idNumber: const Value('123456789'),
            firstNameAr: const Value('أحمد'),
            fatherNameAr: const Value('محمد'),
            grandfatherNameAr: const Value('علي'),
            familyNameAr: const Value('محمود'),
            firstNameEn: const Value('Ahmed'),
            fatherNameEn: const Value('Mohammed'),
            grandfatherNameEn: const Value('Ali'),
            familyNameEn: const Value('Mahmoud'),
            syncStatus: const Value('completed'),
          ),
        );

    final result = await repository.findByIdNumber('123456789');

    expect(result, isNotNull);
    expect(result!.idNumber, '123456789');
    verifyNever(() => mockConnectivity.checkConnectivity());
  });

  test('findByIdNumber fallbacks to remote if not found locally and online', () async {
    when(() => mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.wifi]);
    when(() => mockRemoteRepository.findByIdNumber('123456789'))
        .thenAnswer((_) async => testFarmer);

    final result = await repository.findByIdNumber('123456789');

    expect(result, isNotNull);
    expect(result!.idNumber, '123456789');

    // Verify it was saved locally
    final local = await db.select(db.farmers).get();
    expect(local.length, 1);
    expect(local.first.id, testFarmer.id);
  });

  test('findByIdNumber returns null if not found locally and offline', () async {
    when(() => mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.none]);

    final result = await repository.findByIdNumber('123456789');

    expect(result, isNull);
    verifyNever(() => mockRemoteRepository.findByIdNumber(any()));
  });
}
