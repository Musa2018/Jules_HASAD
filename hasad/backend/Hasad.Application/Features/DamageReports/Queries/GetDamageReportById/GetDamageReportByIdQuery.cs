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
    private readonly IFileStorageService _fileStorage;

    public GetDamageReportByIdQueryHandler(IApplicationDbContext context, ICurrentUserService currentUser, IFileStorageService fileStorage)
    {
        _context = context;
        _currentUser = currentUser;
        _fileStorage = fileStorage;
    }

    public async Task<Result<DamageReportDto>> Handle(GetDamageReportByIdQuery request, CancellationToken cancellationToken)
    {
        var report = await _context.DamageReports
            .AsNoTracking()
            .Include(r => r.Items)
            .Include(r => r.Attachments)
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
                return Result<DamageReportDto>.Failure(new[] { "Access Denied: This report is outside your assigned directorate scope." });
            }
        }
        else if (_currentUser.IsInRole(AppRoles.Director))
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
            ReportNumber = report.ReportNumber,
            PermanentFormNumber = report.PermanentFormNumber,
            TemporaryFormNumber = report.TemporaryFormNumber,
            DamageYear = report.DamageYear,
            FarmId = report.FarmId,
            FarmerId = report.FarmerId,
            DamageDate = report.DamageDate,
            DocumentationDate = report.DocumentationDate,
            AgriculturalSectorId = report.AgriculturalSectorId,
            DamageCauseCategoryId = report.DamageCauseCategoryId,
            DamageCauseId = report.DamageCauseId,
            GovernorateId = report.GovernorateId,
            DirectorateId = report.DirectorateId,
            LocalityId = report.LocalityId,
            StatusId = report.StatusId,
            TotalDamage = report.TotalDamage,
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
            }).ToList(),
            Attachments = report.Attachments.Select(a => new AttachmentDto
            {
                Id = a.Id,
                ClientId = a.ClientId,
                DocumentName = a.DocumentName,
                DocumentDate = a.DocumentDate,
                DocumentTypeId = a.DocumentTypeId,
                RemoteUrl = _fileStorage.GetUrl(a.RemotePath),
                FileType = a.FileType,
                FileSize = a.FileSize,
                UploadStatus = a.UploadStatus,
                RowVersion = Convert.ToBase64String(a.RowVersion)
            }).ToList()
        });
    }
}
