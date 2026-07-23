using FluentValidation;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Models;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Hasad.Application.Features.DamageReports.Commands.UpdateDamageItem;

public record UpdateDamageItemCommand(
    Guid Id,
    int ClassificationId,
    Guid CostingSheetId,
    decimal CalculatedUnitPrice,
    string MeasurementUnitSnapshot,
    decimal AffectedArea,
    decimal DamagePercentage,
    decimal Quantity,
    decimal EstimatedLoss,
    string RowVersion) : IRequest<Result<DamageItemDto>>;

public class UpdateDamageItemCommandHandler : IRequestHandler<UpdateDamageItemCommand, Result<DamageItemDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;
    private readonly ICostingService _costingService;
    private readonly ILogger<UpdateDamageItemCommandHandler> _logger;

    public UpdateDamageItemCommandHandler(
        IApplicationDbContext context,
        ICurrentUserService currentUser,
        ICostingService costingService,
        ILogger<UpdateDamageItemCommandHandler> logger)
    {
        _context = context;
        _currentUser = currentUser;
        _costingService = costingService;
        _logger = logger;
    }

    public async Task<Result<DamageItemDto>> Handle(UpdateDamageItemCommand request, CancellationToken cancellationToken)
    {
        var item = await _context.DamageItems
            .Include(i => i.DamageReport)
            .FirstOrDefaultAsync(i => i.Id == request.Id, cancellationToken);

        if (item == null)
        {
            return Result<DamageItemDto>.Failure(new[] { "Damage item not found." });
        }

        // Authorization Inheritance (Rule 4)
        if (item.DamageReport == null)
        {
            return Result<DamageItemDto>.Failure(new[] { "Parent damage report not found." });
        }

        if (_currentUser.IsInRole(AppRoles.AgriculturalEngineer) || _currentUser.IsInRole(AppRoles.FieldSurveyor))
        {
            if (_currentUser.DirectorateId.HasValue && item.DamageReport.DirectorateId != _currentUser.DirectorateId.Value)
            {
                return Result<DamageItemDto>.Failure(new[] { "Access Denied: You can only manage items within your assigned directorate." });
            }
        }
        else if (_currentUser.IsInRole(AppRoles.Director))
        {
            if (_currentUser.GovernorateId.HasValue && item.DamageReport.GovernorateId != _currentUser.GovernorateId.Value)
            {
                return Result<DamageItemDto>.Failure(new[] { "Access Denied: You can only manage items within your assigned governorate." });
            }
        }

        // Concurrency
        byte[] expectedVersion = Convert.FromBase64String(request.RowVersion);
        if (!item.RowVersion.SequenceEqual(expectedVersion))
        {
            return Result<DamageItemDto>.Failure(new[] { "CONFLICT: The record has been modified by another user." });
        }

        // Valuation & Costing Resolution (Rule: Backend is Authoritative)
        var priceResult = await _costingService.GetUnitPriceAsync(request.ClassificationId, request.CostingSheetId, item.DamageReport.DamageDate, cancellationToken);
        if (!priceResult.Succeeded)
        {
            return Result<DamageItemDto>.Failure(priceResult.Errors);
        }

        decimal unitPrice = priceResult.Data;
        decimal backendCalculatedLoss = request.Quantity * unitPrice * (request.DamagePercentage / 100);

        // Client Audit
        if (Math.Abs(backendCalculatedLoss - request.EstimatedLoss) > 0.01m)
        {
            _logger.LogWarning("Valuation Mismatch during Update for Item {Id}: Client sent {ClientLoss}, Backend calculated {BackendLoss}",
                item.Id, request.EstimatedLoss, backendCalculatedLoss);
        }

        item.ClassificationId = request.ClassificationId;
        item.CostingSheetItemId = request.CostingSheetId;
        item.CalculatedUnitPrice = unitPrice; // Authority price
        item.MeasurementUnitSnapshot = request.MeasurementUnitSnapshot;
        item.AffectedArea = request.AffectedArea;
        item.DamagePercentage = request.DamagePercentage;
        item.Quantity = request.Quantity;
        item.EstimatedLoss = backendCalculatedLoss; // Authority loss
        item.UpdatedAt = DateTime.UtcNow;

        try
        {
            await _context.SaveChangesAsync(cancellationToken);
        }
        catch (DbUpdateConcurrencyException)
        {
            return Result<DamageItemDto>.Failure(new[] { "CONFLICT: The record has been modified by another user." });
        }

        return Result<DamageItemDto>.Success(new DamageItemDto
        {
            Id = item.Id,
            ClientId = item.ClientId,
            ClassificationId = item.ClassificationId,
            CostingSheetId = item.CostingSheetItemId,
            CalculatedUnitPrice = item.CalculatedUnitPrice,
            MeasurementUnitSnapshot = item.MeasurementUnitSnapshot,
            AffectedArea = item.AffectedArea,
            DamagePercentage = item.DamagePercentage,
            Quantity = item.Quantity,
            EstimatedLoss = item.EstimatedLoss,
            RowVersion = Convert.ToBase64String(item.RowVersion)
        });
    }
}

public class UpdateDamageItemCommandValidator : AbstractValidator<UpdateDamageItemCommand>
{
    public UpdateDamageItemCommandValidator()
    {
        RuleFor(v => v.Id).NotEmpty();
        RuleFor(v => v.ClassificationId).NotEmpty();
        RuleFor(v => v.DamagePercentage).InclusiveBetween(0, 100);
        RuleFor(v => v.RowVersion).NotEmpty();
    }
}
