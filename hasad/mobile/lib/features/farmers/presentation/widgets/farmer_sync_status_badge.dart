import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class FarmerSyncStatusBadge extends StatelessWidget {
  final String status;
  final bool isShort;

  const FarmerSyncStatusBadge({
    super.key,
    required this.status,
    this.isShort = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'completed':
        color = Colors.green;
        label = l10n.synced;
        icon = Icons.check_circle;
        break;
      case 'pending':
        color = Colors.orange;
        label = l10n.pendingSync;
        icon = Icons.hourglass_empty;
        break;
      case 'syncing':
        color = Colors.blue;
        label = l10n.syncing;
        icon = Icons.sync;
        break;
      case 'pending_delete':
        color = Colors.red;
        label = l10n.delete; // or l10n.pendingDelete
        icon = Icons.delete_sweep;
        break;
      case 'invalid':
        color = Colors.deepOrange;
        label = l10n.syncInvalid;
        icon = Icons.warning_amber;
        break;
      case 'failed':
      case 'conflict':
        color = Colors.red;
        label = l10n.syncError;
        icon = Icons.error;
        break;
      default:
        color = Colors.grey;
        label = status;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          if (!isShort) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
