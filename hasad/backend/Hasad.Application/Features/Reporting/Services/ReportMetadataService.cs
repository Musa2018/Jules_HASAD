using Hasad.Application.Features.Reporting.Models;

namespace Hasad.Application.Features.Reporting.Services;

public class ReportMetadataService : IReportMetadataService
{
    private readonly Dictionary<string, ReportDefinitionMetadata> _registry;

    public ReportMetadataService()
    {
        _registry = new Dictionary<string, ReportDefinitionMetadata>(StringComparer.OrdinalIgnoreCase);
        InitializeRegistry();
    }

    public Task<ReportDefinitionMetadata?> GetMetadataAsync(string reportId)
    {
        _registry.TryGetValue(reportId, out var metadata);
        return Task.FromResult(metadata);
    }

    public bool IsOperatorValid(string op)
    {
        var validOps = new[] { "EQUALS", "NOTEQUALS", "BETWEEN", "IN", "CONTAINS", "GREATERTHANOREQUAL", "LESSTHANOREQUAL" };
        return validOps.Contains(op.ToUpper());
    }

    public bool IsAggregateValid(string func)
    {
        var validFuncs = new[] { "SUM", "AVG", "COUNT", "MIN", "MAX" };
        return validFuncs.Contains(func.ToUpper());
    }

    private void InitializeRegistry()
    {
        // Sample: Damage Summary Report
        _registry.Add("damage_summary", new ReportDefinitionMetadata
        {
            ReportId = "damage_summary",
            Title = "ملخص الأضرار",
            DataSourceViewName = "vw_DamageSummary",
            DefaultSortField = "DamageDate",
            AllowedFields = new Dictionary<string, ReportFieldMetadata>(StringComparer.OrdinalIgnoreCase)
            {
                { "DamageDate", new ReportFieldMetadata { FieldName = "DamageDate", DataType = "date", AllowedOperators = new() { "BETWEEN", "EQUALS" } } },
                { "GovernorateName", new ReportFieldMetadata { FieldName = "GovernorateName", DataType = "string" } },
                { "DirectorateName", new ReportFieldMetadata { FieldName = "DirectorateName", DataType = "string" } },
                { "SectorName", new ReportFieldMetadata { FieldName = "SectorName", DataType = "string" } },
                { "TotalLoss", new ReportFieldMetadata { FieldName = "TotalLoss", DataType = "number", AllowedOperators = new() { "GREATERTHANOREQUAL", "LESSTHANOREQUAL", "BETWEEN" } } },
                { "Status", new ReportFieldMetadata { FieldName = "Status", DataType = "string", AllowedOperators = new() { "EQUALS", "IN" } } }
            }
        });

        // Sample: Farmer Activity
        _registry.Add("farmer_activity", new ReportDefinitionMetadata
        {
            ReportId = "farmer_activity",
            Title = "نشاط المزارعين",
            DataSourceViewName = "vw_FarmerActivity",
            DefaultSortField = "CreatedAt",
            AllowedFields = new Dictionary<string, ReportFieldMetadata>(StringComparer.OrdinalIgnoreCase)
            {
                { "FarmerName", new ReportFieldMetadata { FieldName = "FarmerName", DataType = "string" } },
                { "IdNumber", new ReportFieldMetadata { FieldName = "IdNumber", DataType = "string" } },
                { "GovernorateName", new ReportFieldMetadata { FieldName = "GovernorateName", DataType = "string" } },
                { "FarmCount", new ReportFieldMetadata { FieldName = "FarmCount", DataType = "number" } },
                { "TotalArea", new ReportFieldMetadata { FieldName = "TotalArea", DataType = "number" } },
                { "CreatedAt", new ReportFieldMetadata { FieldName = "CreatedAt", DataType = "date", AllowedOperators = new() { "BETWEEN" } } }
            }
        });
    }
}
