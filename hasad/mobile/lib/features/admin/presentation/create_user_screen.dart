import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/admin/domain/directorate.dart';
import 'package:mobile/features/admin/presentation/users_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

enum _RoleScope { global, governorate, directorate }

class CreateUserScreen extends ConsumerStatefulWidget {
  const CreateUserScreen({super.key});

  @override
  ConsumerState<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends ConsumerState<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedRoleId;
  String? _selectedGovernorateId;
  String? _selectedDirectorateId;
  bool _isActive = true;

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

  // TECHNICAL DEBT: Role scope is currently mapped client-side based on role names.
  // Ideally, the backend should return scope metadata in the Role model.
  _RoleScope _getScope(String? roleName) {
    if (roleName == 'Director') return _RoleScope.governorate;
    if (roleName == 'AgriculturalEngineer' || roleName == 'FieldSurveyor') {
      return _RoleScope.directorate;
    }
    return _RoleScope.global;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final roles = ref.read(rolesProvider).value ?? [];
    final selectedRole = roles.firstWhere((r) => r.id == _selectedRoleId);

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

    if (mounted && ref.read(userManagementProvider).success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.userCreatedSuccessfully)),
      );
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
    final selectedRole = _selectedRoleId != null ? roles.where((r) => r.id == _selectedRoleId).firstOrNull : null;
    final scope = _getScope(selectedRole?.name);

    final bool lookupLoading = rolesAsync.isLoading ||
        governoratesAsync.isLoading ||
        directoratesAsync.isLoading;

    final bool lookupError = rolesAsync.hasError ||
        governoratesAsync.hasError ||
        directoratesAsync.hasError;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addUser)),
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
                  color: Colors.orange.shade50,
                  child: Text(
                    'Warning: Some lookup data failed to load. Please refresh.',
                    style: TextStyle(color: Colors.orange.shade900),
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
                    final roleName = rolesList.firstWhere((r) => r.id == v).name;
                    final newScope = _getScope(roleName);
                    if (newScope == _RoleScope.global) {
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
                  items: [],
                  onChanged: null,
                  decoration: InputDecoration(
                    labelText: 'Error loading roles',
                    errorText: 'Tap to retry',
                  ),
                ),
              ),
              if (scope != _RoleScope.global) ...[
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
              if (scope == _RoleScope.directorate) ...[
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
