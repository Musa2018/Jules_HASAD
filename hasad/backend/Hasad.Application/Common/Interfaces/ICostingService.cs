using Hasad.Application.Common.Models;

namespace Hasad.Application.Common.Interfaces;

public interface ICostingService
{
    Task<Result<decimal>> GetUnitPriceAsync(int classificationId, Guid costingSheetId, DateTime damageDate, CancellationToken cancellationToken);
}
