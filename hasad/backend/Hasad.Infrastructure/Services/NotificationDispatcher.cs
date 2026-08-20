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

    public async Task SendNotificationAsync(Guid notificationId, string targetUserId)
    {
        var notification = await _context.Notifications
            .AsNoTracking()
            .FirstOrDefaultAsync(n => n.Id == notificationId);

        if (notification == null) return;

        var devices = await _context.UserDevices
            .Where(d => d.UserId == targetUserId)
            .ToListAsync();

        if (!devices.Any())
        {
            Log.Warning("No registered devices found for user {UserId}", targetUserId);
            return;
        }

        foreach (var device in devices)
        {
            try
            {
                if (device.IsOnline && !string.IsNullOrEmpty(device.SignalRConnectionId))
                {
                    // High-speed In-App SignalR path
                    await _hubContext.Clients.Client(device.SignalRConnectionId).SendAsync("ReceiveNotification", new
                    {
                        Id = notification.Id,
                        Title = notification.Title,
                        Body = notification.Body,
                        Category = notification.Category,
                        Payload = notification.PayloadJson,
                        CreatedAt = notification.CreatedAt
                    });

                    Log.Information("Notification {Id} sent via SignalR to user {UserId}", notificationId, targetUserId);
                }
                else
                {
                    // Background Push path
                    if (device.Platform.Equals("iOS", StringComparison.OrdinalIgnoreCase))
                    {
                        await _apnsService.SendDirectPushAsync(device.DeviceToken, notification.Title, notification.Body, notification.PayloadJson);
                    }
                    else if (device.Platform.Equals("Android", StringComparison.OrdinalIgnoreCase))
                    {
                        await _fcmClient.SendRawPushV1Async(device.DeviceToken, notification.Title, notification.Body, notification.PayloadJson);
                    }

                    Log.Information("Notification {Id} sent via {Platform} Push to user {UserId}", notificationId, device.Platform, targetUserId);
                }

                // Update Recipient Status
                await _context.NotificationRecipients
                    .Where(r => r.NotificationId == notificationId && r.UserId == targetUserId)
                    .ExecuteUpdateAsync(s => s
                        .SetProperty(b => b.IsDelivered, true)
                        .SetProperty(b => b.DeliveredAt, DateTime.UtcNow));
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Failed to dispatch notification {Id} to user {UserId} on device {DeviceToken}",
                    notificationId, targetUserId, device.DeviceToken);
            }
        }
    }

    public async Task SendBulkNotificationAsync(Guid notificationId, IEnumerable<string> targetUserIds)
    {
        foreach (var userId in targetUserIds)
        {
            // We can optimize this later with a bulk query if needed,
            // but for now we follow the logic for each user.
            await SendNotificationAsync(notificationId, userId);
        }
    }
}
