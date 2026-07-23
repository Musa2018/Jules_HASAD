using Hasad.Domain.Entities;
using Hasad.Domain.Identity;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Common.Interfaces;

public interface IApplicationDbContext
{
    DbSet<ApplicationUser> Users { get; }
    DbSet<RefreshToken> RefreshTokens { get; }
    DbSet<Governorate> Governorates { get; }
    DbSet<Directorate> Directorates { get; }
    DbSet<Locality> Localities { get; }
    DbSet<Farmer> Farmers { get; }
    DbSet<IdType> IdTypes { get; }
    DbSet<OwnershipType> OwnershipTypes { get; }
    DbSet<AreaUnit> AreaUnits { get; }
    DbSet<AgriculturalSector> AgriculturalSectors { get; }
    DbSet<PoliticalClassification> PoliticalClassifications { get; }
    DbSet<RelationshipToOwner> RelationshipToOwners { get; }
    DbSet<Farm> Farms { get; }
    DbSet<DamageReport> DamageReports { get; }
    DbSet<DamageItem> DamageItems { get; }
    DbSet<DamageReportAttachment> DamageReportAttachments { get; }
    DbSet<DamageWorkflowHistory> DamageWorkflowHistories { get; }

    DbSet<DamageNature> DamageNatures { get; }
    DbSet<DamageCategory> DamageCategories { get; }
    DbSet<DamageSubCategory> DamageSubCategories { get; }
    DbSet<DamageClassification> DamageClassifications { get; }
    DbSet<CostingSheet> CostingSheets { get; }

    DbSet<DamageCauseCategory> DamageCauseCategories { get; }
    DbSet<DamageCause> DamageCauses { get; }

    DbSet<Compensation> Compensations { get; }
    DbSet<CompensationRule> CompensationRules { get; }
    DbSet<CompensationAuditLog> CompensationAuditLogs { get; }
    Task<int> SaveChangesAsync(CancellationToken cancellationToken);
}
