using Hasad.Application.Common.Interfaces;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using Hasad.Domain.Identity;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Serilog;

namespace Hasad.Infrastructure.Services;

public class NotificationService : INotificationService
{
    private readonly IApplicationDbContext _context;
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IEmailService _emailService;
    private readonly INotificationDispatcher _dispatcher;
    private readonly ICurrentUserService _currentUser;

    public NotificationService(
        IApplicationDbContext context,
        UserManager<ApplicationUser> userManager,
        IEmailService emailService,
        INotificationDispatcher dispatcher,
        ICurrentUserService currentUser)
    {
        _context = context;
        _userManager = userManager;
        _emailService = emailService;
        _dispatcher = dispatcher;
        _currentUser = currentUser;
    }

    public async Task NotifyStageTransitionAsync(DamageReport report, string fromStatus, string toStatus, string? comment = null)
    {
        Log.Information("Processing notifications for Report {ReportNumber} transition {From} -> {To}", report.ReportNumber, fromStatus, toStatus);

        // 1. Resolve target roles: Find who is allowed to perform the NEXT action from the new status
        var targetRoles = await _context.WorkflowTransitions
            .Where(t => t.FromStatusId == toStatus && !t.IsReturn)
            .Select(t => t.AllowedRole)
            .Distinct()
            .ToListAsync();

        if (!targetRoles.Any())
        {
             // If it's a return, we usually notify the person who was the "To" of the original transition
             // but for simplicity here we check if there are any return transitions defined
             if (IsReturn(fromStatus, toStatus))
             {
                 targetRoles = await _context.WorkflowTransitions
                    .Where(t => t.ToStatusId == toStatus && t.IsReturn)
                    .Select(t => t.AllowedRole)
                    .Distinct()
                    .ToListAsync();
             }

             if (!targetRoles.Any())
             {
                 Log.Information("No target roles found for transition to {ToStatus}", toStatus);
                 return;
             }
        }

        var initiatingUserId = _currentUser.UserId;

        foreach (var role in targetRoles)
        {
            var usersInRole = await _userManager.GetUsersInRoleAsync(role);

            // Filter by Scope and Exclude Initiator
            var targetUsers = usersInRole.Where(u =>
                u.IsActive &&
                u.Id != initiatingUserId && // EXCLUDE the user who performed the transition
                (!u.DirectorateId.HasValue || u.DirectorateId == report.DirectorateId) &&
                (!u.GovernorateId.HasValue || u.GovernorateId == report.GovernorateId)
            ).ToList();

            if (targetUsers.Any())
            {
                Log.Information("Resolved {Count} target users for role {Role} in scope {DirectorateId}",
                    targetUsers.Count, role, report.DirectorateId);
                // 1. Create In-App Notification Entity
                bool isReturn = IsReturn(fromStatus, toStatus);
                string title = isReturn ? "إعادة تقرير ضرر للمراجعة" : "تقرير ضرر جديد بانتظار الإجراء";

                var gov = await _context.Governorates.AsNoTracking().FirstOrDefaultAsync(g => g.Id == report.GovernorateId);
                var dir = await _context.Directorates.AsNoTracking().FirstOrDefaultAsync(d => d.Id == report.DirectorateId);
                string locationInfo = $"{gov?.NameAr} - {dir?.NameAr}";

                string body = $"رقم التقرير: {report.ReportNumber}\nالمكان: {locationInfo}\nالحالة: {toStatus}";
                if (!string.IsNullOrWhiteSpace(comment))
                {
                    body += $"\nملاحظة: {comment}";
                }

                var notification = new Notification
                {
                    Id = Guid.NewGuid(),
                    Title = title,
                    Body = body,
                    Category = "WorkflowTask",
                    PayloadJson = System.Text.Json.JsonSerializer.Serialize(new
                    {
                        reportId = report.Id,
                        reportNumber = report.ReportNumber,
                        action = "NavigateToReport"
                    }),
                    CreatedAt = DateTime.UtcNow
                };

                _context.Notifications.Add(notification);

                var targetUserIds = targetUsers.Select(u => u.Id).ToList();
                foreach (var userId in targetUserIds)
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

                // 2. Real-time Dispatch via SignalR/Push
                await _dispatcher.SendBulkNotificationAsync(notification.Id, targetUserIds);

                // 3. Legacy Email Alerts
                foreach (var user in targetUsers)
                {
                    if (!string.IsNullOrEmpty(user.Email))
                    {
                        try
                        {
                            await _emailService.SendEmailAsync(user.Email, $"تنبيه: {title}", body);
                        }
                        catch (Exception ex)
                        {
                            Log.Error(ex, "Failed to send email notification to {Email} for report {ReportNumber}", user.Email, report.ReportNumber);
                        }
                    }
                }
            }
        }
    }

    private bool IsReturn(string from, string to)
    {
        var all = DamageReportStatus.All().ToList();
        return all.IndexOf(to) < all.IndexOf(from);
    }
}
