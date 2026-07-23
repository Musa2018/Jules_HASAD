using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Domain.Constants;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.DamageReports.Commands.DeleteDamageItem;

public record DeleteDamageItemCommand(Guid Id) : IRequest<Result<Unit>>;

public class DeleteDamageItemCommandHandler : IRequestHandler<DeleteDamageItemCommand, Result<Unit>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public DeleteDamageItemCommandHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<Unit>> Handle(DeleteDamageItemCommand request, CancellationToken cancellationToken)
    {
        var item = await _context.DamageItems
            .Include(i => i.DamageReport)
            .FirstOrDefaultAsync(i => i.Id == request.Id, cancellationToken);

        if (item == null)
        {
            return Result<Unit>.Failure(new[] { "Damage item not found." });
        }

        // Authorization Inheritance (Rule 4)
        if (item.DamageReport == null)
        {
            return Result<Unit>.Failure(new[] { "Parent damage report not found." });
        }

        if (_currentUser.IsInRole(AppRoles.AgriculturalEngineer) || _currentUser.IsInRole(AppRoles.FieldSurveyor))
        {
            if (_currentUser.DirectorateId.HasValue && item.DamageReport.DirectorateId != _currentUser.DirectorateId.Value)
            {
                return Result<Unit>.Failure(new[] { "Access Denied: You can only delete items within your assigned directorate." });
            }
        }
        else if (_currentUser.IsInRole(AppRoles.Director))
        {
            if (_currentUser.GovernorateId.HasValue && item.DamageReport.GovernorateId != _currentUser.GovernorateId.Value)
            {
                return Result<Unit>.Failure(new[] { "Access Denied: You can only delete items within your assigned governorate." });
            }
        }

        _context.DamageItems.Remove(item);
        await _context.SaveChangesAsync(cancellationToken);

        return Result<Unit>.Success(Unit.Value);
    }
}
