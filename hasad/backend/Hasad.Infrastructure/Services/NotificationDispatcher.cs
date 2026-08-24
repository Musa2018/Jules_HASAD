using Hasad.Application.Common.Interfaces;
using Hasad.Domain.Entities;
using Hasad.Infrastructure.Hubs;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Serilog;

namespace Hasad.Infrastructure.Services;

public class NotificationDispatcher : INotificationDispatcher
{
    private readonly IApplicationDbContext _context;
    private readonly IHubContext<NotificationHub> _hubContext;
    private readonly IFcmHttpV1Client _fcmClient;
    private readonly IApnsService _apnsService;

    public NotificationDispatcher(
        IApplicationDbContext context,
        IHubContext<NotificationHub> hubContext,
        IFcmHttpV1Client fcmClient,
        IApnsService apnsService)
    {
        _context = context;
        _hubContext = hubContext;
        _fcmClient = fcmClient;
        _apnsService = apnsService;
    }

    public async Task SendBulkNotificationAsync(Guid notificationId, IEnumerable<string> targetUserIds)
    {
        var targetIdList = targetUserIds.ToList();
        if (!targetIdList.Any()) return;

        var notification = await _context.Notifications
            .AsNoTracking()
            .FirstOrDefaultAsync(n => n.Id == notificationId);

        if (notification == null) return;

        Log.Information("Bulk dispatching notification {Id} to {Count} users: {UserIds}",
            notificationId, targetIdList.Count, string.Join(", ", targetIdList));

        // 1. High-speed SignalR Dispatch (Targeted to Users)
        // This is strictly targeted to the connections of the specified users.
        await _hubContext.Clients.Users(targetIdList).SendAsync("ReceiveNotification", new
        {
            id = notification.Id,
            title = notification.Title,
            body = notification.Body,
            category = notification.Category,
            payload = notification.PayloadJson,
            createdAt = notification.CreatedAt
        });

        // 2. Background Push and DB Updates
        // For each user, we still check if they have push devices or need status updates
        foreach (var userId in targetIdList)
        {
            await ProcessBackgroundPushAndStatusAsync(notification, userId);
        }
    }

    private async Task ProcessBackgroundPushAndStatusAsync(Notification notification, string targetUserId)
    {
        var devices = await _context.UserDevices
            .Where(d => d.UserId == targetUserId)
            .ToListAsync();

        bool deliveredViaSignalR = devices.Any(d => d.IsOnline && !string.IsNullOrEmpty(d.SignalRConnectionId));

        foreach (var device in devices)
        {
            try
            {
                if (!device.IsOnline || string.IsNullOrEmpty(device.SignalRConnectionId))
                {
                    // Background Push path for offline devices
                    if (device.Platform.Equals("iOS", StringComparison.OrdinalIgnoreCase))
                    {
                        await _apnsService.SendDirectPushAsync(device.DeviceToken, notification.Title, notification.Body, notification.PayloadJson);
                    }
                    else if (device.Platform.Equals("Android", StringComparison.OrdinalIgnoreCase))
                    {
                        await _fcmClient.SendRawPushV1Async(device.DeviceToken, notification.Title, notification.Body, notification.PayloadJson);
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Failed to send background push for notification {Id} to user {UserId} on device {DeviceToken}",
                    notification.Id, targetUserId, device.DeviceToken);
            }
        }

        // Update Recipient Status
        await _context.NotificationRecipients
            .Where(r => r.NotificationId == notification.Id && r.UserId == targetUserId)
            .ExecuteUpdateAsync(s => s
                .SetProperty(b => b.IsDelivered, true)
                .SetProperty(b => b.DeliveredAt, DateTime.UtcNow));
    }

    public async Task SendNotificationAsync(Guid notificationId, string targetUserId)
    {
        await SendBulkNotificationAsync(notificationId, new[] { targetUserId });
    }
}
