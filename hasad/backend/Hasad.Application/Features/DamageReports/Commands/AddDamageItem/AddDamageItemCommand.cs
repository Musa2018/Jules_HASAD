using FluentValidation;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Models;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Hasad.Application.Features.DamageReports.Commands.AddDamageItem;

public record AddDamageItemCommand(
    Guid DamageReportId,
    Guid ClientId,
    int DamageNatureId,
    int DamageActionId,
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
    private readonly ICurrentUserService _currentUser;
    private readonly ICostingService _costingService;
    private readonly ILogger<AddDamageItemCommandHandler> _logger;

    public AddDamageItemCommandHandler(IApplicationDbContext context, ICurrentUserService currentUser, ICostingService costingService, ILogger<AddDamageItemCommandHandler> logger)
    {
        _context = context;
        _currentUser = currentUser;
        _costingService = costingService;
        _logger = logger;
    }

    public async Task<Result<DamageItemDto>> Handle(AddDamageItemCommand request, CancellationToken cancellationToken)
    {
        _logger.LogInformation("Processing AddDamageItem for Report {ReportId}, ClientId {ClientId}", request.DamageReportId, request.ClientId);

        // Idempotency
        var existing = await _context.DamageItems
            .AsNoTracking()
            .FirstOrDefaultAsync(i => i.ClientId == request.ClientId, cancellationToken);

        if (existing != null)
        {
            _logger.LogInformation("AddDamageItem: Item already exists for ClientId {ClientId}", request.ClientId);
            return Result<DamageItemDto>.Success(MapToDto(existing));
        }

        var report = await _context.DamageReports
            .Include(r => r.Items)
            .FirstOrDefaultAsync(r => r.Id == request.DamageReportId, cancellationToken);

        if (report == null)
        {
            _logger.LogWarning("AddDamageItem: Report {ReportId} not found.", request.DamageReportId);
            return Result<DamageItemDto>.Failure(new[] { "Damage report not found." });
        }

        // Authorization check
        if (_currentUser.IsInRole(AppRoles.AgriculturalEngineer) || _currentUser.IsInRole(AppRoles.FieldSurveyor))
        {
            if (_currentUser.DirectorateId.HasValue && report.DirectorateId != _currentUser.DirectorateId.Value)
            {
                return Result<DamageItemDto>.Failure(new[] { "Access Denied: You can only add items to reports within your assigned directorate." });
            }
        }
        else if (_currentUser.IsInRole(AppRoles.Director))
        {
            if (_currentUser.GovernorateId.HasValue && report.GovernorateId != _currentUser.GovernorateId.Value)
            {
                return Result<DamageItemDto>.Failure(new[] { "Access Denied: You can only add items to reports within your assigned governorate." });
            }
        }

        _logger.LogInformation("AddDamageItem: Report {ReportId} found with StatusId: {StatusId}", report.Id, report.StatusId);

        // 6. Valuation Security: Authoritative Recalculation (Sprint 15.0)
        var priceResult = await _costingService.GetUnitPriceAsync(request.ClassificationId, request.CostingSheetId, report.DamageDate, cancellationToken);
        if (!priceResult.Succeeded)
        {
            return Result<DamageItemDto>.Failure(priceResult.Errors);
        }

        decimal unitPrice = priceResult.Data;
        decimal backendCalculatedLoss = request.Quantity * unitPrice * (request.DamagePercentage / 100);

        // Malicious Payload Detection
        if (Math.Abs(backendCalculatedLoss - request.EstimatedLoss) > 0.01m || Math.Abs(unitPrice - request.CalculatedUnitPrice) > 0.01m)
        {
            _logger.LogWarning("Security Audit: Valuation Mismatch for Report {ReportId}. Client sent [Price:{ClientPrice}, Loss:{ClientLoss}], Backend resolved [Price:{BackendPrice}, Loss:{BackendLoss}]",
                request.DamageReportId, request.CalculatedUnitPrice, request.EstimatedLoss, unitPrice, backendCalculatedLoss);
        }

        var item = new DamageItem
        {
            Id = Guid.NewGuid(),
            ClientId = request.ClientId,
            DamageReportId = request.DamageReportId,
            DamageNatureId = request.DamageNatureId,
            DamageActionId = request.DamageActionId,
            ClassificationId = request.ClassificationId,
            CostingSheetItemId = request.CostingSheetId,
            CalculatedUnitPrice = unitPrice, // Authority price
            MeasurementUnitSnapshot = request.MeasurementUnitSnapshot,
            AffectedArea = request.AffectedArea,
            DamagePercentage = request.DamagePercentage,
            Quantity = request.Quantity,
            EstimatedLoss = backendCalculatedLoss, // Authority loss
            CreatedAt = DateTime.UtcNow
        };

        _context.DamageItems.Add(item);

        // Update TotalDamage on Report
        report.TotalDamage = report.Items.Sum(i => i.EstimatedLoss) + backendCalculatedLoss;

        await _context.SaveChangesAsync(cancellationToken);

        return Result<DamageItemDto>.Success(MapToDto(item));
    }

    private static DamageItemDto MapToDto(DamageItem i) => new()
    {
        Id = i.Id,
        ClientId = i.ClientId,
        DamageNatureId = i.DamageNatureId,
        DamageActionId = i.DamageActionId,
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
        RuleFor(v => v.DamageNatureId).NotEmpty();
        RuleFor(v => v.DamageActionId).NotEmpty();
        RuleFor(v => v.ClassificationId).NotEmpty();
        RuleFor(v => v.CostingSheetId).NotEmpty();
        RuleFor(v => v.CalculatedUnitPrice).GreaterThan(0);
        RuleFor(v => v.MeasurementUnitSnapshot).NotEmpty();
        RuleFor(v => v.DamagePercentage).InclusiveBetween(0, 100);
        RuleFor(v => v.AffectedArea).GreaterThanOrEqualTo(0);
        RuleFor(v => v.EstimatedLoss).GreaterThanOrEqualTo(0);
    }
}
