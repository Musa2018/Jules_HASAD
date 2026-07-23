using System;

namespace Hasad.Application.Features.Farms.Models;

public class FarmDto
{
    public Guid Id { get; set; }
    public Guid ClientId { get; set; }
    public Guid FarmerId { get; set; }
    public string? FarmerName { get; set; }

    public string LocalFarmName { get; set; } = string.Empty;

    public int OwnershipTypeId { get; set; }
    public string? OwnershipTypeName { get; set; }

    public Guid? OwnerFarmerId { get; set; }
    public string? OwnerFarmerName { get; set; }

    public int? RelationshipToOwnerId { get; set; }
    public string? RelationshipToOwnerName { get; set; }

    // Geographic Information
    public Guid GovernorateId { get; set; }
    public string? GovernorateName { get; set; }

    public Guid DirectorateId { get; set; }
    public string? DirectorateName { get; set; }

    public Guid LocalityId { get; set; }
    public string? LocalityName { get; set; }

    public string Basin { get; set; } = string.Empty;
    public string Parcel { get; set; } = string.Empty;

    // Area
    public decimal Area { get; set; }
    public int AreaUnitId { get; set; }
    public string? AreaUnitName { get; set; }

    public int AgriculturalSectorId { get; set; }
    public string? AgriculturalSectorName { get; set; }

    public int PoliticalClassificationId { get; set; }
    public string? PoliticalClassificationName { get; set; }

    // Coordinates
    public double? Latitude { get; set; }
    public double? Longitude { get; set; }

    public string? Notes { get; set; }

    // Sync & Metadata
    public string RowVersion { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public bool IsDeleted { get; set; }
}
