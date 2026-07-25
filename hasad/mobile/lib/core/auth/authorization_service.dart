import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';

/// Service to centralize permission-based authorization logic.
class AuthorizationService {
  final AuthSession? _session;

  AuthorizationService(this._session);

  List<String> get _roles => _session?.roles ?? [];

  /// --- Farmer Permissions ---
  
  bool canManageFarmers() {
    // Restricted roles: FieldSurveyor, TechnicalReviewer, ReadOnly, Farmer
    const restrictedRoles = ['FieldSurveyor', 'TechnicalReviewer', 'ReadOnly', 'Farmer'];
    return _roles.isNotEmpty && !restrictedRoles.any((r) => _roles.contains(r));
  }

  /// --- Farm Permissions ---

  bool canManageFarms() {
    // Restricted roles: FieldSurveyor, TechnicalReviewer, ReadOnly, Farmer
    const restrictedRoles = ['FieldSurveyor', 'TechnicalReviewer', 'ReadOnly', 'Farmer'];
    return _roles.isNotEmpty && !restrictedRoles.any((r) => _roles.contains(r));
  }

  /// --- Damage Report Permissions ---

  bool canCreateDamageReport() {
    const allowedRoles = ['SuperAdmin', 'Administrator', 'AgriculturalEngineer', 'FieldSurveyor'];
    return allowedRoles.any((r) => _roles.contains(r));
  }

  bool canVerifyDamageReport() {
    const allowedRoles = ['SuperAdmin', 'Administrator', 'TechnicalReviewer', 'AgriculturalEngineer'];
    return allowedRoles.any((r) => _roles.contains(r));
  }
}

final authorizationServiceProvider = Provider<AuthorizationService>((ref) {
  final session = ref.watch(authProvider).session;
  return AuthorizationService(session);
});
