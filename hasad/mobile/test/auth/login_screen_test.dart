import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/token_refresher.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/auth/presentation/login_screen.dart';
import 'package:mobile/l10n/app_localizations.dart';

import 'fakes.dart';

Widget buildLoginApp(FakeAuthRepository repository, FakeSecureStorage storage) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(
        (ref) => AuthNotifier(
          repository,
          storage,
          TokenRefresher(repository, storage),
        ),
      ),
    ],
    child: const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('ar')],
      home: LoginScreen(),
    ),
  );
}

void main() {
  group('LoginScreen', () {
    late FakeAuthRepository repository;
    late FakeSecureStorage storage;

    setUp(() {
      repository = FakeAuthRepository();
      storage = FakeSecureStorage();
    });

    testWidgets('shows validation errors for empty fields', (tester) async {
      await tester.pumpWidget(buildLoginApp(repository, storage));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email.'), findsOneWidget);
      expect(find.text('Please enter your password.'), findsOneWidget);
    });

    testWidgets('rejects a malformed email', (tester) async {
      await tester.pumpWidget(buildLoginApp(repository, storage));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'not-an-email');
      await tester.enterText(find.byType(TextFormField).last, 'secret');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address.'), findsOneWidget);
    });

    testWidgets('shows a localized error when login fails', (tester) async {
      repository.session = null;
      await tester.pumpWidget(buildLoginApp(repository, storage));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'admin@hasad.ps',
      );
      await tester.enterText(find.byType(TextFormField).last, 'wrong');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Login failed. Please check your credentials and try again.'),
        findsOneWidget,
      );
    });

    testWidgets('valid submission authenticates and stores tokens', (
      tester,
    ) async {
      repository.session = sampleSession();
      await tester.pumpWidget(buildLoginApp(repository, storage));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'admin@hasad.ps',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(storage.values['token'], 'access-1');
      expect(storage.values['refresh'], 'refresh-1');
    });
  });
}
