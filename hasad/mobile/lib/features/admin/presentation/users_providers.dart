import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/admin/data/users_repository.dart';
import 'package:mobile/features/admin/domain/directorate.dart';
import 'package:mobile/features/admin/domain/governorate.dart';
import 'package:mobile/features/admin/domain/role.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepositoryImpl(ref.watch(apiDioProvider));
});

final rolesProvider = FutureProvider<List<Role>>((ref) async {
  final auth = ref.watch(authProvider);
  if (auth.session?.roles.contains('SuperAdmin') != true) {
    throw Exception('Unauthorized: SuperAdmin access required');
  }
  return ref.watch(usersRepositoryProvider).getRoles();
});

final governoratesProvider = FutureProvider<List<Governorate>>((ref) async {
  final auth = ref.watch(authProvider);
  if (auth.session?.roles.contains('SuperAdmin') != true) {
    throw Exception('Unauthorized: SuperAdmin access required');
  }
  return ref.watch(usersRepositoryProvider).getGovernorates();
});

final directoratesProvider = FutureProvider.family<List<Directorate>, String?>((ref, governorateId) async {
  final auth = ref.watch(authProvider);
  if (auth.session?.roles.contains('SuperAdmin') != true) {
    throw Exception('Unauthorized: SuperAdmin access required');
  }
  return ref.watch(usersRepositoryProvider).getDirectorates(governorateId: governorateId);
});
