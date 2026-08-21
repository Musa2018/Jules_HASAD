using Hasad.Application.Common.Interfaces;
using Hasad.Domain.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Serilog;

namespace Hasad.Infrastructure.Hubs;

[Authorize]
public class NotificationHub : Hub
{
    private readonly IApplicationDbContext _context;
    private readonly IHubContext<AdminDashboardHub> _adminHub;

    public NotificationHub(IApplicationDbContext context, IHubContext<AdminDashboardHub> adminHub)
    {
        _context = context;
        _adminHub = adminHub;
    }

    public override async Task OnConnectedAsync()
    {
        var userId = Context.UserIdentifier;
        var connectionId = Context.ConnectionId;

        Log.Information("NotificationHub: User {UserId} connected with ConnectionId {ConnectionId}", userId, connectionId);

        // Get deviceId from query string to distinguish between multiple devices of the same user
        var deviceToken = Context.GetHttpContext()?.Request.Query["deviceToken"].ToString();

        if (!string.IsNullOrEmpty(userId))
        {
            if (!string.IsNullOrEmpty(deviceToken))
            {
                // Update specific device record
                await _context.UserDevices
                    .Where(d => d.UserId == userId && d.DeviceToken == deviceToken)
                    .ExecuteUpdateAsync(s => s
                        .SetProperty(b => b.SignalRConnectionId, connectionId)
                        .SetProperty(b => b.IsOnline, true)
                        .SetProperty(b => b.LastActiveAt, DateTime.UtcNow));
            }
            else
            {
                // Fallback: If deviceToken not provided, update the most recent one for this user
                // or just track by connectionId.
                // Spec says UserDevices has SignalRConnectionId, so we must map it.
                var latestDevice = await _context.UserDevices
                    .Where(d => d.UserId == userId)
                    .OrderByDescending(d => d.LastActiveAt)
                    .FirstOrDefaultAsync();

                if (latestDevice != null)
                {
                    latestDevice.SignalRConnectionId = connectionId;
                    latestDevice.IsOnline = true;
                    latestDevice.LastActiveAt = DateTime.UtcNow;
                }
                else
                {
                    // Create a placeholder device for stats tracking if this is a first-time connection
                    _context.UserDevices.Add(new UserDevice
                    {
                        Id = Guid.NewGuid(),
                        UserId = userId,
                        DeviceToken = "AUTO_SIGNALR_" + Guid.NewGuid().ToString("N").Substring(0, 8),
                        Platform = "Android", // Defaulting to Android for Emulator testing
                        SignalRConnectionId = connectionId,
                        IsOnline = true,
                        LastActiveAt = DateTime.UtcNow
                    });
                }
                await _context.SaveChangesAsync(CancellationToken.None);
            }

            // Broadcast presence update to Admin Dashboard
            var onlineCount = await _context.UserDevices.CountAsync(d => d.IsOnline);
            await _adminHub.Clients.Group("LiveSuperAdminStream").SendAsync("OnMetricUpdated", new
            {
                MetricKey = "ONLINE_DEVICES",
                Title = "Users Online Now",
                CurrentValue = onlineCount,
                UpdatedAt = DateTime.UtcNow
            });
        }

        await base.OnConnectedAsync();
    }

    public override async Task OnDisconnectedAsync(Exception? exception)
    {
        var connectionId = Context.ConnectionId;

        await _context.UserDevices
            .Where(d => d.SignalRConnectionId == connectionId)
            .ExecuteUpdateAsync(s => s
                .SetProperty(b => b.IsOnline, false)
                .SetProperty(b => b.SignalRConnectionId, (string?)null)
                .SetProperty(b => b.LastActiveAt, DateTime.UtcNow));

        // Broadcast presence update to Admin Dashboard
        var onlineCount = await _context.UserDevices.CountAsync(d => d.IsOnline);
        await _adminHub.Clients.Group("LiveSuperAdminStream").SendAsync("OnMetricUpdated", new
        {
            MetricKey = "ONLINE_DEVICES",
            Title = "Users Online Now",
            CurrentValue = onlineCount,
            UpdatedAt = DateTime.UtcNow
        });

        await base.OnDisconnectedAsync(exception);
    }
}
