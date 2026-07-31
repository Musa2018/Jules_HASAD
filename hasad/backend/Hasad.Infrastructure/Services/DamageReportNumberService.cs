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
        // 1. Get the Directorate and its Governorate Code
        var directorate = await _context.Directorates
            .Include(d => d.Governorate)
            .FirstOrDefaultAsync(d => d.Id == directorateId, cancellationToken);

        if (directorate == null)
        {
            throw new Exception("Directorate not found.");
        }

        if (directorate.Governorate == null)
        {
            throw new Exception("Governorate not found for the specified directorate.");
        }

        var govCode = directorate.Governorate.Code; // e.g., JEN
        var dirCode = directorate.Code; // e.g., JEN or NJEN

        // 2. Manage Sequence (Atomic per Directorate)
        var sequence = await _context.DamageReportSequences
            .FirstOrDefaultAsync(s => s.DirectorateId == directorateId, cancellationToken);

        if (sequence == null)
        {
            sequence = new DamageReportSequence
            {
                Id = Guid.NewGuid(),
                DirectorateId = directorateId,
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
