import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart' show damageReportRepositoryProvider;
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/domain/farm_filter.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/features/damage_reports/presentation/screens/damage_reports_list_screen.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/farmers/domain/farmer_filter.dart';

import 'package:mocktail/mocktail.dart';
import '../../helpers/mocks.dart';

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier() : super(null as dynamic, null as dynamic, null as dynamic);
  
  @override
  AuthState get state => AuthState(
    status: AuthStatus.authenticated,
    session: const AuthSession(
      token: 'test-token',
      refreshToken: 'test-refresh',
      email: 'test@test.com',
      userId: 'user-1',
      roles: ['AgriculturalEngineer'],
      fullName: 'Test User',
    ),
  );
  
  @override
  set state(AuthState value) {}
}

void main() {
  late MockDamageReportRepository mockDamageRepo;
  late MockFarmRepository mockFarmRepo;
  late MockFarmerRepository mockFarmerRepo;

  setUp(() {
    mockDamageRepo = MockDamageReportRepository();
    mockFarmRepo = MockFarmRepository();
    mockFarmerRepo = MockFarmerRepository();

    // Default stubs
    when(() => mockDamageRepo.watchDamageReports()).thenAnswer((_) => Stream.value([]));
    when(() => mockDamageRepo.watchDamageReportsByFarm(any())).thenAnswer((_) => Stream.value([]));
    when(() => mockFarmRepo.watchFarms(filter: any(named: 'filter'), session: any(named: 'session')))
        .thenAnswer((_) => Stream.value([]));
    when(() => mockFarmerRepo.watchFarmers(filter: any(named: 'filter')))
        .thenAnswer((_) => Stream.value([]));
  });

  // Need to register fallback values for custom objects used in 'any()'
  setUpAll(() {
    registerFallbackValue(const FarmFilter());
    registerFallbackValue(const FarmerFilter());
  });

  Widget buildTestApp(GoRouter router) {
    return ProviderScope(
      overrides: [
        authProvider.overrideWith((ref) => FakeAuthNotifier()),
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
    expect(find.byType(BackButton), findsOneWidget);
  });
}
