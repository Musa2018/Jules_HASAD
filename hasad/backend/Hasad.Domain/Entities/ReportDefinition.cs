using System.ComponentModel.DataAnnotations;

namespace Hasad.Domain.Entities;

/// <summary>
/// Defines the structure and metadata for a dynamic report template.
/// </summary>
public class ReportDefinition
{
    [Key]
    [MaxLength(100)]
    public string ReportId { get; set; } = string.Empty;

    [Required]
    [MaxLength(200)]
    public string Title { get; set; } = string.Empty;

    public string? Description { get; set; }

    [Required]
    [MaxLength(100)]
    public string Category { get; set; } = "General";

    [Required]
    [MaxLength(150)]
    public string DataSourceName { get; set; } = string.Empty;

    /// <summary>
    /// JSON structure containing default columns, filters, and chart types.
    /// </summary>
    [Required]
    public string ConfigurationJson { get; set; } = "{}";

    [MaxLength(100)]
    public string? RequiredPermission { get; set; }

    public bool IsActive { get; set; } = true;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation properties
    public virtual ICollection<UserReportPreset> Presets { get; set; } = new List<UserReportPreset>();
}
