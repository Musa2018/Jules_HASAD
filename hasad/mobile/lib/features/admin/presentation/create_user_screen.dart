import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/admin/domain/directorate.dart';
import 'package:mobile/features/admin/domain/user.dart';
import 'package:mobile/features/admin/presentation/users_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

class UserFormScreen extends ConsumerStatefulWidget {
  final User? user;

  const UserFormScreen({super.key, this.user});

  @override
  ConsumerState<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends ConsumerState<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _userNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  String? _selectedRoleId;
  String? _selectedGovernorateId;
  String? _selectedDirectorateId;
  bool _isActive = true;

  bool get _isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _fullNameController = TextEditingController(text: u?.fullName);
    _userNameController = TextEditingController(text: u?.userName);
    _emailController = TextEditingController(text: u?.email);
    _phoneController = TextEditingController(text: u?.phoneNumber);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _isActive = u?.isActive ?? true;
    _selectedGovernorateId = u?.governorateId;
    _selectedDirectorateId = u?.directorateId;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final roles = ref.read(rolesProvider).value ?? [];
    final selectedRole = roles.firstWhere((r) => r.id == _selectedRoleId);

    if (_isEdit) {
      await ref.read(userManagementProvider.notifier).updateUser(
            id: widget.user!.id,
            fullName: _fullNameController.text.trim(),
            userName: _userNameController.text.trim(),
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            role: selectedRole.name,
            governorateId: _selectedGovernorateId,
            directorateId: _selectedDirectorateId,
            isActive: _isActive,
          );
    } else {
      await ref.read(userManagementProvider.notifier).createUser(
            fullName: _fullNameController.text.trim(),
            userName: _userNameController.text.trim(),
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            role: selectedRole.name,
            governorateId: _selectedGovernorateId,
            directorateId: _selectedDirectorateId,
            isActive: _isActive,
          );
    }

    if (mounted && ref.read(userManagementProvider).success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEdit ? 'User updated successfully' : AppLocalizations.of(context)!.userCreatedSuccessfully)),
      );
      ref.invalidate(usersListProvider);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(userManagementProvider);
    final rolesAsync = ref.watch(rolesProvider);
    final governoratesAsync = ref.watch(governoratesProvider);
    final directoratesAsync = _selectedGovernorateId != null
        ? ref.watch(directoratesProvider(_selectedGovernorateId))
        : const AsyncValue<List<Directorate>>.data([]);

    final roles = rolesAsync.value ?? [];
    
    if (_selectedRoleId == null && widget.user != null && roles.isNotEmpty) {
      try {
        _selectedRoleId = roles.firstWhere((r) => r.name == widget.user!.role).id;
      } catch (_) {}
    }

    final selectedRole = _selectedRoleId != null ? roles.where((r) => r.id == _selectedRoleId).firstOrNull : null;
    final scopeType = selectedRole?.scopeType ?? 'Global';

    final bool lookupLoading = rolesAsync.isLoading ||
        governoratesAsync.isLoading ||
        directoratesAsync.isLoading;

    final bool lookupError = rolesAsync.hasError ||
        governoratesAsync.hasError ||
        directoratesAsync.hasError;

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit User' : l10n.addUser)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (lookupLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: LinearProgressIndicator(),
                ),
              if (lookupError)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    border: Border.all(color: Colors.orange.shade200),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Warning: Some lookup data failed to load.',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          ref.invalidate(rolesProvider);
                          ref.invalidate(governoratesProvider);
                          if (_selectedGovernorateId != null) {
                            ref.invalidate(directoratesProvider(_selectedGovernorateId));
                          }
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              if (state.errors.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  color: Colors.red.shade50,
                  child: Text(state.errors.join('\n'), style: const TextStyle(color: Colors.red)),
                ),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: l10n.fullName),
                validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userNameController,
                enabled: !_isEdit,
                decoration: InputDecoration(labelText: l10n.username),
                validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: l10n.email),
                validator: (v) {
                  if (v == null || v.isEmpty) return l10n.emailRequired;
                  if (!v.contains('@')) return l10n.emailInvalid;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: l10n.phoneNumber),
              ),
              if (!_isEdit) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: l10n.password),
                  obscureText: true,
                  validator: (v) => (v == null || v.length < 6) ? l10n.passwordRequired : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: l10n.confirmPassword),
                  obscureText: true,
                  validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null,
                ),
              ],
              const SizedBox(height: 16),
              rolesAsync.when(
                data: (rolesList) => DropdownButtonFormField<String>(
                  initialValue: _selectedRoleId,
                  decoration: InputDecoration(labelText: l10n.role),
                  items: rolesList
                      .map<DropdownMenuItem<String>>((r) => DropdownMenuItem(value: r.id, child: Text(r.name)))
                      .toList(),
                  onChanged: (v) => setState(() {
                    _selectedRoleId = v;
                    final role = rolesList.firstWhere((r) => r.id == v);
                    if (role.scopeType == 'Global') {
                      _selectedGovernorateId = null;
                      _selectedDirectorateId = null;
                    }
                  }),
                  validator: (v) => v == null ? l10n.requiredField : null,
                ),
                loading: () => DropdownButtonFormField<String>(
                  items: const [],
                  onChanged: null,
                  decoration: const InputDecoration(
                    labelText: 'Loading roles...',
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                error: (e, _) => DropdownButtonFormField<String>(
                  items: const [],
                  onChanged: null,
                  decoration: const InputDecoration(
                    labelText: 'Error loading roles',
                  ),
                ),
              ),
              if (scopeType != 'Global') ...[
                const SizedBox(height: 16),
                governoratesAsync.when(
                  data: (govList) => DropdownButtonFormField<String>(
                    key: ValueKey('gov_$_selectedRoleId'),
                    initialValue: _selectedGovernorateId,
                    decoration: InputDecoration(labelText: l10n.governorate),
                    items: govList
                        .map<DropdownMenuItem<String>>((g) => DropdownMenuItem(value: g.id, child: Text(g.nameEn)))
                        .toList(),
                    onChanged: (v) => setState(() {
                      _selectedGovernorateId = v;
                      _selectedDirectorateId = null;
                    }),
                    validator: (v) => v == null ? l10n.requiredField : null,
                  ),
                  loading: () => DropdownButtonFormField<String>(
                    items: const [],
                    onChanged: null,
                    decoration: const InputDecoration(
                      labelText: 'Loading governorates...',
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  error: (e, _) => DropdownButtonFormField<String>(
                    initialValue: null,
                    items: const [],
                    onChanged: null,
                    decoration: const InputDecoration(
                      labelText: 'Error loading governorates',
                    ),
                  ),
                ),
              ],
              if (scopeType == 'Directorate') ...[
                const SizedBox(height: 16),
                _selectedGovernorateId == null
                    ? DropdownButtonFormField<String>(
                        initialValue: null,
                        items: const [],
                        onChanged: null,
                        decoration: const InputDecoration(labelText: 'Select Governorate first'),
                      )
                    : directoratesAsync.when(
                        data: (dirList) => DropdownButtonFormField<String>(
                          key: ValueKey('dir_$_selectedGovernorateId'),
                          initialValue: _selectedDirectorateId,
                          decoration: InputDecoration(labelText: l10n.directorate),
                          items: dirList
                              .map<DropdownMenuItem<String>>((d) => DropdownMenuItem(value: d.id, child: Text(d.nameEn)))
                              .toList(),
                          onChanged: (v) => setState(() => _selectedDirectorateId = v),
                          validator: (v) => v == null ? l10n.requiredField : null,
                        ),
                        loading: () => DropdownButtonFormField<String>(
                          items: const [],
                          onChanged: null,
                          decoration: const InputDecoration(
                            labelText: 'Loading directorates...',
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                        error: (e, _) => DropdownButtonFormField<String>(
                          initialValue: null,
                          items: const [],
                          onChanged: null,
                          decoration: const InputDecoration(
                            labelText: 'Error loading directorates',
                          ),
                        ),
                      ),
              ],
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text(l10n.active),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: (state.isLoading || lookupLoading || lookupError) ? null : _submit,
                child: state.isLoading ? const CircularProgressIndicator() : Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
