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

    public async Task<bool> IsTransitionValidAsync(string fromStatus, string toStatus, string userRole)
    {
        // 1. Check if it's a "Forward" move defined in DB
        bool isForwardAllowed = await _context.WorkflowTransitions
            .AnyAsync(t => t.FromStatusId == fromStatus && t.ToStatusId == toStatus && t.AllowedRole == userRole && !t.IsReturn);

        if (isForwardAllowed) return true;

        // 2. Specialized "Return" logic (Backward moves)
        if (IsReturnTransition(fromStatus, toStatus))
        {
            // SuperAdmin & GeneralManager can return to ANY previous stage
            if (userRole == AppRoles.SuperAdmin || userRole == AppRoles.GeneralManager) return true;

            // Directors & Directorate Managers can return to ANY stage within/before their scope
            if (userRole == AppRoles.Director || userRole == AppRoles.DirectorateManager || userRole == AppRoles.Supervisor)
            {
                // Can return to any previous stage
                return true;
            }

            // Ministry Roles can return ONLY ONE STEP back
            if (userRole == AppRoles.MinistryTechReviewer || userRole == AppRoles.LegalReviewer || userRole == AppRoles.ChiefArchiveOfficer)
            {
                return IsOneStepBack(fromStatus, toStatus);
            }

            // Procedural Reviewer CANNOT return (Forward only to GM)
            if (userRole == AppRoles.ProceduralReviewer) return false;

            // Other roles (TechnicalReviewer, ArchiveOfficer) usually return 1 step back as defined in DB or logic
            return await _context.WorkflowTransitions
                .AnyAsync(t => t.FromStatusId == fromStatus && t.ToStatusId == toStatus && t.AllowedRole == userRole && t.IsReturn);
        }

        return false;
    }

    public async Task<bool> CanTransitionAsync(DamageReport report, string targetStatus, string? comment)
    {
        if (_currentUser.UserId == null) return false;

        // 1. Role-based State Machine check
        bool isValid = false;
        foreach (var role in AppRoles.All())
        {
            if (_currentUser.IsInRole(role))
            {
                if (await IsTransitionValidAsync(report.StatusId, targetStatus, role))
                {
                    isValid = true;
                    break;
                }
            }
        }

        if (!isValid) return false;

        // 2. Geographic Scope check
        if (!_currentUser.IsInRole(AppRoles.SuperAdmin) && !_currentUser.IsInRole(AppRoles.GeneralManager))
        {
            // For Directorate/Governorate roles, check if report belongs to their scope
            if (_currentUser.DirectorateId.HasValue && report.DirectorateId != _currentUser.DirectorateId.Value)
            {
                // If it's a global ministry role, skip this check
                if (!IsMinistryRole(_currentUser))
                {
                    return false;
                }
            }

            if (_currentUser.GovernorateId.HasValue && report.GovernorateId != _currentUser.GovernorateId.Value)
            {
                 if (!IsMinistryRole(_currentUser))
                {
                    return false;
                }
            }
        }

        // 3. Attachment Rules
        if (report.StatusId == DamageReportStatus.ArchiveDir && targetStatus == DamageReportStatus.DirManager)
        {
            var hasSitePhoto = await _context.DamageReportAttachments
                .AnyAsync(a => a.DamageReportId == report.Id && a.DocumentTypeId == (int)Hasad.Domain.Enums.DocumentTypeEnum.SitePhoto && !a.IsDeleted);

            if (!hasSitePhoto) return false;
        }

        // 4. Comment Rules (Mandatory for returns)
        if (IsReturnTransition(report.StatusId, targetStatus) && string.IsNullOrWhiteSpace(comment))
        {
            return false;
        }

        return true;
    }

    private bool IsMinistryRole(ICurrentUserService user)
    {
        return user.IsInRole(AppRoles.MinistryTechReviewer) ||
               user.IsInRole(AppRoles.LegalReviewer) ||
               user.IsInRole(AppRoles.ProceduralReviewer) ||
               user.IsInRole(AppRoles.ChiefArchiveOfficer) ||
               user.IsInRole(AppRoles.GeneralManager);
    }

    private bool IsReturnTransition(string from, string to)
    {
        var statuses = DamageReportStatus.All().ToList();
        int fromIndex = statuses.IndexOf(from);
        int toIndex = statuses.IndexOf(to);

        if (fromIndex == -1 || toIndex == -1) return false;
        return toIndex < fromIndex;
    }

    private bool IsOneStepBack(string from, string to)
    {
        var statuses = DamageReportStatus.All().ToList();
        int fromIndex = statuses.IndexOf(from);
        int toIndex = statuses.IndexOf(to);

        return fromIndex - toIndex == 1;
    }

    public Task TransitionAsync(DamageReport report, string toStatus, string? comment = null, bool isOverride = false)
    {
        var fromStatus = report.StatusId;

        report.StatusId = toStatus;
        report.UpdatedAt = DateTime.UtcNow;

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
        return Task.CompletedTask;
    }
}
