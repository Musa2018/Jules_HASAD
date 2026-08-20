using Hasad.Application.Common.Interfaces;
using Hasad.Domain.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class DeviceController : ControllerBase
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public DeviceController(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterDeviceRequest request)
    {
        var userId = _currentUser.UserId;
        if (string.IsNullOrEmpty(userId)) return Unauthorized();

        var existing = await _context.UserDevices
            .FirstOrDefaultAsync(d => d.DeviceToken == request.DeviceToken);

        if (existing != null)
        {
            existing.UserId = userId;
            existing.Platform = request.Platform;
            existing.LastActiveAt = DateTime.UtcNow;
        }
        else
        {
            var device = new UserDevice
            {
                Id = Guid.NewGuid(),
                UserId = userId,
                DeviceToken = request.DeviceToken,
                Platform = request.Platform,
                IsOnline = false,
                LastActiveAt = DateTime.UtcNow
            };
            _context.UserDevices.Add(device);
        }

        await _context.SaveChangesAsync(CancellationToken.None);
        return Ok();
    }
}

public record RegisterDeviceRequest(string DeviceToken, string Platform);
