using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Models;
using Hasad.Domain.Constants;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.DamageReports.Queries.GetDamageReportsByFarmer;

public record GetDamageReportsByFarmerQuery(Guid FarmerId) : IRequest<Result<List<DamageReportDto>>>;

public class GetDamageReportsByFarmerQueryHandler : IRequestHandler<GetDamageReportsByFarmerQuery, Result<List<DamageReportDto>>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public GetDamageReportsByFarmerQueryHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<List<DamageReportDto>>> Handle(GetDamageReportsByFarmerQuery request, CancellationToken cancellationToken)
    {
        var query = _context.DamageReports.AsNoTracking();

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
            .Where(r => r.FarmerId == request.FarmerId)
            .OrderByDescending(r => r.DamageDate)
            .Select(r => new DamageReportDto
            {
                Id = r.Id,
                ClientId = r.ClientId,
                FarmId = r.FarmId,
                FarmerId = r.FarmerId,
                DamageDate = r.DamageDate,
                DocumentationDate = r.DocumentationDate,
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
