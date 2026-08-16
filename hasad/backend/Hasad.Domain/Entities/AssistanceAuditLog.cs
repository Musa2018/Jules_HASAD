using Hasad.Domain.Common;

namespace Hasad.Domain.Entities;

public class AssistanceAuditLog : ISoftDelete
{
    public Guid Id { get; set; }
    public Guid AssistanceId { get; set; }
    public Assistance? Assistance { get; set; }
    public string PreviousStatus { get; set; } = string.Empty;
    public string NewStatus { get; set; } = string.Empty;
    public string ChangedBy { get; set; } = string.Empty; // UserId or Username
    public DateTime ChangedAt { get; set; }
    public string Reason { get; set; } = string.Empty;

    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
    public string? DeletedBy { get; set; }
}
