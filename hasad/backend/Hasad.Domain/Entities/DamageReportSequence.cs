namespace Hasad.Domain.Entities;

public class DamageReportSequence
{
    public Guid Id { get; set; }
    public Guid DirectorateId { get; set; }
    public Directorate? Directorate { get; set; }
    public int DamageYear { get; set; }
    public int LastSequence { get; set; }
}
