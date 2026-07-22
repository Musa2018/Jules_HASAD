using System.Security.Claims;
using Hasad.Application.Common.Interfaces;
using Microsoft.AspNetCore.Http;

namespace Hasad.Infrastructure.Services;

public class CurrentUserService : ICurrentUserService
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public CurrentUserService(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    public string? UserId => _httpContextAccessor.HttpContext?.User?.FindFirstValue(ClaimTypes.NameIdentifier);
    public string? UserName => _httpContextAccessor.HttpContext?.User?.Identity?.Name;

    public Guid? GovernorateId => Guid.TryParse(_httpContextAccessor.HttpContext?.User?.FindFirstValue("governorate_id"), out var id) ? id : null;
    public Guid? DirectorateId => Guid.TryParse(_httpContextAccessor.HttpContext?.User?.FindFirstValue("directorate_id"), out var id) ? id : null;

    public bool IsInRole(string role) => _httpContextAccessor.HttpContext?.User?.IsInRole(role) ?? false;
}
