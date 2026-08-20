using System;

namespace Hasad.Application.Features.DamageReports.Models;

public class AuditLogDto
{
    public string EventType { get; set; } = string.Empty; // Farmer, Farm, Report, Transition
    public string Description { get; set; } = string.Empty;
    public string PerformedBy { get; set; } = string.Empty;
    public DateTime EventDate { get; set; }
    public string? Metadata { get; set; }
}
