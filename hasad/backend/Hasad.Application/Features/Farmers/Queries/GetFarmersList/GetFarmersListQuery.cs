using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Farmers.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Farmers.Queries.GetFarmersList;

public record GetFarmersListQuery(int PageNumber = 1, int PageSize = 10) : IRequest<Result<PaginatedList<FarmerDto>>>;

public class GetFarmersListQueryHandler : IRequestHandler<GetFarmersListQuery, Result<PaginatedList<FarmerDto>>>
{
    private readonly IApplicationDbContext _context;

    public GetFarmersListQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Result<PaginatedList<FarmerDto>>> Handle(GetFarmersListQuery request, CancellationToken cancellationToken)
    {
        var query = _context.Farmers.AsNoTracking();

        var count = await query.CountAsync(cancellationToken);

        // 1. جلب البيانات الأساسية من SQL Server
        var dbItems = await query
            .OrderBy(f => f.FirstNameAr)
            .Skip((request.PageNumber - 1) * request.PageSize)
            .Take(request.PageSize)
            .Select(f => new
            {
                f.Id, f.ClientId, f.IdNumber, f.PhoneNumber, f.Address, f.RowVersion,
                f.IdTypeId, f.GovernorateId, f.LocalityId, f.BirthDate,
                f.FirstNameAr, f.FatherNameAr, f.GrandfatherNameAr, f.FamilyNameAr,
                f.FirstNameEn, f.FatherNameEn, f.GrandfatherNameEn, f.FamilyNameEn
            })
            .ToListAsync(cancellationToken);

        // 2. التحويل (Mapping) في الذاكرة لتفادي أخطاء الـ EF Core Translation
        var items = dbItems.Select(f => new FarmerDto
        {
            Id = f.Id,
            ClientId = f.ClientId,

            // دمج وتنسيق الأسماء مع إزالة الفراغات الزائدة
            Name = (f.FirstNameAr + " " + f.FatherNameAr + " " + f.GrandfatherNameAr + " " + f.FamilyNameAr).Trim(),
            NameEn = (f.FirstNameEn + " " + f.FatherNameEn + " " + f.GrandfatherNameEn + " " + f.FamilyNameEn).Trim(),

            NationalId = f.IdNumber,
            PhoneNumber = f.PhoneNumber,
            Address = f.Address,

            // الحقول الجديدة
            IdTypeId = f.IdTypeId,
            GovernorateId = f.GovernorateId,
            LocalityId = f.LocalityId,
            BirthDate = f.BirthDate,

            // الأسماء المفصلة
            FirstNameAr = f.FirstNameAr,
            FatherNameAr = f.FatherNameAr,
            GrandfatherNameAr = f.GrandfatherNameAr,
            FamilyNameAr = f.FamilyNameAr,

            FirstNameEn = f.FirstNameEn,
            FatherNameEn = f.FatherNameEn,
            GrandfatherNameEn = f.GrandfatherNameEn,
            FamilyNameEn = f.FamilyNameEn,

            // تحويل الـ RowVersion آمن تماماً هنا لأنه ينفذ في الذاكرة
            RowVersion = Convert.ToBase64String(f.RowVersion)
        }).ToList();

        var paginatedList = new PaginatedList<FarmerDto>
        {
            Items = items,
            TotalCount = count,
            PageNumber = request.PageNumber,
            TotalPages = (int)Math.Ceiling(count / (double)request.PageSize)
        };

        return Result<PaginatedList<FarmerDto>>.Success(paginatedList);
    }
}