using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.DamageReports.Commands.TransitionDamageReport;

public record TransitionDamageReportCommand(
    Guid Id,
    string ToStatus,
    string? Comment = null,
    bool IsOverride = false) : IRequest<Result<Guid>>;

public class TransitionDamageReportCommandHandler : IRequestHandler<TransitionDamageReportCommand, Result<Guid>>
{
    private readonly IApplicationDbContext _context;
    private readonly IDamageWorkflowService _workflowService;
    private readonly ICurrentUserService _currentUser;
    private readonly IPDFService _pdfService;
    private readonly IFileStorageService _storageService;
    private readonly INotificationService _notificationService;

    public TransitionDamageReportCommandHandler(
        IApplicationDbContext context,
        IDamageWorkflowService workflowService,
        ICurrentUserService currentUser,
        IPDFService pdfService,
        IFileStorageService storageService,
        INotificationService notificationService)
    {
        _context = context;
        _workflowService = workflowService;
        _currentUser = currentUser;
        _pdfService = pdfService;
        _storageService = storageService;
        _notificationService = notificationService;
    }

    public async Task<Result<Guid>> Handle(TransitionDamageReportCommand request, CancellationToken cancellationToken)
    {
        var report = await _context.DamageReports
            .Include(r => r.Farm)
            .Include(r => r.Items)
            .FirstOrDefaultAsync(r => r.Id == request.Id, cancellationToken);

        if (report == null)
        {
            return Result<Guid>.Failure(new[] { "Damage report not found." });
        }

        if (report.StatusId == request.ToStatus)
        {
            // Idempotency: Already in target status
            return Result<Guid>.Success(report.Id);
        }

        string fromStatus = report.StatusId;

        // 1. Check for Override
        if (request.IsOverride)
        {
            if (!_currentUser.IsInRole(AppRoles.GeneralManager) && !_currentUser.IsInRole(AppRoles.SuperAdmin))
            {
                return Result<Guid>.Failure(new[] { "Access denied. Only General Manager can perform workflow overrides." });
            }

            if (string.IsNullOrWhiteSpace(request.Comment))
            {
                return Result<Guid>.Failure(new[] { "Comment is mandatory for workflow overrides." });
            }

            await _workflowService.TransitionAsync(report, request.ToStatus, request.Comment, true);
        }
        else
        {
            // 2. Standard Transition (using centralized CanTransition logic)
            if (!await _workflowService.CanTransitionAsync(report, request.ToStatus, request.Comment))
            {
                // Detailed reasoning would be better for debugging
                return Result<Guid>.Failure(new[] { $"Invalid transition from {report.StatusId} to {request.ToStatus}. Please check your role, geographic scope, and ensure comments are provided for returns." });
            }

            await _workflowService.TransitionAsync(report, request.ToStatus, request.Comment);
        }

        await _context.SaveChangesAsync(cancellationToken);

        // 3. Post-Transition Automation (PDF Generation)
        if (request.ToStatus == DamageReportStatus.ArchiveDir)
        {
            await GenerateAndAttachPdfAsync(report, "استمارة حصر الأضرار", Hasad.Domain.Enums.DocumentType.DamageAssessmentForm, cancellationToken);
        }
        else if (request.ToStatus == DamageReportStatus.Completed)
        {
            await GenerateAndAttachPdfAsync(report, $"شهادة ضرر - {report.ReportNumber}", Hasad.Domain.Enums.DocumentType.DamageCertificate, cancellationToken);
        }

        // 4. Notifications
        await _notificationService.NotifyStageTransitionAsync(report, fromStatus, request.ToStatus, request.Comment);

        return Result<Guid>.Success(report.Id);
    }

    private async Task GenerateAndAttachPdfAsync(DamageReport report, string docName, Hasad.Domain.Enums.DocumentType docType, CancellationToken cancellationToken)
    {
        byte[] pdfBytes;
        if (docType == Hasad.Domain.Enums.DocumentType.DamageAssessmentForm)
        {
            pdfBytes = await _pdfService.GenerateDamageAssessmentFormAsync(report);
        }
        else
        {
            pdfBytes = await _pdfService.GenerateDamageCertificateAsync(report);
        }

        var fileName = $"{Guid.NewGuid()}.pdf";
        using var stream = new MemoryStream(pdfBytes);
        var remotePath = await _storageService.SaveFileAsync(stream, fileName, cancellationToken);

        var attachment = new DamageReportAttachment
        {
            Id = Guid.NewGuid(),
            ClientId = Guid.NewGuid(),
            DamageReportId = report.Id,
            DocumentName = docName,
            DocumentDate = DateTime.UtcNow,
            DocumentTypeId = (int)docType,
            FileName = fileName,
            OriginalFileName = $"{docName}.pdf",
            FileType = "application/pdf",
            FileSize = pdfBytes.Length,
            RemotePath = remotePath,
            UploadStatus = "Completed",
            CreatedAt = DateTime.UtcNow
        };

        _context.DamageReportAttachments.Add(attachment);
        await _context.SaveChangesAsync(cancellationToken);
    }
}
