using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Farmers.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Farmers.Queries.GetFarmersList;

public record GetFarmersListQuery(int PageNumber = 1, int PageSize = 10) : IRequest<Result<PaginatedList<FarmerDto>>>;

public class GetFarmersListQueryHandler : IRequestHandler<GetFarmersListQuery, Result<PaginatedList<FarmerDto>>>
{
    private readonly IApplicationDbContext _context;

    public GetFarmersListQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Result<PaginatedList<FarmerDto>>> Handle(GetFarmersListQuery request, CancellationToken cancellationToken)
    {
        var query = _context.Farmers.AsNoTracking();

        var count = await query.CountAsync(cancellationToken);
        var items = await query
            .OrderBy(f => f.Name)
            .Skip((request.PageNumber - 1) * request.PageSize)
            .Take(request.PageSize)
            .Select(f => new FarmerDto
            {
                Id = f.Id,
                Name = f.Name,
                NationalId = f.NationalId,
                PhoneNumber = f.PhoneNumber,
                Address = f.Address,
                RowVersion = Convert.ToBase64String(f.RowVersion)
            })
            .ToListAsync(cancellationToken);

        var paginatedList = new PaginatedList<FarmerDto>
        {
            Items = items,
            TotalCount = count,
            PageNumber = request.PageNumber,
            TotalPages = (int)Math.Ceiling(count / (double)request.PageSize)
        };

        return Result<PaginatedList<FarmerDto>>.Success(paginatedList);
    }
}
