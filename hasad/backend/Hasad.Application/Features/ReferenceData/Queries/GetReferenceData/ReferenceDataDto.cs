using Hasad.Application.Common.Models;

namespace Hasad.Application.Features.ReferenceData.Queries.GetReferenceData;

public class ReferenceDataDto
{
    public List<LookupDto> OwnershipTypes { get; set; } = new();
    public List<LookupDto> AgriculturalSectors { get; set; } = new();
    public List<LookupDto> PoliticalClassifications { get; set; } = new();
    public List<LookupDto> AreaUnits { get; set; } = new();
    public List<LookupDto> RelationshipToOwners { get; set; } = new();
}
