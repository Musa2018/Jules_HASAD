namespace Hasad.Domain.Entities;

public class DamageNature
{
    public int Id { get; set; }
    public string NameAr { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;

    public ICollection<DamageCategory> Categories { get; set; } = new List<DamageCategory>();
}
