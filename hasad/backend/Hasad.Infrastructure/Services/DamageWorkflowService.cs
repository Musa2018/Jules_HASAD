using Hasad.Application.Common.Interfaces;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Infrastructure.Services;

public class DamageWorkflowService : IDamageWorkflowService
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public DamageWorkflowService(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public bool IsTransitionValid(string fromStatus, string toStatus, string userRole)
    {
        // Define the state machine
        return (fromStatus, toStatus, userRole) switch
        {
            ("Draft", "Submitted", AppRoles.AgriculturalEngineer or AppRoles.FieldSurveyor) => true,

            ("Submitted", "TechnicalReview", AppRoles.TechnicalReviewer) => true,
            ("Submitted", "Draft", AppRoles.TechnicalReviewer) => true, // Return for correction

            ("TechnicalReview", "SupervisorReview", AppRoles.TechnicalReviewer) => true,
            ("TechnicalReview", "Draft", AppRoles.TechnicalReviewer) => true, // Return for correction

            ("SupervisorReview", "MinistryReview", AppRoles.Supervisor) => true,
            ("SupervisorReview", "TechnicalReview", AppRoles.Supervisor) => true, // Return to technical

            ("MinistryReview", "Archive", AppRoles.MinistryReviewer) => true,
            ("MinistryReview", "SupervisorReview", AppRoles.MinistryReviewer) => true, // Return to supervisor

            ("Archive", "Approved", AppRoles.ArchiveOfficer) => true,
            ("Archive", "MinistryReview", AppRoles.ArchiveOfficer) => true, // Return to ministry

            // General Manager Override
            (_, _, AppRoles.GeneralManager or AppRoles.SuperAdmin) => true,

            _ => false
        };
    }

    public async Task TransitionAsync(DamageReport report, string toStatus, string? comment = null, bool isOverride = false)
    {
        var fromStatus = report.StatusId;

        // Update report status
        report.StatusId = toStatus;
        report.UpdatedAt = DateTime.UtcNow;

        // Create history record
        var history = new DamageWorkflowHistory
        {
            Id = Guid.NewGuid(),
            DamageReportId = report.Id,
            FromStatus = fromStatus,
            ToStatus = toStatus,
            ChangedByUserId = _currentUser.UserId ?? "System",
            ChangedAt = DateTime.UtcNow,
            Comment = comment,
            IsOverride = isOverride
        };

        _context.DamageWorkflowHistories.Add(history);

        // We don't call SaveChanges here, the command handler will do it.
    }
}
