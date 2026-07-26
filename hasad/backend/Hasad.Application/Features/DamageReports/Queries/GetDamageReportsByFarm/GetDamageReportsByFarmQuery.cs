using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Models;
using Hasad.Domain.Constants;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.DamageReports.Queries.GetDamageReportsByFarm;

public record GetDamageReportsByFarmQuery(Guid FarmId) : IRequest<Result<List<DamageReportDto>>>;

public class GetDamageReportsByFarmQueryHandler : IRequestHandler<GetDamageReportsByFarmQuery, Result<List<DamageReportDto>>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public GetDamageReportsByFarmQueryHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<List<DamageReportDto>>> Handle(GetDamageReportsByFarmQuery request, CancellationToken cancellationToken)
    {
        var query = _context.DamageReports.AsNoTracking();

        // Authorization filtering
        if (_currentUser.IsInRole(AppRoles.AgriculturalEngineer) || _currentUser.IsInRole(AppRoles.FieldSurveyor))
        {
            if (_currentUser.DirectorateId.HasValue)
            {
                query = query.Where(r => r.Farm!.DirectorateId == _currentUser.DirectorateId.Value);
            }
        }
        else if (_currentUser.IsInRole(AppRoles.Director))
        {
            if (_currentUser.GovernorateId.HasValue)
            {
                query = query.Where(r => r.Farm!.GovernorateId == _currentUser.GovernorateId.Value);
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
                DamageYear = r.DamageDate.Year,
                FarmId = r.FarmId,
                FarmerId = r.Farm!.FarmerId,
                DamageDate = r.DamageDate,
                DocumentationDate = r.DocumentationDate,
                AgriculturalSectorId = r.AgriculturalSectorId,
                DamageCauseCategoryId = r.DamageCauseCategoryId,
                DamageCauseId = r.DamageCauseId,
                GovernorateId = r.Farm!.GovernorateId,
                DirectorateId = r.Farm!.DirectorateId,
                LocalityId = r.Farm!.LocalityId,
                Latitude = r.Farm!.Latitude,
                Longitude = r.Farm!.Longitude,
                StatusId = r.StatusId,
                Notes = r.Notes,
                RowVersion = Convert.ToBase64String(r.RowVersion)
            })
            .ToListAsync(cancellationToken);

        return Result<List<DamageReportDto>>.Success(reports);
    }
}
