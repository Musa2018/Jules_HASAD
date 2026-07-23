using FluentValidation;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Models;
using Hasad.Domain.Constants;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.DamageReports.Commands.UpdateDamageReport;

public record UpdateDamageReportCommand(
    Guid Id,
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
    string RowVersion) : IRequest<Result<DamageReportDto>>;

public class UpdateDamageReportCommandHandler : IRequestHandler<UpdateDamageReportCommand, Result<DamageReportDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public UpdateDamageReportCommandHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<DamageReportDto>> Handle(UpdateDamageReportCommand request, CancellationToken cancellationToken)
    {
        var report = await _context.DamageReports
            .Include(r => r.Items)
            .FirstOrDefaultAsync(r => r.Id == request.Id, cancellationToken);

        if (report == null)
        {
            return Result<DamageReportDto>.Failure(new[] { "Damage report not found." });
        }

        // Authorization check
        if (_currentUser.IsInRole(AppRoles.AgriculturalEngineer) || _currentUser.IsInRole(AppRoles.FieldSurveyor))
        {
            if (_currentUser.DirectorateId.HasValue && report.DirectorateId != _currentUser.DirectorateId.Value)
            {
                return Result<DamageReportDto>.Failure(new[] { "Access Denied: You can only manage reports within your assigned directorate." });
            }
        }
        else if (_currentUser.IsInRole(AppRoles.Director))
        {
            if (_currentUser.GovernorateId.HasValue && report.GovernorateId != _currentUser.GovernorateId.Value)
            {
                return Result<DamageReportDto>.Failure(new[] { "Access Denied: You can only manage reports within your assigned governorate." });
            }
        }

        // Immutability Rule: DirectorateId cannot be changed independently of the Farm link.
        // We don't expose DirectorateId in the command anyway, but we should ensure the report's geographic integrity.
        // Rule: On update, DirectorateId MUST never be changed independently (Rule 2).
        // Since it's not in the command, we just don't touch it.
        // If the user wants to move the report to a different farm, that's a different operation (not supported yet).

        // Optimistic concurrency
        byte[] expectedVersion = Convert.FromBase64String(request.RowVersion);
        if (!report.RowVersion.SequenceEqual(expectedVersion))
        {
            return Result<DamageReportDto>.Failure(new[] { "CONFLICT: The record has been modified by another user." });
        }

        // Duplicate Prevention (Farm + Date + Cause) - Check if date or cause changed
        if (report.DamageDate.Date != request.DamageDate.Date || report.DamageCauseId != request.DamageCauseId)
        {
            var existingDuplicate = await _context.DamageReports
                .AsNoTracking()
                .AnyAsync(r => r.Id != request.Id &&
                               r.FarmId == report.FarmId &&
                               r.DamageDate.Date == request.DamageDate.Date &&
                               r.DamageCauseId == request.DamageCauseId,
                          cancellationToken);

            if (existingDuplicate)
            {
                return Result<DamageReportDto>.Failure(new[] { "A damage report already exists for this farm, date, and cause." });
            }
        }

        report.DamageDate = request.DamageDate;
        report.DamageCauseCategoryId = request.DamageCauseCategoryId;
        report.DamageCauseId = request.DamageCauseId;
        report.SettlementName = request.SettlementName;
        report.CompanyName = request.CompanyName;
        report.GovernorateId = request.GovernorateId;
        report.LocalityId = request.LocalityId;
        report.Latitude = request.Latitude;
        report.Longitude = request.Longitude;
        report.Notes = request.Notes;
        report.UpdatedAt = DateTime.UtcNow;

        try
        {
            await _context.SaveChangesAsync(cancellationToken);
        }
        catch (DbUpdateConcurrencyException)
        {
            return Result<DamageReportDto>.Failure(new[] { "CONFLICT: The record has been modified by another user." });
        }

        return Result<DamageReportDto>.Success(new DamageReportDto
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
            DirectorateId = report.DirectorateId,
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
        });
    }
}

public class UpdateDamageReportCommandValidator : AbstractValidator<UpdateDamageReportCommand>
{
    public UpdateDamageReportCommandValidator()
    {
        RuleFor(v => v.Id).NotEmpty();
        RuleFor(v => v.DamageDate).NotEmpty().LessThanOrEqualTo(DateTime.UtcNow);
        RuleFor(v => v.DamageCauseCategoryId).NotEmpty();
        RuleFor(v => v.DamageCauseId).NotEmpty();
        RuleFor(v => v.GovernorateId).NotEmpty();
        RuleFor(v => v.LocalityId).NotEmpty();
        RuleFor(v => v.RowVersion).NotEmpty();
    }
}
