namespace Hasad.Domain.Entities;

public class MeasurementUnit
{
    public int Id { get; set; }
    public string NameAr { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;
    public string? Code { get; set; }
    public string Category { get; set; } = string.Empty; // Area, Weight, Count, Packaging, Volume, Length
}
