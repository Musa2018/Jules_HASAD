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
            // 2. Standard Transition (using centralized CanTransition logic)
            if (!_workflowService.CanTransition(report, request.ToStatus, request.Comment))
            {
                // Detailed reason would be better, but for now we follow the Boolean contract.
                // We can assume failure is due to state machine, scope, or missing comment.
                return Result<Guid>.Failure(new[] { $"Invalid transition to {request.ToStatus}. Please check your role, geographic scope, and ensures comments are provided for returns." });
            }

            await _workflowService.TransitionAsync(report, request.ToStatus, request.Comment);
        }

        await _context.SaveChangesAsync(cancellationToken);

        return Result<Guid>.Success(report.Id);
    }
}
