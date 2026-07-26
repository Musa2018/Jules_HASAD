namespace Hasad.Domain.Entities;

public class DamageCauseCategory
{
    public int Id { get; set; }
    public string NameAr { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;

    public ICollection<DamageCause> Causes { get; set; } = new List<DamageCause>();
}
