using Hasad.Application.Common.Models;

namespace Hasad.Application.Features.ReferenceData.Queries.GetReferenceData;

public class ReferenceDataDto
{
    public List<LookupDto> OwnershipTypes { get; set; } = new();
    public List<LookupDto> AgriculturalSectors { get; set; } = new();
    public List<LookupDto> PoliticalClassifications { get; set; } = new();
    public List<LookupDto> AreaUnits { get; set; } = new();
    public List<LookupDto> MeasurementUnits { get; set; } = new();
    public List<LookupDto> RelationshipToOwners { get; set; } = new();

    // Damage Classification Hierarchy
    public List<LookupDto> DamageNatures { get; set; } = new();
    public List<LookupDto> DamageActions { get; set; } = new();
    public List<LookupDto> DamageCategories { get; set; } = new();
    public List<LookupDto> DamageSubCategories { get; set; } = new();
    public List<LookupDto> DamageClassifications { get; set; } = new();

    // Damage Causes
    public List<LookupDto> DamageCauseCategories { get; set; } = new();
    public List<LookupDto> DamageCauses { get; set; } = new();

    public List<CostingSheetCatalogDto> CostingSheetCatalogs { get; set; } = new();
    public List<CostingSheetVersionDto> CostingSheetVersions { get; set; } = new();
    public List<CostingSheetItemDto> CostingSheetItems { get; set; } = new();

    // Kept for backward compatibility
    public List<CostingSheetDto> CostingSheets { get; set; } = new();
}

public class CostingSheetCatalogDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; } = string.Empty;
}

public class CostingSheetVersionDto
{
    public Guid Id { get; set; }
    public Guid CatalogId { get; set; }
    public int VersionNumber { get; set; }
    public int Status { get; set; }
    public DateTime EffectiveFrom { get; set; }
    public DateTime? EffectiveTo { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; } = string.Empty;
    public DateTime? ApprovedAt { get; set; }
    public string? ApprovedBy { get; set; }
}

public class CostingSheetItemDto
{
    public Guid Id { get; set; }
    public Guid VersionId { get; set; }
    public int ClassificationId { get; set; }
    public int? MeasurementUnitId { get; set; }
    public decimal UnitPrice { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class CostingSheetDto
{
    public Guid Id { get; set; }
    public Guid VersionId { get; set; }
    public int ClassificationId { get; set; }
    public decimal UnitPrice { get; set; }
    public DateTime EffectiveFrom { get; set; }
    public DateTime? EffectiveTo { get; set; }
    public bool IsActive { get; set; }
    public int VersionNumber { get; set; }
    public DateTime CreatedAt { get; set; }
}
