using FluentValidation;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Farmers.Models;
using Hasad.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Farmers.Commands.CreateFarmer;

public record CreateFarmerCommand(
    Guid ClientId,
    string Name,
    string NationalId,
    string PhoneNumber,
    string Address) : IRequest<Result<FarmerDto>>;

public class CreateFarmerCommandHandler : IRequestHandler<CreateFarmerCommand, Result<FarmerDto>>
{
    private readonly IApplicationDbContext _context;

    public CreateFarmerCommandHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Result<FarmerDto>> Handle(CreateFarmerCommand request, CancellationToken cancellationToken)
    {
        // Idempotency check: if a farmer with this ClientId already exists, return it.
        var existingByClientId = await _context.Farmers
            .AsNoTracking()
            .FirstOrDefaultAsync(f => f.ClientId == request.ClientId, cancellationToken);

        if (existingByClientId != null)
        {
            return Result<FarmerDto>.Success(MapToDto(existingByClientId));
        }

        // Business rule: National ID must be unique.
        if (await _context.Farmers.AnyAsync(f => f.NationalId == request.NationalId, cancellationToken))
        {
            return Result<FarmerDto>.Failure(new[] { "A farmer with this National ID already exists." });
        }

        var farmer = new Farmer
        {
            Id = Guid.NewGuid(),
            ClientId = request.ClientId,
            Name = request.Name,
            NationalId = request.NationalId,
            PhoneNumber = request.PhoneNumber,
            Address = request.Address
        };

        _context.Farmers.Add(farmer);
        await _context.SaveChangesAsync(cancellationToken);

        return Result<FarmerDto>.Success(MapToDto(farmer));
    }

    private static FarmerDto MapToDto(Farmer farmer) => new()
    {
        Id = farmer.Id,
        ClientId = farmer.ClientId,
        Name = farmer.Name,
        NationalId = farmer.NationalId,
        PhoneNumber = farmer.PhoneNumber,
        Address = farmer.Address,
        RowVersion = Convert.ToBase64String(farmer.RowVersion)
    };
}

public class CreateFarmerCommandValidator : AbstractValidator<CreateFarmerCommand>
{
    public CreateFarmerCommandValidator()
    {
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
    }
}
