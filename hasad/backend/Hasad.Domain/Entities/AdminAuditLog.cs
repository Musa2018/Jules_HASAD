using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Hasad.Domain.Entities;

/// <summary>
/// Stores logs of administrative actions for compliance and tracking.
/// </summary>
public class AdminAuditLog
{
    [Key]
    public long AuditId { get; set; }

    [Required]
    public string AdminUserId { get; set; } = string.Empty;

    [Required]
    [MaxLength(100)]
    public string Action { get; set; } = string.Empty; // CREATE, UPDATE, DELETE, BULK_NOTIFICATION, EXPORT

    [Required]
    [MaxLength(100)]
    public string EntityName { get; set; } = string.Empty;

    [MaxLength(100)]
    public string? EntityId { get; set; }

    public string? OldValuesJson { get; set; }

    public string? NewValuesJson { get; set; }

    [MaxLength(50)]
    public string? IpAddress { get; set; }

    [MaxLength(256)]
    public string? UserAgent { get; set; }

    public DateTime Timestamp { get; set; } = DateTime.UtcNow;

    [ForeignKey(nameof(AdminUserId))]
    public virtual AdminUser AdminUser { get; set; } = null!;
}
