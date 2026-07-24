using Hasad.Application.Common.Interfaces;
using Hasad.Domain.Common;
using Hasad.Domain.Entities;
using Hasad.Domain.Enums;
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
    private readonly ICurrentUserService _currentUser;

    /// <summary>Initializes the context.</summary>
    public ApplicationDbContext(
        DbContextOptions<ApplicationDbContext> options,
        ICurrentUserService currentUser)
        : base(options)
    {
        _currentUser = currentUser;
    }

    public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
    {
        foreach (var entry in ChangeTracker.Entries<ISoftDelete>())
        {
            if (entry.State == EntityState.Modified && entry.Entity.IsDeleted)
            {
                // Only set audit fields if they haven't been set yet (or we can always overwrite for consistency)
                entry.Entity.DeletedAt ??= DateTime.UtcNow;
                entry.Entity.DeletedBy ??= _currentUser.UserId;
            }
        }

        return await base.SaveChangesAsync(cancellationToken);
    }

    /// <summary>Persisted refresh tokens.</summary>
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();

    /// <summary>Governorates for geographic assignment.</summary>
    public DbSet<Governorate> Governorates => Set<Governorate>();

    /// <summary>Directorates for geographic assignment.</summary>
    public DbSet<Directorate> Directorates => Set<Directorate>();

    /// <summary>Localities for geographic assignment.</summary>
    public DbSet<Locality> Localities => Set<Locality>();

    /// <summary>Registered farmers.</summary>
    public DbSet<Farmer> Farmers => Set<Farmer>();

   /// <summary>Types of identification for farmers.</summary>
   public DbSet<IdType> IdTypes => Set<IdType>();

    /// <summary>Types of ownership for farms.</summary>
    public DbSet<OwnershipType> OwnershipTypes => Set<OwnershipType>();

    /// <summary>Units of measurement (Area, Weight, Count, etc.).</summary>
    public DbSet<MeasurementUnit> MeasurementUnits => Set<MeasurementUnit>();

    /// <summary>Agricultural sectors (Plant, Animal, Mixed).</summary>
    public DbSet<AgriculturalSector> AgriculturalSectors => Set<AgriculturalSector>();

    /// <summary>Political classifications (A, B, C).</summary>
    public DbSet<PoliticalClassification> PoliticalClassifications => Set<PoliticalClassification>();

    /// <summary>Relationships between operator and owner.</summary>
    public DbSet<RelationshipToOwner> RelationshipToOwners => Set<RelationshipToOwner>();

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

    /// <summary>Workflow history for damage reports.</summary>
    public DbSet<DamageWorkflowHistory> DamageWorkflowHistories => Set<DamageWorkflowHistory>();

    public DbSet<DamageReportSequence> DamageReportSequences => Set<DamageReportSequence>();

    public DbSet<DamageNature> DamageNatures => Set<DamageNature>();
    public DbSet<DamageCategory> DamageCategories => Set<DamageCategory>();
    public DbSet<DamageSubCategory> DamageSubCategories => Set<DamageSubCategory>();
    public DbSet<DamageClassification> DamageClassifications => Set<DamageClassification>();
    public DbSet<CostingSheetCatalog> CostingSheetCatalogs => Set<CostingSheetCatalog>();
    public DbSet<CostingSheetVersion> CostingSheetVersions => Set<CostingSheetVersion>();
    public DbSet<CostingSheetItem> CostingSheetItems => Set<CostingSheetItem>();

    public DbSet<DamageCauseCategory> DamageCauseCategories => Set<DamageCauseCategory>();
    public DbSet<DamageCause> DamageCauses => Set<DamageCause>();

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

        // --- 1. إعدادات جدول أنواع الهويات وحقن البيانات الأساسية ---
                builder.Entity<IdType>(entity =>
                {
                    entity.HasKey(e => e.Id);
                    entity.Property(e => e.NameAr).IsRequired().HasMaxLength(50);
                    entity.Property(e => e.NameEn).IsRequired().HasMaxLength(50);

                    // حقن البيانات (Seed Data) ليتم إنشاؤها فوراً مع التهجير
                    entity.HasData(
                        new IdType { Id = 1, NameAr = "هوية فلسطينية", NameEn = "Palestinian ID" },
                        new IdType { Id = 2, NameAr = "هوية القدس", NameEn = "Jerusalem ID" },
                        new IdType { Id = 3, NameAr = "جواز سفر", NameEn = "Passport" }
                    );
                });



        builder.Entity<Governorate>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.NameAr).IsRequired().HasMaxLength(100);
            entity.Property(e => e.NameEn).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Code).IsRequired().HasMaxLength(20);
            entity.HasIndex(e => e.Code).IsUnique();
        });

        builder.Entity<Directorate>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.NameAr).IsRequired().HasMaxLength(100);
            entity.Property(e => e.NameEn).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Code).IsRequired().HasMaxLength(20);
            entity.HasIndex(e => e.Code).IsUnique();

            entity.HasOne(e => e.Governorate)
                .WithMany(g => g.Directorates)
                .HasForeignKey(e => e.GovernorateId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        builder.Entity<Locality>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.NameAr).IsRequired().HasMaxLength(100);
            entity.Property(e => e.NameEn).IsRequired().HasMaxLength(100);

            entity.HasOne(e => e.Directorate)
                .WithMany()
                .HasForeignKey(e => e.DirectorateId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(e => e.Governorate)
                .WithMany(g => g.Localities)
                .HasForeignKey(e => e.GovernorateId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasIndex(e => e.GovernorateId);
            entity.HasIndex(e => e.DirectorateId);
        });

        builder.Entity<ApplicationUser>(entity =>
        {
            entity.Property(u => u.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            entity.Property(u => u.IsActive).HasDefaultValue(true);

            entity.HasOne(u => u.Governorate)
                .WithMany()
                .HasForeignKey(u => u.GovernorateId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(u => u.Directorate)
                .WithMany()
                .HasForeignKey(u => u.DirectorateId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        builder.Entity<Farmer>(entity =>
                {
                    entity.HasKey(f => f.Id);

                    // Global query filter for soft delete
                    entity.HasQueryFilter(f => !f.IsDeleted);

                    // التزامن - Partial index to allow reusing ClientId from deleted records
                    entity.HasIndex(f => f.ClientId)
                        .IsUnique()
                        .HasFilter("[IsDeleted] = 0");

                    // الهوية - Partial index to allow reusing ID Number from deleted records
                    entity.Property(f => f.IdNumber).IsRequired().HasMaxLength(20);
                    entity.HasIndex(f => new { f.IdTypeId, f.IdNumber })
                        .IsUnique()
                        .HasFilter("[IsDeleted] = 0");

                    // الأسماء
                    entity.Property(f => f.FirstNameAr).IsRequired().HasMaxLength(50);
                    entity.Property(f => f.FatherNameAr).IsRequired().HasMaxLength(50);
                    entity.Property(f => f.GrandfatherNameAr).IsRequired().HasMaxLength(50);
                    entity.Property(f => f.FamilyNameAr).IsRequired().HasMaxLength(50);

                    entity.Property(f => f.FirstNameEn).IsRequired().HasMaxLength(50);
                    entity.Property(f => f.FatherNameEn).IsRequired().HasMaxLength(50);
                    entity.Property(f => f.GrandfatherNameEn).IsRequired().HasMaxLength(50);
                    entity.Property(f => f.FamilyNameEn).IsRequired().HasMaxLength(50);

                    // الجغرافيا والديموغرافيا
                    entity.Property(f => f.BirthDate).IsRequired();
                    entity.Property(f => f.Gender).IsRequired().HasDefaultValue(Gender.Unspecified);
                    entity.Property(f => f.PhoneNumber).IsRequired().HasMaxLength(20);
                    entity.Property(f => f.FamilySize).IsRequired().HasDefaultValue(1);
                    entity.Property(f => f.Address).HasMaxLength(500);

                    // توافق جغرافي مع Farm و DamageReport
                    entity.Property(f => f.GovernorateId).IsRequired().HasMaxLength(50);
                    entity.Property(f => f.LocalityId).IsRequired().HasMaxLength(50);

                    // إعدادات أخرى
                    entity.Property(f => f.SyncStatus).IsRequired().HasDefaultValue(0);
                    entity.Property(f => f.CreatedAt).IsRequired().HasDefaultValueSql("GETUTCDATE()");
                    entity.Property(f => f.RowVersion).IsRowVersion();

                    // العلاقات
                    entity.HasOne(f => f.IdType)
                        .WithMany(t => t.Farmers)
                        .HasForeignKey(f => f.IdTypeId)
                        .OnDelete(DeleteBehavior.Restrict);
                });

        builder.Entity<Farm>(entity =>
        {
            entity.HasKey(f => f.Id);

            // Soft Delete
            entity.HasQueryFilter(f => !f.IsDeleted);

            entity.Property(f => f.LocalFarmName).IsRequired().HasMaxLength(200);
            entity.Property(f => f.Basin).IsRequired().HasMaxLength(100);
            entity.Property(f => f.Parcel).IsRequired().HasMaxLength(100);
            entity.Property(f => f.Area).HasPrecision(18, 2);
            entity.Property(f => f.RowVersion).IsRowVersion();

            entity.HasIndex(f => f.ClientId).IsUnique();
            entity.HasIndex(f => f.FarmerId);
            entity.HasIndex(f => f.OwnerFarmerId);
            entity.HasIndex(f => new { f.GovernorateId, f.DirectorateId, f.LocalityId });

            entity.HasOne(f => f.Farmer)
                .WithMany()
                .HasForeignKey(f => f.FarmerId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(f => f.OwnerFarmer)
                .WithMany()
                .HasForeignKey(f => f.OwnerFarmerId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(f => f.OwnershipType)
                .WithMany()
                .HasForeignKey(f => f.OwnershipTypeId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(f => f.RelationshipToOwner)
                .WithMany()
                .HasForeignKey(f => f.RelationshipToOwnerId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(f => f.Governorate)
                .WithMany()
                .HasForeignKey(f => f.GovernorateId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(f => f.Directorate)
                .WithMany()
                .HasForeignKey(f => f.DirectorateId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(f => f.Locality)
                .WithMany()
                .HasForeignKey(f => f.LocalityId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(f => f.MeasurementUnit)
                .WithMany()
                .HasForeignKey(f => f.MeasurementUnitId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(f => f.AgriculturalSector)
                .WithMany()
                .HasForeignKey(f => f.AgriculturalSectorId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(f => f.PoliticalClassification)
                .WithMany()
                .HasForeignKey(f => f.PoliticalClassificationId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // --- Seed Data for Lookups ---
        builder.Entity<OwnershipType>(entity =>
        {
            entity.HasData(
                new OwnershipType { Id = 1, NameAr = "ملك", NameEn = "Owned" },
                new OwnershipType { Id = 2, NameAr = "تأجير", NameEn = "Leased" },
                new OwnershipType { Id = 3, NameAr = "مزارعة", NameEn = "Sharecropping" },
                new OwnershipType { Id = 4, NameAr = "شراكة", NameEn = "Partnership" },
                new OwnershipType { Id = 5, NameAr = "أخرى", NameEn = "Other" }
            );
        });

        builder.Entity<AgriculturalSector>(entity =>
        {
            entity.HasData(
                new AgriculturalSector { Id = 1, NameAr = "نباتي", NameEn = "Plant" },
                new AgriculturalSector { Id = 2, NameAr = "حيواني", NameEn = "Animal" },
                new AgriculturalSector { Id = 3, NameAr = "مختلط", NameEn = "Mixed" }
            );
        });

        builder.Entity<PoliticalClassification>(entity =>
        {
            entity.HasData(
                new PoliticalClassification { Id = 1, NameAr = "A", NameEn = "A" },
                new PoliticalClassification { Id = 2, NameAr = "B", NameEn = "B" },
                new PoliticalClassification { Id = 3, NameAr = "C", NameEn = "C" }
            );
        });

        builder.Entity<MeasurementUnit>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.NameAr).IsRequired().HasMaxLength(100);
            entity.Property(e => e.NameEn).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Category).IsRequired().HasMaxLength(50);

            entity.HasData(
                new MeasurementUnit { Id = 1, NameAr = "دونم", NameEn = "Dunum", Category = "Area" },
                new MeasurementUnit { Id = 2, NameAr = "متر مربع", NameEn = "Square Meter", Category = "Area" },
                new MeasurementUnit { Id = 3, NameAr = "هكتار", NameEn = "Hectare", Category = "Area" },
                new MeasurementUnit { Id = 4, NameAr = "أخرى", NameEn = "Other", Category = "Area" }
            );
        });

        builder.Entity<RelationshipToOwner>(entity =>
        {
            entity.HasData(
                new RelationshipToOwner { Id = 1, NameAr = "المالك نفسه", NameEn = "Owner Himself" },
                new RelationshipToOwner { Id = 2, NameAr = "مستأجر", NameEn = "Tenant" },
                new RelationshipToOwner { Id = 3, NameAr = "شريك", NameEn = "Partner" },
                new RelationshipToOwner { Id = 4, NameAr = "وكيل", NameEn = "Agent" },
                new RelationshipToOwner { Id = 5, NameAr = "وريث", NameEn = "Heir" },
                new RelationshipToOwner { Id = 6, NameAr = "منتفع", NameEn = "Beneficiary" },
                new RelationshipToOwner { Id = 7, NameAr = "أخرى", NameEn = "Other" }
            );
        });

        builder.Entity<DamageReport>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.ReportNumber).HasMaxLength(100);
            entity.Property(e => e.PermanentFormNumber).HasMaxLength(50);
            entity.Property(e => e.TemporaryFormNumber).HasMaxLength(50);
            entity.Property(e => e.GovernorateId).IsRequired();
            entity.Property(e => e.DirectorateId).IsRequired();
            entity.Property(e => e.LocalityId).IsRequired();
            entity.Property(e => e.StatusId).IsRequired().HasMaxLength(50);
            entity.Property(e => e.RowVersion).IsRowVersion();

            entity.HasIndex(e => e.ClientId).IsUnique();
            entity.HasIndex(e => e.ReportNumber).IsUnique();
            entity.HasIndex(e => e.PermanentFormNumber).IsUnique();
            entity.HasIndex(e => new { e.FarmId, e.DamageDate }).IsUnique().HasFilter("[IsDeleted] = 0");
            entity.HasIndex(e => e.FarmerId);

            entity.HasOne(e => e.Farm)
                .WithMany()
                .HasForeignKey(e => e.FarmId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(e => e.Farmer)
                .WithMany()
                .HasForeignKey(e => e.FarmerId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(e => e.DamageNature)
                .WithMany()
                .HasForeignKey(e => e.DamageNatureId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(e => e.DamageCauseCategory)
                .WithMany()
                .HasForeignKey(e => e.DamageCauseCategoryId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(e => e.DamageCause)
                .WithMany()
                .HasForeignKey(e => e.DamageCauseId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        builder.Entity<DamageItem>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.CalculatedUnitPrice).HasPrecision(18, 2);
            entity.Property(e => e.MeasurementUnitSnapshot).IsRequired().HasMaxLength(50);
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

            entity.HasOne(e => e.Classification)
                .WithMany()
                .HasForeignKey(e => e.ClassificationId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(e => e.CostingSheetItem)
                .WithMany()
                .HasForeignKey(e => e.CostingSheetItemId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        builder.Entity<DamageNature>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.NameAr).IsRequired().HasMaxLength(100);
            entity.Property(e => e.NameEn).IsRequired().HasMaxLength(100);
        });

        builder.Entity<DamageCategory>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.NameAr).IsRequired().HasMaxLength(100);
            entity.Property(e => e.NameEn).IsRequired().HasMaxLength(100);
            entity.HasOne(e => e.Nature)
                .WithMany(n => n.Categories)
                .HasForeignKey(e => e.NatureId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        builder.Entity<DamageSubCategory>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.NameAr).IsRequired().HasMaxLength(100);
            entity.Property(e => e.NameEn).IsRequired().HasMaxLength(100);
            entity.HasOne(e => e.Category)
                .WithMany(c => c.SubCategories)
                .HasForeignKey(e => e.CategoryId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        builder.Entity<DamageClassification>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.NameAr).IsRequired().HasMaxLength(100);
            entity.Property(e => e.NameEn).IsRequired().HasMaxLength(100);
            entity.HasOne(e => e.SubCategory)
                .WithMany(s => s.Classifications)
                .HasForeignKey(e => e.SubCategoryId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        builder.Entity<CostingSheetCatalog>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Name).IsRequired().HasMaxLength(200);
            entity.Property(e => e.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
        });

        builder.Entity<CostingSheetVersion>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            entity.HasOne(e => e.Catalog)
                .WithMany(c => c.Versions)
                .HasForeignKey(e => e.CatalogId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        builder.Entity<CostingSheetItem>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.UnitPrice).HasPrecision(18, 2);
            entity.Property(e => e.CreatedAt).HasDefaultValueSql("GETUTCDATE()");

            entity.HasOne(e => e.Version)
                .WithMany(v => v.Items)
                .HasForeignKey(e => e.VersionId)
                .OnDelete(DeleteBehavior.Cascade);

            entity.HasOne(e => e.Classification)
                .WithMany(c => c.CostingSheetItems)
                .HasForeignKey(e => e.ClassificationId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(e => e.MeasurementUnit)
                .WithMany()
                .HasForeignKey(e => e.MeasurementUnitId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        builder.Entity<DamageCauseCategory>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.NameAr).IsRequired().HasMaxLength(100);
            entity.Property(e => e.NameEn).IsRequired().HasMaxLength(100);
        });

        builder.Entity<DamageCause>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.NameAr).IsRequired().HasMaxLength(100);
            entity.Property(e => e.NameEn).IsRequired().HasMaxLength(100);
            entity.HasOne(e => e.Category)
                .WithMany(c => c.Causes)
                .HasForeignKey(e => e.CategoryId)
                .OnDelete(DeleteBehavior.Restrict);
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

        builder.Entity<DamageWorkflowHistory>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.FromStatus).IsRequired().HasMaxLength(50);
            entity.Property(e => e.ToStatus).IsRequired().HasMaxLength(50);
            entity.Property(e => e.ChangedByUserId).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Comment).HasMaxLength(500);

            entity.HasOne(e => e.DamageReport)
                .WithMany()
                .HasForeignKey(e => e.DamageReportId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        builder.Entity<DamageReportSequence>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => new { e.DirectorateId, e.DamageYear }).IsUnique();

            entity.HasOne(e => e.Directorate)
                .WithMany()
                .HasForeignKey(e => e.DirectorateId)
                .OnDelete(DeleteBehavior.Restrict);
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
