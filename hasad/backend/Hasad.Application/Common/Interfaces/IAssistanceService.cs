using Hasad.Domain.Entities;

namespace Hasad.Application.Common.Interfaces;

public interface IAssistanceService
{
    decimal Calculate(DamageReport report, AssistanceRule rule);
}
