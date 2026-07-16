import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/admin/data/users_repository.dart';
import 'package:mobile/features/admin/domain/directorate.dart';
import 'package:mobile/features/admin/domain/governorate.dart';
import 'package:mobile/features/admin/domain/role.dart';
import 'package:mobile/features/admin/domain/user.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/shared/domain/paginated_list.dart';

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

class UsersListState {
  final bool isLoading;
  final PaginatedList<User>? data;
  final List<String> errors;
  final String? search;
  final String? role;

  UsersListState({
    this.isLoading = false,
    this.data,
    this.errors = const [],
    this.search,
    this.role,
  });

  UsersListState copyWith({
    bool? isLoading,
    PaginatedList<User>? data,
    List<String>? errors,
    String? search,
    String? role,
  }) {
    return UsersListState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errors: errors ?? this.errors,
      search: search ?? this.search,
      role: role ?? this.role,
    );
  }
}

class UsersListNotifier extends StateNotifier<UsersListState> {
  final UsersRepository _repository;

  UsersListNotifier(this._repository) : super(UsersListState());

  Future<void> fetchUsers({int pageNumber = 1, bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(isLoading: true, errors: []);
    } else if (state.isLoading) {
      return;
    }

    try {
      final result = await _repository.getUsers(
        pageNumber: pageNumber,
        search: state.search,
        role: state.role,
      );

      if (isRefresh || pageNumber == 1) {
        state = state.copyWith(isLoading: false, data: result);
      } else {
        final existingItems = state.data?.items ?? [];
        state = state.copyWith(
          isLoading: false,
          data: result.copyWith(items: [...existingItems, ...result.items]),
        );
      }
    } on UsersException catch (e) {
      state = state.copyWith(isLoading: false, errors: e.errors);
    } catch (e) {
      state = state.copyWith(isLoading: false, errors: [e.toString()]);
    }
  }

  void setSearch(String? search) {
    state = state.copyWith(search: search);
    fetchUsers(isRefresh: true);
  }

  void setRole(String? role) {
    state = state.copyWith(role: role);
    fetchUsers(isRefresh: true);
  }
}

final usersListProvider = StateNotifierProvider<UsersListNotifier, UsersListState>((ref) {
  final notifier = UsersListNotifier(ref.watch(usersRepositoryProvider));
  notifier.fetchUsers();
  return notifier;
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

  Future<void> updateUser({
    required String id,
    required String fullName,
    required String userName,
    required String email,
    required String phoneNumber,
    required String role,
    String? governorateId,
    String? directorateId,
    required bool isActive,
  }) async {
    state = UserFormState(isLoading: true);
    try {
      await _repository.updateUser(
        id: id,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
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

  Future<void> resetPassword({
    required String userId,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = UserFormState(isLoading: true);
    try {
      await _repository.resetPassword(
        userId: userId,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      state = UserFormState(success: true);
    } on UsersException catch (e) {
      state = UserFormState(errors: e.errors);
    } catch (e) {
      state = UserFormState(errors: [e.toString()]);
    }
  }

  Future<void> changeStatus({
    required String userId,
    required bool isActive,
  }) async {
    state = UserFormState(isLoading: true);
    try {
      await _repository.changeStatus(
        userId: userId,
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

