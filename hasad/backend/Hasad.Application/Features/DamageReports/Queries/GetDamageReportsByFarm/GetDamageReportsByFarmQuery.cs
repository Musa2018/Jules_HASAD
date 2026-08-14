using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Models;
using Hasad.Domain.Constants;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Hasad.Application.Features.DamageReports.Queries.GetDamageReportsByFarm;

public record GetDamageReportsByFarmQuery(Guid FarmId) : IRequest<Result<List<DamageReportDto>>>;

public class GetDamageReportsByFarmQueryHandler : IRequestHandler<GetDamageReportsByFarmQuery, Result<List<DamageReportDto>>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;
private readonly ILogger<GetDamageReportsByFarmQueryHandler> _logger;
    public GetDamageReportsByFarmQueryHandler(IApplicationDbContext context, ICurrentUserService currentUser,
    ILogger<GetDamageReportsByFarmQueryHandler> logger)
    {
        _context = context;
        _currentUser = currentUser;
         _logger = logger;
    }

    public async Task<Result<List<DamageReportDto>>> Handle(GetDamageReportsByFarmQuery request, CancellationToken cancellationToken)
    {
        var query = _context.DamageReports.AsNoTracking();
_logger.LogInformation(
     "DamageReport Farm Query: User={UserId}, Directorate={DirectorateId}, Governorate={GovernorateId}, Engineer={Engineer}, Surveyor={Surveyor}, Director={Director}",
     _currentUser.UserId,
     _currentUser.DirectorateId,
     _currentUser.GovernorateId,
     _currentUser.IsInRole(AppRoles.AgriculturalEngineer),
     _currentUser.IsInRole(AppRoles.FieldSurveyor),
     _currentUser.IsInRole(AppRoles.Director)
 );
        // Authorization filtering
        if (_currentUser.IsInRole(AppRoles.AgriculturalEngineer) || _currentUser.IsInRole(AppRoles.FieldSurveyor))
        {
            if (_currentUser.DirectorateId.HasValue)
            {
                query = query.Where(r => r.DirectorateId == _currentUser.DirectorateId.Value);
            }
        }
        else if (_currentUser.IsInRole(AppRoles.Director))
        {
            if (_currentUser.GovernorateId.HasValue)
            {
                query = query.Where(r => r.GovernorateId == _currentUser.GovernorateId.Value);
            }
        }

        var reports = await query
            .Where(r => r.FarmId == request.FarmId)
            .OrderByDescending(r => r.DamageDate)
            .Select(r => new DamageReportDto
            {
                Id = r.Id,
                ClientId = r.ClientId,
                ReportNumber = r.ReportNumber,
                PermanentFormNumber = r.PermanentFormNumber,
                TemporaryFormNumber = r.TemporaryFormNumber,
                DamageYear = r.DamageYear,
                FarmId = r.FarmId,
                FarmerId = r.FarmerId,
                DamageDate = r.DamageDate,
                DocumentationDate = r.DocumentationDate,
                AgriculturalSectorId = r.AgriculturalSectorId,
                DamageCauseCategoryId = r.DamageCauseCategoryId,
                DamageCauseId = r.DamageCauseId,
                GovernorateId = r.GovernorateId,
                DirectorateId = r.DirectorateId,
                LocalityId = r.LocalityId,
                StatusId = r.StatusId,
                TotalDamage = r.TotalDamage,
                Notes = r.Notes,
                RowVersion = Convert.ToBase64String(r.RowVersion),
                Items = r.Items.Select(i => new DamageItemDto
                {
                    Id = i.Id,
                    ClientId = i.ClientId,
                    DamageNatureId = i.DamageNatureId,
                    DamageActionId = i.DamageActionId,
                    ClassificationId = i.ClassificationId,
                    CostingSheetId = i.CostingSheetItemId,
                    CalculatedUnitPrice = i.CalculatedUnitPrice,
                    MeasurementUnitSnapshot = i.MeasurementUnitSnapshot,
                    AffectedArea = i.AffectedArea,
                    DamagePercentage = i.DamagePercentage,
                    Quantity = i.Quantity,
                    EstimatedLoss = i.EstimatedLoss,
                    RowVersion = Convert.ToBase64String(i.RowVersion)
                }).ToList()
            })
            .ToListAsync(cancellationToken);

        return Result<List<DamageReportDto>>.Success(reports);
    }
}
