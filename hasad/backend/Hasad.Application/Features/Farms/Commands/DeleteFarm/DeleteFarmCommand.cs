using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Farms.Commands.DeleteFarm;

public record DeleteFarmCommand(Guid Id) : IRequest<Result<Unit>>;

public class DeleteFarmCommandHandler : IRequestHandler<DeleteFarmCommand, Result<Unit>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public DeleteFarmCommandHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<Unit>> Handle(DeleteFarmCommand request, CancellationToken cancellationToken)
    {
        var farm = await _context.Farms
            .FirstOrDefaultAsync(f => f.Id == request.Id, cancellationToken);

        if (farm == null)
        {
            return Result<Unit>.Failure(new[] { "Farm not found." });
        }

        // Authorization check
        if (_currentUser.IsInRole("AgriculturalEngineer") || _currentUser.IsInRole("FieldSurveyor"))
        {
            if (farm.DirectorateId != _currentUser.DirectorateId)
            {
                return Result<Unit>.Failure(new[] { "Access Denied: You can only delete farms within your assigned directorate." });
            }
        }
        else if (_currentUser.IsInRole("Director"))
        {
            if (farm.GovernorateId != _currentUser.GovernorateId)
            {
                return Result<Unit>.Failure(new[] { "Access Denied: You can only delete farms within your assigned governorate." });
            }
        }

        farm.IsDeleted = true;
        farm.DeletedAt = DateTime.UtcNow;
        farm.DeletedBy = _currentUser.UserName;

        await _context.SaveChangesAsync(cancellationToken);

        return Result<Unit>.Success(Unit.Value);
    }
}
