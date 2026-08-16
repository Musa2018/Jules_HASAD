using Hasad.Domain.Common;

namespace Hasad.Domain.Entities;

public class Assistance : ISoftDelete
{
    public Guid Id { get; set; }
    public Guid ClientId { get; set; }

    public Guid DamageReportId { get; set; }
    public DamageReport? DamageReport { get; set; }

    public Guid? RuleId { get; set; }
    public AssistanceRule? Rule { get; set; }

    public decimal CalculatedAmount { get; set; }
    public decimal ApprovedAmount { get; set; }

    public string Status { get; set; } = "Draft"; // Draft, Calculated, Submitted, Approved, Rejected, Paid

    public string Remarks { get; set; } = string.Empty;

    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
    public string? DeletedBy { get; set; }

    public byte[] RowVersion { get; set; } = Array.Empty<byte>();

    public ICollection<AssistanceAuditLog> AuditLogs { get; set; } = new List<AssistanceAuditLog>();
}
