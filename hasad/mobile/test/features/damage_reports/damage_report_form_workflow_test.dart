import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/damage_reports/presentation/screens/damage_report_form_screen.dart';
import 'package:mobile/features/farms/data/reference_data_repository.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/domain/reference_data.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockReferenceDataRepository extends Mock implements ReferenceDataRepository {}
class MockDamageReportRepository extends Mock implements DamageReportRepository {}

void main() {
  late MockReferenceDataRepository mockRefRepo;
  late MockDamageReportRepository mockDamageRepo;

  final testFarm = Farm(
    id: 'FARM-1',
    farmerId: 'FARMER-1',
    localFarmName: 'Test Farm',
    ownershipTypeId: 1,
    governorateId: 'G1',
    directorateId: 'D1',
    localityId: 'L1',
    basin: 'B1',
    parcel: 'P1',
    area: 10.0,
    areaUnitId: 1,
    agriculturalSectorId: 1,
    politicalClassificationId: 1,
  );

  setUp(() {
    mockRefRepo = MockReferenceDataRepository();
    mockDamageRepo = MockDamageReportRepository();

    registerFallbackValue(DamageReport(
      id: '',
      farmId: '',
      farmerId: '',
      damageDate: DateTime.now(),
      documentationDate: DateTime.now(),
      governorateId: '',
      directorateId: '',
      localityId: '',
      statusId: '',
      notes: '',
    ));
  });

  Widget buildTestApp({DamageReport? report}) {
    return ProviderScope(
      overrides: [
        referenceDataRepositoryProvider.overrideWithValue(mockRefRepo),
        damageReportRepositoryProvider.overrideWithValue(mockDamageRepo),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: MediaQuery(
          data: const MediaQueryData(size: Size(800, 1200)),
          child: DamageReportFormScreen(farm: testFarm, report: report),
        ),
      ),
    );
  }

  testWidgets('DamageReportFormScreen requires nature and cause selection', (tester) async {
    when(() => mockRefRepo.getDamageCauseCategories()).thenAnswer((_) async => []);
    when(() => mockRefRepo.getNatures()).thenAnswer((_) async => []);
    final refData = ReferenceData(
      ownershipTypes: [], agriculturalSectors: [], politicalClassifications: [],
      areaUnits: [], measurementUnits: [], relationshipToOwners: [],
      damageNatures: [], damageActions: [], damageCategories: [], damageSubCategories: [], damageClassifications: [],
      damageCauseCategories: [], damageCauses: []
    );
    when(() => mockRefRepo.getReferenceData()).thenAnswer((_) async => refData);

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    final saveButton = find.text('Save & Next');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Please select an agricultural sector.'), findsOneWidget);
    verifyNever(() => mockDamageRepo.createDamageReport(any()));
  });

  testWidgets('DamageReportFormScreen transitions to Step 2 after header save', (tester) async {
    final natures = [const DamageNature(id: 1, nameAr: 'NatureAr', nameEn: 'NatureEn')];
    final categories = [const DamageCauseCategory(id: 1, nameAr: 'CatAr', nameEn: 'CatEn')];
    final causes = [const DamageCause(id: 10, parentId: 1, nameAr: 'CauseAr', nameEn: 'CauseEn')];
    
    when(() => mockRefRepo.getNatures()).thenAnswer((_) async => natures);
    when(() => mockRefRepo.getDamageCauseCategories()).thenAnswer((_) async => categories);
    when(() => mockRefRepo.getDamageCauses(1)).thenAnswer((_) async => causes);

    final refData = ReferenceData(
      ownershipTypes: [], agriculturalSectors: natures.map((e) => AgriculturalSector(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn)).toList(), 
      politicalClassifications: [],
      areaUnits: [], measurementUnits: [], relationshipToOwners: [],
      damageNatures: natures, damageActions: [], damageCategories: [], damageSubCategories: [], damageClassifications: [],
      damageCauseCategories: categories, damageCauses: causes
    );
    when(() => mockRefRepo.getReferenceData()).thenAnswer((_) async => refData);
    
    when(() => mockDamageRepo.createDamageReport(any())).thenAnswer((inv) async {
      final report = inv.positionalArguments[0] as DamageReport;
      return report.copyWith(reportNumber: 'NB-NAB-2026-000001');
    });

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Select Nature
    await tester.tap(find.text('Agricultural Sector'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('NatureAr').last);
    await tester.pumpAndSettle();

    // Select Cause
    await tester.tap(find.text('Select Cause'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CatAr'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CauseAr'));
    await tester.pumpAndSettle();

    // Save & Next
    final saveButton = find.text('Save & Next');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Verify in Step 2
    expect(find.text('Official Report Number'), findsOneWidget);
    expect(find.text('NB-NAB-2026-000001'), findsOneWidget);
    expect(find.text('Damage Assessment'), findsOneWidget);
  });
}
