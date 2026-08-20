namespace Hasad.Application.Features.Reporting.Models;

public class DashboardOverviewDto
{
    public IEnumerable<KpiMetricDto> Kpis { get; set; } = new List<KpiMetricDto>();
    public DeviceStatsDto DeviceStats { get; set; } = new();
    public IEnumerable<AuditLogDto> RecentAudits { get; set; } = new List<AuditLogDto>();
    public DateTime ServerTime { get; set; }
}

public class KpiMetricDto
{
    public string MetricKey { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public decimal CurrentValue { get; set; }
    public decimal? PreviousValue { get; set; }
    public string? Unit { get; set; }
    public string Category { get; set; } = string.Empty;
}

public class DeviceStatsDto
{
    public int TotalRegisteredDevices { get; set; }
    public int OnlineNow { get; set; }
    public int AndroidDevices { get; set; }
    public int IosDevices { get; set; }
}

public class AuditLogDto
{
    public long AuditId { get; set; }
    public string AdminUserId { get; set; } = string.Empty;
    public string Action { get; set; } = string.Empty;
    public string EntityName { get; set; } = string.Empty;
    public DateTime Timestamp { get; set; }
}
