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
    relationshipToOwners: [const domain.RelationshipToOwner(id: 1, nameAr: 'المالك نفسه', nameEn: 'Owner Himself')],
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

      expect(result, sampleData);
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
      await db.into(db.relationshipToOwners).insert(RelationshipToOwnersCompanion.insert(id: const drift.Value(1), nameAr: 'المالك نفسه', nameEn: 'Owner Himself'));

      final result = await repository.getReferenceData();

      expect(result, sampleData);
      verifyNever(() => remote.getReferenceData());
    });

    test('refreshes from remote when forceRefresh is true', () async {
      // Seed local DB
       await db.into(db.ownershipTypes).insert(OwnershipTypesCompanion.insert(id: const drift.Value(1), nameAr: 'قديم', nameEn: 'Old'));
       
      await db.into(db.agriculturalSectors).insert(AgriculturalSectorsCompanion.insert(id: const drift.Value(1), nameAr: 'نباتي', nameEn: 'Plant'));
      await db.into(db.politicalClassifications).insert(PoliticalClassificationsCompanion.insert(id: const drift.Value(1), nameAr: 'A', nameEn: 'A'));
      await db.into(db.areaUnits).insert(AreaUnitsCompanion.insert(id: const drift.Value(1), nameAr: 'دونم', nameEn: 'Dunum'));
      await db.into(db.relationshipToOwners).insert(RelationshipToOwnersCompanion.insert(id: const drift.Value(1), nameAr: 'المالك نفسه', nameEn: 'Owner Himself'));

      when(() => remote.getReferenceData()).thenAnswer((_) async => sampleData);

      final result = await repository.getReferenceData(forceRefresh: true);

      expect(result, sampleData);
      verify(() => remote.getReferenceData()).called(1);
      
      final localOwnership = await db.select(db.ownershipTypes).get();
      expect(localOwnership.first.nameEn, 'Owned');
    });
  });
}
