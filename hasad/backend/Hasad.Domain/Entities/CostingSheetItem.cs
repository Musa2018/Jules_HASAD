namespace Hasad.Domain.Entities;

public class CostingSheetItem
{
    public Guid Id { get; set; }

    public Guid VersionId { get; set; }
    public CostingSheetVersion? Version { get; set; }

    public int ClassificationId { get; set; }
    public DamageClassification? Classification { get; set; }

    public int? MeasurementUnitId { get; set; }
    public MeasurementUnit? MeasurementUnit { get; set; }

    public decimal UnitPrice { get; set; }

    public DateTime CreatedAt { get; set; }
}
