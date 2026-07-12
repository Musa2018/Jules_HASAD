namespace Hasad.Domain.Entities;

public class DamageReportAttachment
{
    public Guid Id { get; set; }
    public Guid DamageReportId { get; set; }
    public DamageReport? DamageReport { get; set; }

    public string LocalPath { get; set; } = string.Empty;
    public string RemoteUrl { get; set; } = string.Empty;
    public string FileType { get; set; } = string.Empty;

    public string SyncStatus { get; set; } = "Pending";
}
