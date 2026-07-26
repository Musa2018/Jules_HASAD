namespace Hasad.Domain.Entities;

public class CostingSheetCatalog
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }

    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; } = string.Empty;

    public ICollection<CostingSheetVersion> Versions { get; set; } = new List<CostingSheetVersion>();
}
