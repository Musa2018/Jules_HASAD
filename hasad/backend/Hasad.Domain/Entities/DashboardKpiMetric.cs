using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Hasad.Domain.Entities;

/// <summary>
/// Stores calculated KPI data for real-time dashboard visualization.
/// </summary>
public class DashboardKpiMetric
{
    [Key]
    [MaxLength(100)]
    public string MetricKey { get; set; } = string.Empty;

    [Required]
    [MaxLength(200)]
    public string Title { get; set; } = string.Empty;

    [Column(TypeName = "decimal(18,2)")]
    public decimal CurrentValue { get; set; }

    [Column(TypeName = "decimal(18,2)")]
    public decimal? PreviousValue { get; set; }

    [MaxLength(20)]
    public string? Unit { get; set; }

    [Required]
    [MaxLength(50)]
    public string Category { get; set; } = "General";

    public DateTime LastCalculatedAt { get; set; } = DateTime.UtcNow;
}
