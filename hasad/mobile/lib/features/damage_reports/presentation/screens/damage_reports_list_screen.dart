import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DamageReportsListScreen extends ConsumerWidget {
  final Farm? farm;

  const DamageReportsListScreen({super.key, this.farm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final reportsAsync = farm != null
        ? ref.watch(damageReportsListByFarmProvider(farm!.id))
        : ref.watch(allDamageReportsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(farm != null
            ? '${l10n.damageReports}: ${farm!.localFarmName}'
            : l10n.damageReportsForms),
      ),
      body: reportsAsync.when(
        data: (reports) {
          if (reports.isEmpty) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                farm != null
                    ? 'لا يوجد استمارات ضرر لهذه المزرعة.'
                    : 'لا يوجد استمارات ضرر في منطقتك حالياً.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ));
          }
          return ListView.builder(
            itemCount: reports.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.reportNumber.isNotEmpty ? report.reportNumber : report.temporaryFormNumber,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              DateFormat.yMMMd().format(report.damageDate),
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _StatusBadge(statusId: report.statusId),
                          const SizedBox(height: 4),
                          _SyncStatusBadge(syncStatus: report.syncStatus),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${report.items.length} ${l10n.assessmentItem}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        if (farm == null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.agriculture, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'المزرعة: ${report.farmId.substring(0, 8)}...',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_left), // RTL
                  onTap: () async {
                    Farm? targetFarm = farm;
                    if (targetFarm == null) {
                      final db = ref.read(databaseProvider);
                      final farmLocal = await (db.select(db.farms)
                            ..where((t) => t.id.equals(report.farmId)))
                          .getSingleOrNull();
                      if (farmLocal != null) {
                        targetFarm = Farm(
                          id: farmLocal.id,
                          serverId: farmLocal.serverId,
                          farmerId: farmLocal.farmerId,
                          localFarmName: farmLocal.localFarmName,
                          governorateId: farmLocal.governorateId,
                          directorateId: farmLocal.directorateId,
                          localityId: farmLocal.localityId,
                          agriculturalSectorId: farmLocal.agriculturalSectorId,
                          politicalClassificationId: farmLocal.politicalClassificationId,
                          ownershipTypeId: farmLocal.ownershipTypeId,
                          area: farmLocal.area,
                          areaUnitId: farmLocal.areaUnitId,
                          measurementUnitId: farmLocal.measurementUnitId,
                          basin: farmLocal.basin,
                          parcel: farmLocal.parcel,
                          latitude: farmLocal.latitude,
                          longitude: farmLocal.longitude,
                          rowVersion: farmLocal.rowVersion,
                          syncStatus: farmLocal.syncStatus,
                        );
                      }
                    }

                    if (context.mounted) {
                      if (targetFarm != null) {
                        context.push(
                          AppRoutes.damageReportDetails,
                          extra: {'farm': targetFarm, 'report': report},
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('تعذر تحميل بيانات المزرعة محلياً.')),
                        );
                      }
                    }
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: farm != null
          ? FloatingActionButton(
              onPressed: () => context.push('/damage-reports/add', extra: farm),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _SyncStatusBadge extends StatelessWidget {
  final String syncStatus;
  const _SyncStatusBadge({required this.syncStatus});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String label = syncStatus;
    Color color = Colors.grey;
    IconData icon = Icons.sync_problem;

    switch (syncStatus) {
      case 'pending':
        label = l10n.pendingSync;
        color = Colors.orange;
        icon = Icons.access_time;
        break;
      case 'syncing':
        label = l10n.syncing;
        color = Colors.blue;
        icon = Icons.sync;
        break;
      case 'completed':
        label = l10n.synced;
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case 'failed':
        label = l10n.syncError;
        color = Colors.red;
        icon = Icons.error_outline;
        break;
      case 'conflict':
        label = 'Conflict'; // Or l10n.syncConflict if exists
        color = Colors.deepOrange;
        icon = Icons.warning_amber_outlined;
        break;
    }

    if (syncStatus == 'completed') return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String statusId;
  const _StatusBadge({required this.statusId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String label = statusId;
    Color color = Colors.grey;

    switch (statusId) {
      case 'Draft':
        label = l10n.status_Draft;
        color = Colors.grey;
        break;
      case 'TechReview':
      case 'MinTechReview':
        label = l10n.status_TechReview;
        color = Colors.blue;
        break;
      case 'Completed':
        label = l10n.status_Completed;
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
