import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/core/storage/pull_sync_service.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

import 'package:mobile/features/notifications/presentation/providers/notification_providers.dart';

/// Landing screen shown after a successful login.
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure the notification client is connected when the home screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationClientServiceProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(authProvider).session;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboard),
        actions: [
          ref.watch(unreadCountProvider).when(
            data: (count) => IconButton(
              icon: Badge.count(
                count: count,
                isLabelVisible: count > 0,
                child: const Icon(Icons.notifications),
              ),
              onPressed: () => context.push(AppRoutes.notifications),
            ),
            loading: () => const IconButton(
              icon: Icon(Icons.notifications),
              onPressed: null,
            ),
            error: (_, __) => IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () => context.push(AppRoutes.notifications),
            ),
          ),
          IconButton(
            tooltip: l10n.syncStatus,
            icon: const Icon(Icons.sync),
            onPressed: () async {
              try {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.syncing)),
                );
                await ref.read(pullSyncServiceProvider).syncAll();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.synced)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${l10n.syncError}: $e')),
                  );
                }
              }
            },
          ),
          IconButton(
            tooltip: l10n.logout,
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.welcome(session?.fullName ?? session?.email ?? ''),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                _FeatureCard(
                  title: l10n.farmers,
                  icon: Icons.people,
                  onTap: () => context.push(AppRoutes.farmers),
                ),
                _FeatureCard(
                  title: l10n.farms,
                  icon: Icons.agriculture,
                  onTap: () => context.push(AppRoutes.farms),
                ),
                _FeatureCard(
                  title: l10n.damageReportsForms,
                  icon: Icons.assignment,
                  onTap: () => context.push(AppRoutes.damageReports),
                ),
                if (session?.roles.contains('SuperAdmin') ?? false)
                  _FeatureCard(
                    title: l10n.users,
                    icon: Icons.admin_panel_settings,
                    onTap: () => context.push(AppRoutes.users),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
