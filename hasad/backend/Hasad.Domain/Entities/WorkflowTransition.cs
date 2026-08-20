using System;

namespace Hasad.Domain.Entities;

public class WorkflowTransition
{
    public Guid Id { get; set; }
    public string FromStatusId { get; set; } = string.Empty;
    public WorkflowStatus? FromStatus { get; set; }

    public string ToStatusId { get; set; } = string.Empty;
    public WorkflowStatus? ToStatus { get; set; }

    public string AllowedRole { get; set; } = string.Empty;

    /// <summary>
    /// If true, this is a backward move (Return).
    /// </summary>
    public bool IsReturn { get; set; }
}
