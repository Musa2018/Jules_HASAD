import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/auth/presentation/login_screen.dart';
import 'package:mobile/features/home/presentation/home_screen.dart';

/// Route paths used across the application.
abstract final class AppRoutes {
  /// Splash shown while the persisted session is being restored.
  static const splash = '/';

  /// Login screen.
  static const login = '/login';

  /// Authenticated home screen.
  static const home = '/home';
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
    ],
  );
});
