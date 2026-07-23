using Hasad.Application.Common.Models;

namespace Hasad.Application.Features.ReferenceData.Queries.GetReferenceData;

public class ReferenceDataDto
{
    public List<LookupDto> OwnershipTypes { get; set; } = new();
    public List<LookupDto> AgriculturalSectors { get; set; } = new();
    public List<LookupDto> PoliticalClassifications { get; set; } = new();
    public List<LookupDto> AreaUnits { get; set; } = new();
    public List<LookupDto> RelationshipToOwners { get; set; } = new();

    // Damage Classification Hierarchy
    public List<LookupDto> DamageNatures { get; set; } = new();
    public List<LookupDto> DamageCategories { get; set; } = new();
    public List<LookupDto> DamageSubCategories { get; set; } = new();
    public List<LookupDto> DamageClassifications { get; set; } = new();

    // Damage Causes
    public List<LookupDto> DamageCauseCategories { get; set; } = new();
    public List<LookupDto> DamageCauses { get; set; } = new();

    public List<CostingSheetDto> CostingSheets { get; set; } = new();
}

public class CostingSheetDto
{
    public Guid Id { get; set; }
    public int ClassificationId { get; set; }
    public decimal UnitPrice { get; set; }
    public DateTime EffectiveFrom { get; set; }
    public DateTime? EffectiveTo { get; set; }
    public bool IsActive { get; set; }
    public int VersionNumber { get; set; }
}
