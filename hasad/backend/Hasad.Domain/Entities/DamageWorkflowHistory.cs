using System.ComponentModel.DataAnnotations;
using Hasad.Domain.Common;

namespace Hasad.Domain.Entities;

public class DamageWorkflowHistory : ISoftDelete
{
    public Guid Id { get; set; }

    public Guid DamageReportId { get; set; }
    public DamageReport? DamageReport { get; set; }

    [MaxLength(50)]
    public string FromStatus { get; set; } = string.Empty;
    public WorkflowStatus? FromWorkflowStatus { get; set; }

    [MaxLength(50)]
    public string ToStatus { get; set; } = string.Empty;
    public WorkflowStatus? ToWorkflowStatus { get; set; }

    public string ChangedByUserId { get; set; } = string.Empty;
    public DateTime ChangedAt { get; set; }

    public string? Comment { get; set; }
    public bool IsOverride { get; set; }

    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
    public string? DeletedBy { get; set; }
}
