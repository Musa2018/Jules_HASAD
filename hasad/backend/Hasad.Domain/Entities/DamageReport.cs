using Hasad.Domain.Common;

namespace Hasad.Domain.Entities;

public class DamageReport : ISoftDelete
{
    public Guid Id { get; set; }
    public Guid ClientId { get; set; }

    public string FormNumber { get; set; } = string.Empty;
    public string TemporaryFormNumber { get; set; } = string.Empty;
    public int DamageYear { get; set; }

    public Guid FarmId { get; set; }
    public Farm? Farm { get; set; }

    public Guid FarmerId { get; set; }
    public Farmer? Farmer { get; set; }

    public DateTime DamageDate { get; set; }
    public DateTime DocumentationDate { get; set; }

    public int DamageTypeId { get; set; }
    public DamageCauseCategory? DamageType { get; set; }

    public int DamageCauseId { get; set; }
    public DamageCause? DamageCause { get; set; }

    public string? SettlementName { get; set; }
    public string? CompanyName { get; set; }

    public string GovernorateId { get; set; } = string.Empty;
    public string LocalityId { get; set; } = string.Empty;

    public double? Latitude { get; set; }
    public double? Longitude { get; set; }

    public string StatusId { get; set; } = "Draft"; // e.g., Draft, Submitted, Verified, Rejected

    public string Notes { get; set; } = string.Empty;

    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    public byte[] RowVersion { get; set; } = Array.Empty<byte>();

    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
    public string? DeletedBy { get; set; }

    public ICollection<DamageItem> Items { get; set; } = new List<DamageItem>();
    public ICollection<DamageReportAttachment> Attachments { get; set; } = new List<DamageReportAttachment>();
}
