namespace Hasad.Application.Features.DamageReports.Models;

public class AttachmentDto
{
    public Guid Id { get; set; }
    public Guid ClientId { get; set; }
    public string FileName { get; set; } = string.Empty;
    public string DocumentName { get; set; } = string.Empty;
    public DateTime DocumentDate { get; set; }
    public int DocumentTypeId { get; set; }
    public string RemoteUrl { get; set; } = string.Empty;
    public string FileType { get; set; } = string.Empty;
    public long FileSize { get; set; }
    public string UploadStatus { get; set; } = string.Empty;
    public string RowVersion { get; set; } = string.Empty;
}
