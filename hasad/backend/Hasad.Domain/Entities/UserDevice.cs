using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Hasad.Domain.Identity;

namespace Hasad.Domain.Entities;

public class UserDevice
{
    [Key]
    public Guid Id { get; set; }

    [Required]
    public string UserId { get; set; } = string.Empty;

    [Required]
    [MaxLength(500)]
    public string DeviceToken { get; set; } = string.Empty;

    [Required]
    [MaxLength(20)]
    public string Platform { get; set; } = "Android"; // Android, iOS, Web

    [MaxLength(100)]
    public string? SignalRConnectionId { get; set; }

    public bool IsOnline { get; set; }

    public DateTime LastActiveAt { get; set; } = DateTime.UtcNow;

    [ForeignKey(nameof(UserId))]
    public virtual ApplicationUser User { get; set; } = null!;
}
