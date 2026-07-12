using FluentValidation;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Farmers.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Farmers.Commands.UpdateFarmer;

public record UpdateFarmerCommand(
    Guid Id,
    Guid ClientId,
    string Name,
    string NationalId,
    string PhoneNumber,
    string Address,
    string RowVersion) : IRequest<Result<FarmerDto>>;

public class UpdateFarmerCommandHandler : IRequestHandler<UpdateFarmerCommand, Result<FarmerDto>>
{
    private readonly IApplicationDbContext _context;

    public UpdateFarmerCommandHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Result<FarmerDto>> Handle(UpdateFarmerCommand request, CancellationToken cancellationToken)
    {
        var farmer = await _context.Farmers
            .FirstOrDefaultAsync(f => f.Id == request.Id, cancellationToken);

        if (farmer == null)
        {
            return Result<FarmerDto>.Failure(new[] { "Farmer not found." });
        }

        // Check if National ID is taken by another farmer
        if (await _context.Farmers.AnyAsync(f => f.NationalId == request.NationalId && f.Id != request.Id, cancellationToken))
        {
            return Result<FarmerDto>.Failure(new[] { "A farmer with this National ID already exists." });
        }

        // Optimistic concurrency check
        byte[] expectedVersion = Convert.FromBase64String(request.RowVersion);
        if (!farmer.RowVersion.SequenceEqual(expectedVersion))
        {
             return Result<FarmerDto>.Failure(new[] { "CONFLICT: The record has been modified by another user." });
        }

        farmer.ClientId = request.ClientId; // Should ideally not change but we update it to stay consistent.
        farmer.Name = request.Name;
        farmer.NationalId = request.NationalId;
        farmer.PhoneNumber = request.PhoneNumber;
        farmer.Address = request.Address;

        try
        {
            await _context.SaveChangesAsync(cancellationToken);
        }
        catch (DbUpdateConcurrencyException)
        {
            return Result<FarmerDto>.Failure(new[] { "CONFLICT: The record has been modified by another user." });
        }

        return Result<FarmerDto>.Success(new FarmerDto
        {
            Id = farmer.Id,
            ClientId = farmer.ClientId,
            Name = farmer.Name,
            NationalId = farmer.NationalId,
            PhoneNumber = farmer.PhoneNumber,
            Address = farmer.Address,
            RowVersion = Convert.ToBase64String(farmer.RowVersion)
        });
    }
}

public class UpdateFarmerCommandValidator : AbstractValidator<UpdateFarmerCommand>
{
    public UpdateFarmerCommandValidator()
    {
        RuleFor(v => v.Id)
            .NotEmpty().WithMessage("Id is required.");

        RuleFor(v => v.ClientId)
            .NotEmpty().WithMessage("ClientId is required.");

        RuleFor(v => v.Name)
            .NotEmpty().WithMessage("Name is required.")
            .MaximumLength(200).WithMessage("Name must not exceed 200 characters.");

        RuleFor(v => v.NationalId)
            .NotEmpty().WithMessage("National ID is required.")
            .MaximumLength(20).WithMessage("National ID must not exceed 20 characters.");

        RuleFor(v => v.PhoneNumber)
            .NotEmpty().WithMessage("Phone Number is required.")
            .MaximumLength(20).WithMessage("Phone Number must not exceed 20 characters.");

        RuleFor(v => v.Address)
            .MaximumLength(500).WithMessage("Address must not exceed 500 characters.");

        RuleFor(v => v.RowVersion)
            .NotEmpty().WithMessage("RowVersion is required.");
    }
}
