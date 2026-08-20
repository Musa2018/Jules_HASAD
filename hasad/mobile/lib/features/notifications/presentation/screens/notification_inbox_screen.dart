import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/notifications/presentation/providers/notification_providers.dart';
import 'package:intl/intl.dart';

class NotificationInboxScreen extends ConsumerWidget {
  const NotificationInboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(localNotificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          ref.watch(unreadCountProvider).when(
            data: (count) => count > 0 
                ? Badge(label: Text(count.toString()), child: const Icon(Icons.notifications))
                : const Icon(Icons.notifications),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // 1. Fetch from server and merge into SQLite (Optional but recommended)
          final apiClient = ref.read(notificationApiClientProvider);
          final db = ref.read(notificationDbProvider);
          
          try {
            final serverResults = await apiClient.getMyNotifications();
            final items = serverResults['Items'] as List;
            for (var item in items) {
              await db.insertNotification({
                'Id': item['Id'],
                'Title': item['Title'],
                'Body': item['Body'],
                'Category': item['Category'],
                'PayloadJson': item['PayloadJson'],
                'IsRead': item['IsRead'] ? 1 : 0,
                'ReceivedAt': item['CreatedAt'],
                'SyncStatus': 1,
              });
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('خطأ في تحديث الإشعارات: $e')),
              );
            }
          }
          
          // 2. Refresh local provider
          return ref.read(localNotificationsProvider.notifier).refresh();
        },
        child: notifications.isEmpty
            ? const Center(child: Text('لا توجد إشعارات حالياً'))
            : ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final n = notifications[index];
                  final isRead = n['IsRead'] == 1;
                  final date = DateTime.parse(n['ReceivedAt']);
                  
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isRead ? Colors.grey.shade200 : Colors.blue.shade50,
                      child: Icon(
                        _getCategoryIcon(n['Category']),
                        color: isRead ? Colors.grey : Colors.blue,
                      ),
                    ),
                    title: Text(
                      n['Title'],
                      style: TextStyle(
                        fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n['Body']),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('yyyy-MM-dd HH:mm').format(date),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    onTap: () {
                      if (!isRead) {
                        ref.read(localNotificationsProvider.notifier).markAsRead(n['Id']);
                      }
                      // Handle navigation based on payload if needed
                    },
                  );
                },
              ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'damage': return Icons.report_problem;
      case 'assistance': return Icons.volunteer_activism;
      case 'system': return Icons.settings;
      default: return Icons.notifications;
    }
  }
}
