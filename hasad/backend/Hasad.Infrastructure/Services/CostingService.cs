using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Microsoft.EntityFrameworkCore;

using Hasad.Domain.Enums;

namespace Hasad.Infrastructure.Services;

public class CostingService : ICostingService
{
    private readonly IApplicationDbContext _context;

    public CostingService(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Result<decimal>> GetUnitPriceAsync(int classificationId, Guid costingSheetId, DateTime damageDate, CancellationToken cancellationToken)
    {
        var item = await _context.CostingSheetItems
            .Include(x => x.Version)
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.Id == costingSheetId, cancellationToken);

        if (item == null)
        {
            return Result<decimal>.Failure(new[] { "Costing sheet item not found." });
        }

        if (item.ClassificationId != classificationId)
        {
            return Result<decimal>.Failure(new[] { $"Costing sheet item {costingSheetId} does not belong to classification {classificationId}." });
        }

        var version = item.Version;
        if (version == null)
        {
            return Result<decimal>.Failure(new[] { "Costing sheet version not found." });
        }

        // Rule: was active on DamageDate
        if (damageDate.Date < version.EffectiveFrom.Date || (version.EffectiveTo.HasValue && damageDate.Date > version.EffectiveTo.Value.Date))
        {
            return Result<decimal>.Failure(new[] { $"Costing sheet version {version.Id} was not active on the damage date {damageDate:yyyy-MM-dd}." });
        }

        if (version.Status != CostingSheetStatus.Active && version.Status != CostingSheetStatus.Archived)
        {
            return Result<decimal>.Failure(new[] { "Costing sheet version is not active or archived." });
        }

        return Result<decimal>.Success(item.UnitPrice);
    }
}
