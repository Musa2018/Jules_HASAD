namespace Hasad.Domain.Entities;

public class CostingSheet
{
    public Guid Id { get; set; }
    public int ClassificationId { get; set; }
    public DamageClassification? Classification { get; set; }

    public decimal UnitPrice { get; set; }
    public DateTime EffectiveFrom { get; set; }
    public DateTime? EffectiveTo { get; set; }
    public bool IsActive { get; set; } = true;
    public int VersionNumber { get; set; }

    public DateTime CreatedAt { get; set; }
}
