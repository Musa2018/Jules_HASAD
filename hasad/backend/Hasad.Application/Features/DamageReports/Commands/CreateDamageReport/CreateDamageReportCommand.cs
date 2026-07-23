using FluentValidation;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Models;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.DamageReports.Commands.CreateDamageReport;

public record CreateDamageItemInput(
    Guid ClientId,
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
    int DamageYear,
    Guid FarmId,
    Guid FarmerId,
    DateTime DamageDate,
    int DamageCauseCategoryId,
    int DamageCauseId,
    string? SettlementName,
    string? CompanyName,
    Guid GovernorateId,
    Guid LocalityId,
    double? Latitude,
    double? Longitude,
    string Notes,
    List<CreateDamageItemInput> Items) : IRequest<Result<DamageReportDto>>;

public class CreateDamageReportCommandHandler : IRequestHandler<CreateDamageReportCommand, Result<DamageReportDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;
    private readonly IDamageReportNumberService _numberService;

    public CreateDamageReportCommandHandler(
        IApplicationDbContext context,
        ICurrentUserService currentUser,
        IDamageReportNumberService numberService)
    {
        _context = context;
        _currentUser = currentUser;
        _numberService = numberService;
    }

    public async Task<Result<DamageReportDto>> Handle(CreateDamageReportCommand request, CancellationToken cancellationToken)
    {
        // 1. Validation: Farm and Farmer must exist
        var farm = await _context.Farms
            .AsNoTracking()
            .FirstOrDefaultAsync(f => f.Id == request.FarmId, cancellationToken);

        if (farm == null)
        {
            return Result<DamageReportDto>.Failure(new[] { "Farm not found." });
        }
        if (!await _context.Farmers.AnyAsync(f => f.Id == request.FarmerId, cancellationToken))
        {
            return Result<DamageReportDto>.Failure(new[] { "Farmer not found." });
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
            .AsNoTracking()
            .Include(r => r.Items)
            .FirstOrDefaultAsync(r => r.ClientId == request.ClientId, cancellationToken);

        if (existingByClientId != null)
        {
            return Result<DamageReportDto>.Success(MapToDto(existingByClientId));
        }

        // 4. Duplicate Prevention (Farm + Date + Cause)
        var existingDuplicate = await _context.DamageReports
            .AsNoTracking()
            .AnyAsync(r => r.FarmId == request.FarmId &&
                           r.DamageDate.Date == request.DamageDate.Date &&
                           r.DamageCauseId == request.DamageCauseId,
                      cancellationToken);

        if (existingDuplicate)
        {
            return Result<DamageReportDto>.Failure(new[] { "A damage report already exists for this farm, date, and cause." });
        }

        // 5. Generate Permanent Number
        var permanentNumber = await _numberService.GeneratePermanentNumberAsync(farm.DirectorateId, request.DamageYear, cancellationToken);

        var report = new DamageReport
        {
            Id = Guid.NewGuid(),
            ClientId = request.ClientId,
            PermanentFormNumber = permanentNumber,
            TemporaryFormNumber = request.TemporaryFormNumber,
            DamageYear = request.DamageYear,
            FarmId = request.FarmId,
            FarmerId = request.FarmerId,
            DamageDate = request.DamageDate,
            DocumentationDate = DateTime.UtcNow,
            DamageCauseCategoryId = request.DamageCauseCategoryId,
            DamageCauseId = request.DamageCauseId,
            SettlementName = request.SettlementName,
            CompanyName = request.CompanyName,
            GovernorateId = request.GovernorateId,
            DirectorateId = farm.DirectorateId, // Denormalized from Farm (Rule 1)
            LocalityId = request.LocalityId,
            Latitude = request.Latitude,
            Longitude = request.Longitude,
            StatusId = DamageReportStatus.Draft,
            Notes = request.Notes,
            CreatedAt = DateTime.UtcNow,
            Items = request.Items.Select(i => new DamageItem
            {
                Id = Guid.NewGuid(),
                ClientId = i.ClientId,
                ClassificationId = i.ClassificationId,
                CostingSheetId = i.CostingSheetId,
                CalculatedUnitPrice = i.CalculatedUnitPrice,
                MeasurementUnitSnapshot = i.MeasurementUnitSnapshot,
                AffectedArea = i.AffectedArea,
                DamagePercentage = i.DamagePercentage,
                Quantity = i.Quantity,
                EstimatedLoss = i.EstimatedLoss,
                CreatedAt = DateTime.UtcNow
            }).ToList()
        };

        _context.DamageReports.Add(report);
        await _context.SaveChangesAsync(cancellationToken);

        return Result<DamageReportDto>.Success(MapToDto(report));
    }

    private static DamageReportDto MapToDto(DamageReport report) => new()
    {
        Id = report.Id,
        ClientId = report.ClientId,
        PermanentFormNumber = report.PermanentFormNumber,
        TemporaryFormNumber = report.TemporaryFormNumber,
        DamageYear = report.DamageYear,
        FarmId = report.FarmId,
        FarmerId = report.FarmerId,
        DamageDate = report.DamageDate,
        DocumentationDate = report.DocumentationDate,
        DamageCauseCategoryId = report.DamageCauseCategoryId,
        DamageCauseId = report.DamageCauseId,
        SettlementName = report.SettlementName,
        CompanyName = report.CompanyName,
        GovernorateId = report.GovernorateId,
        LocalityId = report.LocalityId,
        Latitude = report.Latitude,
        Longitude = report.Longitude,
        StatusId = report.StatusId,
        Notes = report.Notes,
        RowVersion = Convert.ToBase64String(report.RowVersion),
        Items = report.Items.Select(i => new DamageItemDto
        {
            Id = i.Id,
            ClientId = i.ClientId,
            ClassificationId = i.ClassificationId,
            CostingSheetId = i.CostingSheetId,
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
        RuleFor(v => v.FarmerId).NotEmpty();
        RuleFor(v => v.DamageDate).NotEmpty().LessThanOrEqualTo(DateTime.UtcNow);
        RuleFor(v => v.GovernorateId).NotEmpty();
        RuleFor(v => v.LocalityId).NotEmpty();

        RuleForEach(v => v.Items).SetValidator(new CreateDamageItemInputValidator());
    }
}

public class CreateDamageItemInputValidator : AbstractValidator<CreateDamageItemInput>
{
    public CreateDamageItemInputValidator()
    {
        RuleFor(v => v.ClientId).NotEmpty();
        RuleFor(v => v.ClassificationId).NotEmpty();
        RuleFor(v => v.CostingSheetId).NotEmpty();
        RuleFor(v => v.CalculatedUnitPrice).GreaterThan(0);
        RuleFor(v => v.MeasurementUnitSnapshot).NotEmpty();
        RuleFor(v => v.DamagePercentage).InclusiveBetween(0, 100);
        RuleFor(v => v.AffectedArea).GreaterThanOrEqualTo(0);
        RuleFor(v => v.EstimatedLoss).GreaterThanOrEqualTo(0);
    }
}
