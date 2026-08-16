using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.DamageReports.Queries.GetIntegratedAuditLog;

public record GetIntegratedAuditLogQuery(Guid ReportId) : IRequest<Result<List<AuditLogDto>>>;

public class GetIntegratedAuditLogQueryHandler : IRequestHandler<GetIntegratedAuditLogQuery, Result<List<AuditLogDto>>>
{
    private readonly IApplicationDbContext _context;

    public GetIntegratedAuditLogQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Result<List<AuditLogDto>>> Handle(GetIntegratedAuditLogQuery request, CancellationToken cancellationToken)
    {
        var report = await _context.DamageReports
            .Include(r => r.Farm)
            .FirstOrDefaultAsync(r => r.Id == request.ReportId, cancellationToken);

        if (report == null) return Result<List<AuditLogDto>>.Failure(new[] { "Report not found." });

        var logs = new List<AuditLogDto>();

        // 1. Farmer Context
        var farmer = await _context.Farmers.FindAsync(new object[] { report.FarmerId }, cancellationToken);
        if (farmer != null)
        {
            logs.Add(new AuditLogDto
            {
                EventType = "Farmer",
                Description = $"تم إنشاء المزارع: {farmer.FirstNameAr} {farmer.FamilyNameAr}",
                PerformedBy = "System/Initial",
                EventDate = farmer.CreatedAt
            });

            if (farmer.UpdatedAt.HasValue)
            {
                logs.Add(new AuditLogDto
                {
                    EventType = "Farmer",
                    Description = "تم تحديث بيانات المزارع",
                    PerformedBy = "System/Update",
                    EventDate = farmer.UpdatedAt.Value
                });
            }
        }

        // 2. Farm Context
        if (report.Farm != null)
        {
            logs.Add(new AuditLogDto
            {
                EventType = "Farm",
                Description = $"تم إنشاء المزرعة: {report.Farm.LocalFarmName}",
                PerformedBy = "System/Initial",
                EventDate = report.Farm.CreatedAt
            });
        }

        // 3. Report Initial Creation
        logs.Add(new AuditLogDto
        {
            EventType = "Report",
            Description = "تم بدء إنشاء تقرير الضرر في الميدان",
            PerformedBy = report.CreatedBy,
            EventDate = report.CreatedAt
        });

        // 4. Workflow Transitions
        var transitions = await _context.DamageWorkflowHistories
            .Where(h => h.DamageReportId == report.Id)
            .OrderBy(h => h.ChangedAt)
            .ToListAsync(cancellationToken);

        foreach (var t in transitions)
        {
            logs.Add(new AuditLogDto
            {
                EventType = "Transition",
                Description = $"تغيير الحالة من {t.FromStatus} إلى {t.ToStatus}",
                PerformedBy = t.ChangedByUserId,
                EventDate = t.ChangedAt,
                Metadata = t.Comment
            });
        }

        return Result<List<AuditLogDto>>.Success(logs.OrderBy(l => l.EventDate).ToList());
    }
}
