namespace Hasad.Domain.Entities;

public class DamageCause
{
    public int Id { get; set; }
    public int CategoryId { get; set; }
    public DamageCauseCategory? Category { get; set; }

    public string NameAr { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;
}
