using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.DamageReports.Commands.DeleteDamageReport;

public record DeleteDamageReportCommand(Guid Id) : IRequest<Result<Unit>>;

public class DeleteDamageReportCommandHandler : IRequestHandler<DeleteDamageReportCommand, Result<Unit>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public DeleteDamageReportCommandHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<Unit>> Handle(DeleteDamageReportCommand request, CancellationToken cancellationToken)
    {
        var report = await _context.DamageReports
            .FirstOrDefaultAsync(r => r.Id == request.Id, cancellationToken);

        if (report == null)
        {
            return Result<Unit>.Failure(new[] { "Damage report not found." });
        }

        // Authorization check
        if (_currentUser.IsInRole("AgriculturalEngineer") || _currentUser.IsInRole("FieldSurveyor"))
        {
            if (_currentUser.DirectorateId.HasValue && report.DirectorateId != _currentUser.DirectorateId.Value)
            {
                return Result<Unit>.Failure(new[] { "Access Denied: You can only delete reports within your assigned directorate." });
            }
        }
        else if (_currentUser.IsInRole("Director"))
        {
            if (_currentUser.GovernorateId.HasValue && report.GovernorateId != _currentUser.GovernorateId.Value)
            {
                return Result<Unit>.Failure(new[] { "Access Denied: You can only delete reports within your assigned governorate." });
            }
        }

        // Rule: Block deletion if status is beyond Submitted
        // As per the plan: Block deletion if status is beyond Submitted.
        if (report.StatusId != "Draft" && report.StatusId != "Submitted" && !_currentUser.IsInRole("SuperAdmin"))
        {
            return Result<Unit>.Failure(new[] { $"Cannot delete a report that is already in {report.StatusId} status." });
        }

        _context.DamageReports.Remove(report);
        await _context.SaveChangesAsync(cancellationToken);

        return Result<Unit>.Success(Unit.Value);
    }
}
