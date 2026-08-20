using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Hasad.Domain.Identity;

namespace Hasad.Domain.Entities;

/// <summary>
/// Stores user-specific customizations for a report (saved filters, selected columns).
/// </summary>
public class UserReportPreset
{
    [Key]
    public long PresetId { get; set; }

    [Required]
    public string UserId { get; set; } = string.Empty;

    [Required]
    [MaxLength(100)]
    public string ReportId { get; set; } = string.Empty;

    [Required]
    [MaxLength(200)]
    public string PresetName { get; set; } = string.Empty;

    [Required]
    public string SavedFiltersJson { get; set; } = "[]";

    [Required]
    public string SelectedColumnsJson { get; set; } = "[]";

    [MaxLength(100)]
    public string? SortByField { get; set; }

    [MaxLength(10)]
    public string SortDirection { get; set; } = "ASC";

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation properties
    [ForeignKey(nameof(UserId))]
    public virtual ApplicationUser User { get; set; } = null!;

    [ForeignKey(nameof(ReportId))]
    public virtual ReportDefinition ReportDefinition { get; set; } = null!;
}
