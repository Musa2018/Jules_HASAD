using System;
using System.Text.Json.Serialization;

namespace Hasad.Application.Features.Farms.Models;

/// <summary>
/// DTO optimized for synchronization responses.
/// </summary>
public class FarmSyncDto
{
    public Guid Id { get; set; }
    public Guid ClientId { get; set; }
    public Guid FarmerId { get; set; }
    public string LocalFarmName { get; set; } = string.Empty;
    public int OwnershipTypeId { get; set; }
    public Guid? OwnerFarmerId { get; set; }
    public int? RelationshipToOwnerId { get; set; }
    public Guid GovernorateId { get; set; }
    public Guid DirectorateId { get; set; }
    public Guid LocalityId { get; set; }
    public string Basin { get; set; } = string.Empty;
    public string Parcel { get; set; } = string.Empty;
    public decimal Area { get; set; }
    public int AreaUnitId { get; set; }

    [JsonPropertyName("measurementUnitId")]
    public int MeasurementUnitId => AreaUnitId;

    public int AgriculturalSectorId { get; set; }
    public int PoliticalClassificationId { get; set; }
    public double? Latitude { get; set; }
    public double? Longitude { get; set; }
    public string RowVersion { get; set; } = string.Empty;
    public bool IsDeleted { get; set; }
}
