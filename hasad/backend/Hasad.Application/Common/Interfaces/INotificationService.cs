using Hasad.Domain.Entities;

namespace Hasad.Application.Common.Interfaces;

public interface INotificationService
{
    Task NotifyStageTransitionAsync(DamageReport report, string fromStatus, string toStatus, string? comment = null);
}
