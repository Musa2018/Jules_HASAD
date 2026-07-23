using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Models;
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
            .Include(r => r.Items)
            .FirstOrDefaultAsync(r => r.Id == request.Id, cancellationToken);

        if (report == null)
        {
            return Result<DamageReportDto>.Failure(new[] { "Damage report not found." });
        }

        // Authorization check
        if (_currentUser.IsInRole("AgriculturalEngineer") || _currentUser.IsInRole("FieldSurveyor"))
        {
            if (_currentUser.DirectorateId.HasValue && report.DirectorateId != _currentUser.DirectorateId.Value)
            {
                return Result<DamageReportDto>.Failure(new[] { "Access Denied: This report is outside your assigned directorate scope." });
            }
        }
        else if (_currentUser.IsInRole("Director"))
        {
            if (_currentUser.GovernorateId.HasValue && report.GovernorateId != _currentUser.GovernorateId.Value)
            {
                return Result<DamageReportDto>.Failure(new[] { "Access Denied: This report is outside your assigned governorate scope." });
            }
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
