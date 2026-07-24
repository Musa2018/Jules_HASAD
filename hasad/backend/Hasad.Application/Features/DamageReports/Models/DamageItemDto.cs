namespace Hasad.Application.Features.DamageReports.Models;

public class DamageItemDto
{
    public Guid Id { get; set; }
    public Guid ClientId { get; set; }
    public int DamageNatureId { get; set; }
    public int DamageActionId { get; set; }
    public int ClassificationId { get; set; }
    public Guid CostingSheetId { get; set; }
    public decimal CalculatedUnitPrice { get; set; }
    public string MeasurementUnitSnapshot { get; set; } = string.Empty;
    public decimal AffectedArea { get; set; }
    public decimal DamagePercentage { get; set; }
    public decimal Quantity { get; set; }
    public decimal EstimatedLoss { get; set; }
    public string RowVersion { get; set; } = string.Empty;
}
