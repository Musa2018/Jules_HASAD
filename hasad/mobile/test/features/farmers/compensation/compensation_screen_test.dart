import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/farmers/domain/compensation.dart';
import 'package:mobile/features/farmers/presentation/compensation/compensation_providers.dart';
import 'package:mobile/features/farmers/presentation/compensation/compensation_screen.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/farmers/data/compensation_repository.dart';

class MockCompensationRepository extends Mock implements CompensationRepository {}

void main() {
  late MockCompensationRepository repository;

  setUp(() {
    repository = MockCompensationRepository();
  });

  Widget buildTestApp(String reportId) {
    return ProviderScope(
      overrides: [
        compensationRepositoryProvider.overrideWithValue(repository),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        home: CompensationScreen(reportId: '123'),
      ),
    );
  }

  testWidgets('CompensationScreen shows no compensation view when null', (tester) async {
    when(() => repository.getByReportId('123')).thenAnswer((_) async => null);

    await tester.pumpWidget(buildTestApp('123'));
    await tester.pumpAndSettle();

    expect(find.text('No compensation calculated yet.'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('CompensationScreen shows detail view when compensation exists', (tester) async {
    final comp = Compensation(
      id: 'c1',
      clientId: 'c1',
      damageReportId: '123',
      calculatedAmount: 1000,
      approvedAmount: 800,
      status: 'Calculated',
      remarks: 'Looks good',
      rowVersion: 'v1',
    );
    when(() => repository.getByReportId('123')).thenAnswer((_) async => comp);

    await tester.pumpWidget(buildTestApp('123'));
    await tester.pumpAndSettle();

    expect(find.text('1000.0'), findsOneWidget);
    expect(find.text('800.0'), findsOneWidget);
    expect(find.text('Calculated'), findsOneWidget);
    expect(find.text('Looks good'), findsOneWidget);
  });
}
