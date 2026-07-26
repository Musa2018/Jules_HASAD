namespace Hasad.Domain.Entities;

public class DamageCategory
{
    public int Id { get; set; }
    public int AgriculturalSectorId { get; set; }
    public AgriculturalSector? AgriculturalSector { get; set; }

    public string NameAr { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;

    public ICollection<DamageSubCategory> SubCategories { get; set; } = new List<DamageSubCategory>();
}
