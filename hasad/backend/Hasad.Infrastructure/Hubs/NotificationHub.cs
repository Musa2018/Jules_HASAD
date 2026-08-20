using Hasad.Application.Common.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Infrastructure.Hubs;

[Authorize]
public class NotificationHub : Hub
{
    private readonly IApplicationDbContext _context;

    public NotificationHub(IApplicationDbContext context)
    {
        _context = context;
    }

    public override async Task OnConnectedAsync()
    {
        var userId = Context.UserIdentifier;
        var connectionId = Context.ConnectionId;

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
                    await _context.SaveChangesAsync(CancellationToken.None);
                }
            }
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

        await base.OnDisconnectedAsync(exception);
    }
}
