using System.ComponentModel.DataAnnotations;

namespace Hasad.Domain.Entities;

/// <summary>
/// Audit log for monitoring report execution performance and usage patterns.
/// </summary>
public class ReportExecutionLog
{
    [Key]
    public long LogId { get; set; }

    [Required]
    [MaxLength(100)]
    public string ReportId { get; set; } = string.Empty;

    [Required]
    public string UserId { get; set; } = string.Empty;

    public DateTime ExecutedAt { get; set; } = DateTime.UtcNow;

    public int ExecutionDurationMs { get; set; }

    public int RowsReturned { get; set; }

    [Required]
    [MaxLength(20)]
    public string ExportFormat { get; set; } = "JSON"; // JSON, EXCEL, PDF, CSV
}
