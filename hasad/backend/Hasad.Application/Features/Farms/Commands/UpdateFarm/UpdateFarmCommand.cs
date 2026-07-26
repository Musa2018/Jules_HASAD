using System.Text.Json.Serialization;
using FluentValidation;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.Farms.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.Farms.Commands.UpdateFarm;

public record UpdateFarmCommand(
    Guid Id,
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
    string? Notes,
    string RowVersion) : IRequest<Result<FarmDto>>
{
    [JsonPropertyName("areaUnitId")]
    public int? AreaUnitId { init => MeasurementUnitId = value ?? MeasurementUnitId; }
}

public class UpdateFarmCommandHandler : IRequestHandler<UpdateFarmCommand, Result<FarmDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public UpdateFarmCommandHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<FarmDto>> Handle(UpdateFarmCommand request, CancellationToken cancellationToken)
    {
        var farm = await _context.Farms
            .FirstOrDefaultAsync(f => f.Id == request.Id, cancellationToken);

        if (farm == null)
        {
            return Result<FarmDto>.Failure(new[] { "Farm not found." });
        }

        // Authorization check
        if (_currentUser.IsInRole("AgriculturalEngineer") || _currentUser.IsInRole("FieldSurveyor"))
        {
            if (farm.DirectorateId != _currentUser.DirectorateId || request.DirectorateId != _currentUser.DirectorateId)
            {
                return Result<FarmDto>.Failure(new[] { "Access Denied: You can only manage farms within your assigned directorate." });
            }
        }
        else if (_currentUser.IsInRole("Director"))
        {
            if (farm.GovernorateId != _currentUser.GovernorateId || request.GovernorateId != _currentUser.GovernorateId)
            {
                return Result<FarmDto>.Failure(new[] { "Access Denied: You can only manage farms within your assigned governorate." });
            }
        }

        // Optimistic concurrency check
        byte[] expectedVersion = Convert.FromBase64String(request.RowVersion);
        if (!farm.RowVersion.SequenceEqual(expectedVersion))
        {
            return Result<FarmDto>.Failure(new[] { "CONFLICT: The record has been modified by another user." });
        }

        // Validate OwnerFarmer if Ownership is not "ملك" (Id=1)
        if (request.OwnershipTypeId != 1 && !request.OwnerFarmerId.HasValue)
        {
            return Result<FarmDto>.Failure(new[] { "Owner Farmer is required when ownership type is not Owned (ملك)." });
        }

        farm.LocalFarmName = request.LocalFarmName;
        farm.OwnershipTypeId = request.OwnershipTypeId;
        farm.OwnerFarmerId = request.OwnerFarmerId;
        farm.RelationshipToOwnerId = request.RelationshipToOwnerId;
        farm.GovernorateId = request.GovernorateId;
        farm.DirectorateId = request.DirectorateId;
        farm.LocalityId = request.LocalityId;
        farm.Basin = request.Basin;
        farm.Parcel = request.Parcel;
        farm.Area = request.Area;
        farm.MeasurementUnitId = request.MeasurementUnitId;
        farm.AgriculturalSectorId = request.AgriculturalSectorId;
        farm.PoliticalClassificationId = request.PoliticalClassificationId;
        farm.Latitude = request.Latitude;
        farm.Longitude = request.Longitude;
        farm.Notes = request.Notes;
        farm.UpdatedAt = DateTime.UtcNow;

        try
        {
            await _context.SaveChangesAsync(cancellationToken);
        }
        catch (DbUpdateConcurrencyException)
        {
            return Result<FarmDto>.Failure(new[] { "CONFLICT: The record has been modified by another user." });
        }

        return Result<FarmDto>.Success(new FarmDto
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
            RowVersion = Convert.ToBase64String(farm.RowVersion)
        });
    }
}

public class UpdateFarmCommandValidator : AbstractValidator<UpdateFarmCommand>
{
    public UpdateFarmCommandValidator()
    {
        RuleFor(v => v.Id).NotEmpty();
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
        RuleFor(v => v.RowVersion).NotEmpty();

        RuleFor(v => v.OwnerFarmerId).NotEmpty()
            .When(v => v.OwnershipTypeId != 1)
            .WithMessage("Owner Farmer is required when ownership type is not Owned (ملك).");
    }
}
