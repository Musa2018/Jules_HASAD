import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/damage_reports/presentation/screens/damage_report_header_screen.dart';
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
class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockReferenceDataRepository mockRefRepo;
  late MockDamageReportRepository mockDamageRepo;
  late MockGoRouter mockRouter;

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
    mockRouter = MockGoRouter();

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
      createdBy: '',
    ));
  });

  Widget buildTestApp({String? reportId}) {
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
        home: InheritedGoRouter(
          goRouter: mockRouter,
          child: MediaQuery(
            data: const MediaQueryData(size: Size(800, 1200)),
            child: (reportId == null
                ? DamageReportHeaderScreen(farm: testFarm)
                : DamageReportFormScreen(reportId: reportId)) as Widget,
          ),
        ),
      ),
    );
  }

  testWidgets('DamageReportHeaderScreen requires cause selection', (tester) async {
    when(() => mockRefRepo.getDamageCauseCategories()).thenAnswer((_) async => []);
    when(() => mockRefRepo.getNatures()).thenAnswer((_) async => []);
    final refData = ReferenceData(
      ownershipTypes: [], agriculturalSectors: [const AgriculturalSector(id: 1, nameAr: 'S1', nameEn: 'S1')], 
      politicalClassifications: [],
      areaUnits: [], measurementUnits: [], relationshipToOwners: [],
      damageNatures: [], damageActions: [], damageCategories: [], damageSubCategories: [], damageClassifications: [],
      damageCauseCategories: [], damageCauses: []
    );
    when(() => mockRefRepo.getReferenceData()).thenAnswer((_) async => refData);

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    final saveButton = find.text('Save');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Please select a damage cause.'), findsOneWidget);
    verifyNever(() => mockDamageRepo.createDamageReport(any()));
  });

  testWidgets('DamageReportHeaderScreen successfully saves header and returns to list', (tester) async {
    final natures = [const DamageNature(id: 1, nameAr: 'NatureAr', nameEn: 'NatureEn')];
    final categories = [const DamageCauseCategory(id: 1, nameAr: 'CatAr', nameEn: 'CatEn')];
    final causes = [const DamageCause(id: 10, parentId: 1, nameAr: 'CauseAr', nameEn: 'CauseEn')];
    
    when(() => mockRefRepo.getNatures()).thenAnswer((_) async => natures);
    when(() => mockRefRepo.getDamageCauseCategories()).thenAnswer((_) async => categories);
    when(() => mockRefRepo.getDamageCauses(1)).thenAnswer((_) async => causes);

    final refData = ReferenceData(
      ownershipTypes: [], agriculturalSectors: [const AgriculturalSector(id: 1, nameAr: 'NatureAr', nameEn: 'NatureEn')], 
      politicalClassifications: [],
      areaUnits: [], measurementUnits: [], relationshipToOwners: [],
      damageNatures: natures, damageActions: [], damageCategories: [], damageSubCategories: [], damageClassifications: [],
      damageCauseCategories: categories, damageCauses: causes
    );
    when(() => mockRefRepo.getReferenceData()).thenAnswer((_) async => refData);
    
    when(() => mockDamageRepo.createDamageReport(any())).thenAnswer((inv) async {
      final report = inv.positionalArguments[0] as DamageReport;
      return report.copyWith(id: 'NEW-ID', temporaryFormNumber: 'TEMP-2026-0001');
    });

    when(() => mockRouter.go(any(), extra: any(named: 'extra'))).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Select Cause
    await tester.tap(find.text('Select Cause'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CatAr'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CauseAr'));
    await tester.pumpAndSettle();

    // Save
    final saveButton = find.text('Save');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Verify success message and navigation to list
    expect(find.textContaining('Items can be added after synchronization'), findsOneWidget);
    verify(() => mockDamageRepo.createDamageReport(any())).called(1);
    verify(() => mockRouter.pop()).called(1);
  });
}
