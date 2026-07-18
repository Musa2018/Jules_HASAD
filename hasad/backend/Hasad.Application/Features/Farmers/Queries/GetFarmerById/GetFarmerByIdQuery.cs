using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Farmers.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Farmers.Queries.GetFarmerById;

public record GetFarmerByIdQuery(Guid Id) : IRequest<Result<FarmerDto>>;

public class GetFarmerByIdQueryHandler : IRequestHandler<GetFarmerByIdQuery, Result<FarmerDto>>
{
    private readonly IApplicationDbContext _context;

    public GetFarmerByIdQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Result<FarmerDto>> Handle(GetFarmerByIdQuery request, CancellationToken cancellationToken)
    {
        var farmer = await _context.Farmers
            .AsNoTracking()
            .FirstOrDefaultAsync(f => f.Id == request.Id, cancellationToken);

        if (farmer == null)
        {
            return Result<FarmerDto>.Failure(new[] { "Farmer not found." });
        }

        return Result<FarmerDto>.Success(new FarmerDto
        {
            Id = farmer.Id,
            ClientId = farmer.ClientId,

            // دمج الأسماء المنسقة
            Name = $"{farmer.FirstNameAr} {farmer.FatherNameAr} {farmer.GrandfatherNameAr} {farmer.FamilyNameAr}".Trim(),
            NameEn = $"{farmer.FirstNameEn} {farmer.FatherNameEn} {farmer.GrandfatherNameEn} {farmer.FamilyNameEn}".Trim(),

            // الحقول الأساسية
            NationalId = farmer.IdNumber,
            PhoneNumber = farmer.PhoneNumber,
            Address = farmer.Address,
            RowVersion = Convert.ToBase64String(farmer.RowVersion),

            // الحقول الجديدة التي تمت إضافتها
            IdTypeId = farmer.IdTypeId,
            GovernorateId = farmer.GovernorateId,
            LocalityId = farmer.LocalityId,
            BirthDate = farmer.BirthDate,

            // تفاصيل الأسماء (مهمة في حال أردت عرضها في نماذج التعديل بالواجهة)
            FirstNameAr = farmer.FirstNameAr,
            FatherNameAr = farmer.FatherNameAr,
            GrandfatherNameAr = farmer.GrandfatherNameAr,
            FamilyNameAr = farmer.FamilyNameAr,

            FirstNameEn = farmer.FirstNameEn,
            FatherNameEn = farmer.FatherNameEn,
            GrandfatherNameEn = farmer.GrandfatherNameEn,
            FamilyNameEn = farmer.FamilyNameEn
        });
    }
}