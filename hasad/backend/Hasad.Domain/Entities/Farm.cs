using System;

using Hasad.Domain.Common;

namespace Hasad.Domain.Entities;

public class Farm : ISoftDelete
{
    public Guid Id { get; set; }

    /// <summary>
    /// Client-generated synchronization identifier for idempotency.
    /// </summary>
    public Guid ClientId { get; set; }

    /// <summary>
    /// The farmer associated with/operating the farm.
    /// </summary>
    public Guid FarmerId { get; set; }
    public Farmer? Farmer { get; set; }

    public string LocalFarmName { get; set; } = string.Empty;

    public int OwnershipTypeId { get; set; }
    public OwnershipType? OwnershipType { get; set; }

    /// <summary>
    /// Mandatory if OwnershipType is not "ملك".
    /// </summary>
    public Guid? OwnerFarmerId { get; set; }
    public Farmer? OwnerFarmer { get; set; }

    public int? RelationshipToOwnerId { get; set; }
    public RelationshipToOwner? RelationshipToOwner { get; set; }

    // Geographic Information
    public Guid GovernorateId { get; set; }
    public Governorate? Governorate { get; set; }

    public Guid DirectorateId { get; set; }
    public Directorate? Directorate { get; set; }

    public Guid LocalityId { get; set; }
    public Locality? Locality { get; set; }

    public string Basin { get; set; } = string.Empty;
    public string Parcel { get; set; } = string.Empty;

    // Area
    public decimal Area { get; set; }
    public int AreaUnitId { get; set; }
    public AreaUnit? AreaUnit { get; set; }

    public int AgriculturalSectorId { get; set; }
    public AgriculturalSector? AgriculturalSector { get; set; }

    public int PoliticalClassificationId { get; set; }
    public PoliticalClassification? PoliticalClassification { get; set; }

    // Coordinates
    public double? Latitude { get; set; }
    public double? Longitude { get; set; }

    public string? Notes { get; set; }

    // Metadata & Sync
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    /// <summary>
    /// Concurrency token for optimistic synchronization.
    /// </summary>
    public byte[] RowVersion { get; set; } = Array.Empty<byte>();

    // Soft Delete
    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
    public string? DeletedBy { get; set; }
}
