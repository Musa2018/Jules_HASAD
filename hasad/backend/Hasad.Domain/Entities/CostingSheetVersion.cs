using Hasad.Domain.Enums;

namespace Hasad.Domain.Entities;

public class CostingSheetVersion
{
    public Guid Id { get; set; }
    public Guid CatalogId { get; set; }
    public CostingSheetCatalog? Catalog { get; set; }

    public int VersionNumber { get; set; }
    public CostingSheetStatus Status { get; set; } = CostingSheetStatus.Draft;

    public DateTime EffectiveFrom { get; set; }
    public DateTime? EffectiveTo { get; set; }

    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; } = string.Empty;

    public DateTime? ApprovedAt { get; set; }
    public string? ApprovedBy { get; set; }

    public ICollection<CostingSheetItem> Items { get; set; } = new List<CostingSheetItem>();
}
