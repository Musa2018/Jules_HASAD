using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Farms.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Farms.Queries.GetFarmsByFarmer;

public record GetFarmsByFarmerQuery(Guid FarmerId) : IRequest<Result<List<FarmDto>>>;

public class GetFarmsByFarmerQueryHandler : IRequestHandler<GetFarmsByFarmerQuery, Result<List<FarmDto>>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public GetFarmsByFarmerQueryHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<List<FarmDto>>> Handle(GetFarmsByFarmerQuery request, CancellationToken cancellationToken)
    {
        var query = _context.Farms.AsNoTracking();

        // Authorization Scoping (Land-based)
        if (_currentUser.IsInRole("AgriculturalEngineer") || _currentUser.IsInRole("FieldSurveyor"))
        {
            if (_currentUser.DirectorateId.HasValue)
            {
                query = query.Where(f => f.DirectorateId == _currentUser.DirectorateId.Value);
            }
        }
        else if (_currentUser.IsInRole("Director"))
        {
            if (_currentUser.GovernorateId.HasValue)
            {
                query = query.Where(f => f.GovernorateId == _currentUser.GovernorateId.Value);
            }
        }

        var dbFarms = await query
            .Where(f => f.FarmerId == request.FarmerId)
            .ToListAsync(cancellationToken);

        var items = dbFarms.Select(f => new FarmDto
        {
            Id = f.Id,
            ClientId = f.ClientId,
            FarmerId = f.FarmerId,
            LocalFarmName = f.LocalFarmName,
            OwnershipTypeId = f.OwnershipTypeId,
            LocalityId = f.LocalityId,
            Basin = f.Basin,
            Parcel = f.Parcel,
            Area = f.Area,
            MeasurementUnitId = f.MeasurementUnitId,
            RowVersion = f.RowVersion != null ? Convert.ToBase64String(f.RowVersion) : string.Empty,
            CreatedAt = f.CreatedAt
        }).ToList();

        return Result<List<FarmDto>>.Success(items);
    }
}
