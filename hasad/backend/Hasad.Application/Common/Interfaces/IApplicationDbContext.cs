using Hasad.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Common.Interfaces;

public interface IApplicationDbContext
{
    DbSet<RefreshToken> RefreshTokens { get; }
    DbSet<Farmer> Farmers { get; }
    DbSet<Farm> Farms { get; }
    DbSet<DamageReport> DamageReports { get; }
    DbSet<Compensation> Compensations { get; }
    DbSet<CompensationRule> CompensationRules { get; }
    DbSet<CompensationAuditLog> CompensationAuditLogs { get; }
    DbSet<DamageItem> DamageItems { get; }
    DbSet<DamageReportAttachment> DamageReportAttachments { get; }
    Task<int> SaveChangesAsync(CancellationToken cancellationToken);
}
