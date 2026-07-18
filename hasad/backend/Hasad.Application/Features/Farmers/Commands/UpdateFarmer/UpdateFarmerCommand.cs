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
    int IdTypeId,
    string IdNumber,
    string FirstNameAr,
    string FatherNameAr,
    string GrandfatherNameAr,
    string FamilyNameAr,
    string FirstNameEn,
    string FatherNameEn,
    string GrandfatherNameEn,
    string FamilyNameEn,
    DateOnly BirthDate,
    string PhoneNumber,
    string GovernorateId,
    string LocalityId,
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

        // Business rule: The combination of Id Type and Id Number must be unique among other farmers.
        if (await _context.Farmers.AnyAsync(f => f.IdNumber == request.IdNumber && f.IdTypeId == request.IdTypeId && f.Id != request.Id, cancellationToken))
        {
            return Result<FarmerDto>.Failure(new[] { "A farmer with this ID Number and ID Type already exists." });
        }

        // Optimistic concurrency check
        byte[] expectedVersion = Convert.FromBase64String(request.RowVersion);
        if (!farmer.RowVersion.SequenceEqual(expectedVersion))
        {
            return Result<FarmerDto>.Failure(new[] { "CONFLICT: The record has been modified by another user." });
        }

        farmer.ClientId = request.ClientId;
        farmer.IdTypeId = request.IdTypeId;
        farmer.IdNumber = request.IdNumber;
        farmer.FirstNameAr = request.FirstNameAr;
        farmer.FatherNameAr = request.FatherNameAr;
        farmer.GrandfatherNameAr = request.GrandfatherNameAr;
        farmer.FamilyNameAr = request.FamilyNameAr;
        farmer.FirstNameEn = request.FirstNameEn;
        farmer.FatherNameEn = request.FatherNameEn;
        farmer.GrandfatherNameEn = request.GrandfatherNameEn;
        farmer.FamilyNameEn = request.FamilyNameEn;
        farmer.BirthDate = request.BirthDate;
        farmer.PhoneNumber = request.PhoneNumber;
        farmer.GovernorateId = request.GovernorateId;
        farmer.LocalityId = request.LocalityId;
        farmer.Address = request.Address;

        // Update SyncStatus so external systems know it needs to be synced again
        farmer.SyncStatus = 0;

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
            // دمج الأسماء مؤقتاً للتوافق مع الـ DTO
            Name = $"{farmer.FirstNameAr} {farmer.FatherNameAr} {farmer.GrandfatherNameAr} {farmer.FamilyNameAr}".Trim(),
            NationalId = farmer.IdNumber,
            PhoneNumber = farmer.PhoneNumber,
            Address = farmer.Address,
            RowVersion = Convert.ToBase64String(farmer.RowVersion),
            IdTypeId = farmer.IdTypeId,
                GovernorateId = farmer.GovernorateId,
                LocalityId = farmer.LocalityId,
                BirthDate = farmer.BirthDate,
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

public class UpdateFarmerCommandValidator : AbstractValidator<UpdateFarmerCommand>
{
    public UpdateFarmerCommandValidator()
    {
        RuleFor(v => v.Id)
            .NotEmpty().WithMessage("Id is required.");

        RuleFor(v => v.ClientId)
            .NotEmpty().WithMessage("ClientId is required.");

        RuleFor(v => v.IdTypeId)
            .GreaterThan(0).WithMessage("IdType is required.");

        RuleFor(v => v.IdNumber)
            .NotEmpty().WithMessage("ID Number is required.")
            .MaximumLength(20).WithMessage("ID Number must not exceed 20 characters.");

        RuleFor(v => v.FirstNameAr).NotEmpty().MaximumLength(50);
        RuleFor(v => v.FatherNameAr).NotEmpty().MaximumLength(50);
        RuleFor(v => v.GrandfatherNameAr).NotEmpty().MaximumLength(50);
        RuleFor(v => v.FamilyNameAr).NotEmpty().MaximumLength(50);

        RuleFor(v => v.FirstNameEn).NotEmpty().MaximumLength(50);
        RuleFor(v => v.FatherNameEn).NotEmpty().MaximumLength(50);
        RuleFor(v => v.GrandfatherNameEn).NotEmpty().MaximumLength(50);
        RuleFor(v => v.FamilyNameEn).NotEmpty().MaximumLength(50);

        RuleFor(v => v.BirthDate)
            .NotEmpty().WithMessage("Birth Date is required.");

        RuleFor(v => v.GovernorateId)
            .NotEmpty().MaximumLength(50);

        RuleFor(v => v.LocalityId)
            .NotEmpty().MaximumLength(50);

        RuleFor(v => v.PhoneNumber)
            .NotEmpty().WithMessage("Phone Number is required.")
            .MaximumLength(20).WithMessage("Phone Number must not exceed 20 characters.");

        RuleFor(v => v.Address)
            .MaximumLength(500).WithMessage("Address must not exceed 500 characters.");

        RuleFor(v => v.RowVersion)
            .NotEmpty().WithMessage("RowVersion is required.");
    }
}