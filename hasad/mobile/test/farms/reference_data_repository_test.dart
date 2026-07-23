import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farms/data/offline_first_reference_data_repository.dart';
import 'package:mobile/features/farms/data/reference_data_repository.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart' as domain;
import 'package:mobile/features/farms/domain/reference_data.dart';

class MockReferenceDataRepository extends Mock implements ReferenceDataRepository {}

void main() {
  late AppDatabase db;
  late MockReferenceDataRepository remote;
  late OfflineFirstReferenceDataRepository repository;

  final sampleData = ReferenceData(
    ownershipTypes: [const domain.OwnershipType(id: 1, nameAr: 'ملك', nameEn: 'Owned')],
    agriculturalSectors: [const domain.AgriculturalSector(id: 1, nameAr: 'نباتي', nameEn: 'Plant')],
    politicalClassifications: [const domain.PoliticalClassification(id: 1, nameAr: 'A', nameEn: 'A')],
    areaUnits: [const domain.AreaUnit(id: 1, nameAr: 'دونم', nameEn: 'Dunum')],
    measurementUnits: [const domain.MeasurementUnit(id: 1, nameAr: 'دونم', nameEn: 'Dunum', category: 'Area')],
    relationshipToOwners: [const domain.RelationshipToOwner(id: 1, nameAr: 'المالك نفسه', nameEn: 'Owner Himself')],
    damageNatures: [const domain.DamageNature(id: 1, nameAr: 'نباتي', nameEn: 'Plant')],
    damageCategories: [const domain.DamageCategory(id: 1, parentId: 1, nameAr: 'أشجار', nameEn: 'Trees')],
    damageSubCategories: [const domain.DamageSubCategory(id: 1, parentId: 1, nameAr: 'زيتون', nameEn: 'Olive')],
    damageClassifications: [const domain.DamageClassification(id: 1, parentId: 1, nameAr: 'عمر 1-5', nameEn: 'Age 1-5')],
    damageCauseCategories: [const domain.DamageCauseCategory(id: 1, nameAr: 'سياسي', nameEn: 'Political')],
    damageCauses: [const domain.DamageCause(id: 1, parentId: 1, nameAr: 'جيش', nameEn: 'Army')],
    costingSheetCatalogs: [],
    costingSheetVersions: [],
    costingSheetItems: [],
    legacyCostingSheets: [
      domain.CostingSheetItem(
        id: 'cs1',
        versionId: 'v1',
        classificationId: 1,
        unitPrice: 100,
        createdAt: DateTime(2026, 1, 1),
      )
    ],
  );

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    remote = MockReferenceDataRepository();
    repository = OfflineFirstReferenceDataRepository(db, remote);
  });

  tearDown(() async {
    await db.close();
  });

  group('OfflineFirstReferenceDataRepository', () {
    test('fetches from remote and saves to local when local is empty', () async {
      when(() => remote.getReferenceData()).thenAnswer((_) async => sampleData);

      final result = await repository.getReferenceData();

      expect(result.ownershipTypes.length, sampleData.ownershipTypes.length);
      expect(result.measurementUnits.length, sampleData.measurementUnits.length);
      verify(() => remote.getReferenceData()).called(1);

      // Verify persistence
      final localOwnership = await db.select(db.ownershipTypes).get();
      expect(localOwnership.length, 1);
      expect(localOwnership.first.nameEn, 'Owned');
    });

    test('returns local data when present and not forced', () async {
      // Seed local DB
      await db.into(db.ownershipTypes).insert(OwnershipTypesCompanion.insert(id: const drift.Value(1), nameAr: 'ملك', nameEn: 'Owned'));
      await db.into(db.agriculturalSectors).insert(AgriculturalSectorsCompanion.insert(id: const drift.Value(1), nameAr: 'نباتي', nameEn: 'Plant'));
      await db.into(db.politicalClassifications).insert(PoliticalClassificationsCompanion.insert(id: const drift.Value(1), nameAr: 'A', nameEn: 'A'));
      await db.into(db.areaUnits).insert(AreaUnitsCompanion.insert(id: const drift.Value(1), nameAr: 'دونم', nameEn: 'Dunum'));
      await db.into(db.measurementUnits).insert(MeasurementUnitsCompanion.insert(id: const drift.Value(1), nameAr: 'دونم', nameEn: 'Dunum', category: 'Area'));
      await db.into(db.relationshipToOwners).insert(RelationshipToOwnersCompanion.insert(id: const drift.Value(1), nameAr: 'المالك نفسه', nameEn: 'Owner Himself'));
      await db.into(db.damageNatures).insert(DamageNaturesCompanion.insert(id: const drift.Value(1), nameAr: 'نباتي', nameEn: 'Plant'));
      await db.into(db.damageCategories).insert(DamageCategoriesCompanion.insert(id: const drift.Value(1), parentId: 1, nameAr: 'أشجار', nameEn: 'Trees'));
      await db.into(db.damageSubCategories).insert(DamageSubCategoriesCompanion.insert(id: const drift.Value(1), parentId: 1, nameAr: 'زيتون', nameEn: 'Olive'));
      await db.into(db.damageClassifications).insert(DamageClassificationsCompanion.insert(id: const drift.Value(1), parentId: 1, nameAr: 'عمر 1-5', nameEn: 'Age 1-5'));
      await db.into(db.damageCauseCategories).insert(DamageCauseCategoriesCompanion.insert(id: const drift.Value(1), nameAr: 'سياسي', nameEn: 'Political'));
      await db.into(db.damageCauses).insert(DamageCausesCompanion.insert(id: const drift.Value(1), parentId: 1, nameAr: 'جيش', nameEn: 'Army'));
      
      final legacyVersionId = 'LEGACY-VERSION-SERVER';
      await db.into(db.costingSheetVersions).insert(CostingSheetVersionsCompanion.insert(
        id: legacyVersionId,
        catalogId: 'LEGACY-CATALOG-SERVER',
        versionNumber: 1,
        status: 2, // Active
        effectiveFrom: DateTime(2026, 1, 1),
        createdBy: 'System',
      ));

      await db.into(db.costingSheetItems).insert(CostingSheetItemsCompanion.insert(
        id: 'cs1',
        versionId: legacyVersionId,
        classificationId: 1,
        unitPrice: 100,
      ));

      final result = await repository.getReferenceData();

      expect(result.ownershipTypes.length, 1);
      expect(result.costingSheetItems.length, 1);
      expect(result.costingSheetItems.first.unitPrice, 100.0);
      verifyNever(() => remote.getReferenceData());
    });

    test('refreshes from remote when forceRefresh is true', () async {
      // Seed local DB
       await db.into(db.ownershipTypes).insert(OwnershipTypesCompanion.insert(id: const drift.Value(1), nameAr: 'قديم', nameEn: 'Old'));
       
      await db.into(db.agriculturalSectors).insert(AgriculturalSectorsCompanion.insert(id: const drift.Value(1), nameAr: 'نباتي', nameEn: 'Plant'));
      await db.into(db.politicalClassifications).insert(PoliticalClassificationsCompanion.insert(id: const drift.Value(1), nameAr: 'A', nameEn: 'A'));
      await db.into(db.areaUnits).insert(AreaUnitsCompanion.insert(id: const drift.Value(1), nameAr: 'دونم', nameEn: 'Dunum'));
      await db.into(db.measurementUnits).insert(MeasurementUnitsCompanion.insert(id: const drift.Value(1), nameAr: 'دونم', nameEn: 'Dunum', category: 'Area'));
      await db.into(db.relationshipToOwners).insert(RelationshipToOwnersCompanion.insert(id: const drift.Value(1), nameAr: 'المالك نفسه', nameEn: 'Owner Himself'));

      when(() => remote.getReferenceData()).thenAnswer((_) async => sampleData);

      final result = await repository.getReferenceData(forceRefresh: true);

      expect(result.ownershipTypes.first.nameEn, 'Owned');
      verify(() => remote.getReferenceData()).called(1);
      
      final localOwnership = await db.select(db.ownershipTypes).get();
      expect(localOwnership.first.nameEn, 'Owned');
    });
  });
}
