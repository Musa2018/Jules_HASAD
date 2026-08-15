using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Hasad.Domain.Constants;

namespace Hasad.Application.Features.DamageReports.Queries.GetDamageReportsList;

public record GetDamageReportsListQuery(
    int PageNumber = 1,
    int PageSize = 10,
    string? SearchText = null,
    DateTime? UpdatedSince = null) : IRequest<Result<PaginatedList<DamageReportDto>>>;

public class GetDamageReportsListQueryHandler : IRequestHandler<GetDamageReportsListQuery, Result<PaginatedList<DamageReportDto>>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public GetDamageReportsListQueryHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<PaginatedList<DamageReportDto>>> Handle(GetDamageReportsListQuery request, CancellationToken cancellationToken)
    {
        var query = _context.DamageReports.AsNoTracking();

        // 1. Authorization Scoping
        if (_currentUser.IsInRole(AppRoles.AgriculturalEngineer) || _currentUser.IsInRole(AppRoles.FieldSurveyor))
        {
            if (_currentUser.DirectorateId.HasValue)
            {
                query = query.Where(r => r.DirectorateId == _currentUser.DirectorateId.Value);
            }
        }
        else if (_currentUser.IsInRole(AppRoles.Director))
        {
            if (_currentUser.GovernorateId.HasValue)
            {
                query = query.Where(r => r.GovernorateId == _currentUser.GovernorateId.Value);
            }
        }

        // 2. Incremental Sync (Pull Watermark)
        if (request.UpdatedSince.HasValue)
        {
            query = query.Where(r => r.UpdatedAt > request.UpdatedSince.Value || r.CreatedAt > request.UpdatedSince.Value);
        }

        // 3. Search Filtering
        if (!string.IsNullOrWhiteSpace(request.SearchText))
        {
            var search = request.SearchText.ToLower();
            query = query.Where(r =>
                r.ReportNumber.ToLower().Contains(search) ||
                r.PermanentFormNumber.ToLower().Contains(search) ||
                r.TemporaryFormNumber.ToLower().Contains(search));
        }

        var count = await query.CountAsync(cancellationToken);

        var dbItems = await query
            .OrderByDescending(r => r.DamageDate)
            .Skip((request.PageNumber - 1) * request.PageSize)
            .Take(request.PageSize)
            .Include(r => r.Items)
            .ToListAsync(cancellationToken);

        var items = dbItems.Select(r => new DamageReportDto
        {
            Id = r.Id,
            ClientId = r.ClientId,
            ReportNumber = r.ReportNumber,
            PermanentFormNumber = r.PermanentFormNumber,
            TemporaryFormNumber = r.TemporaryFormNumber,
            DamageYear = r.DamageYear,
            FarmId = r.FarmId,
            FarmerId = r.FarmerId,
            DamageDate = r.DamageDate,
            DocumentationDate = r.DocumentationDate,
            AgriculturalSectorId = r.AgriculturalSectorId,
            DamageCauseCategoryId = r.DamageCauseCategoryId,
            DamageCauseId = r.DamageCauseId,
            GovernorateId = r.GovernorateId,
            DirectorateId = r.DirectorateId,
            LocalityId = r.LocalityId,
            StatusId = r.StatusId,
            TotalDamage = r.TotalDamage,
            Notes = r.Notes,
            RowVersion = Convert.ToBase64String(r.RowVersion),
            Items = r.Items.Select(i => new DamageItemDto
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
        }).ToList();

        var paginatedList = new PaginatedList<DamageReportDto>
        {
            Items = items,
            TotalCount = count,
            PageNumber = request.PageNumber,
            TotalPages = (int)Math.Ceiling(count / (double)request.PageSize)
        };

        return Result<PaginatedList<DamageReportDto>>.Success(paginatedList);
    }
}
