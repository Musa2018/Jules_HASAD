using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.ReferenceData.Queries.GetReferenceData;

public record GetReferenceDataQuery : IRequest<ReferenceDataDto>;

public class GetReferenceDataQueryHandler : IRequestHandler<GetReferenceDataQuery, ReferenceDataDto>
{
    private readonly IApplicationDbContext _context;

    public GetReferenceDataQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<ReferenceDataDto> Handle(GetReferenceDataQuery request, CancellationToken cancellationToken)
    {
        var dto = new ReferenceDataDto();

        dto.OwnershipTypes = await _context.OwnershipTypes
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                NameAr = x.NameAr,
                NameEn = x.NameEn
            })
            .ToListAsync(cancellationToken);

        dto.AgriculturalSectors = await _context.AgriculturalSectors
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                NameAr = x.NameAr,
                NameEn = x.NameEn
            })
            .ToListAsync(cancellationToken);

        dto.PoliticalClassifications = await _context.PoliticalClassifications
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                NameAr = x.NameAr,
                NameEn = x.NameEn
            })
            .ToListAsync(cancellationToken);

        dto.AreaUnits = await _context.AreaUnits
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                NameAr = x.NameAr,
                NameEn = x.NameEn,
                Category = "Area"
            })
            .ToListAsync(cancellationToken);

        dto.RelationshipToOwners = await _context.RelationshipToOwners
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                NameAr = x.NameAr,
                NameEn = x.NameEn
            })
            .ToListAsync(cancellationToken);

        return dto;
    }
}
