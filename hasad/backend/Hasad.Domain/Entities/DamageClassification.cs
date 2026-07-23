namespace Hasad.Domain.Entities;

public class DamageClassification
{
    public int Id { get; set; }
    public int SubCategoryId { get; set; }
    public DamageSubCategory? SubCategory { get; set; }

    public string NameAr { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;

    public ICollection<CostingSheet> CostingSheets { get; set; } = new List<CostingSheet>();
}
