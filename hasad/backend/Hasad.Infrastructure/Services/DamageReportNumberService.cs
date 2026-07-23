using Hasad.Application.Common.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Infrastructure.Services;

public class DamageReportNumberService : IDamageReportNumberService
{
    private readonly IApplicationDbContext _context;

    public DamageReportNumberService(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<string> GeneratePermanentNumberAsync(Guid directorateId, int year, CancellationToken cancellationToken = default)
    {
        // 1. Get the Governorate Code for the Directorate
        var directorate = await _context.Directorates
            .Include(d => d.Governorate)
            .FirstOrDefaultAsync(d => d.Id == directorateId, cancellationToken);

        if (directorate == null || directorate.Governorate == null)
        {
            throw new Exception("Directorate or associated Governorate not found.");
        }

        var govCode = directorate.Governorate.Code; // e.g., NB

        // 2. Increment Sequence (Global)
        // For simplicity and multi-DB compatibility in this implementation,
        // we use a simple count-based approach with a lock or a dedicated sequence table if available.
        // In a production PostgreSQL environment, we would use:
        // SELECT nextval('DamageReportSequence')

        // Let's use a simple approach: Find the max number for this year and increment.
        // Note: This is prone to race conditions if not handled with a DB lock.
        // We will use a Transaction in the Command Handler which helps.

        var lastNumberStr = await _context.DamageReports
            .Where(r => r.DamageYear == year)
            .OrderByDescending(r => r.PermanentFormNumber)
            .Select(r => r.PermanentFormNumber)
            .FirstOrDefaultAsync(cancellationToken);

        int nextSequence = 1;
        if (!string.IsNullOrEmpty(lastNumberStr))
        {
            var parts = lastNumberStr.Split('-');
            if (parts.Length > 0 && int.TryParse(parts[0], out int lastSeq))
            {
                nextSequence = lastSeq + 1;
            }
        }

        return $"{nextSequence:D6}-{govCode}-{year}";
    }
}
