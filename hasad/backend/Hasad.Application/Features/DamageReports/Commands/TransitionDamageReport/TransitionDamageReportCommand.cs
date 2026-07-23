using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Domain.Constants;
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

    public TransitionDamageReportCommandHandler(
        IApplicationDbContext context,
        IDamageWorkflowService workflowService,
        ICurrentUserService currentUser)
    {
        _context = context;
        _workflowService = workflowService;
        _currentUser = currentUser;
    }

    public async Task<Result<Guid>> Handle(TransitionDamageReportCommand request, CancellationToken cancellationToken)
    {
        var report = await _context.DamageReports
            .FirstOrDefaultAsync(r => r.Id == request.Id, cancellationToken);

        if (report == null)
        {
            return Result<Guid>.Failure(new[] { "Damage report not found." });
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
            // 2. Standard Transition

            // Validate Role & State Machine
            bool isValid = false;
            foreach (var role in AppRoles.All())
            {
                if (_currentUser.IsInRole(role))
                {
                    if (_workflowService.IsTransitionValid(fromStatus, request.ToStatus, role))
                    {
                        isValid = true;
                        break;
                    }
                }
            }

            if (!isValid)
            {
                return Result<Guid>.Failure(new[] { $"Invalid transition from {fromStatus} to {request.ToStatus} for your current roles." });
            }

            // 3. Geographic Scope Validation
            if (!await IsWithinScope(report, cancellationToken))
            {
                return Result<Guid>.Failure(new[] { "Access denied. This report is outside your assigned geographic scope." });
            }

            // 4. Mandatory Comments for Returns/Rejections
            // If moving "backwards" in some sense, comment is usually mandatory.
            // For now, let's assume any transition that isn't the "standard forward" might need a comment if specified.
            // Actually, the prompt says "Required comments exist for rejection/return."
            if (IsReturnTransition(fromStatus, request.ToStatus) && string.IsNullOrWhiteSpace(request.Comment))
            {
                return Result<Guid>.Failure(new[] { "A comment is mandatory when returning a report for correction." });
            }

            await _workflowService.TransitionAsync(report, request.ToStatus, request.Comment);
        }

        await _context.SaveChangesAsync(cancellationToken);

        return Result<Guid>.Success(report.Id);
    }

    private async Task<bool> IsWithinScope(Hasad.Domain.Entities.DamageReport report, CancellationToken ct)
    {
        if (_currentUser.IsInRole(AppRoles.SuperAdmin)) return true;

        if (_currentUser.DirectorateId.HasValue)
        {
            var locality = await _context.Localities.FindAsync(new object[] { report.LocalityId }, ct);
            return locality?.DirectorateId == _currentUser.DirectorateId.Value;
        }

        if (_currentUser.GovernorateId.HasValue)
        {
            return report.GovernorateId == _currentUser.GovernorateId.Value.ToString();
        }

        return true; // Global roles
    }

    private bool IsReturnTransition(string from, string to)
    {
        // Define "backward" transitions
        return (from, to) switch
        {
            ("Submitted", "Draft") => true,
            ("TechnicalReview", "Draft") => true,
            ("SupervisorReview", "TechnicalReview") => true,
            ("MinistryReview", "SupervisorReview") => true,
            ("Archive", "MinistryReview") => true,
            _ => false
        };
    }
}
