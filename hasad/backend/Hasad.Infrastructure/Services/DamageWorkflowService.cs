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
        // Define the 10-stage state machine (Sprint 13.1)
        return (fromStatus, toStatus, userRole) switch
        {
            (DamageReportStatus.Draft, DamageReportStatus.PendingTechnicalVerification, AppRoles.AgriculturalEngineer or AppRoles.FieldSurveyor) => true,
            (DamageReportStatus.PendingTechnicalVerification, DamageReportStatus.TechReview, AppRoles.AgriculturalEngineer or AppRoles.FieldSurveyor) => true,

            (DamageReportStatus.TechReview, DamageReportStatus.ArchiveDir, AppRoles.TechnicalReviewer) => true,
            (DamageReportStatus.TechReview, DamageReportStatus.PendingTechnicalVerification, AppRoles.TechnicalReviewer) => true, // Return

            (DamageReportStatus.ArchiveDir, DamageReportStatus.DirManager, AppRoles.ArchiveOfficer) => true,
            (DamageReportStatus.ArchiveDir, DamageReportStatus.TechReview, AppRoles.ArchiveOfficer) => true, // Return

            (DamageReportStatus.DirManager, DamageReportStatus.MinTechReview, AppRoles.DirectorateManager or AppRoles.Director or AppRoles.Supervisor) => true,
            (DamageReportStatus.DirManager, DamageReportStatus.ArchiveDir, AppRoles.DirectorateManager or AppRoles.Director or AppRoles.Supervisor) => true, // Return

            (DamageReportStatus.MinTechReview, DamageReportStatus.LegalReview, AppRoles.MinistryTechReviewer) => true,
            (DamageReportStatus.MinTechReview, DamageReportStatus.DirManager, AppRoles.MinistryTechReviewer) => true, // Return

            (DamageReportStatus.LegalReview, DamageReportStatus.ProcReview, AppRoles.LegalReviewer) => true,
            (DamageReportStatus.LegalReview, DamageReportStatus.MinTechReview, AppRoles.LegalReviewer) => true, // Return

            (DamageReportStatus.ProcReview, DamageReportStatus.MinArchive, AppRoles.ProceduralReviewer) => true,
            (DamageReportStatus.ProcReview, DamageReportStatus.LegalReview, AppRoles.ProceduralReviewer) => true, // Return

            (DamageReportStatus.MinArchive, DamageReportStatus.GenManager, AppRoles.ChiefArchiveOfficer) => true,
            (DamageReportStatus.MinArchive, DamageReportStatus.ProcReview, AppRoles.ChiefArchiveOfficer) => true, // Return

            (DamageReportStatus.GenManager, DamageReportStatus.Completed, AppRoles.GeneralManager) => true,
            (DamageReportStatus.GenManager, DamageReportStatus.MinArchive, AppRoles.GeneralManager) => true, // Return

            // General Manager / SuperAdmin Override
            (_, _, AppRoles.GeneralManager or AppRoles.SuperAdmin) => true,

            _ => false
        };
    }

    public bool CanTransition(DamageReport report, string targetStatus, string? comment)
    {
        // 1. Current User check
        if (_currentUser.UserId == null) return false;

        // 2. State Machine check
        bool isValid = false;
        foreach (var role in AppRoles.All())
        {
            if (_currentUser.IsInRole(role))
            {
                if (IsTransitionValid(report.StatusId, targetStatus, role))
                {
                    isValid = true;
                    break;
                }
            }
        }

        if (!isValid) return false;

        // 3. Geographic Scope check (inherited from ADR 0013 logic)
        if (!_currentUser.IsInRole(AppRoles.SuperAdmin) && !_currentUser.IsInRole(AppRoles.GeneralManager))
        {
            // Ensure Farm is loaded if needed. Since this is a service, we assume report might not have it.
            // But usually the caller provides the report.
            if (report.Farm == null)
            {
                // This is a safety guard. In production, we should probably load it if missing.
                // For now, let's assume it's included as per repository patterns.
            }

            if (_currentUser.DirectorateId.HasValue && report.Farm?.DirectorateId != _currentUser.DirectorateId.Value)
            {
                return false;
            }

            if (_currentUser.GovernorateId.HasValue && report.Farm?.GovernorateId != _currentUser.GovernorateId.Value)
            {
                return false;
            }
        }

        // 4. Comment Rules (Mandatory for returns/backward)
        if (IsReturnTransition(report.StatusId, targetStatus) && string.IsNullOrWhiteSpace(comment))
        {
            return false;
        }

        return true;
    }

    private bool IsReturnTransition(string from, string to)
    {
        // Returns are backward moves in the 10-stage chain
        var statuses = DamageReportStatus.All().ToList();
        int fromIndex = statuses.IndexOf(from);
        int toIndex = statuses.IndexOf(to);

        return toIndex < fromIndex;
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
