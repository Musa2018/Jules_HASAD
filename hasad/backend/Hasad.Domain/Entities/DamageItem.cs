using Hasad.Domain.Common;

namespace Hasad.Domain.Entities;

public class DamageItem : ISoftDelete
{
    public Guid Id { get; set; }
    public Guid ClientId { get; set; }

    public Guid DamageReportId { get; set; }
    public DamageReport? DamageReport { get; set; }

    public int ClassificationId { get; set; }
    public DamageClassification? Classification { get; set; }

    public Guid CostingSheetItemId { get; set; }
    public CostingSheetItem? CostingSheetItem { get; set; }

    public decimal CalculatedUnitPrice { get; set; }
    public string MeasurementUnitSnapshot { get; set; } = string.Empty;

    public decimal AffectedArea { get; set; }
    public decimal DamagePercentage { get; set; }

    public decimal Quantity { get; set; }
    public decimal EstimatedLoss { get; set; }

    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    public byte[] RowVersion { get; set; } = Array.Empty<byte>();

    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
    public string? DeletedBy { get; set; }
}
