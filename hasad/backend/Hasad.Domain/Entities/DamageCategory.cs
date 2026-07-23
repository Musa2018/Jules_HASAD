namespace Hasad.Domain.Entities;

public class DamageCategory
{
    public int Id { get; set; }
    public int NatureId { get; set; }
    public DamageNature? Nature { get; set; }

    public string NameAr { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;

    public ICollection<DamageSubCategory> SubCategories { get; set; } = new List<DamageSubCategory>();
}
