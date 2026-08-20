using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace Hasad.Infrastructure.Hubs;

[Authorize(Policy = "SuperAdminOnly")]
public class AdminDashboardHub : Hub
{
    public async Task JoinLiveMonitoringGroup()
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, "LiveSuperAdminStream");
    }

    public async Task LeaveLiveMonitoringGroup()
    {
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, "LiveSuperAdminStream");
    }
}
