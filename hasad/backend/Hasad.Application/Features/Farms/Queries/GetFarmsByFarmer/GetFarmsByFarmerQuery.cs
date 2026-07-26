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

    public GetFarmsByFarmerQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Result<List<FarmDto>>> Handle(GetFarmsByFarmerQuery request, CancellationToken cancellationToken)
    {
        var farms = await _context.Farms
            .AsNoTracking()
            .Include(f => f.OwnershipType)
            .Include(f => f.Locality)
            .Include(f => f.MeasurementUnit)
            .Where(f => f.FarmerId == request.FarmerId)
            .Select(f => new FarmDto
            {
                Id = f.Id,
                ClientId = f.ClientId,
                FarmerId = f.FarmerId,
                LocalFarmName = f.LocalFarmName,
                OwnershipTypeId = f.OwnershipTypeId,
                OwnershipTypeName = f.OwnershipType != null ? f.OwnershipType.NameAr : null,
                LocalityId = f.LocalityId,
                LocalityName = f.Locality != null ? f.Locality.NameAr : null,
                Basin = f.Basin,
                Parcel = f.Parcel,
                Area = f.Area,
                MeasurementUnitId = f.MeasurementUnitId,
                MeasurementUnitName = f.MeasurementUnit != null ? f.MeasurementUnit.NameAr : null,
                RowVersion = Convert.ToBase64String(f.RowVersion),
                CreatedAt = f.CreatedAt
            })
            .ToListAsync(cancellationToken);

        return Result<List<FarmDto>>.Success(farms);
    }
}
