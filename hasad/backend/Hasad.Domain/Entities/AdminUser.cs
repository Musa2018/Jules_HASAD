using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Hasad.Domain.Identity;

namespace Hasad.Domain.Entities;

/// <summary>
/// Represents a user with administrative privileges and security settings.
/// </summary>
public class AdminUser
{
    [Key]
    public string AdminId { get; set; } = string.Empty;

    [Required]
    public string UserId { get; set; } = string.Empty;

    [Required]
    [MaxLength(50)]
    public string Role { get; set; } = "SuperAdmin"; // SuperAdmin, SystemAuditor

    [MaxLength(128)]
    public string? TwoFactorSecret { get; set; }

    public bool Is2FAEnabled { get; set; }

    public DateTime? LastLoginAt { get; set; }

    [MaxLength(50)]
    public string? LastLoginIp { get; set; }

    public bool IsActive { get; set; } = true;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    [ForeignKey(nameof(UserId))]
    public virtual ApplicationUser User { get; set; } = null!;
}
