using Hasad.Application.Common.Interfaces;
using Hasad.Domain.Entities;
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
        // 1. Get the Governorate Code and Directorate Code
        var directorate = await _context.Directorates
            .Include(d => d.Governorate)
            .FirstOrDefaultAsync(d => d.Id == directorateId, cancellationToken);

        if (directorate == null || directorate.Governorate == null)
        {
            throw new Exception("Directorate or associated Governorate not found.");
        }

        var govCode = directorate.Governorate.Code; // e.g., NB
        var dirCode = directorate.Code; // e.g., NAB

        // 2. Manage Sequence (Atomic)
        var sequence = await _context.DamageReportSequences
            .FirstOrDefaultAsync(s => s.DirectorateId == directorateId && s.DamageYear == year, cancellationToken);

        if (sequence == null)
        {
            sequence = new DamageReportSequence
            {
                Id = Guid.NewGuid(),
                DirectorateId = directorateId,
                DamageYear = year,
                LastSequence = 1
            };
            _context.DamageReportSequences.Add(sequence);
        }
        else
        {
            sequence.LastSequence++;
        }

        // Note: SaveChangesAsync will be called by the Command Handler within the transaction.

        return $"{govCode}-{dirCode}-{year}-{sequence.LastSequence:D6}";
    }
}
