using FluentValidation;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Models;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Hasad.Application.Features.DamageReports.Commands.CreateDamageReport;

public record CreateDamageItemInput(
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
    decimal EstimatedLoss);

public record CreateDamageReportCommand(
    Guid ClientId,
    string TemporaryFormNumber,
    Guid FarmId,
    DateTime DamageDate,
    int AgriculturalSectorId,
    int DamageCauseCategoryId,
    int DamageCauseId,
    string? SettlementName,
    string? CompanyName,
    string Notes,
    List<CreateDamageItemInput>? Items = null) : IRequest<Result<DamageReportDto>>;

public class CreateDamageReportCommandHandler : IRequestHandler<CreateDamageReportCommand, Result<DamageReportDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;
    private readonly IDamageReportNumberService _numberService;
    private readonly ICostingService _costingService;
    private readonly ILogger<CreateDamageReportCommandHandler> _logger;

    public CreateDamageReportCommandHandler(
        IApplicationDbContext context,
        ICurrentUserService currentUser,
        IDamageReportNumberService numberService,
        ICostingService costingService,
        ILogger<CreateDamageReportCommandHandler> logger)
    {
        _context = context;
        _currentUser = currentUser;
        _numberService = numberService;
        _costingService = costingService;
        _logger = logger;
    }

    public async Task<Result<DamageReportDto>> Handle(CreateDamageReportCommand request, CancellationToken cancellationToken)
    {
        // 1. Validation: Farm must exist
        var farm = await _context.Farms
            .Include(f => f.Farmer) // Needed for DTO mapping
            .FirstOrDefaultAsync(f => f.Id == request.FarmId, cancellationToken);

        if (farm == null)
        {
            return Result<DamageReportDto>.Failure(new[] { "Farm not found." });
        }

        // 2. Authorization check
        if (_currentUser.IsInRole("AgriculturalEngineer") || _currentUser.IsInRole("FieldSurveyor"))
        {
            if (_currentUser.DirectorateId.HasValue && farm.DirectorateId != _currentUser.DirectorateId.Value)
            {
                return Result<DamageReportDto>.Failure(new[] { "Access Denied: You can only create reports for farms within your assigned directorate." });
            }
        }
        else if (_currentUser.IsInRole("Director"))
        {
            if (_currentUser.GovernorateId.HasValue && farm.GovernorateId != _currentUser.GovernorateId.Value)
            {
                return Result<DamageReportDto>.Failure(new[] { "Access Denied: You can only manage reports within your assigned governorate." });
            }
        }

        // 3. Idempotency (ClientId)
        var existingByClientId = await _context.DamageReports
            .Include(r => r.Farm)
            .ThenInclude(f => f!.Farmer)
            .Include(r => r.Items)
            .FirstOrDefaultAsync(r => r.ClientId == request.ClientId, cancellationToken);

        if (existingByClientId != null)
        {
            return Result<DamageReportDto>.Success(MapToDto(existingByClientId));
        }

        // 4. Duplicate Prevention (Farm + Date) - Open existing if found
        var existingDuplicate = await _context.DamageReports
            .Include(r => r.Farm)
            .ThenInclude(f => f!.Farmer)
            .Include(r => r.Items)
            .FirstOrDefaultAsync(r => r.FarmId == request.FarmId &&
                                      r.DamageDate.Date == request.DamageDate.Date,
                                 cancellationToken);

        if (existingDuplicate != null)
        {
            return Result<DamageReportDto>.Success(MapToDto(existingDuplicate));
        }

        // 5. Generate Official Report Number
        var reportNumber = await _numberService.GeneratePermanentNumberAsync(farm.DirectorateId, request.DamageDate.Year, cancellationToken);

        // 6. Valuation & Costing Resolution (Authoritative Backend Calculation)
        var items = new List<DamageItem>();
        if (request.Items != null)
        {
            foreach (var itemInput in request.Items)
            {
                var priceResult = await _costingService.GetUnitPriceAsync(itemInput.ClassificationId, itemInput.CostingSheetId, request.DamageDate, cancellationToken);
                if (!priceResult.Succeeded)
                {
                    return Result<DamageReportDto>.Failure(priceResult.Errors);
                }

                decimal unitPrice = priceResult.Data;
                decimal backendCalculatedLoss = itemInput.Quantity * unitPrice * (itemInput.DamagePercentage / 100);

                // Client Audit
                if (Math.Abs(backendCalculatedLoss - itemInput.EstimatedLoss) > 0.01m)
                {
                    _logger.LogWarning("Valuation Mismatch for ClientId {ClientId}: Client sent {ClientLoss}, Backend calculated {BackendLoss}",
                        itemInput.ClientId, itemInput.EstimatedLoss, backendCalculatedLoss);
                }

                items.Add(new DamageItem
                {
                    Id = Guid.NewGuid(),
                    ClientId = itemInput.ClientId,
                    DamageNatureId = itemInput.DamageNatureId,
                    DamageActionId = itemInput.DamageActionId,
                    ClassificationId = itemInput.ClassificationId,
                    CostingSheetItemId = itemInput.CostingSheetId,
                    CalculatedUnitPrice = unitPrice, // Authority price
                    MeasurementUnitSnapshot = itemInput.MeasurementUnitSnapshot,
                    AffectedArea = itemInput.AffectedArea,
                    DamagePercentage = itemInput.DamagePercentage,
                    Quantity = itemInput.Quantity,
                    EstimatedLoss = backendCalculatedLoss, // Authority loss
                    CreatedAt = DateTime.UtcNow
                });
            }
        }

        var report = new DamageReport
        {
            Id = Guid.NewGuid(),
            ClientId = request.ClientId,
            ReportNumber = reportNumber,
            PermanentFormNumber = reportNumber,
            TemporaryFormNumber = request.TemporaryFormNumber,
            FarmId = request.FarmId,
            DamageDate = request.DamageDate,
            DocumentationDate = DateTime.UtcNow,
            AgriculturalSectorId = request.AgriculturalSectorId,
            DamageCauseCategoryId = request.DamageCauseCategoryId,
            DamageCauseId = request.DamageCauseId,
            SettlementName = request.SettlementName,
            CompanyName = request.CompanyName,
            StatusId = DamageReportStatus.PendingTechnicalVerification,
            Notes = request.Notes,
            CreatedAt = DateTime.UtcNow,
            Items = items
        };

        _context.DamageReports.Add(report);
        await _context.SaveChangesAsync(cancellationToken);

        // Reload to ensure Farm is included for DTO
        report.Farm = farm;

        return Result<DamageReportDto>.Success(MapToDto(report));
    }

    private static DamageReportDto MapToDto(DamageReport report) => new()
    {
        Id = report.Id,
        ClientId = report.ClientId,
        ReportNumber = report.ReportNumber,
        PermanentFormNumber = report.PermanentFormNumber,
        TemporaryFormNumber = report.TemporaryFormNumber,
        DamageYear = report.DamageDate.Year,
        FarmId = report.FarmId,
        FarmerId = report.Farm?.FarmerId ?? Guid.Empty,
        DamageDate = report.DamageDate,
        DocumentationDate = report.DocumentationDate,
        AgriculturalSectorId = report.AgriculturalSectorId,
        DamageCauseCategoryId = report.DamageCauseCategoryId,
        DamageCauseId = report.DamageCauseId,
        SettlementName = report.SettlementName,
        CompanyName = report.CompanyName,
        GovernorateId = report.Farm?.GovernorateId ?? Guid.Empty,
        DirectorateId = report.Farm?.DirectorateId ?? Guid.Empty,
        LocalityId = report.Farm?.LocalityId ?? Guid.Empty,
        Latitude = report.Farm?.Latitude,
        Longitude = report.Farm?.Longitude,
        StatusId = report.StatusId,
        Notes = report.Notes,
        RowVersion = Convert.ToBase64String(report.RowVersion),
        Items = report.Items.Select(i => new DamageItemDto
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
        }).ToList()
    };
}

public class CreateDamageReportCommandValidator : AbstractValidator<CreateDamageReportCommand>
{
    public CreateDamageReportCommandValidator()
    {
        RuleFor(v => v.ClientId).NotEmpty();
        RuleFor(v => v.FarmId).NotEmpty();
        RuleFor(v => v.DamageDate).NotEmpty().LessThanOrEqualTo(DateTime.UtcNow);

        When(v => v.Items != null, () =>
        {
            RuleForEach(v => v.Items!).SetValidator(new CreateDamageItemInputValidator());
        });
    }
}

public class CreateDamageItemInputValidator : AbstractValidator<CreateDamageItemInput>
{
    public CreateDamageItemInputValidator()
    {
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
