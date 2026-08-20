using System.ComponentModel.DataAnnotations;

namespace Hasad.Domain.Entities;

public class Notification
{
    [Key]
    public Guid Id { get; set; }

    [Required]
    [MaxLength(200)]
    public string Title { get; set; } = string.Empty;

    [Required]
    public string Body { get; set; } = string.Empty;

    [MaxLength(50)]
    public string Category { get; set; } = "General";

    public string? PayloadJson { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public virtual ICollection<NotificationRecipient> Recipients { get; set; } = new List<NotificationRecipient>();
}
