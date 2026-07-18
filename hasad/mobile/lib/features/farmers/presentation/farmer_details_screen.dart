import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/l10n/app_localizations.dart';

class FarmerDetailsScreen extends ConsumerWidget {
  final Farmer farmer;

  const FarmerDetailsScreen({super.key, required this.farmer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.farmerDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push(AppRoutes.editFarmer, extra: farmer),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(label: l10n.farmerName, value: farmer.name),
            _InfoRow(label: l10n.nationalId, value: farmer.idNumber),
            _InfoRow(label: l10n.phoneNumber, value: farmer.phoneNumber),
            _InfoRow(label: l10n.address, value: farmer.address),
            const Divider(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.farms, extra: farmer),
              icon: const Icon(Icons.agriculture),
              label: Text(l10n.farms),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
