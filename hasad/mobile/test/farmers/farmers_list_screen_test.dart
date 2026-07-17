import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/presentation/farmers_list_screen.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  testWidgets('FarmersListScreen shows farmers list', (tester) async {
    final farmers = [
      const Farmer(
        id: '1',
        name: 'John Doe',
        nationalId: '123456789',
        phoneNumber: '0599123456',
        address: 'Gaza',
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [farmersListProvider.overrideWith((ref) => farmers)],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en'), Locale('ar')],
          home: FarmersListScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('123456789'), findsOneWidget);
  });

  testWidgets('FarmersListScreen shows empty message', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [farmersListProvider.overrideWith((ref) => [])],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en'), Locale('ar')],
          home: FarmersListScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('No farmers found.'), findsOneWidget);
  });
}
