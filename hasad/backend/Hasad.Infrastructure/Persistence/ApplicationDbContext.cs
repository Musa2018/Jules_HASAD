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

    /// <summary>Damage reports.</summary>
    public DbSet<DamageReport> DamageReports => Set<DamageReport>();

    /// <summary>Compensations linked to reports.</summary>
    public DbSet<Compensation> Compensations => Set<Compensation>();

    /// <summary>Compensation rules for calculation.</summary>
    public DbSet<CompensationRule> CompensationRules => Set<CompensationRule>();

    /// <summary>Audit logs for compensation status changes.</summary>
    public DbSet<CompensationAuditLog> CompensationAuditLogs => Set<CompensationAuditLog>();

    /// <summary>Damage items within reports.</summary>
    public DbSet<DamageItem> DamageItems => Set<DamageItem>();

    /// <summary>Attachments linked to reports.</summary>
    public DbSet<DamageReportAttachment> DamageReportAttachments => Set<DamageReportAttachment>();

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

        builder.Entity<DamageReport>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.GovernorateId).IsRequired().HasMaxLength(50);
            entity.Property(e => e.LocalityId).IsRequired().HasMaxLength(50);
            entity.Property(e => e.StatusId).IsRequired().HasMaxLength(50);
            entity.Property(e => e.RowVersion).IsRowVersion();

            entity.HasIndex(e => e.ClientId).IsUnique();
            entity.HasIndex(e => e.FarmId);
            entity.HasIndex(e => e.FarmerId);

            entity.HasOne(e => e.Farm)
                .WithMany()
                .HasForeignKey(e => e.FarmId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(e => e.Farmer)
                .WithMany()
                .HasForeignKey(e => e.FarmerId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        builder.Entity<DamageItem>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.AgriculturalSectorId).IsRequired().HasMaxLength(50);
            entity.Property(e => e.SubSectorId).IsRequired().HasMaxLength(50);
            entity.Property(e => e.CropId).IsRequired().HasMaxLength(50);
            entity.Property(e => e.DamageTypeId).IsRequired().HasMaxLength(50);
            entity.Property(e => e.AffectedArea).HasPrecision(18, 2);
            entity.Property(e => e.DamagePercentage).HasPrecision(18, 2);
            entity.Property(e => e.Quantity).HasPrecision(18, 2);
            entity.Property(e => e.EstimatedLoss).HasPrecision(18, 2);
            entity.Property(e => e.RowVersion).IsRowVersion();

            entity.HasIndex(e => e.ClientId).IsUnique();
            entity.HasIndex(e => e.DamageReportId);

            entity.HasOne(e => e.DamageReport)
                .WithMany(r => r.Items)
                .HasForeignKey(e => e.DamageReportId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        builder.Entity<DamageReportAttachment>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.FileName).IsRequired().HasMaxLength(250);
            entity.Property(e => e.OriginalFileName).IsRequired().HasMaxLength(250);
            entity.Property(e => e.FileType).IsRequired().HasMaxLength(100);
            entity.Property(e => e.LocalPath).HasMaxLength(500);
            entity.Property(e => e.RemotePath).HasMaxLength(500);
            entity.Property(e => e.UploadStatus).IsRequired().HasMaxLength(50);
            entity.Property(e => e.RowVersion).IsRowVersion();

            entity.HasIndex(e => e.ClientId).IsUnique();

            entity.HasOne(e => e.DamageReport)
                .WithMany(r => r.Attachments)
                .HasForeignKey(e => e.DamageReportId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        builder.Entity<Compensation>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.CalculatedAmount).HasPrecision(18, 2);
            entity.Property(e => e.ApprovedAmount).HasPrecision(18, 2);
            entity.Property(e => e.Status).IsRequired().HasMaxLength(50);
            entity.Property(e => e.RowVersion).IsRowVersion();

            entity.HasIndex(e => e.ClientId).IsUnique();
            entity.HasIndex(e => e.DamageReportId).IsUnique();

            entity.HasOne(e => e.DamageReport)
                .WithOne()
                .HasForeignKey<Compensation>(e => e.DamageReportId)
                .OnDelete(DeleteBehavior.Cascade);

            entity.HasOne(e => e.Rule)
                .WithMany()
                .HasForeignKey(e => e.RuleId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        builder.Entity<CompensationRule>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Name).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Multiplier).HasPrecision(18, 4);
        });

        builder.Entity<CompensationAuditLog>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.PreviousStatus).IsRequired().HasMaxLength(50);
            entity.Property(e => e.NewStatus).IsRequired().HasMaxLength(50);
            entity.Property(e => e.ChangedBy).IsRequired().HasMaxLength(100);

            entity.HasOne(e => e.Compensation)
                .WithMany(c => c.AuditLogs)
                .HasForeignKey(e => e.CompensationId)
                .OnDelete(DeleteBehavior.Cascade);
        });
    }
}
