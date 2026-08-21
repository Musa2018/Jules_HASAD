using Dapper;
using Hasad.Api.Filters;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.Reporting.Models;
using Hasad.Application.Features.Reporting.Services;
using Hasad.Domain.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Hasad.Infrastructure.Hubs;

namespace Hasad.Api.Controllers;

[Authorize(Policy = "SuperAdminOnly")]
[ApiController]
[Route("api/admin/dashboard")]
public class SuperAdminDashboardController : ControllerBase
{
    private readonly IApplicationDbContext _context;
    private readonly IHubContext<AdminDashboardHub> _adminHub;
    private readonly INotificationDispatcher _notificationDispatcher;

    public SuperAdminDashboardController(
        IApplicationDbContext context,
        IHubContext<AdminDashboardHub> adminHub,
        INotificationDispatcher notificationDispatcher)
    {
        _context = context;
        _adminHub = adminHub;
        _notificationDispatcher = notificationDispatcher;
    }

    [HttpGet("overview")]
    public async Task<IActionResult> GetOverviewStats()
    {
        using var connection = _context.Database.GetDbConnection();

        var multi = await connection.QueryMultipleAsync(@"
            -- 1. KPI Metrics (Real-time Agricultural Domain)
            SELECT
                'TOTAL_FARMERS' AS MetricKey,
                N'إجمالي المزارعين (Farmers)' AS Title,
                CAST(COUNT(*) AS DECIMAL(18,2)) AS CurrentValue,
                NULL AS PreviousValue,
                N'مزارع' AS Unit,
                'Agricultural' AS Category
            FROM Farmers
            WHERE IsDeleted = 0

            UNION ALL

            SELECT
                'TOTAL_FARMS',
                N'إجمالي المزارع (Farms)',
                CAST(COUNT(*) AS DECIMAL(18,2)),
                NULL,
                N'مزرعة',
                'Agricultural'
            FROM Farms
            WHERE IsDeleted = 0

            UNION ALL

            SELECT
                'DAMAGE_REPORTS',
                N'تقارير الأضرار (Damage Reports)',
                CAST(COUNT(*) AS DECIMAL(18,2)),
                CAST(SUM(CASE WHEN StatusId = 'PendingTechnicalVerification' THEN 1 ELSE 0 END) AS DECIMAL(18,2)),
                N'تقرير',
                'Damage'
            FROM DamageReports
            WHERE IsDeleted = 0

            UNION ALL

            SELECT
                'SYSTEM_NOTIFICATIONS',
                N'الإشعارات الصادرة (Notifications)',
                CAST(COUNT(*) AS DECIMAL(18,2)),
                NULL,
                N'إشعار',
                'System'
            FROM Notifications;

            -- 2. Device Statistics
            SELECT
                COUNT(1) AS TotalRegisteredDevices,
                SUM(CASE WHEN IsOnline = 1 THEN 1 ELSE 0 END) AS OnlineNow,
                SUM(CASE WHEN Platform = 'Android' THEN 1 ELSE 0 END) AS AndroidDevices,
                SUM(CASE WHEN Platform = 'iOS' THEN 1 ELSE 0 END) AS IosDevices
            FROM UserDevices;

            -- 3. Recent Audit Logs
            SELECT TOP 10 AuditId, AdminUserId, Action, EntityName, Timestamp
            FROM AdminAuditLogs
            ORDER BY Timestamp DESC;
        ");

        var kpis = await multi.ReadAsync<KpiMetricDto>();
        var deviceStats = await multi.ReadFirstOrDefaultAsync<DeviceStatsDto>() ?? new DeviceStatsDto();
        var recentAudits = await multi.ReadAsync<AuditLogDto>();

        return Ok(new DashboardOverviewDto
        {
            Kpis = kpis,
            DeviceStats = deviceStats,
            RecentAudits = recentAudits,
            ServerTime = DateTime.UtcNow
        });
    }

    [HttpPost("broadcast-notification")]
    [AuditLog("Notifications", "BROADCAST_ALL")]
    public async Task<IActionResult> BroadcastNotification([FromBody] BroadcastNotificationRequest request)
    {
        var notification = new Notification
        {
            Id = Guid.NewGuid(),
            Title = request.Title,
            Body = request.Body,
            Category = request.Category ?? "SystemAnnouncement",
            PayloadJson = request.PayloadJson,
            CreatedAt = DateTime.UtcNow
        };
        _context.Notifications.Add(notification);

        // Fetch all user IDs
        var targetUsers = await _context.Users.Select(u => u.Id).ToListAsync();

        foreach (var userId in targetUsers)
        {
            _context.NotificationRecipients.Add(new NotificationRecipient
            {
                NotificationId = notification.Id,
                UserId = userId,
                IsDelivered = false,
                IsRead = false
            });
        }

        await _context.SaveChangesAsync(CancellationToken.None);

        // Use dispatcher for hybrid delivery
        await _notificationDispatcher.SendBulkNotificationAsync(notification.Id, targetUsers);

        return Ok(new { notification.Id, DispatchedCount = targetUsers.Count });
    }
}

public record BroadcastNotificationRequest(string Title, string Body, string? Category, string? PayloadJson);
