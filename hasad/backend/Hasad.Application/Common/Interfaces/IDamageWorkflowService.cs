using Hasad.Domain.Entities;

namespace Hasad.Application.Common.Interfaces;

public interface IDamageWorkflowService
{
    bool IsTransitionValid(string fromStatus, string toStatus, string userRole);
    bool CanTransition(DamageReport report, string targetStatus, string? comment);
    Task TransitionAsync(DamageReport report, string toStatus, string? comment = null, bool isOverride = false);
}
