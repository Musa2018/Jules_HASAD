using Hasad.Domain.Entities;
using Hasad.Domain.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;

namespace Hasad.Application.Common.Interfaces;

public interface IApplicationDbContext
{
    DatabaseFacade Database { get; }
    DbSet<ApplicationUser> Users { get; }
    DbSet<RefreshToken> RefreshTokens { get; }
    DbSet<Governorate> Governorates { get; }
    DbSet<Directorate> Directorates { get; }
    DbSet<Locality> Localities { get; }
    DbSet<Farmer> Farmers { get; }
    DbSet<IdType> IdTypes { get; }
    DbSet<OwnershipType> OwnershipTypes { get; }
    DbSet<MeasurementUnit> MeasurementUnits { get; }
    DbSet<AgriculturalSector> AgriculturalSectors { get; }
    DbSet<PoliticalClassification> PoliticalClassifications { get; }
    DbSet<RelationshipToOwner> RelationshipToOwners { get; }
    DbSet<Farm> Farms { get; }
    DbSet<DamageReport> DamageReports { get; }
    DbSet<DamageItem> DamageItems { get; }
    DbSet<DamageReportAttachment> DamageReportAttachments { get; }
    DbSet<DamageWorkflowHistory> DamageWorkflowHistories { get; }
    DbSet<DocumentType> DocumentTypes { get; }
    DbSet<WorkflowStatus> WorkflowStatuses { get; }
    DbSet<WorkflowTransition> WorkflowTransitions { get; }

    DbSet<DamageNature> DamageNatures { get; }
    DbSet<DamageAction> DamageActions { get; }
    DbSet<DamageCategory> DamageCategories { get; }
    DbSet<DamageSubCategory> DamageSubCategories { get; }
    DbSet<DamageClassification> DamageClassifications { get; }
    DbSet<CostingSheetCatalog> CostingSheetCatalogs { get; }
    DbSet<CostingSheetVersion> CostingSheetVersions { get; }
    DbSet<CostingSheetItem> CostingSheetItems { get; }

    DbSet<DamageCauseCategory> DamageCauseCategories { get; }
    DbSet<DamageCause> DamageCauses { get; }
    DbSet<DamageReportSequence> DamageReportSequences { get; }

    DbSet<Assistance> Assistances { get; }
    DbSet<AssistanceRule> AssistanceRules { get; }
    DbSet<AssistanceAuditLog> AssistanceAuditLogs { get; }

    DbSet<ReportDefinition> ReportDefinitions { get; }
    DbSet<UserReportPreset> UserReportPresets { get; }
    DbSet<ReportExecutionLog> ReportExecutionLogs { get; }

    DbSet<UserDevice> UserDevices { get; }
    DbSet<Notification> Notifications { get; }
    DbSet<NotificationRecipient> NotificationRecipients { get; }

    DbSet<AdminUser> AdminUsers { get; }
    DbSet<AdminAuditLog> AdminAuditLogs { get; }
    DbSet<DashboardKpiMetric> DashboardKpiMetrics { get; }

    Task<int> SaveChangesAsync(CancellationToken cancellationToken);
}
