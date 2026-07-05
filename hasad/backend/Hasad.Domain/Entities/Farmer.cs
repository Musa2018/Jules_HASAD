namespace Hasad.Domain.Entities;

public class Farmer
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string NationalId { get; set; } = string.Empty;
    public string PhoneNumber { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
}
