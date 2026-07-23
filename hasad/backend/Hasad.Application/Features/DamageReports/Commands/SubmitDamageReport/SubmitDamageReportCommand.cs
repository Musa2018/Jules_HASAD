using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.DamageReports.Commands.SubmitDamageReport;

public record SubmitDamageReportCommand(Guid Id) : IRequest<Result<Guid>>;

public class SubmitDamageReportCommandHandler : IRequestHandler<SubmitDamageReportCommand, Result<Guid>>
{
    private readonly IApplicationDbContext _context;
    private readonly IDamageWorkflowService _workflowService;
    private readonly ICurrentUserService _currentUser;

    public SubmitDamageReportCommandHandler(
        IApplicationDbContext context,
        IDamageWorkflowService workflowService,
        ICurrentUserService currentUser)
    {
        _context = context;
        _workflowService = workflowService;
        _currentUser = currentUser;
    }

    public async Task<Result<Guid>> Handle(SubmitDamageReportCommand request, CancellationToken cancellationToken)
    {
        var report = await _context.DamageReports
            .Include(r => r.Items)
            .FirstOrDefaultAsync(r => r.Id == request.Id, cancellationToken);

        if (report == null)
        {
            return Result<Guid>.Failure(new[] { "Damage report not found." });
        }

        if (report.StatusId != "Draft")
        {
            return Result<Guid>.Failure(new[] { "Only draft reports can be submitted." });
        }

        if (!report.Items.Any())
        {
            return Result<Guid>.Failure(new[] { "Cannot submit a report without any damage items." });
        }

        // Scope validation
        if (_currentUser.DirectorateId.HasValue && report.LocalityId != null)
        {
            // Verify if locality belongs to user's directorate
            var locality = await _context.Localities.FindAsync(report.LocalityId);
            if (locality?.DirectorateId != _currentUser.DirectorateId.Value)
            {
                 return Result<Guid>.Failure(new[] { "Access denied. Report is outside your assigned directorate scope." });
            }
        }

        // Check workflow permission
        // AgriculturalEngineer or FieldSurveyor can submit
        bool canSubmit = false;
        if (_currentUser.IsInRole("AgriculturalEngineer") || _currentUser.IsInRole("FieldSurveyor"))
        {
            canSubmit = _workflowService.IsTransitionValid(report.StatusId, "Submitted", "AgriculturalEngineer"); // Role mapping
        }

        if (!canSubmit && !_currentUser.IsInRole("SuperAdmin"))
        {
            return Result<Guid>.Failure(new[] { "You do not have permission to submit this report." });
        }

        await _workflowService.TransitionAsync(report, "Submitted", "Report submitted for review.");

        await _context.SaveChangesAsync(cancellationToken);

        return Result<Guid>.Success(report.Id);
    }
}
