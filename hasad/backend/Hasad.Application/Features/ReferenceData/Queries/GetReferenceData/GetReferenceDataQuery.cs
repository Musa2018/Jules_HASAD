using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Domain.Enums;
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

        dto.AreaUnits = await _context.MeasurementUnits
            .AsNoTracking()
            .Where(x => x.Category == "Area")
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

        dto.DamageNatures = await _context.DamageNatures
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                NameAr = x.NameAr,
                NameEn = x.NameEn
            })
            .ToListAsync(cancellationToken);

        dto.DamageCategories = await _context.DamageCategories
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                ParentId = x.NatureId,
                NameAr = x.NameAr,
                NameEn = x.NameEn
            })
            .ToListAsync(cancellationToken);

        dto.DamageSubCategories = await _context.DamageSubCategories
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                ParentId = x.CategoryId,
                NameAr = x.NameAr,
                NameEn = x.NameEn
            })
            .ToListAsync(cancellationToken);

        dto.DamageClassifications = await _context.DamageClassifications
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                ParentId = x.SubCategoryId,
                NameAr = x.NameAr,
                NameEn = x.NameEn
            })
            .ToListAsync(cancellationToken);

        dto.DamageCauseCategories = await _context.DamageCauseCategories
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                NameAr = x.NameAr,
                NameEn = x.NameEn
            })
            .ToListAsync(cancellationToken);

        dto.DamageCauses = await _context.DamageCauses
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                ParentId = x.CategoryId,
                NameAr = x.NameAr,
                NameEn = x.NameEn
            })
            .ToListAsync(cancellationToken);

        dto.CostingSheets = await _context.CostingSheetItems
            .AsNoTracking()
            .Include(x => x.Version)
            .Where(x => x.Version!.Status == CostingSheetStatus.Active)
            .Select(x => new CostingSheetDto
            {
                Id = x.Id,
                ClassificationId = x.ClassificationId,
                UnitPrice = x.UnitPrice,
                EffectiveFrom = x.Version!.EffectiveFrom,
                EffectiveTo = x.Version.EffectiveTo,
                IsActive = true,
                VersionNumber = x.Version.VersionNumber
            })
            .ToListAsync(cancellationToken);

        return dto;
    }
}
