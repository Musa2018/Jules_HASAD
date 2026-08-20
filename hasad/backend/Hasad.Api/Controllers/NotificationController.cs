using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Domain.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class NotificationController : ControllerBase
{
    private readonly IApplicationDbContext _context;
    private readonly INotificationDispatcher _dispatcher;
    private readonly ICurrentUserService _currentUser;

    public NotificationController(
        IApplicationDbContext context,
        INotificationDispatcher dispatcher,
        ICurrentUserService currentUser)
    {
        _context = context;
        _dispatcher = dispatcher;
        _currentUser = currentUser;
    }

    [HttpGet("my-notifications")]
    public async Task<IActionResult> GetMyNotifications([FromQuery] int pageIndex = 1, [FromQuery] int pageSize = 20)
    {
        var userId = _currentUser.UserId;
        if (string.IsNullOrEmpty(userId)) return Unauthorized();

        var query = _context.NotificationRecipients
            .Include(r => r.Notification)
            .Where(r => r.UserId == userId)
            .OrderByDescending(r => r.Notification.CreatedAt);

        var totalCount = await query.CountAsync();
        var unreadCount = await query.CountAsync(r => !r.IsRead);

        var items = await query
            .Skip((pageIndex - 1) * pageSize)
            .Take(pageSize)
            .Select(r => new
            {
                r.Notification.Id,
                r.Notification.Title,
                r.Notification.Body,
                r.Notification.Category,
                r.Notification.PayloadJson,
                r.Notification.CreatedAt,
                r.IsRead,
                r.ReadAt,
                r.IsDelivered,
                r.DeliveredAt
            })
            .ToListAsync();

        return Ok(new
        {
            Items = items,
            TotalCount = totalCount,
            UnreadCount = unreadCount,
            PageIndex = pageIndex,
            PageSize = pageSize
        });
    }

    [HttpPut("{id}/read")]
    public async Task<IActionResult> MarkAsRead(Guid id)
    {
        var userId = _currentUser.UserId;
        if (string.IsNullOrEmpty(userId)) return Unauthorized();

        await _context.NotificationRecipients
            .Where(r => r.NotificationId == id && r.UserId == userId)
            .ExecuteUpdateAsync(s => s
                .SetProperty(b => b.IsRead, true)
                .SetProperty(b => b.ReadAt, DateTime.UtcNow));

        return NoContent();
    }

    [HttpPost("send")]
    public async Task<IActionResult> SendNotification([FromBody] SendNotificationRequest request)
    {
        // Only Admins or System should ideally call this
        // Check permissions if needed.

        var notification = new Notification
        {
            Id = Guid.NewGuid(),
            Title = request.Title,
            Body = request.Body,
            Category = request.Category,
            PayloadJson = request.PayloadJson,
            CreatedAt = DateTime.UtcNow
        };

        _context.Notifications.Add(notification);

        foreach (var userId in request.TargetUserIds)
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

        // Dispatch in background or immediately
        await _dispatcher.SendBulkNotificationAsync(notification.Id, request.TargetUserIds);

        return Ok(new { notification.Id });
    }
}

public record SendNotificationRequest(
    string Title,
    string Body,
    string Category,
    string? PayloadJson,
    List<string> TargetUserIds);
