using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Hasad.Domain.Identity;

namespace Hasad.Domain.Entities;

public class NotificationRecipient
{
    [Key]
    public long Id { get; set; }

    [Required]
    public Guid NotificationId { get; set; }

    [Required]
    public string UserId { get; set; } = string.Empty;

    public bool IsDelivered { get; set; }
    public DateTime? DeliveredAt { get; set; }

    public bool IsRead { get; set; }
    public DateTime? ReadAt { get; set; }

    [ForeignKey(nameof(NotificationId))]
    public virtual Notification Notification { get; set; } = null!;

    [ForeignKey(nameof(UserId))]
    public virtual ApplicationUser User { get; set; } = null!;
}
