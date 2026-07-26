import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/storage/database.dart' as db_local;
import 'package:mobile/features/farms/data/offline_first_reference_data_repository.dart';
import 'package:mobile/features/farms/data/remote_reference_data_repository.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/domain/reference_data.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteReferenceDataRepository extends Mock implements RemoteReferenceDataRepository {}

void main() {
  late db_local.AppDatabase db;
  late OfflineFirstReferenceDataRepository repository;
  late MockRemoteReferenceDataRepository mockRemote;

  setUp(() {
    db = db_local.AppDatabase.withExecutor(NativeDatabase.memory());
    mockRemote = MockRemoteReferenceDataRepository();
    repository = OfflineFirstReferenceDataRepository(db, mockRemote);
  });

  tearDown(() async {
    await db.close();
  });

  test('getActiveCostingSheet resolves only Active versions', () async {
    // 1. Setup hierarchical data
    final catalogId = 'CAT-1';
    await db.into(db.costingSheetCatalogs).insert(db_local.CostingSheetCatalogsCompanion.insert(
      id: catalogId,
      name: 'Test Catalog',
      createdBy: 'Admin',
    ));

    final activeVersionId = 'VER-ACTIVE';
    final archivedVersionId = 'VER-ARCHIVED';

    await db.into(db.costingSheetVersions).insert(db_local.CostingSheetVersionsCompanion.insert(
      id: activeVersionId,
      catalogId: catalogId,
      versionNumber: 2,
      status: 2, // Active
      effectiveFrom: DateTime.now().subtract(const Duration(days: 1)),
      createdBy: 'Admin',
    ));

    await db.into(db.costingSheetVersions).insert(db_local.CostingSheetVersionsCompanion.insert(
      id: archivedVersionId,
      catalogId: catalogId,
      versionNumber: 1,
      status: 3, // Archived
      effectiveFrom: DateTime.now().subtract(const Duration(days: 10)),
      createdBy: 'Admin',
    ));

    // Items for both versions
    await db.into(db.costingSheetItems).insert(db_local.CostingSheetItemsCompanion.insert(
      id: 'ITEM-ACTIVE',
      versionId: activeVersionId,
      classificationId: 101,
      unitPrice: 200.0,
    ));

    await db.into(db.costingSheetItems).insert(db_local.CostingSheetItemsCompanion.insert(
      id: 'ITEM-ARCHIVED',
      versionId: archivedVersionId,
      classificationId: 101,
      unitPrice: 150.0,
    ));

    // 2. Act
    final activePrice = await repository.getActiveCostingSheet(101);

    // 3. Assert
    expect(activePrice, isNotNull);
    expect(activePrice!.id, 'ITEM-ACTIVE');
    expect(activePrice.unitPrice, 200.0);
  });

  test('Backward compatibility: Maps legacy flat costingSheets to local legacy version', () async {
    // 1. Setup DTO with flat costingSheets (simulating old backend response)
    final referenceData = ReferenceData(
      ownershipTypes: [],
      agriculturalSectors: [],
      politicalClassifications: [],
      areaUnits: [],
      measurementUnits: [const MeasurementUnit(id: 1, nameAr: 'U', nameEn: 'U', category: 'Area')],
      relationshipToOwners: [],
      damageNatures: [const DamageNature(id: 1, nameAr: 'N', nameEn: 'N')],
      damageActions: [],
      damageCategories: [],
      damageSubCategories: [],
      damageClassifications: [],
      damageCauseCategories: [],
      damageCauses: [],
      costingSheetCatalogs: [],
      costingSheetVersions: [],
      costingSheetItems: [],
      legacyCostingSheets: [
        CostingSheetItem(
          id: 'LEGACY-GUID',
          versionId: '', // Empty in flat DTO
          classificationId: 202,
          unitPrice: 50.0,
          createdAt: DateTime.now(),
        ),
      ],
    );

    when(() => mockRemote.getReferenceData()).thenAnswer((_) async => referenceData);

    // 2. Save to local
    await repository.getReferenceData(forceRefresh: true);

    // 3. Verify it was mapped to LEGACY-VERSION-SERVER
    final items = await db.select(db.costingSheetItems).get();
    expect(items.any((i) => i.id == 'LEGACY-GUID' && i.versionId == 'LEGACY-VERSION-SERVER'), isTrue);

    final resolved = await repository.getActiveCostingSheet(202);
    expect(resolved, isNotNull);
    expect(resolved!.unitPrice, 50.0);
  });
}
