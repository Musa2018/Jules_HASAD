using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Models;
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
        if (_currentUser.IsInRole("AgriculturalEngineer") || _currentUser.IsInRole("FieldSurveyor"))
        {
            if (_currentUser.DirectorateId.HasValue)
            {
                query = query.Where(r => r.DirectorateId == _currentUser.DirectorateId.Value);
            }
        }
        else if (_currentUser.IsInRole("Director"))
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
                PermanentFormNumber = r.PermanentFormNumber,
                TemporaryFormNumber = r.TemporaryFormNumber,
                FarmId = r.FarmId,
                FarmerId = r.FarmerId,
                DamageDate = r.DamageDate,
                DocumentationDate = r.DocumentationDate,
                DamageCauseCategoryId = r.DamageCauseCategoryId,
                DamageCauseId = r.DamageCauseId,
                GovernorateId = r.GovernorateId,
                DirectorateId = r.DirectorateId,
                LocalityId = r.LocalityId,
                Latitude = r.Latitude,
                Longitude = r.Longitude,
                StatusId = r.StatusId,
                Notes = r.Notes,
                RowVersion = Convert.ToBase64String(r.RowVersion)
            })
            .ToListAsync(cancellationToken);

        return Result<List<DamageReportDto>>.Success(reports);
    }
}
