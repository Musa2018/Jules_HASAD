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

        // Business rule: The combination of Id Type and Id Number must be unique.
        if (await _context.Farmers.AnyAsync(f => f.IdNumber == request.IdNumber && f.IdTypeId == request.IdTypeId, cancellationToken))
        {
            return Result<FarmerDto>.Failure(new[] { "A farmer with this ID Number and ID Type already exists." });
        }

        var farmer = new Farmer
        {
            Id = Guid.NewGuid(),
            ClientId = request.ClientId,
            IdTypeId = request.IdTypeId,
            IdNumber = request.IdNumber,
            FirstNameAr = request.FirstNameAr,
            FatherNameAr = request.FatherNameAr,
            GrandfatherNameAr = request.GrandfatherNameAr,
            FamilyNameAr = request.FamilyNameAr,
            FirstNameEn = request.FirstNameEn,
            FatherNameEn = request.FatherNameEn,
            GrandfatherNameEn = request.GrandfatherNameEn,
            FamilyNameEn = request.FamilyNameEn,
            BirthDate = request.BirthDate,
            PhoneNumber = request.PhoneNumber,
            GovernorateId = request.GovernorateId,
            LocalityId = request.LocalityId,
            Address = request.Address,
            SyncStatus = 0
        };

        _context.Farmers.Add(farmer);
        await _context.SaveChangesAsync(cancellationToken);

        return Result<FarmerDto>.Success(MapToDto(farmer));
    }

    private static FarmerDto MapToDto(Farmer farmer) => new()
    {
        Id = farmer.Id,
        ClientId = farmer.ClientId,
        // دمج الأسماء الأربعة لتتوافق مع الـ DTO الحالي دون إحداث أخطاء إضافية
        Name = $"{farmer.FirstNameAr} {farmer.FatherNameAr} {farmer.GrandfatherNameAr} {farmer.FamilyNameAr}".Trim(),
        NationalId = farmer.IdNumber,
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
    }
}