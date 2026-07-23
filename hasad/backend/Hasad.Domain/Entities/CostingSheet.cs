// This file is obsolete and has been replaced by CostingSheetItem.cs
// It will be removed in a future cleanup.
namespace Hasad.Domain.Entities;

[System.Obsolete("Use CostingSheetItem instead")]
public class CostingSheet
{
    public Guid Id { get; set; }
    public int ClassificationId { get; set; }
    public decimal UnitPrice { get; set; }
    public DateTime EffectiveFrom { get; set; }
    public DateTime? EffectiveTo { get; set; }
    public bool IsActive { get; set; }
    public int VersionNumber { get; set; }
    public DateTime CreatedAt { get; set; }
}
