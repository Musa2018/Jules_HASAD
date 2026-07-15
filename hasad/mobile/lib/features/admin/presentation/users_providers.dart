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

class UserFormState {
  final bool isLoading;
  final bool success;
  final List<String> errors;

  UserFormState({this.isLoading = false, this.success = false, this.errors = const []});
}

class UserManagementNotifier extends StateNotifier<UserFormState> {
  final UsersRepository _repository;

  UserManagementNotifier(this._repository) : super(UserFormState());

  Future<void> createUser({
    required String fullName,
    required String userName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    required String role,
    String? governorateId,
    String? directorateId,
    required bool isActive,
  }) async {
    state = UserFormState(isLoading: true);
    try {
      await _repository.createUser(
        fullName: fullName,
        userName: userName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        confirmPassword: confirmPassword,
        role: role,
        governorateId: governorateId,
        directorateId: directorateId,
        isActive: isActive,
      );
      state = UserFormState(success: true);
    } on UsersException catch (e) {
      state = UserFormState(errors: e.errors);
    } catch (e) {
      state = UserFormState(errors: [e.toString()]);
    }
  }
}

final userManagementProvider = StateNotifierProvider<UserManagementNotifier, UserFormState>((ref) {
  return UserManagementNotifier(ref.watch(usersRepositoryProvider));
});

