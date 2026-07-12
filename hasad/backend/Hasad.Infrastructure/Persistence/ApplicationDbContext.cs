using Hasad.Application.Common.Interfaces;
using Hasad.Domain.Entities;
using Hasad.Domain.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Infrastructure.Persistence;

/// <summary>
/// EF Core database context bridging the domain model, ASP.NET Core Identity,
/// and the PostgreSQL (or in-memory development) database.
/// </summary>
public class ApplicationDbContext : IdentityDbContext<ApplicationUser>, IApplicationDbContext
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

    /// <summary>Registered farms.</summary>
    public DbSet<Farm> Farms => Set<Farm>();

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
            entity.Property(f => f.RowVersion).IsRowVersion();

            // A national ID uniquely identifies one farmer record.
            entity.HasIndex(f => f.NationalId).IsUnique();

            // ClientId is used for idempotency during synchronization.
            entity.HasIndex(f => f.ClientId).IsUnique();
        });

        builder.Entity<Farm>(entity =>
        {
            entity.HasKey(f => f.Id);
            entity.Property(f => f.Name).IsRequired().HasMaxLength(200);
            entity.Property(f => f.GovernorateId).IsRequired().HasMaxLength(50);
            entity.Property(f => f.LocalityId).IsRequired().HasMaxLength(50);
            entity.Property(f => f.LandArea).HasPrecision(18, 2);
            entity.Property(f => f.LandAreaUnit).IsRequired().HasMaxLength(20);
            entity.Property(f => f.OwnershipTypeId).IsRequired().HasMaxLength(50);
            entity.Property(f => f.RowVersion).IsRowVersion();

            entity.HasIndex(f => f.ClientId).IsUnique();
            entity.HasIndex(f => f.FarmerId);

            entity.HasOne(f => f.Farmer)
                .WithMany()
                .HasForeignKey(f => f.FarmerId)
                .OnDelete(DeleteBehavior.Cascade);
        });
    }
}
