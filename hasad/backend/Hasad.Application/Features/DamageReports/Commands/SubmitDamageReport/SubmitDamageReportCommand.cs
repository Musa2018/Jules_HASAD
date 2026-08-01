using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Domain.Constants;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Hasad.Application.Features.DamageReports.Commands.SubmitDamageReport;

public record SubmitDamageReportCommand(Guid Id) : IRequest<Result<Guid>>;

public class SubmitDamageReportCommandHandler : IRequestHandler<SubmitDamageReportCommand, Result<Guid>>
{
    private readonly IApplicationDbContext _context;
    private readonly IDamageWorkflowService _workflowService;
    private readonly ICurrentUserService _currentUser;
    private readonly ILogger<SubmitDamageReportCommandHandler> _logger;

    public SubmitDamageReportCommandHandler(
        IApplicationDbContext context,
        IDamageWorkflowService workflowService,
        ICurrentUserService currentUser,
        ILogger<SubmitDamageReportCommandHandler> logger)
    {
        _context = context;
        _workflowService = workflowService;
        _currentUser = currentUser;
        _logger = logger;
    }

    public async Task<Result<Guid>> Handle(SubmitDamageReportCommand request, CancellationToken cancellationToken)
    {
        _logger.LogInformation("Attempting to submit DamageReport {ReportId}", request.Id);

        var report = await _context.DamageReports
            .Include(r => r.Farm)
            .Include(r => r.Items)
            .FirstOrDefaultAsync(r => r.Id == request.Id, cancellationToken);

        if (report == null)
        {
            _logger.LogWarning("SubmitDamageReport: Report {ReportId} not found.", request.Id);
            return Result<Guid>.Failure(new[] { "Damage report not found." });
        }

        _logger.LogInformation("SubmitDamageReport: Found Report {ReportId} with StatusId: {StatusId}, Items: {ItemCount}",
            report.Id, report.StatusId, report.Items.Count);

        if (report.StatusId != DamageReportStatus.Draft && report.StatusId != DamageReportStatus.PendingTechnicalVerification)
        {
            _logger.LogWarning("SubmitDamageReport: Invalid initial status {StatusId}", report.StatusId);
            return Result<Guid>.Failure(new[] { "Only draft or pending reports can be submitted." });
        }

        if (!report.Items.Any())
        {
            _logger.LogWarning("SubmitDamageReport: Report {ReportId} has no items.", report.Id);
            return Result<Guid>.Failure(new[] { "Cannot submit a report without any damage items." });
        }

        if (string.IsNullOrWhiteSpace(report.ReportNumber))
        {
            _logger.LogWarning("SubmitDamageReport: Report {ReportId} missing official ReportNumber.", report.Id);
            return Result<Guid>.Failure(new[] { "Cannot submit a report without an official Report Number. Ensure header is synchronized." });
        }

        // Validate items integrity (Final check before submission)
        foreach (var item in report.Items)
        {
            if (item.EstimatedLoss <= 0 && item.Quantity > 0)
            {
                _logger.LogWarning("SubmitDamageReport: Item {ItemId} has invalid valuation (Loss: {Loss}, Qty: {Qty})",
                    item.Id, item.EstimatedLoss, item.Quantity);
                return Result<Guid>.Failure(new[] { $"Damage item {item.ClientId} has invalid valuation." });
            }
        }

        // Scope validation
        if (_currentUser.IsInRole(AppRoles.AgriculturalEngineer) || _currentUser.IsInRole(AppRoles.FieldSurveyor))
        {
            if (_currentUser.DirectorateId.HasValue && report.DirectorateId != _currentUser.DirectorateId.Value)
            {
                _logger.LogWarning("SubmitDamageReport: Directorate Scope Mismatch. User: {UserDir}, Report: {ReportDir}",
                    _currentUser.DirectorateId, report.DirectorateId);
                return Result<Guid>.Failure(new[] { "Access denied. Report is outside your assigned directorate scope." });
            }
        }
        else if (_currentUser.IsInRole(AppRoles.Director))
        {
            if (_currentUser.GovernorateId.HasValue && report.GovernorateId != _currentUser.GovernorateId.Value)
            {
                _logger.LogWarning("SubmitDamageReport: Governorate Scope Mismatch. User: {UserGov}, Report: {ReportGov}",
                    _currentUser.GovernorateId, report.GovernorateId);
                return Result<Guid>.Failure(new[] { "Access denied. Report is outside your assigned governorate scope." });
            }
        }

        // Check workflow permission
        if (!_workflowService.CanTransition(report, DamageReportStatus.TechReview, "Report submitted for review."))
        {
            _logger.LogWarning("SubmitDamageReport: Workflow transition from {From} to {To} REJECTED by service.",
                report.StatusId, DamageReportStatus.TechReview);
            return Result<Guid>.Failure(new[] { "You do not have permission to submit this report or it is in an invalid state." });
        }

        _logger.LogInformation("SubmitDamageReport: All checks passed. Transitioning to TechReview.");
        await _workflowService.TransitionAsync(report, DamageReportStatus.TechReview, "Report submitted for review.");

        await _context.SaveChangesAsync(cancellationToken);

        return Result<Guid>.Success(report.Id);
    }
}
