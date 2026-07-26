using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Assistances.Models;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Assistances.Commands.SubmitAssistance;

public record SubmitAssistanceCommand(Guid Id, string RowVersion) : IRequest<Result<AssistanceDto>>;

public class SubmitAssistanceCommandHandler : IRequestHandler<SubmitAssistanceCommand, Result<AssistanceDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUserService;

    public SubmitAssistanceCommandHandler(IApplicationDbContext context, ICurrentUserService currentUserService)
    {
        _context = context;
        _currentUserService = currentUserService;
    }

    public async Task<Result<AssistanceDto>> Handle(SubmitAssistanceCommand request, CancellationToken cancellationToken)
    {
        var assistance = await _context.Assistances
            .FirstOrDefaultAsync(c => c.Id == request.Id, cancellationToken);

        if (assistance == null) return Result<AssistanceDto>.Failure(new[] { "Assistance not found." });

        byte[] expectedVersion = Convert.FromBase64String(request.RowVersion);
        if (!assistance.RowVersion.SequenceEqual(expectedVersion))
            return Result<AssistanceDto>.Failure(new[] { "CONFLICT: The record has been modified by another user." });

        if (!AssistanceStatus.CanTransition(assistance.Status, AssistanceStatus.Submitted))
            return Result<AssistanceDto>.Failure(new[] { $"Invalid status transition from {assistance.Status} to Submitted." });

        var previousStatus = assistance.Status;
        assistance.Status = AssistanceStatus.Submitted;
        assistance.UpdatedAt = DateTime.UtcNow;

        _context.AssistanceAuditLogs.Add(new AssistanceAuditLog
        {
            Id = Guid.NewGuid(),
            AssistanceId = assistance.Id,
            PreviousStatus = previousStatus,
            NewStatus = AssistanceStatus.Submitted,
            ChangedBy = _currentUserService.UserName ?? "System",
            ChangedAt = DateTime.UtcNow,
            Reason = "Submission for approval"
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
