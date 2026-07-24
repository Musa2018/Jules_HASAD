using FluentValidation;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Assistances.Models;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Assistances.Commands.UpdateAssistance;

public record UpdateAssistanceCommand(
    Guid Id,
    decimal ApprovedAmount,
    string Status,
    string Remarks,
    string RowVersion) : IRequest<Result<AssistanceDto>>;

public class UpdateAssistanceCommandHandler : IRequestHandler<UpdateAssistanceCommand, Result<AssistanceDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUserService;

    public UpdateAssistanceCommandHandler(IApplicationDbContext context, ICurrentUserService currentUserService)
    {
        _context = context;
        _currentUserService = currentUserService;
    }

    public async Task<Result<AssistanceDto>> Handle(UpdateAssistanceCommand request, CancellationToken cancellationToken)
    {
        var assistance = await _context.Assistances
            .FirstOrDefaultAsync(c => c.Id == request.Id, cancellationToken);

        if (assistance == null)
        {
            return Result<AssistanceDto>.Failure(new[] { "Assistance not found." });
        }

        // Optimistic concurrency check
        byte[] expectedVersion = Convert.FromBase64String(request.RowVersion);
        if (!assistance.RowVersion.SequenceEqual(expectedVersion))
        {
            return Result<AssistanceDto>.Failure(new[] { "CONFLICT: The record has been modified by another user." });
        }

        // Validate state transition
        if (!AssistanceStatus.CanTransition(assistance.Status, request.Status))
        {
            return Result<AssistanceDto>.Failure(new[] { $"Invalid status transition from {assistance.Status} to {request.Status}." });
        }

        var previousStatus = assistance.Status;
        assistance.ApprovedAmount = request.ApprovedAmount;
        assistance.Status = request.Status;
        assistance.Remarks = request.Remarks;
        assistance.UpdatedAt = DateTime.UtcNow;

        _context.AssistanceAuditLogs.Add(new AssistanceAuditLog
        {
            Id = Guid.NewGuid(),
            AssistanceId = assistance.Id,
            PreviousStatus = previousStatus,
            NewStatus = request.Status,
            ChangedBy = _currentUserService.UserName ?? "System",
            ChangedAt = DateTime.UtcNow,
            Reason = request.Remarks
        });

        try
        {
            await _context.SaveChangesAsync(cancellationToken);
        }
        catch (DbUpdateConcurrencyException)
        {
            return Result<AssistanceDto>.Failure(new[] { "CONFLICT: The record has been modified by another user." });
        }

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

public class UpdateAssistanceCommandValidator : AbstractValidator<UpdateAssistanceCommand>
{
    public UpdateAssistanceCommandValidator()
    {
        RuleFor(v => v.Id).NotEmpty();
        RuleFor(v => v.ApprovedAmount).GreaterThanOrEqualTo(0);
        RuleFor(v => v.Status).NotEmpty().MaximumLength(50);
        RuleFor(v => v.RowVersion).NotEmpty();
    }
}
