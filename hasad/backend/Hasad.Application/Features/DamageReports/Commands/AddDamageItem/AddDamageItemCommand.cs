using FluentValidation;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Models;
using Hasad.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.DamageReports.Commands.AddDamageItem;

public record AddDamageItemCommand(
    Guid DamageReportId,
    Guid ClientId,
    int ClassificationId,
    Guid CostingSheetId,
    decimal CalculatedUnitPrice,
    string MeasurementUnitSnapshot,
    decimal AffectedArea,
    decimal DamagePercentage,
    decimal Quantity,
    decimal EstimatedLoss) : IRequest<Result<DamageItemDto>>;

public class AddDamageItemCommandHandler : IRequestHandler<AddDamageItemCommand, Result<DamageItemDto>>
{
    private readonly IApplicationDbContext _context;

    public AddDamageItemCommandHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Result<DamageItemDto>> Handle(AddDamageItemCommand request, CancellationToken cancellationToken)
    {
        // Idempotency
        var existing = await _context.DamageItems
            .AsNoTracking()
            .FirstOrDefaultAsync(i => i.ClientId == request.ClientId, cancellationToken);

        if (existing != null)
        {
            return Result<DamageItemDto>.Success(MapToDto(existing));
        }

        if (!await _context.DamageReports.AnyAsync(r => r.Id == request.DamageReportId, cancellationToken))
        {
            return Result<DamageItemDto>.Failure(new[] { "Damage report not found." });
        }

        var item = new DamageItem
        {
            Id = Guid.NewGuid(),
            ClientId = request.ClientId,
            DamageReportId = request.DamageReportId,
            ClassificationId = request.ClassificationId,
            CostingSheetItemId = request.CostingSheetId,
            CalculatedUnitPrice = request.CalculatedUnitPrice,
            MeasurementUnitSnapshot = request.MeasurementUnitSnapshot,
            AffectedArea = request.AffectedArea,
            DamagePercentage = request.DamagePercentage,
            Quantity = request.Quantity,
            EstimatedLoss = request.EstimatedLoss,
            CreatedAt = DateTime.UtcNow
        };

        _context.DamageItems.Add(item);
        await _context.SaveChangesAsync(cancellationToken);

        return Result<DamageItemDto>.Success(MapToDto(item));
    }

    private static DamageItemDto MapToDto(DamageItem i) => new()
    {
        Id = i.Id,
        ClientId = i.ClientId,
        ClassificationId = i.ClassificationId,
        CostingSheetId = i.CostingSheetItemId,
        CalculatedUnitPrice = i.CalculatedUnitPrice,
        MeasurementUnitSnapshot = i.MeasurementUnitSnapshot,
        AffectedArea = i.AffectedArea,
        DamagePercentage = i.DamagePercentage,
        Quantity = i.Quantity,
        EstimatedLoss = i.EstimatedLoss,
        RowVersion = Convert.ToBase64String(i.RowVersion)
    };
}

public class AddDamageItemCommandValidator : AbstractValidator<AddDamageItemCommand>
{
    public AddDamageItemCommandValidator()
    {
        RuleFor(v => v.DamageReportId).NotEmpty();
        RuleFor(v => v.ClientId).NotEmpty();
        RuleFor(v => v.ClassificationId).NotEmpty();
        RuleFor(v => v.DamagePercentage).InclusiveBetween(0, 100);
    }
}
