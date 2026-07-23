using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Domain.Constants;
using Hasad.Domain.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.CostingSheets.Commands.ApproveVersion;

public record ApproveVersionCommand(Guid VersionId) : IRequest<Result<Unit>>;

public class ApproveVersionCommandHandler : IRequestHandler<ApproveVersionCommand, Result<Unit>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public ApproveVersionCommandHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<Unit>> Handle(ApproveVersionCommand request, CancellationToken cancellationToken)
    {
        if (!_currentUser.IsInRole(AppRoles.MinistryReviewer) && !_currentUser.IsInRole(AppRoles.SuperAdmin))
        {
            return Result<Unit>.Failure(new[] { "Access Denied: Only Ministry Reviewers or SuperAdmins can approve pricing versions." });
        }

        var version = await _context.CostingSheetVersions
            .FirstOrDefaultAsync(v => v.Id == request.VersionId, cancellationToken);

        if (version == null)
        {
            return Result<Unit>.Failure(new[] { "Version not found." });
        }

        if (version.Status != CostingSheetStatus.PendingApproval)
        {
            return Result<Unit>.Failure(new[] { "Only versions in PendingApproval state can be approved." });
        }

        // Archive current active version
        var activeVersions = await _context.CostingSheetVersions
            .Where(v => v.Status == CostingSheetStatus.Active)
            .ToListAsync(cancellationToken);

        foreach (var active in activeVersions)
        {
            active.Status = CostingSheetStatus.Archived;
            active.EffectiveTo = DateTime.UtcNow;
        }

        // Activate new version
        version.Status = CostingSheetStatus.Active;
        version.EffectiveFrom = DateTime.UtcNow;
        version.ApprovedAt = DateTime.UtcNow;
        version.ApprovedBy = _currentUser.UserId;

        await _context.SaveChangesAsync(cancellationToken);

        return Result<Unit>.Success(Unit.Value);
    }
}
