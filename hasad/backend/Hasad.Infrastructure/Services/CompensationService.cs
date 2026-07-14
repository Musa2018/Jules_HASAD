using Hasad.Application.Common.Interfaces;
using Hasad.Domain.Entities;

namespace Hasad.Infrastructure.Services;

public class CompensationService : ICompensationService
{
    public decimal Calculate(DamageReport report)
    {
        if (report.Items == null || !report.Items.Any())
            return 0;

        // Basic calculation logic: 80% of estimated loss
        decimal totalEstimatedLoss = report.Items.Sum(i => i.EstimatedLoss);
        return totalEstimatedLoss * 0.8m;
    }
}
