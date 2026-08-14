namespace Hasad.Application.Features.DamageReports.Models;

public class DamageReportDto
{
    public Guid Id { get; set; }
    public Guid ClientId { get; set; }
    public string ReportNumber { get; set; } = string.Empty;
    public string PermanentFormNumber { get; set; } = string.Empty;
    public string TemporaryFormNumber { get; set; } = string.Empty;
    public int DamageYear { get; set; }
    public Guid FarmId { get; set; }
    public Guid FarmerId { get; set; }
    public DateTime DamageDate { get; set; }
    public DateTime DocumentationDate { get; set; }
    public int AgriculturalSectorId { get; set; }
    public int DamageCauseCategoryId { get; set; }
    public int DamageCauseId { get; set; }
    public Guid GovernorateId { get; set; }
    public Guid DirectorateId { get; set; }
    public Guid LocalityId { get; set; }
    public string StatusId { get; set; } = string.Empty;
    public decimal TotalDamage { get; set; }
    public string Notes { get; set; } = string.Empty;
    public string RowVersion { get; set; } = string.Empty;
    public List<DamageItemDto> Items { get; set; } = new();
}
