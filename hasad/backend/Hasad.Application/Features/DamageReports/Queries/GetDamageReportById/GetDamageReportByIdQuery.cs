using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Models;
using Hasad.Domain.Constants;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.DamageReports.Queries.GetDamageReportById;

public record GetDamageReportByIdQuery(Guid Id) : IRequest<Result<DamageReportDto>>;

public class GetDamageReportByIdQueryHandler : IRequestHandler<GetDamageReportByIdQuery, Result<DamageReportDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public GetDamageReportByIdQueryHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<DamageReportDto>> Handle(GetDamageReportByIdQuery request, CancellationToken cancellationToken)
    {
        var report = await _context.DamageReports
            .AsNoTracking()
            .Include(r => r.Farm)
            .ThenInclude(f => f!.Farmer)
            .Include(r => r.Items)
            .FirstOrDefaultAsync(r => r.Id == request.Id, cancellationToken);

        if (report == null)
        {
            return Result<DamageReportDto>.Failure(new[] { "Damage report not found." });
        }

        // Authorization check
        if (_currentUser.IsInRole(AppRoles.AgriculturalEngineer) || _currentUser.IsInRole(AppRoles.FieldSurveyor))
        {
            if (_currentUser.DirectorateId.HasValue && report.Farm?.DirectorateId != _currentUser.DirectorateId.Value)
            {
                return Result<DamageReportDto>.Failure(new[] { "Access Denied: This report is outside your assigned directorate scope." });
            }
        }
        else if (_currentUser.IsInRole(AppRoles.Director))
        {
            if (_currentUser.GovernorateId.HasValue && report.Farm?.GovernorateId != _currentUser.GovernorateId.Value)
            {
                return Result<DamageReportDto>.Failure(new[] { "Access Denied: This report is outside your assigned governorate scope." });
            }
        }

        return Result<DamageReportDto>.Success(new DamageReportDto
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
        });
    }
}
