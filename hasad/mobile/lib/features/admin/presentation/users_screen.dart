import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/admin/domain/user.dart';
import 'package:mobile/features/admin/presentation/users_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(usersListProvider);
      if (!state.isLoading && (state.data?.pageNumber ?? 0) < (state.data?.totalPages ?? 0)) {
        ref.read(usersListProvider.notifier).fetchUsers(pageNumber: (state.data?.pageNumber ?? 0) + 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(usersListProvider);
    final users = state.data?.items ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.users),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => context.push(AppRoutes.addUser),
          ),
        ],
      ),
      body: Column(
        children: [
          if (state.isLoading && users.isEmpty)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (state.errors.isNotEmpty && users.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errors.first, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.read(usersListProvider.notifier).fetchUsers(isRefresh: true),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            )
          else if (users.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people_outline, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(l10n.noFarmers), // Reusing existing key
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => context.push(AppRoutes.addUser),
                      icon: const Icon(Icons.person_add),
                      label: Text(l10n.addUser),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(usersListProvider.notifier).fetchUsers(isRefresh: true),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: users.length + (state.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == users.length) {
                      return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                    }
                    return _UserCard(user: users[index]);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UserCard extends ConsumerWidget {
  final User user;

  const _UserCard({required this.user});

  Future<void> _resetPassword(BuildContext context, WidgetRef ref) async {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter new password for ${user.fullName}'),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmController,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (v) => v != passwordController.text ? 'Passwords do not match' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) Navigator.pop(context, true);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(userManagementProvider.notifier).resetPassword(
            userId: user.id,
            newPassword: passwordController.text,
            confirmPassword: confirmController.text,
          );

      if (context.mounted) {
        final state = ref.read(userManagementProvider);
        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset successfully')));
        } else if (state.errors.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errors.first), backgroundColor: Colors.red));
        }
      }
    }
  }

  Future<void> _toggleStatus(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.isActive ? 'Deactivate User' : 'Activate User'),
        content: Text('Are you sure you want to ${user.isActive ? 'deactivate' : 'activate'} ${user.fullName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(user.isActive ? 'Deactivate' : 'Activate'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(userManagementProvider.notifier).changeStatus(
            userId: user.id,
            isActive: !user.isActive,
          );

      if (context.mounted) {
        final state = ref.read(userManagementProvider);
        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User ${user.isActive ? 'deactivated' : 'activated'} successfully')));
          ref.read(usersListProvider.notifier).fetchUsers(isRefresh: true);
        } else if (state.errors.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errors.first), backgroundColor: Colors.red));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Text(user.fullName[0].toUpperCase())),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.fullName, style: Theme.of(context).textTheme.titleMedium),
                      Text('@${user.userName}', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                _StatusBadge(isActive: user.isActive),
              ],
            ),
            const Divider(height: 24),
            _InfoRow(icon: Icons.badge_outlined, label: 'Role', value: user.role),
            _InfoRow(icon: Icons.location_on_outlined, label: 'Governorate', value: user.governorateName ?? 'Global'),
            if (user.directorateName != null)
              _InfoRow(icon: Icons.business_outlined, label: 'Directorate', value: user.directorateName!),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => context.push(AppRoutes.editUser, extra: user),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: () => _resetPassword(context, ref),
                  icon: const Icon(Icons.lock_reset_outlined, size: 18),
                  label: const Text('Reset'),
                ),
                TextButton.icon(
                  onPressed: () => _toggleStatus(context, ref),
                  icon: Icon(user.isActive ? Icons.person_off_outlined : Icons.person_outline, size: 18),
                  label: Text(user.isActive ? 'Deactivate' : 'Activate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? Colors.green.shade200 : Colors.red.shade200),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          color: isActive ? Colors.green.shade700 : Colors.red.shade700,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
