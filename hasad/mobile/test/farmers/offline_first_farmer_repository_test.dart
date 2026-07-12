import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';

class MockSyncService extends Mock implements BackgroundSyncService {}

void main() {
  late AppDatabase db;
  late MockSyncService mockSyncService;
  late OfflineFirstFarmerRepository repository;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    mockSyncService = MockSyncService();
    repository = OfflineFirstFarmerRepository(db, mockSyncService);
    
    registerFallbackValue(const Farmer(id: '', name: '', nationalId: '', phoneNumber: '', address: '', rowVersion: ''));
  });

  tearDown(() async {
    await db.close();
  });

  test('createFarmer saves locally and adds to sync queue', () async {
    when(() => mockSyncService.addToQueue(
          localId: any(named: 'localId'),
          entityType: any(named: 'entityType'),
          operation: any(named: 'operation'),
          data: any(named: 'data'),
        )).thenAnswer((_) async {});

    const farmer = Farmer(
      id: '',
      name: 'Test Farmer',
      nationalId: '12345',
      phoneNumber: '555',
      address: 'Test Address',
    );

    final result = await repository.createFarmer(farmer);

    expect(result.name, farmer.name);
    expect(result.id, isNotEmpty);

    final localFarmers = await db.select(db.farmers).get();
    expect(localFarmers.length, 1);
    expect(localFarmers.first.name, farmer.name);
    expect(localFarmers.first.syncStatus, 'pending');

    verify(() => mockSyncService.addToQueue(
          localId: result.id,
          entityType: 'farmer',
          operation: 'create',
          data: result.toJson(),
        )).called(1);
  });
}
