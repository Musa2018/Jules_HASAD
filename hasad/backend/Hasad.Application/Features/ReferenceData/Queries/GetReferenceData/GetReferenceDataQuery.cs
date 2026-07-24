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
                NameAr = x.NameAr ?? string.Empty,
                NameEn = x.NameEn ?? string.Empty
            })
            .ToListAsync(cancellationToken);

        dto.AgriculturalSectors = await _context.AgriculturalSectors
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                NameAr = x.NameAr ?? string.Empty,
                NameEn = x.NameEn ?? string.Empty
            })
            .ToListAsync(cancellationToken);

        dto.PoliticalClassifications = await _context.PoliticalClassifications
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                NameAr = x.NameAr ?? string.Empty,
                NameEn = x.NameEn ?? string.Empty
            })
            .ToListAsync(cancellationToken);

        dto.AreaUnits = await _context.MeasurementUnits
            .AsNoTracking()
            .Where(x => x.Category == "Area")
            .Select(x => new LookupDto
            {
                Id = x.Id,
                NameAr = x.NameAr ?? string.Empty,
                NameEn = x.NameEn ?? string.Empty,
                Category = "Area"
            })
            .ToListAsync(cancellationToken);

        dto.MeasurementUnits = await _context.MeasurementUnits
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                NameAr = x.NameAr ?? string.Empty,
                NameEn = x.NameEn ?? string.Empty,
                Code = x.Code,
                Category = x.Category ?? string.Empty
            })
            .ToListAsync(cancellationToken);

        dto.RelationshipToOwners = await _context.RelationshipToOwners
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                NameAr = x.NameAr ?? string.Empty,
                NameEn = x.NameEn ?? string.Empty
            })
            .ToListAsync(cancellationToken);

        dto.DamageNatures = await _context.DamageNatures
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                NameAr = x.NameAr ?? string.Empty,
                NameEn = x.NameEn ?? string.Empty
            })
            .ToListAsync(cancellationToken);

        dto.DamageCategories = await _context.DamageCategories
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                ParentId = x.NatureId,
                NameAr = x.NameAr ?? string.Empty,
                NameEn = x.NameEn ?? string.Empty
            })
            .ToListAsync(cancellationToken);

        dto.DamageSubCategories = await _context.DamageSubCategories
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                ParentId = x.CategoryId,
                NameAr = x.NameAr ?? string.Empty,
                NameEn = x.NameEn ?? string.Empty
            })
            .ToListAsync(cancellationToken);

        dto.DamageClassifications = await _context.DamageClassifications
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                ParentId = x.SubCategoryId,
                NameAr = x.NameAr ?? string.Empty,
                NameEn = x.NameEn ?? string.Empty
            })
            .ToListAsync(cancellationToken);

        dto.DamageCauseCategories = await _context.DamageCauseCategories
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                NameAr = x.NameAr ?? string.Empty,
                NameEn = x.NameEn ?? string.Empty
            })
            .ToListAsync(cancellationToken);

        dto.DamageCauses = await _context.DamageCauses
            .AsNoTracking()
            .Select(x => new LookupDto
            {
                Id = x.Id,
                ParentId = x.CategoryId,
                NameAr = x.NameAr ?? string.Empty,
                NameEn = x.NameEn ?? string.Empty
            })
            .ToListAsync(cancellationToken);

        // Hierarchical Costing Data
        dto.CostingSheetCatalogs = await _context.CostingSheetCatalogs
            .AsNoTracking()
            .Select(x => new CostingSheetCatalogDto
            {
                Id = x.Id,
                Name = x.Name ?? string.Empty,
                Description = x.Description,
                CreatedAt = x.CreatedAt,
                CreatedBy = x.CreatedBy ?? string.Empty
            })
            .ToListAsync(cancellationToken);

        dto.CostingSheetVersions = await _context.CostingSheetVersions
            .AsNoTracking()
            .Select(x => new CostingSheetVersionDto
            {
                Id = x.Id,
                CatalogId = x.CatalogId,
                VersionNumber = x.VersionNumber,
                Status = (int)x.Status,
                EffectiveFrom = x.EffectiveFrom,
                EffectiveTo = x.EffectiveTo,
                CreatedAt = x.CreatedAt,
                CreatedBy = x.CreatedBy ?? string.Empty,
                ApprovedAt = x.ApprovedAt,
                ApprovedBy = x.ApprovedBy
            })
            .ToListAsync(cancellationToken);

        dto.CostingSheetItems = await _context.CostingSheetItems
            .AsNoTracking()
            .Select(x => new CostingSheetItemDto
            {
                Id = x.Id,
                VersionId = x.VersionId,
                ClassificationId = x.ClassificationId,
                MeasurementUnitId = x.MeasurementUnitId,
                UnitPrice = x.UnitPrice,
                CreatedAt = x.CreatedAt
            })
            .ToListAsync(cancellationToken);

        dto.CostingSheets = await _context.CostingSheetItems
            .AsNoTracking()
            .Include(x => x.Version)
            .Where(x => x.Version!.Status == CostingSheetStatus.Active)
            .Select(x => new CostingSheetDto
            {
                Id = x.Id,
                VersionId = x.VersionId,
                ClassificationId = x.ClassificationId,
                UnitPrice = x.UnitPrice,
                EffectiveFrom = x.Version!.EffectiveFrom,
                EffectiveTo = x.Version.EffectiveTo,
                IsActive = true,
                VersionNumber = x.Version.VersionNumber,
                CreatedAt = x.CreatedAt
            })
            .ToListAsync(cancellationToken);

        return dto;
    }
}
