import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/damage_reports/presentation/widgets/classification_selector.dart';
import 'package:mobile/features/farms/data/reference_data_repository.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockReferenceDataRepository extends Mock implements ReferenceDataRepository {}

void main() {
  late MockReferenceDataRepository mockRepo;

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
        home: Scaffold(body: ClassificationSelector()),
      ),
    );
  }

  testWidgets('ClassificationSelector shows Natures in Step 1', (tester) async {
    final natures = [const DamageNature(id: 1, nameAr: 'PlantsAr', nameEn: 'PlantsEn')];
    when(() => mockRepo.getNatures()).thenAnswer((_) async => natures);

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Select Damage Nature'), findsOneWidget);
    expect(find.text('PlantsAr'), findsOneWidget);
  });

  testWidgets('ClassificationSelector navigates to Categories in Step 2', (tester) async {
    final natures = [const DamageNature(id: 1, nameAr: 'PlantsAr', nameEn: 'PlantsEn')];
    final categories = [const DamageCategory(id: 10, parentId: 1, nameAr: 'TreesAr', nameEn: 'TreesEn')];
    
    when(() => mockRepo.getNatures()).thenAnswer((_) async => natures);
    when(() => mockRepo.getCategories(1)).thenAnswer((_) async => categories);

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Click Plants
    await tester.tap(find.text('PlantsAr'));
    await tester.pumpAndSettle();

    expect(find.text('Select Category'), findsOneWidget);
    expect(find.text('TreesAr'), findsOneWidget);
  });
}
