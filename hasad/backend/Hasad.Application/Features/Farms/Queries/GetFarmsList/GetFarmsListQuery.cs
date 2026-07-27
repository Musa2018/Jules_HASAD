using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Farms.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Farms.Queries.GetFarmsList;

public record GetFarmsListQuery(
    int PageNumber = 1,
    int PageSize = 10,
    string? SearchText = null,
    DateTime? UpdatedSince = null) : IRequest<Result<PaginatedList<FarmDto>>>;

public class GetFarmsListQueryHandler : IRequestHandler<GetFarmsListQuery, Result<PaginatedList<FarmDto>>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public GetFarmsListQueryHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<PaginatedList<FarmDto>>> Handle(GetFarmsListQuery request, CancellationToken cancellationToken)
    {
        var query = _context.Farms.AsNoTracking();

        // 1. Authorization Scoping
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

        // 2. Incremental Sync (Pull Watermark)
        if (request.UpdatedSince.HasValue)
        {
            query = query.Where(f => f.UpdatedAt > request.UpdatedSince.Value || f.CreatedAt > request.UpdatedSince.Value);
        }

        // 3. Search Filtering
        if (!string.IsNullOrWhiteSpace(request.SearchText))
        {
            var search = request.SearchText.ToLower();
            query = query.Where(f =>
                f.LocalFarmName.ToLower().Contains(search) ||
                f.Basin.ToLower().Contains(search) ||
                f.Parcel.ToLower().Contains(search));
        }

        var count = await query.CountAsync(cancellationToken);

        var dbItems = await query
            .OrderBy(f => f.LocalFarmName)
            .Skip((request.PageNumber - 1) * request.PageSize)
            .Take(request.PageSize)
            .ToListAsync(cancellationToken);

        var items = dbItems.Select(f => new FarmDto
        {
            Id = f.Id,
            ClientId = f.ClientId,
            FarmerId = f.FarmerId,
            LocalFarmName = f.LocalFarmName,
            OwnershipTypeId = f.OwnershipTypeId,
            OwnerFarmerId = f.OwnerFarmerId,
            RelationshipToOwnerId = f.RelationshipToOwnerId,
            GovernorateId = f.GovernorateId,
            DirectorateId = f.DirectorateId,
            LocalityId = f.LocalityId,
            Basin = f.Basin,
            Parcel = f.Parcel,
            Area = f.Area,
            MeasurementUnitId = f.MeasurementUnitId,
            AgriculturalSectorId = f.AgriculturalSectorId,
            PoliticalClassificationId = f.PoliticalClassificationId,
            Latitude = f.Latitude,
            Longitude = f.Longitude,
            Notes = f.Notes,
            CreatedAt = f.CreatedAt,
            RowVersion = f.RowVersion != null ? Convert.ToBase64String(f.RowVersion) : string.Empty,
            IsDeleted = f.IsDeleted
        }).ToList();

        var paginatedList = new PaginatedList<FarmDto>
        {
            Items = items,
            TotalCount = count,
            PageNumber = request.PageNumber,
            TotalPages = (int)Math.Ceiling(count / (double)request.PageSize)
        };

        return Result<PaginatedList<FarmDto>>.Success(paginatedList);
    }
}
