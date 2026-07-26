namespace Hasad.Application.Common.Models;

/// <summary>
/// A generic data transfer object for lookup/reference data.
/// </summary>
public class LookupDto
{
    public int Id { get; set; }
    public int? ParentId { get; set; }
    public string? Code { get; set; }
    public string NameAr { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;
    public string? Category { get; set; }
}
