import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/auth/presentation/login_screen.dart';
import 'package:mobile/features/farmers/domain/damage_report.dart';
import 'package:mobile/features/farmers/domain/farm.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/presentation/damage_report/damage_report_form_screen.dart';
import 'package:mobile/features/farmers/presentation/damage_report/damage_reports_list_screen.dart';
import 'package:mobile/features/farmers/presentation/farm_form_screen.dart';
import 'package:mobile/features/farmers/presentation/farmer_form_screen.dart';
import 'package:mobile/features/farmers/presentation/farmers_list_screen.dart';
import 'package:mobile/features/farmers/presentation/farms_list_screen.dart';
import 'package:mobile/features/home/presentation/home_screen.dart';

/// Route paths used across the application.
abstract final class AppRoutes {
  /// Splash shown while the persisted session is being restored.
  static const splash = '/';

  /// Login screen.
  static const login = '/login';

  /// Authenticated home screen.
  static const home = '/home';

  /// Farmers list.
  static const farmers = '/farmers';

  /// Add farmer.
  static const addFarmer = '/farmers/add';

  /// Edit farmer.
  static const editFarmer = '/farmers/edit';

  /// Farms list.
  static const farms = '/farms';

  /// Add farm.
  static const addFarm = '/farms/add';

  /// Edit farm.
  static const editFarm = '/farms/edit';

  /// Damage reports list.
  static const damageReports = '/damage-reports';

  /// Add damage report.
  static const addDamageReport = '/damage-reports/add';

  /// Edit damage report.
  static const editDamageReport = '/damage-reports/edit';
}

/// Bridges a Riverpod provider into a [Listenable] so GoRouter re-evaluates
/// its redirect whenever authentication state changes.
class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(Ref ref) {
    ref.listen<AuthState>(authProvider, (_, _) => notifyListeners());
  }
}

/// Application router with an authentication guard.
///
/// - While the session is being restored, all navigation stays on the splash
///   route.
/// - Unauthenticated users are redirected to [AppRoutes.login].
/// - Authenticated users are kept out of the splash/login routes and land on
///   [AppRoutes.home].
final appRouterProvider = Provider<GoRouter>((ref) {
  final listenable = _AuthStateListenable(ref);
  ref.onDispose(listenable.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: listenable,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final location = state.matchedLocation;

      if (auth.status == AuthStatus.unknown) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }
      if (!auth.isAuthenticated) {
        return location == AppRoutes.login ? null : AppRoutes.login;
      }
      if (location == AppRoutes.splash || location == AppRoutes.login) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.farmers,
        builder: (context, state) => const FarmersListScreen(),
      ),
      GoRoute(
        path: AppRoutes.addFarmer,
        builder: (context, state) => const FarmerFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.editFarmer,
        builder: (context, state) => FarmerFormScreen(farmer: state.extra as Farmer?),
      ),
      GoRoute(
        path: AppRoutes.farms,
        builder: (context, state) => FarmsListScreen(farmer: state.extra as Farmer),
      ),
      GoRoute(
        path: AppRoutes.addFarm,
        builder: (context, state) => FarmFormScreen(farmer: state.extra as Farmer),
      ),
      GoRoute(
        path: AppRoutes.editFarm,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return FarmFormScreen(
            farmer: extra['farmer'] as Farmer,
            farm: extra['farm'] as Farm,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.damageReports,
        builder: (context, state) => DamageReportsListScreen(farm: state.extra as Farm),
      ),
      GoRoute(
        path: AppRoutes.addDamageReport,
        builder: (context, state) => DamageReportFormScreen(farm: state.extra as Farm),
      ),
      GoRoute(
        path: AppRoutes.editDamageReport,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return DamageReportFormScreen(
            farm: extra['farm'] as Farm,
            report: extra['report'] as DamageReport,
          );
        },
      ),
    ],
  );
});
