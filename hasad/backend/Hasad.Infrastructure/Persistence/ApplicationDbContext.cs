using Hasad.Domain.Entities;
using Hasad.Domain.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Infrastructure.Persistence;

/// <summary>
/// EF Core database context bridging the domain model, ASP.NET Core Identity,
/// and the PostgreSQL (or in-memory development) database.
/// </summary>
public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
{
    /// <summary>Initializes the context.</summary>
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    /// <summary>Persisted refresh tokens.</summary>
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();

    /// <summary>Registered farmers.</summary>
    public DbSet<Farmer> Farmers => Set<Farmer>();

    /// <inheritdoc />
    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);

        builder.Entity<RefreshToken>(entity =>
        {
            entity.HasKey(t => t.Id);
            entity.Property(t => t.TokenHash).IsRequired().HasMaxLength(64);
            entity.Property(t => t.UserId).IsRequired();
            entity.HasIndex(t => t.TokenHash).IsUnique();
            entity.HasIndex(t => new { t.UserId, t.FamilyId });
        });

        builder.Entity<Farmer>(entity =>
        {
            entity.HasKey(f => f.Id);
            entity.Property(f => f.Name).IsRequired().HasMaxLength(200);
            entity.Property(f => f.NationalId).IsRequired().HasMaxLength(20);
            entity.Property(f => f.PhoneNumber).IsRequired().HasMaxLength(20);
            entity.Property(f => f.Address).HasMaxLength(500);

            // A national ID uniquely identifies one farmer record.
            entity.HasIndex(f => f.NationalId).IsUnique();
        });
    }
}
