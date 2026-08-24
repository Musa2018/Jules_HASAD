using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

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
    private readonly ILogger<TransitionDamageReportCommandHandler> _logger;

    public TransitionDamageReportCommandHandler(
        IApplicationDbContext context,
        IDamageWorkflowService workflowService,
        ICurrentUserService currentUser,
        IPDFService pdfService,
        IFileStorageService storageService,
        INotificationService notificationService,
        ILogger<TransitionDamageReportCommandHandler> logger)
    {
        _context = context;
        _workflowService = workflowService;
        _currentUser = currentUser;
        _pdfService = pdfService;
        _storageService = storageService;
        _notificationService = notificationService;
        _logger = logger;
    }

    public async Task<Result<Guid>> Handle(TransitionDamageReportCommand request, CancellationToken cancellationToken)
    {
        var report = await _context.DamageReports
            .FirstOrDefaultAsync(r => r.Id == request.Id, cancellationToken);

        if (report == null)
        {
            return Result<Guid>.Failure(new[] { "Damage report not found." });
        }

        if (report.StatusId == request.ToStatus)
        {
            return Result<Guid>.Success(report.Id);
        }

        string fromStatus = report.StatusId;

        // 1. Logic Transition
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
            if (!await _workflowService.CanTransitionAsync(report, request.ToStatus, request.Comment))
            {
                return Result<Guid>.Failure(new[] { $"Invalid transition from {report.StatusId} to {request.ToStatus}." });
            }

            await _workflowService.TransitionAsync(report, request.ToStatus, request.Comment);
        }

        // 2. Save State Change
        await _context.SaveChangesAsync(cancellationToken);

        // 3. SAFE Post-Action Hook (PDF Automation)
        // We execute this strictly AFTER commit to ensure workflow integrity.
        try
        {
            if (request.ToStatus == DamageReportStatus.ArchiveDir)
            {
                await GenerateAndAttachPdfAsync(report.Id, "استمارة حصر الأضرار", Hasad.Domain.Enums.DocumentTypeEnum.DamageAssessmentForm, cancellationToken);
            }
            else if (request.ToStatus == DamageReportStatus.Completed)
            {
                await GenerateAndAttachPdfAsync(report.Id, $"شهادة ضرر - {report.ReportNumber}", Hasad.Domain.Enums.DocumentTypeEnum.DamageCertificate, cancellationToken);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to generate automated PDF for report {ReportId} during transition to {Status}", report.Id, request.ToStatus);
            // We do NOT rethrow here, satisfying the requirement that rendering issues never interrupt the workflow.
        }

        // 4. Notifications
        await _notificationService.NotifyStageTransitionAsync(report, fromStatus, request.ToStatus, request.Comment);

        return Result<Guid>.Success(report.Id);
    }

    private async Task GenerateAndAttachPdfAsync(Guid reportId, string docName, Hasad.Domain.Enums.DocumentTypeEnum docType, CancellationToken cancellationToken)
    {
        // Fully load the report with all related entities needed for PDF
        var report = await _context.DamageReports
            .Include(r => r.Farm!)
                .ThenInclude(f => f.Farmer!)
            .Include(r => r.Farm!)
                .ThenInclude(f => f.Governorate!)
            .Include(r => r.Farm!)
                .ThenInclude(f => f.Locality!)
            .Include(r => r.Farm!)
                .ThenInclude(f => f.MeasurementUnit!)
            .Include(r => r.Farm!)
                .ThenInclude(f => f.OwnershipType!)
            .Include(r => r.Farm!)
                .ThenInclude(f => f.PoliticalClassification!)
            .Include(r => r.Items)
                .ThenInclude(i => i.Classification!)
                    .ThenInclude(c => c.SubCategory!)
            .Include(r => r.Items)
                .ThenInclude(i => i.DamageNature!)
            .Include(r => r.DamageCause!)
            .Include(r => r.DamageCauseCategory!)
            .FirstOrDefaultAsync(r => r.Id == reportId, cancellationToken);

        if (report == null) return;

        byte[] pdfBytes;
        if (docType == Hasad.Domain.Enums.DocumentTypeEnum.DamageAssessmentForm)
        {
            // Direct query for history as per specification
            var histories = await _context.DamageWorkflowHistories
                .Where(h => h.DamageReportId == reportId && !h.IsDeleted)
                .OrderBy(h => h.ChangedAt)
                .ToListAsync(cancellationToken);

            pdfBytes = await _pdfService.GenerateDamageAssessmentFormAsync(report, histories);
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
