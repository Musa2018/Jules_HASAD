using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.DamageReports.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.DamageReports.Queries.GetDamageReportHistory;

public record GetDamageReportHistoryQuery(Guid DamageReportId) : IRequest<List<DamageWorkflowHistoryDto>>;

public class GetDamageReportHistoryQueryHandler : IRequestHandler<GetDamageReportHistoryQuery, List<DamageWorkflowHistoryDto>>
{
    private readonly IApplicationDbContext _context;

    public GetDamageReportHistoryQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<List<DamageWorkflowHistoryDto>> Handle(GetDamageReportHistoryQuery request, CancellationToken cancellationToken)
    {
        return await _context.DamageWorkflowHistories
            .Where(h => h.DamageReportId == request.DamageReportId)
            .OrderByDescending(h => h.ChangedAt)
            .Select(h => new DamageWorkflowHistoryDto
            {
                Id = h.Id,
                FromStatus = h.FromStatus,
                ToStatus = h.ToStatus,
                ChangedByUserId = h.ChangedByUserId,
                ChangedAt = h.ChangedAt,
                Comment = h.Comment,
                IsOverride = h.IsOverride
            })
            .ToListAsync(cancellationToken);
    }
}
