using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System.IO.Compression;
using System.Text;

namespace Hasad.Application.Features.DamageReports.Queries.GetDamageReportZip;

public record GetDamageReportZipQuery(Guid ReportId) : IRequest<Result<(byte[] Content, string FileName)>>;

public class GetDamageReportZipQueryHandler : IRequestHandler<GetDamageReportZipQuery, Result<(byte[] Content, string FileName)>>
{
    private readonly IApplicationDbContext _context;
    private readonly IFileStorageService _storageService;
    private readonly IMediator _mediator;

    public GetDamageReportZipQueryHandler(IApplicationDbContext context, IFileStorageService storageService, IMediator mediator)
    {
        _context = context;
        _storageService = storageService;
        _mediator = mediator;
    }

    public async Task<Result<(byte[] Content, string FileName)>> Handle(GetDamageReportZipQuery request, CancellationToken cancellationToken)
    {
        var report = await _context.DamageReports
            .Include(r => r.Attachments)
            .FirstOrDefaultAsync(r => r.Id == request.ReportId, cancellationToken);

        if (report == null) return Result<(byte[] Content, string FileName)>.Failure(new[] { "Report not found." });

        using var memoryStream = new MemoryStream();
        using (var archive = new ZipArchive(memoryStream, ZipArchiveMode.Create, true))
        {
            // 1. Add Audit Log
            var logResult = await _mediator.Send(new Hasad.Application.Features.DamageReports.Queries.GetIntegratedAuditLog.GetIntegratedAuditLogQuery(request.ReportId), cancellationToken);
            if (logResult.Succeeded)
            {
                var logEntry = archive.CreateEntry("audit_log.txt");
                using var entryStream = logEntry.Open();
                using var writer = new StreamWriter(entryStream, Encoding.UTF8);
                writer.WriteLine($"Audit Log for Damage Report: {report.ReportNumber}");
                writer.WriteLine("------------------------------------------");
                foreach (var log in logResult.Data!)
                {
                    writer.WriteLine($"[{log.EventDate:yyyy-MM-dd HH:mm}] {log.EventType}: {log.Description} (By: {log.PerformedBy})");
                    if (!string.IsNullOrEmpty(log.Metadata)) writer.WriteLine($"   Note: {log.Metadata}");
                }
            }

            // 2. Add Attachments
            foreach (var att in report.Attachments)
            {
                try
                {
                    var fileStream = await _storageService.GetFileStreamAsync(att.RemotePath, cancellationToken);
                    if (fileStream != null)
                    {
                        var fileEntry = archive.CreateEntry($"attachments/{att.OriginalFileName}");
                        using var entryStream = fileEntry.Open();
                        await fileStream.CopyToAsync(entryStream, cancellationToken);
                    }
                }
                catch
                {
                    // Skip if file missing
                }
            }
        }

        var fileName = $"DamageReport_{report.ReportNumber}_{DateTime.Now:yyyyMMdd}.zip";
        return Result<(byte[] Content, string FileName)>.Success((memoryStream.ToArray(), fileName));
    }
}
