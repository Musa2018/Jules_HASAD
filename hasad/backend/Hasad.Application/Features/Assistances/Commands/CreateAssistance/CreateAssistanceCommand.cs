using FluentValidation;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Assistances.Models;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Assistances.Commands.CreateAssistance;

public record CreateAssistanceCommand(
    Guid ClientId,
    Guid DamageReportId,
    string Remarks) : IRequest<Result<AssistanceDto>>;

public class CreateAssistanceCommandHandler : IRequestHandler<CreateAssistanceCommand, Result<AssistanceDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly IAssistanceService _assistanceService;
    private readonly ICurrentUserService _currentUserService;

    public CreateAssistanceCommandHandler(IApplicationDbContext context, IAssistanceService assistanceService, ICurrentUserService currentUserService)
    {
        _context = context;
        _assistanceService = assistanceService;
        _currentUserService = currentUserService;
    }

    public async Task<Result<AssistanceDto>> Handle(CreateAssistanceCommand request, CancellationToken cancellationToken)
    {
        // Idempotency check
        var existing = await _context.Assistances
            .AsNoTracking()
            .FirstOrDefaultAsync(c => c.ClientId == request.ClientId, cancellationToken);

        if (existing != null)
        {
            return Result<AssistanceDto>.Success(MapToDto(existing));
        }

        // Check if report exists and load items for calculation
        var report = await _context.DamageReports
            .Include(r => r.Items)
            .FirstOrDefaultAsync(r => r.Id == request.DamageReportId, cancellationToken);

        if (report == null)
        {
            return Result<AssistanceDto>.Failure(new[] { "Damage report not found." });
        }

        // Check if assistance already exists for this report
        if (await _context.Assistances.AnyAsync(c => c.DamageReportId == request.DamageReportId, cancellationToken))
        {
            return Result<AssistanceDto>.Failure(new[] { "Assistance already exists for this damage report." });
        }

        // Get active rule
        var rule = await _context.AssistanceRules
            .FirstOrDefaultAsync(r => r.IsActive, cancellationToken);

        if (rule == null)
        {
            return Result<AssistanceDto>.Failure(new[] { "No active assistance rule found." });
        }

        var calculatedAmount = _assistanceService.Calculate(report, rule);

        var assistance = new Assistance
        {
            Id = Guid.NewGuid(),
            ClientId = request.ClientId,
            DamageReportId = request.DamageReportId,
            RuleId = rule.Id,
            CalculatedAmount = calculatedAmount,
            ApprovedAmount = calculatedAmount,
            Status = AssistanceStatus.Calculated,
            Remarks = request.Remarks,
            CreatedAt = DateTime.UtcNow
        };

        assistance.AuditLogs.Add(new AssistanceAuditLog
        {
            Id = Guid.NewGuid(),
            PreviousStatus = "None",
            NewStatus = AssistanceStatus.Calculated,
            ChangedBy = _currentUserService.UserName ?? "System",
            ChangedAt = DateTime.UtcNow,
            Reason = "Initial calculation"
        });

        _context.Assistances.Add(assistance);
        await _context.SaveChangesAsync(cancellationToken);

        return Result<AssistanceDto>.Success(MapToDto(assistance));
    }

    private static AssistanceDto MapToDto(Assistance assistance) => new()
    {
        Id = assistance.Id,
        ClientId = assistance.ClientId,
        DamageReportId = assistance.DamageReportId,
        CalculatedAmount = assistance.CalculatedAmount,
        ApprovedAmount = assistance.ApprovedAmount,
        Status = assistance.Status,
        Remarks = assistance.Remarks,
        RowVersion = Convert.ToBase64String(assistance.RowVersion)
    };
}

public class CreateAssistanceCommandValidator : AbstractValidator<CreateAssistanceCommand>
{
    public CreateAssistanceCommandValidator()
    {
        RuleFor(v => v.ClientId).NotEmpty();
        RuleFor(v => v.DamageReportId).NotEmpty();
    }
}
