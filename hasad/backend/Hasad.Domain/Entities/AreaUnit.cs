// This file is obsolete and has been replaced by MeasurementUnit.cs
// It will be removed in a future cleanup.
namespace Hasad.Domain.Entities;

[System.Obsolete("Use MeasurementUnit instead")]
public class AreaUnit
{
    public int Id { get; set; }
    public string NameAr { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;
}
