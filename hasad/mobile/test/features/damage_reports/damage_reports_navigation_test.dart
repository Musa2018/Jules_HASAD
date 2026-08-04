import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart' show damageReportRepositoryProvider;
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/domain/farm_filter.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/damage_reports/presentation/screens/damage_reports_list_screen.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_workflow_history.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/farmers/domain/farmer_filter.dart';

class MockDamageReportRepository implements DamageReportRepository {
  @override
  Stream<List<DamageReport>> watchDamageReports() => Stream.value([]);
  @override
  Future<void> synchronize() async {}
  @override
  Future<DamageReport> createDamageReport(DamageReport report) async => report;
  @override
  Future<void> deleteDamageReport(String id) async {}
  @override
  Future<DamageReport> getDamageReport(String id) async => throw UnimplementedError();
  @override
  Future<DamageReport> updateDamageReport(DamageReport report) async => report;
  Stream<DamageReport?> watchDamageReport(String id) => Stream.value(null);
  @override
  Future<DamageItem> addDamageItem(DamageItem item) async => item;
  @override
  Future<void> deleteDamageItem(String id) async {}
  @override
  Future<DamageItem> updateDamageItem(DamageItem item) async => item;
  @override
  Future<void> transitionReport(String id, String toStatus, {String? comment, bool isOverride = false}) async {}
  @override
  Future<List<DamageWorkflowHistory>> getReportHistory(String id) async => [];
  @override
  Stream<List<DamageWorkflowHistory>> watchReportHistory(String id) => Stream.value([]);
  @override
  Future<void> cancelDeleteDamageReport(String id) async {}
  @override
  Future<DamageReport> createDamageReportFromJson(Map<String, dynamic> json) async => throw UnimplementedError();
  @override
  Future<List<DamageReport>> getDamageReports() async => [];
  @override
  Future<List<DamageReport>> getDamageReportsByFarm(String farmId) async => [];
  @override
  Future<void> submitReport(String id) async {}
  @override
  Future<void> retrySync(String id) async {}
  @override
  Future<void> retryAllFailedSyncs() async {}
  @override
  Stream<List<DamageReport>> watchDamageReportsByFarm(String farmId) => Stream.value([]);
  @override
  Future<void> syncWorkflowHistory(String localId, String serverId) async {}
}

class MockFarmRepository implements FarmRepository {
  @override
  Stream<List<Farm>> watchFarms({FarmFilter filter = const FarmFilter(), AuthSession? session}) => Stream.value([]);
  @override
  Future<void> synchronize({DateTime? updatedSince}) async {}
  @override
  Future<Farm> createFarm(Farm farm, {AuthSession? session}) async => farm;
  @override
  Future<void> deleteFarm(String id, {AuthSession? session}) async {}
  @override
  Future<Farm> getFarm(String id) async => throw UnimplementedError();
  @override
  Future<Farm> updateFarm(Farm farm, {AuthSession? session}) async => farm;
  @override
  Stream<Farm?> watchFarm(String id) => Stream.value(null);
  @override
  Future<void> cancelDeleteFarm(String id) async {}
  @override
  Future<List<Farm>> getFarms({int pageNumber = 1, int pageSize = 10, String? searchText, DateTime? updatedSince}) async => [];
  @override
  Future<List<Farm>> getFarmsByFarmer(String farmerId) async => [];
}

class MockFarmerRepository implements FarmerRepository {
  @override
  Future<List<Farmer>> getFarmers({int pageNumber = 1, int pageSize = 10, String? idNumber, String? name, String? searchText, DateTime? updatedSince, bool isOperational = false}) async => [];
  @override
  Future<void> synchronize({DateTime? updatedSince}) async {}
  @override
  Future<Farmer> createFarmer(Farmer farmer) async => farmer;
  @override
  Future<void> deleteFarmer(String id) async {}
  @override
  Future<Farmer> getFarmer(String id) async => throw UnimplementedError();
  @override
  Future<Farmer> updateFarmer(Farmer farmer) async => farmer;
  @override
  Stream<List<Farmer>> watchFarmers({FarmerFilter filter = const FarmerFilter()}) => Stream.value([]);
  @override
  Stream<Farmer?> watchFarmer(String id) => Stream.value(null);
  @override
  Future<void> cancelDeleteFarmer(String id) async {}
  @override
  Future<Farmer?> findByIdNumber(String idNumber) async => null;
}

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
