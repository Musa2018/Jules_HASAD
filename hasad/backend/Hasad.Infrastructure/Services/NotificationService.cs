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

    public NotificationService(IApplicationDbContext context, UserManager<ApplicationUser> userManager, IEmailService emailService)
    {
        _context = context;
        _userManager = userManager;
        _emailService = emailService;
    }

    public async Task NotifyStageTransitionAsync(DamageReport report, string fromStatus, string toStatus, string? comment = null)
    {
        Log.Information("Processing notifications for Report {ReportNumber} transition {From} -> {To}", report.ReportNumber, fromStatus, toStatus);

        // 1. Find the target role(s) for the new status
        var transitions = await _context.WorkflowTransitions
            .Where(t => t.ToStatusId == toStatus && !t.IsReturn)
            .Select(t => t.AllowedRole)
            .Distinct()
            .ToListAsync();

        if (!transitions.Any())
        {
             // If it's a return, notify the creator or the previous reviewer
             if (IsReturn(fromStatus, toStatus))
             {
                 // Implementation for return notification
                 return;
             }
             return;
        }

        foreach (var role in transitions)
        {
            var usersInRole = await _userManager.GetUsersInRoleAsync(role);

            // Filter by Scope
            var targetUsers = usersInRole.Where(u =>
                u.IsActive &&
                (!u.DirectorateId.HasValue || u.DirectorateId == report.DirectorateId) &&
                (!u.GovernorateId.HasValue || u.GovernorateId == report.GovernorateId)
            ).ToList();

            foreach (var user in targetUsers)
            {
                if (!string.IsNullOrEmpty(user.Email))
                {
                    try
                    {
                        await _emailService.SendEmailAsync(user.Email, "تنبيه: معاملة بانتظار المراجعة",
                            $"المزارع: {report.FarmerId}\nرقم التقرير: {report.ReportNumber}\nالحالة الحالية: {toStatus}\nالرجاء مراجعة النظام.");
                    }
                    catch (Exception ex)
                    {
                        Log.Error(ex, "Failed to send email notification to {Email} for report {ReportNumber}", user.Email, report.ReportNumber);
                        // Notifications are secondary; we don't want to break the whole workflow if email fails.
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
