using Hasad.Domain.Entities;

namespace Hasad.Application.Common.Interfaces;

public interface IDamageWorkflowService
{
    Task<bool> IsTransitionValidAsync(string fromStatus, string toStatus, string userRole);
    Task<bool> CanTransitionAsync(DamageReport report, string targetStatus, string? comment);
    Task TransitionAsync(DamageReport report, string toStatus, string? comment = null, bool isOverride = false);
}
