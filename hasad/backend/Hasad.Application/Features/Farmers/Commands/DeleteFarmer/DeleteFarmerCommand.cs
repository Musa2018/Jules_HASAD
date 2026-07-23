using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Farmers.Commands.DeleteFarmer;

public record DeleteFarmerCommand(Guid Id) : IRequest<Result<Unit>>;

public class DeleteFarmerCommandHandler : IRequestHandler<DeleteFarmerCommand, Result<Unit>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public DeleteFarmerCommandHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<Unit>> Handle(DeleteFarmerCommand request, CancellationToken cancellationToken)
    {
        // جلب المزارع من قاعدة البيانات
        var farmer = await _context.Farmers
            .FirstOrDefaultAsync(f => f.Id == request.Id, cancellationToken);

        // التحقق من وجود المزارع
        if (farmer == null)
        {
            return Result<Unit>.Failure(new[] { "Farmer not found." });
        }

        // Authorization check
        if (_currentUser.IsInRole("AgriculturalEngineer") || _currentUser.IsInRole("FieldSurveyor"))
        {
             if (farmer.GovernorateId != _currentUser.GovernorateId?.ToString())
             {
                 return Result<Unit>.Failure(new[] { "Access Denied: You can only delete farmers within your assigned governorate." });
             }
        }

        // Integrity check: Farmer cannot be deleted if linked to any Farm
        var hasFarms = await _context.Farms
            .AnyAsync(f => f.FarmerId == farmer.Id || f.OwnerFarmerId == farmer.Id, cancellationToken);

        if (hasFarms)
        {
            return Result<Unit>.Failure(new[] { "لا يمكن حذف المزارع لوجود أراضٍ مرتبطة به." });
        }

        // تنفيذ الحذف المنطقي (Soft Delete)
        farmer.IsDeleted = true;

        // حفظ التغييرات (EF Core سيقوم بعمل UPDATE وليس DELETE)
        await _context.SaveChangesAsync(cancellationToken);

        return Result<Unit>.Success(Unit.Value);
    }
}
