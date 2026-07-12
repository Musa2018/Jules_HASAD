using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Farmers.Commands.DeleteFarmer;

public record DeleteFarmerCommand(Guid Id) : IRequest<Result<Unit>>;

public class DeleteFarmerCommandHandler : IRequestHandler<DeleteFarmerCommand, Result<Unit>>
{
    private readonly IApplicationDbContext _context;

    public DeleteFarmerCommandHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Result<Unit>> Handle(DeleteFarmerCommand request, CancellationToken cancellationToken)
    {
        var farmer = await _context.Farmers
            .FirstOrDefaultAsync(f => f.Id == request.Id, cancellationToken);

        if (farmer == null)
        {
            return Result<Unit>.Failure(new[] { "Farmer not found." });
        }

        _context.Farmers.Remove(farmer);
        await _context.SaveChangesAsync(cancellationToken);

        return Result<Unit>.Success(Unit.Value);
    }
}
