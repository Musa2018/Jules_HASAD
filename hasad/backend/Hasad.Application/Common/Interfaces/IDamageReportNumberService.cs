namespace Hasad.Application.Common.Interfaces;

public interface IDamageReportNumberService
{
    /// <summary>
    /// Generates a permanent form number in the format SEQUENCE-DIRECTORATE-YEAR.
    /// Example: 000125-NBL-2026
    /// </summary>
    Task<string> GeneratePermanentNumberAsync(Guid directorateId, int year, CancellationToken cancellationToken = default);
}
