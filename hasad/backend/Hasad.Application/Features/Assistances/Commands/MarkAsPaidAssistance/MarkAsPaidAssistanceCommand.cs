using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Assistances.Models;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Assistances.Commands.MarkAsPaidAssistance;

public record MarkAsPaidAssistanceCommand(Guid Id, string Remarks, string RowVersion) : IRequest<Result<AssistanceDto>>;

public class MarkAsPaidAssistanceCommandHandler : IRequestHandler<MarkAsPaidAssistanceCommand, Result<AssistanceDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUserService;

    public MarkAsPaidAssistanceCommandHandler(IApplicationDbContext context, ICurrentUserService currentUserService)
    {
        _context = context;
        _currentUserService = currentUserService;
    }

    public async Task<Result<AssistanceDto>> Handle(MarkAsPaidAssistanceCommand request, CancellationToken cancellationToken)
    {
        var assistance = await _context.Assistances
            .FirstOrDefaultAsync(c => c.Id == request.Id, cancellationToken);

        if (assistance == null) return Result<AssistanceDto>.Failure(new[] { "Assistance not found." });

        byte[] expectedVersion = Convert.FromBase64String(request.RowVersion);
        if (!assistance.RowVersion.SequenceEqual(expectedVersion))
            return Result<AssistanceDto>.Failure(new[] { "CONFLICT: The record has been modified by another user." });

        if (!AssistanceStatus.CanTransition(assistance.Status, AssistanceStatus.Paid))
            return Result<AssistanceDto>.Failure(new[] { $"Invalid status transition from {assistance.Status} to Paid." });

        var previousStatus = assistance.Status;
        assistance.Status = AssistanceStatus.Paid;
        assistance.Remarks = request.Remarks;
        assistance.UpdatedAt = DateTime.UtcNow;

        _context.AssistanceAuditLogs.Add(new AssistanceAuditLog
        {
            Id = Guid.NewGuid(),
            AssistanceId = assistance.Id,
            PreviousStatus = previousStatus,
            NewStatus = AssistanceStatus.Paid,
            ChangedBy = _currentUserService.UserName ?? "System",
            ChangedAt = DateTime.UtcNow,
            Reason = request.Remarks
        });

        await _context.SaveChangesAsync(cancellationToken);

        return Result<AssistanceDto>.Success(new AssistanceDto
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
