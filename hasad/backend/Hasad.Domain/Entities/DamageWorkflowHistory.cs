using System.ComponentModel.DataAnnotations;

namespace Hasad.Domain.Entities;

public class DamageWorkflowHistory
{
    public Guid Id { get; set; }

    public Guid DamageReportId { get; set; }
    public DamageReport? DamageReport { get; set; }

    [MaxLength(50)]
    public string FromStatus { get; set; } = string.Empty;

    [MaxLength(50)]
    public string ToStatus { get; set; } = string.Empty;

    public string ChangedByUserId { get; set; } = string.Empty;
    public DateTime ChangedAt { get; set; }

    public string? Comment { get; set; }
    public bool IsOverride { get; set; }
}
