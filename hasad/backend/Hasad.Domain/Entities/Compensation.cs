namespace Hasad.Domain.Entities;

public class Compensation
{
    public Guid Id { get; set; }
    public Guid ClientId { get; set; }

    public Guid DamageReportId { get; set; }
    public DamageReport? DamageReport { get; set; }

    public decimal CalculatedAmount { get; set; }
    public decimal ApprovedAmount { get; set; }

    public string Status { get; set; } = "Draft"; // Draft, Calculated, Approved, Paid

    public string Remarks { get; set; } = string.Empty;

    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    public byte[] RowVersion { get; set; } = Array.Empty<byte>();
}
