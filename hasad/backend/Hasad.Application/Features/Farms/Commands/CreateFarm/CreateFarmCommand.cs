using FluentValidation;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Farms.Models;
using Hasad.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Farms.Commands.CreateFarm;

public record CreateFarmCommand(
    Guid ClientId,
    Guid FarmerId,
    string LocalFarmName,
    int OwnershipTypeId,
    Guid? OwnerFarmerId,
    int? RelationshipToOwnerId,
    Guid GovernorateId,
    Guid DirectorateId,
    Guid LocalityId,
    string Basin,
    string Parcel,
    decimal Area,
    int MeasurementUnitId,
    int AgriculturalSectorId,
    int PoliticalClassificationId,
    double? Latitude,
    double? Longitude,
    string? Notes) : IRequest<Result<FarmDto>>;

public class CreateFarmCommandHandler : IRequestHandler<CreateFarmCommand, Result<FarmDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public CreateFarmCommandHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<FarmDto>> Handle(CreateFarmCommand request, CancellationToken cancellationToken)
    {
        // Idempotency check
        var existing = await _context.Farms
            .AsNoTracking()
            .FirstOrDefaultAsync(f => f.ClientId == request.ClientId, cancellationToken);

        if (existing != null)
        {
            return Result<FarmDto>.Success(MapToDto(existing));
        }

        // Authorization check
        if (_currentUser.IsInRole("AgriculturalEngineer") || _currentUser.IsInRole("FieldSurveyor"))
        {
            if (request.DirectorateId != _currentUser.DirectorateId)
            {
                return Result<FarmDto>.Failure(new[] { "Access Denied: You can only manage farms within your assigned directorate." });
            }
        }
        else if (_currentUser.IsInRole("Director"))
        {
            if (request.GovernorateId != _currentUser.GovernorateId)
            {
                return Result<FarmDto>.Failure(new[] { "Access Denied: You can only manage farms within your assigned governorate." });
            }
        }

        // Validate Farmer
        if (!await _context.Farmers.AnyAsync(f => f.Id == request.FarmerId, cancellationToken))
        {
            return Result<FarmDto>.Failure(new[] { "Farmer not found." });
        }

        // Validate OwnerFarmer if Ownership is not "ملك" (Id=1)
        if (request.OwnershipTypeId != 1 && !request.OwnerFarmerId.HasValue)
        {
            return Result<FarmDto>.Failure(new[] { "Owner Farmer is required when ownership type is not Owned (ملك)." });
        }

        if (request.OwnerFarmerId.HasValue && !await _context.Farmers.AnyAsync(f => f.Id == request.OwnerFarmerId.Value, cancellationToken))
        {
            return Result<FarmDto>.Failure(new[] { "Owner Farmer not found." });
        }

        var farm = new Farm
        {
            Id = Guid.NewGuid(),
            ClientId = request.ClientId,
            FarmerId = request.FarmerId,
            LocalFarmName = request.LocalFarmName,
            OwnershipTypeId = request.OwnershipTypeId,
            OwnerFarmerId = request.OwnerFarmerId,
            RelationshipToOwnerId = request.RelationshipToOwnerId,
            GovernorateId = request.GovernorateId,
            DirectorateId = request.DirectorateId,
            LocalityId = request.LocalityId,
            Basin = request.Basin,
            Parcel = request.Parcel,
            Area = request.Area,
            MeasurementUnitId = request.MeasurementUnitId,
            AgriculturalSectorId = request.AgriculturalSectorId,
            PoliticalClassificationId = request.PoliticalClassificationId,
            Latitude = request.Latitude,
            Longitude = request.Longitude,
            Notes = request.Notes,
            CreatedAt = DateTime.UtcNow
        };

        _context.Farms.Add(farm);
        await _context.SaveChangesAsync(cancellationToken);

        return Result<FarmDto>.Success(MapToDto(farm));
    }

    private static FarmDto MapToDto(Farm farm) => new()
    {
        Id = farm.Id,
        ClientId = farm.ClientId,
        FarmerId = farm.FarmerId,
        LocalFarmName = farm.LocalFarmName,
        OwnershipTypeId = farm.OwnershipTypeId,
        OwnerFarmerId = farm.OwnerFarmerId,
        RelationshipToOwnerId = farm.RelationshipToOwnerId,
        GovernorateId = farm.GovernorateId,
        DirectorateId = farm.DirectorateId,
        LocalityId = farm.LocalityId,
        Basin = farm.Basin,
        Parcel = farm.Parcel,
        Area = farm.Area,
            MeasurementUnitId = farm.MeasurementUnitId,
        AgriculturalSectorId = farm.AgriculturalSectorId,
        PoliticalClassificationId = farm.PoliticalClassificationId,
        Latitude = farm.Latitude,
        Longitude = farm.Longitude,
        Notes = farm.Notes,
        CreatedAt = farm.CreatedAt,
        RowVersion = farm.RowVersion != null ? Convert.ToBase64String(farm.RowVersion) : string.Empty
    };
}

public class CreateFarmCommandValidator : AbstractValidator<CreateFarmCommand>
{
    public CreateFarmCommandValidator()
    {
        RuleFor(v => v.ClientId).NotEmpty();
        RuleFor(v => v.FarmerId).NotEmpty();
        RuleFor(v => v.LocalFarmName).NotEmpty().MaximumLength(200);
        RuleFor(v => v.OwnershipTypeId).NotEmpty();
        RuleFor(v => v.GovernorateId).NotEmpty();
        RuleFor(v => v.DirectorateId).NotEmpty();
        RuleFor(v => v.LocalityId).NotEmpty();
        RuleFor(v => v.Basin).NotEmpty().MaximumLength(100);
        RuleFor(v => v.Parcel).NotEmpty().MaximumLength(100);
        RuleFor(v => v.Area).GreaterThan(0);
        RuleFor(v => v.MeasurementUnitId).NotEmpty();
        RuleFor(v => v.AgriculturalSectorId).NotEmpty();
        RuleFor(v => v.PoliticalClassificationId).NotEmpty();

        RuleFor(v => v.OwnerFarmerId).NotEmpty()
            .When(v => v.OwnershipTypeId != 1)
            .WithMessage("Owner Farmer is required when ownership type is not Owned (ملك).");

        RuleFor(v => v.Latitude).InclusiveBetween(-90, 90).When(v => v.Latitude.HasValue);
        RuleFor(v => v.Longitude).InclusiveBetween(-180, 180).When(v => v.Longitude.HasValue);
    }
}
