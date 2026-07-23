namespace Hasad.Application.Features.DamageReports.Models;

public class DamageReportDto
{
    public Guid Id { get; set; }
    public Guid ClientId { get; set; }
    public string PermanentFormNumber { get; set; } = string.Empty;
    public string TemporaryFormNumber { get; set; } = string.Empty;
    public int DamageYear { get; set; }
    public Guid FarmId { get; set; }
    public Guid FarmerId { get; set; }
    public DateTime DamageDate { get; set; }
    public DateTime DocumentationDate { get; set; }
    public int DamageCauseCategoryId { get; set; }
    public int DamageCauseId { get; set; }
    public string? SettlementName { get; set; }
    public string? CompanyName { get; set; }
    public Guid GovernorateId { get; set; }
    public Guid DirectorateId { get; set; }
    public Guid LocalityId { get; set; }
    public double? Latitude { get; set; }
    public double? Longitude { get; set; }
    public string StatusId { get; set; } = string.Empty;
    public string Notes { get; set; } = string.Empty;
    public string RowVersion { get; set; } = string.Empty;
    public List<DamageItemDto> Items { get; set; } = new();
}
