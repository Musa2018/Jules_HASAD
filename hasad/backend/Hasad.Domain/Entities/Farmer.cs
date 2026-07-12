namespace Hasad.Domain.Entities;

public class Farmer
{
    public Guid Id { get; set; }

    /// <summary>
    /// Client-generated synchronization identifier.
    /// </summary>
    public Guid ClientId { get; set; }

    public string Name { get; set; } = string.Empty;
    public string NationalId { get; set; } = string.Empty;
    public string PhoneNumber { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;

    /// <summary>
    /// Concurrency token for optimistic synchronization.
    /// </summary>
    public byte[] RowVersion { get; set; } = Array.Empty<byte>();
}
