using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Domain.Constants;
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
            .Include(r => r.Farm)
            .FirstOrDefaultAsync(r => r.Id == request.Id, cancellationToken);

        if (report == null)
        {
            return Result<Unit>.Failure(new[] { "Damage report not found." });
        }

        // Authorization check
        if (_currentUser.IsInRole(AppRoles.AgriculturalEngineer) || _currentUser.IsInRole(AppRoles.FieldSurveyor))
        {
            if (_currentUser.DirectorateId.HasValue && report.Farm?.DirectorateId != _currentUser.DirectorateId.Value)
            {
                return Result<Unit>.Failure(new[] { "Access Denied: You can only delete reports within your assigned directorate." });
            }
        }
        else if (_currentUser.IsInRole(AppRoles.Director))
        {
            if (_currentUser.GovernorateId.HasValue && report.Farm?.GovernorateId != _currentUser.GovernorateId.Value)
            {
                return Result<Unit>.Failure(new[] { "Access Denied: You can only delete reports within your assigned governorate." });
            }
        }

        // Rule: Block deletion if status is beyond TechReview (Mapping for Submitted)
        if (report.StatusId != DamageReportStatus.Draft && report.StatusId != DamageReportStatus.TechReview && !_currentUser.IsInRole(AppRoles.SuperAdmin))
        {
            return Result<Unit>.Failure(new[] { $"Cannot delete a report that is already in {report.StatusId} status." });
        }

        _context.DamageReports.Remove(report);
        await _context.SaveChangesAsync(cancellationToken);

        return Result<Unit>.Success(Unit.Value);
    }
}
