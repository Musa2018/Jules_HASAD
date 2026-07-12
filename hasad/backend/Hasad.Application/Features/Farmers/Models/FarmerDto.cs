namespace Hasad.Application.Features.Farmers.Models;

public class FarmerDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string NationalId { get; set; } = string.Empty;
    public string PhoneNumber { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public string RowVersion { get; set; } = string.Empty;
}
