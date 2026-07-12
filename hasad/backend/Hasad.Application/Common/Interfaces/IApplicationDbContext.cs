using Hasad.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Common.Interfaces;

public interface IApplicationDbContext
{
    DbSet<RefreshToken> RefreshTokens { get; }
    DbSet<Farmer> Farmers { get; }
    DbSet<Farm> Farms { get; }
    Task<int> SaveChangesAsync(CancellationToken cancellationToken);
}
