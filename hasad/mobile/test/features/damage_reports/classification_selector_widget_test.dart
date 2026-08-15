import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/damage_reports/presentation/widgets/classification_selector.dart';
import 'package:mobile/features/damage_reports/presentation/providers/classification_wizard_provider.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockReferenceDataRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(const DamageNature(id: 0, nameAr: '', nameEn: ''));
    registerFallbackValue(const DamageAction(id: 0, nameAr: '', nameEn: ''));
    registerFallbackValue(const DamageCategory(id: 0, parentId: 0, nameAr: '', nameEn: ''));
    registerFallbackValue(const DamageSubCategory(id: 0, parentId: 0, nameAr: '', nameEn: ''));
    registerFallbackValue(const DamageClassification(id: 0, parentId: 0, nameAr: '', nameEn: ''));
    registerFallbackValue(const ClassificationParams(sectorId: 0));
  });

  setUp(() {
    mockRepo = MockReferenceDataRepository();
  });

  Widget buildTestApp() {
    return ProviderScope(
      overrides: [
        referenceDataRepositoryProvider.overrideWithValue(mockRepo),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        home: Scaffold(body: ClassificationSelector(sectorId: 1)),
      ),
    );
  }

  testWidgets('ClassificationSelector shows Natures in Step 1', (tester) async {
    final natures = [const DamageNature(id: 1, nameAr: 'PlantsAr', nameEn: 'PlantsEn')];
    when(() => mockRepo.getNatures()).thenAnswer((_) async => natures);

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Damage Nature'), findsOneWidget);
    expect(find.text('PlantsAr'), findsOneWidget);
  });

  testWidgets('ClassificationSelector navigates to Categories in Step 2', (tester) async {
    final natures = [const DamageNature(id: 1, nameAr: 'PlantsAr', nameEn: 'PlantsEn')];
    final actions = [const DamageAction(id: 5, nameAr: 'ActionAr', nameEn: 'ActionEn')];
    final categories = [const DamageCategory(id: 10, parentId: 1, nameAr: 'TreesAr', nameEn: 'TreesEn')];
    
    when(() => mockRepo.getNatures()).thenAnswer((_) async => natures);
    when(() => mockRepo.getActions()).thenAnswer((_) async => actions);
    when(() => mockRepo.getCategories(1)).thenAnswer((_) async => categories);

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Click Plants
    await tester.tap(find.text('PlantsAr'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Damage Action'), findsOneWidget);
    expect(find.textContaining('2 of 5'), findsOneWidget);

    // Click Action
    await tester.tap(find.text('ActionAr'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Category'), findsOneWidget);
    expect(find.textContaining('3 of 5'), findsOneWidget);
    expect(find.text('TreesAr'), findsOneWidget);
  });
}
