using System.Security.Claims;
using System.Text.Json;
using Hasad.Application.Common.Interfaces;
using Hasad.Domain.Entities;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Api.Filters;

/// <summary>
/// Intercepts actions to automatically log administrative mutations for auditing.
/// </summary>
public class AuditLogAttribute : ActionFilterAttribute
{
    private readonly string _entityName;
    private readonly string _action;

    public AuditLogAttribute(string entityName, string action)
    {
        _entityName = entityName;
        _action = action;
    }

    public override async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
    {
        // Execute the action
        var executedContext = await next();

        // Only log if the action was successful
        if (executedContext.Exception == null)
        {
            var db = context.HttpContext.RequestServices.GetRequiredService<IApplicationDbContext>();
            var userId = context.HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
            var ip = context.HttpContext.Connection.RemoteIpAddress?.ToString();

            if (!string.IsNullOrEmpty(userId))
            {
                // Find AdminId for this UserId
                var admin = await db.AdminUsers.FirstOrDefaultAsync(a => a.UserId == userId);
                if (admin != null)
                {
                    db.AdminAuditLogs.Add(new AdminAuditLog
                    {
                        AdminUserId = admin.AdminId,
                        EntityName = _entityName,
                        Action = _action,
                        IpAddress = ip,
                        UserAgent = context.HttpContext.Request.Headers["User-Agent"].ToString(),
                        Timestamp = DateTime.UtcNow,
                        NewValuesJson = context.ActionArguments.Any()
                            ? JsonSerializer.Serialize(context.ActionArguments)
                            : null
                    });
                    await db.SaveChangesAsync(CancellationToken.None);
                }
            }
        }
    }
}
