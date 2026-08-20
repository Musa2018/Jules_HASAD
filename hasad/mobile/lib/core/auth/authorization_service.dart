import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';

/// Service to centralize permission-based authorization logic.
class AuthorizationService {
  final AuthSession? _session;

  AuthorizationService(this._session);

  String? get userId => _session?.userId;
  String? get directorateId => _session?.directorateId;
  String? get governorateId => _session?.governorateId;

  List<String> get _roles => _session?.roles ?? [];

  bool hasRole(String role) => _roles.contains(role);

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

  bool canDeleteDamageReport() {
    // Restricted to admins/super admins as per latest policy
    const allowedRoles = ['SuperAdmin', 'Administrator'];
    return allowedRoles.any((r) => _roles.contains(r));
  }
}

final authorizationServiceProvider = Provider<AuthorizationService>((ref) {
  final session = ref.watch(authProvider).session;
  return AuthorizationService(session);
});
