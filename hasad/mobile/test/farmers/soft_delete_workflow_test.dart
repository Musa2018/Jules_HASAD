import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mocks.dart';

void main() {
  late AppDatabase db;
  late OfflineFirstFarmerRepository repository;
  late MockBackgroundSyncService mockSyncService;
  late MockRef mockRef;
  late MockFarmerRepository mockRemoteRepository;
  late MockConnectivity mockConnectivity;
  late MockAuthorizationService mockAuthService;

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

    when(() => mockSyncService.addToQueue(
          localId: any(named: 'localId'),
          entityType: any(named: 'entityType'),
          operation: any(named: 'operation'),
          data: any(named: 'data'),
        )).thenAnswer((_) async => {});

    when(() => mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.none]);
  });

  tearDown(() async {
    await db.close();
  });

  test('Soft Delete allows creating new farmer with same ID Number', () async {
    final idNumber = '949585335';
    final farmer1 = Farmer(
      id: 'uuid-1',
      idTypeId: 1,
      idNumber: idNumber,
      firstNameAr: 'Farmer',
      fatherNameAr: 'One',
      grandfatherNameAr: 'A',
      familyNameAr: 'B',
      firstNameEn: 'Farmer',
      fatherNameEn: 'One',
      grandfatherNameEn: 'A',
      familyNameEn: 'B',
      birthDate: DateTime(1980, 1, 1),
      gender: Gender.male,
      phoneNumber: '0599111111',
      familySize: 4,
      governorateId: 'G1',
      localityId: 'L1',
      address: 'Address 1',
    );

    // 1. Create first farmer
    await repository.createFarmer(farmer1);
    
    // Verify it's found
    var found = await repository.findByIdNumber(idNumber);
    expect(found?.id, 'uuid-1');

    // 2. Soft delete first farmer
    await repository.deleteFarmer('uuid-1');
    
    // Verify it's NOT found by search anymore (though it exists in DB)
    found = await repository.findByIdNumber(idNumber);
    expect(found, isNull);

    // 3. Create second farmer with SAME ID number
    final farmer2 = farmer1.copyWith(id: 'uuid-2', firstNameAr: 'Farmer Two');
    await repository.createFarmer(farmer2);

    // Verify it's found
    found = await repository.findByIdNumber(idNumber);
    expect(found?.id, 'uuid-2');
    expect(found?.firstNameAr, 'Farmer Two');

    // 4. Verify DB state (both exist)
    final allInDb = await db.select(db.farmers).get();
    expect(allInDb.length, 2);
    
    final deleted = allInDb.firstWhere((f) => f.id == 'uuid-1');
    final active = allInDb.firstWhere((f) => f.id == 'uuid-2');
    
    expect(deleted.isPendingDelete, isTrue);
    expect(active.isPendingDelete, isFalse);
    expect(deleted.idNumber, active.idNumber);
  });
}
