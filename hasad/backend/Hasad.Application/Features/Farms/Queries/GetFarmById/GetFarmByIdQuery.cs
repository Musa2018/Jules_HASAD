using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Farms.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Farms.Queries.GetFarmById;

public record GetFarmByIdQuery(Guid Id) : IRequest<Result<FarmDto>>;

public class GetFarmByIdQueryHandler : IRequestHandler<GetFarmByIdQuery, Result<FarmDto>>
{
    private readonly IApplicationDbContext _context;

    public GetFarmByIdQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Result<FarmDto>> Handle(GetFarmByIdQuery request, CancellationToken cancellationToken)
    {
        var farm = await _context.Farms
            .AsNoTracking()
            .Include(f => f.Farmer)
            .Include(f => f.OwnerFarmer)
            .Include(f => f.OwnershipType)
            .Include(f => f.RelationshipToOwner)
            .Include(f => f.Governorate)
            .Include(f => f.Directorate)
            .Include(f => f.Locality)
            .Include(f => f.MeasurementUnit)
            .Include(f => f.AgriculturalSector)
            .Include(f => f.PoliticalClassification)
            .FirstOrDefaultAsync(f => f.Id == request.Id, cancellationToken);

        if (farm == null)
        {
            return Result<FarmDto>.Failure(new[] { "Farm not found." });
        }

        return Result<FarmDto>.Success(new FarmDto
        {
            Id = farm.Id,
            ClientId = farm.ClientId,
            FarmerId = farm.FarmerId,
            FarmerName = farm.Farmer != null ? $"{farm.Farmer.FirstNameAr} {farm.Farmer.FamilyNameAr}" : null,
            LocalFarmName = farm.LocalFarmName,
            OwnershipTypeId = farm.OwnershipTypeId,
            OwnershipTypeName = farm.OwnershipType?.NameAr,
            OwnerFarmerId = farm.OwnerFarmerId,
            OwnerFarmerName = farm.OwnerFarmer != null ? $"{farm.OwnerFarmer.FirstNameAr} {farm.OwnerFarmer.FamilyNameAr}" : null,
            RelationshipToOwnerId = farm.RelationshipToOwnerId,
            RelationshipToOwnerName = farm.RelationshipToOwner?.NameAr,
            GovernorateId = farm.GovernorateId,
            GovernorateName = farm.Governorate?.NameAr,
            DirectorateId = farm.DirectorateId,
            DirectorateName = farm.Directorate?.NameAr,
            LocalityId = farm.LocalityId,
            LocalityName = farm.Locality?.NameAr,
            Basin = farm.Basin,
            Parcel = farm.Parcel,
            Area = farm.Area,
            MeasurementUnitId = farm.MeasurementUnitId,
            MeasurementUnitName = farm.MeasurementUnit?.NameAr,
            AgriculturalSectorId = farm.AgriculturalSectorId,
            AgriculturalSectorName = farm.AgriculturalSector?.NameAr,
            PoliticalClassificationId = farm.PoliticalClassificationId,
            PoliticalClassificationName = farm.PoliticalClassification?.NameAr,
            Latitude = farm.Latitude,
            Longitude = farm.Longitude,
            Notes = farm.Notes,
            CreatedAt = farm.CreatedAt,
            IsDeleted = farm.IsDeleted,
            RowVersion = Convert.ToBase64String(farm.RowVersion)
        });
    }
}
