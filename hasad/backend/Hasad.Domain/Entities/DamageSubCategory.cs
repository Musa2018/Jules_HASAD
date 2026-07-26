namespace Hasad.Domain.Entities;

public class DamageSubCategory
{
    public int Id { get; set; }
    public int CategoryId { get; set; }
    public DamageCategory? Category { get; set; }

    public string NameAr { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;

    public ICollection<DamageClassification> Classifications { get; set; } = new List<DamageClassification>();
}
