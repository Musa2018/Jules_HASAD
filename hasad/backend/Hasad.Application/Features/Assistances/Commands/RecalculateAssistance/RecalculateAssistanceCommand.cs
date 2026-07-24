using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Assistances.Models;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Assistances.Commands.RecalculateAssistance;

public record RecalculateAssistanceCommand(Guid Id, string RowVersion) : IRequest<Result<AssistanceDto>>;

public class RecalculateAssistanceCommandHandler : IRequestHandler<RecalculateAssistanceCommand, Result<AssistanceDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly IAssistanceService _assistanceService;
    private readonly ICurrentUserService _currentUserService;

    public RecalculateAssistanceCommandHandler(IApplicationDbContext context, IAssistanceService assistanceService, ICurrentUserService currentUserService)
    {
        _context = context;
        _assistanceService = assistanceService;
        _currentUserService = currentUserService;
    }

    public async Task<Result<AssistanceDto>> Handle(RecalculateAssistanceCommand request, CancellationToken cancellationToken)
    {
        var assistance = await _context.Assistances
            .Include(c => c.DamageReport)
                .ThenInclude(r => r!.Items)
            .FirstOrDefaultAsync(c => c.Id == request.Id, cancellationToken);

        if (assistance == null) return Result<AssistanceDto>.Failure(new[] { "Assistance not found." });

        byte[] expectedVersion = Convert.FromBase64String(request.RowVersion);
        if (!assistance.RowVersion.SequenceEqual(expectedVersion))
            return Result<AssistanceDto>.Failure(new[] { "CONFLICT: The record has been modified by another user." });

        // Only allow recalculation if in certain states (Draft, Calculated, Rejected)
        if (assistance.Status == AssistanceStatus.Approved || assistance.Status == AssistanceStatus.Paid || assistance.Status == AssistanceStatus.Submitted)
        {
            return Result<AssistanceDto>.Failure(new[] { $"Recalculation not allowed in {assistance.Status} status." });
        }

        var rule = await _context.AssistanceRules.FirstOrDefaultAsync(r => r.IsActive, cancellationToken);
        if (rule == null) return Result<AssistanceDto>.Failure(new[] { "No active assistance rule found." });

        var newCalculatedAmount = _assistanceService.Calculate(assistance.DamageReport!, rule);

        var previousStatus = assistance.Status;
        assistance.CalculatedAmount = newCalculatedAmount;
        assistance.ApprovedAmount = newCalculatedAmount; // Reset approved to calculated
        assistance.Status = AssistanceStatus.Calculated;
        assistance.RuleId = rule.Id;
        assistance.UpdatedAt = DateTime.UtcNow;

        _context.AssistanceAuditLogs.Add(new AssistanceAuditLog
        {
            Id = Guid.NewGuid(),
            AssistanceId = assistance.Id,
            PreviousStatus = previousStatus,
            NewStatus = AssistanceStatus.Calculated,
            ChangedBy = _currentUserService.UserName ?? "System",
            ChangedAt = DateTime.UtcNow,
            Reason = "Recalculation triggered"
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
