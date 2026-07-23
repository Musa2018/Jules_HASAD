using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Microsoft.EntityFrameworkCore;

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
        var costingSheet = await _context.CostingSheets
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.Id == costingSheetId, cancellationToken);

        if (costingSheet == null)
        {
            return Result<decimal>.Failure(new[] { "Costing sheet not found." });
        }

        if (costingSheet.ClassificationId != classificationId)
        {
            return Result<decimal>.Failure(new[] { $"Costing sheet {costingSheetId} does not belong to classification {classificationId}." });
        }

        // Rule: was active on DamageDate
        if (damageDate.Date < costingSheet.EffectiveFrom.Date || (costingSheet.EffectiveTo.HasValue && damageDate.Date > costingSheet.EffectiveTo.Value.Date))
        {
            return Result<decimal>.Failure(new[] { $"Costing sheet {costingSheetId} was not active on the damage date {damageDate:yyyy-MM-dd}." });
        }

        if (!costingSheet.IsActive)
        {
            return Result<decimal>.Failure(new[] { "Costing sheet is marked as inactive." });
        }

        return Result<decimal>.Success(costingSheet.UnitPrice);
    }
}
