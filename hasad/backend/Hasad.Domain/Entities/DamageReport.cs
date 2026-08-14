using Hasad.Domain.Common;

namespace Hasad.Domain.Entities;

public class DamageReport : ISoftDelete
{
    public Guid Id { get; set; }
    public Guid ClientId { get; set; }

    public string ReportNumber { get; set; } = string.Empty;
    public string PermanentFormNumber { get; set; } = string.Empty;
    public string TemporaryFormNumber { get; set; } = string.Empty;

    public Guid FarmId { get; set; }
    public Farm? Farm { get; set; }

    public Guid FarmerId { get; set; }
    public Guid GovernorateId { get; set; }
    public Guid DirectorateId { get; set; }
    public Guid LocalityId { get; set; }
    public int DamageYear { get; set; }

    public DateTime DamageDate { get; set; }
    public DateTime DocumentationDate { get; set; }

    public int AgriculturalSectorId { get; set; }
    public AgriculturalSector? AgriculturalSector { get; set; }

    public int DamageCauseCategoryId { get; set; }
    public DamageCauseCategory? DamageCauseCategory { get; set; }

    public int DamageCauseId { get; set; }
    public DamageCause? DamageCause { get; set; }

    public string StatusId { get; set; } = "PendingTechnicalVerification";

    public decimal TotalDamage { get; set; }

    public string Notes { get; set; } = string.Empty;

    public string CreatedBy { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    public byte[] RowVersion { get; set; } = Array.Empty<byte>();

    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
    public string? DeletedBy { get; set; }

    public ICollection<DamageItem> Items { get; set; } = new List<DamageItem>();
    public ICollection<DamageReportAttachment> Attachments { get; set; } = new List<DamageReportAttachment>();
}
