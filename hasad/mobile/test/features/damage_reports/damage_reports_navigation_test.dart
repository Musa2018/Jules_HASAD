import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mobile/features/damage_reports/domain/interfaces/damage_report_repository.dart';
import 'package:mobile/features/farms/domain/interfaces/farm_repository.dart';
import 'package:mobile/features/farmers/domain/interfaces/farmer_repository.dart';

import 'damage_reports_navigation_test.mocks.dart';

@GenerateMocks([IDamageReportRepository, IFarmRepository, IFarmerRepository])
void main() {
  late MockIDamageReportRepository mockDamageRepo;
  late MockIFarmRepository mockFarmRepo;
  late MockIFarmerRepository mockFarmerRepo;

  setUp(() {
    mockDamageRepo = MockIDamageReportRepository();
    mockFarmRepo = MockIFarmRepository();
    mockFarmerRepo = MockIFarmerRepository();

    when(mockDamageRepo.watchDamageReports()).thenAnswer((_) => Stream.value([]));
    when(mockFarmRepo.watchFarms()).thenAnswer((_) => Stream.value([]));
  });

  Widget buildTestApp(GoRouter router) {
    return ProviderScope(
      overrides: [
        authProvider.overrideWith((ref) => AuthState(
          status: AuthStatus.authenticated,
          session: const AuthSession(
            token: 'test-token',
            email: 'test@test.com',
            userId: 'user-1',
            roles: ['AgriculturalEngineer'],
            fullName: 'Test User',
          ),
        )),
        damageReportRepositoryProvider.overrideWithValue(mockDamageRepo),
        farmRepositoryProvider.overrideWithValue(mockFarmRepo),
        farmerRepositoryProvider.overrideWithValue(mockFarmerRepo),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ar')],
      ),
    );
  }

  testWidgets('DamageReportsListScreen shows back to dashboard when it is the root of the stack', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.damageReports,
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const Scaffold(body: Text('Dashboard')),
        ),
        GoRoute(
          path: AppRoutes.damageReports,
          builder: (context, state) => DamageReportsListScreen(farm: state.extra as Farm?),
        ),
      ],
    );

    await tester.pumpWidget(buildTestApp(router));
    await tester.pumpAndSettle();

    // Should find the manual back button (since it's root)
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // Click it
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Should be on dashboard
    expect(find.text('Dashboard'), findsOneWidget);
  });

  testWidgets('DamageReportsListScreen shows default back button when pushed', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.home,
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => Scaffold(
            body: ElevatedButton(
              onPressed: () => context.push(AppRoutes.damageReports),
              child: const Text('Go to Reports'),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.damageReports,
          builder: (context, state) => DamageReportsListScreen(farm: state.extra as Farm?),
        ),
      ],
    );

    await tester.pumpWidget(buildTestApp(router));
    await tester.pumpAndSettle();

    // Go to reports
    await tester.tap(find.text('Go to Reports'));
    await tester.pumpAndSettle();

    // Should find the back button (provided by Scaffold/AppBar naturally because it can pop)
    // AppBar leading will be null if context.canPop() is true, letting Flutter handle it.
    expect(find.byType(BackButton), findsOneWidget);
  });
}
