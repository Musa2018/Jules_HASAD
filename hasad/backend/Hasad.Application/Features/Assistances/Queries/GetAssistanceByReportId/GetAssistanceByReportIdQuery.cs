using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Assistances.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Assistances.Queries.GetAssistanceByReportId;

public record GetAssistanceByReportIdQuery(Guid DamageReportId) : IRequest<Result<AssistanceDto?>>;

public class GetAssistanceByReportIdQueryHandler : IRequestHandler<GetAssistanceByReportIdQuery, Result<AssistanceDto?>>
{
    private readonly IApplicationDbContext _context;

    public GetAssistanceByReportIdQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Result<AssistanceDto?>> Handle(GetAssistanceByReportIdQuery request, CancellationToken cancellationToken)
    {
        var assistance = await _context.Assistances
            .AsNoTracking()
            .FirstOrDefaultAsync(c => c.DamageReportId == request.DamageReportId, cancellationToken);

        if (assistance == null)
        {
            return Result<AssistanceDto?>.Success(null);
        }

        return Result<AssistanceDto?>.Success(new AssistanceDto
        {
            Id = assistance.Id,
            ClientId = assistance.ClientId,
            DamageReportId = assistance.DamageReportId,
            CalculatedAmount = assistance.CalculatedAmount,
            ApprovedAmount = assistance.ApprovedAmount,
            Status = assistance.Status,
            Remarks = assistance.Remarks,
            RowVersion = Convert.ToBase64String(assistance.RowVersion)
        });
    }
}
