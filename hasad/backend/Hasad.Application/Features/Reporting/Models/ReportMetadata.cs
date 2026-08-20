namespace Hasad.Application.Features.Reporting.Models;

public class ReportDefinitionMetadata
{
    public string ReportId { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string DataSourceViewName { get; set; } = string.Empty;
    public string DefaultSortField { get; set; } = string.Empty;
    public Dictionary<string, ReportFieldMetadata> AllowedFields { get; set; } = new();
}

public class ReportFieldMetadata
{
    public string FieldName { get; set; } = string.Empty;
    public string DataType { get; set; } = "string"; // string, number, date, boolean
    public bool IsFilterable { get; set; } = true;
    public bool IsSortable { get; set; } = true;
    public List<string> AllowedOperators { get; set; } = new() { "EQUALS", "IN" };
}

public class ReportRequest
{
    public string ReportId { get; set; } = string.Empty;
    public int PageIndex { get; set; } = 1;
    public int PageSize { get; set; } = 50;
    public List<string> SelectedColumns { get; set; } = new();
    public List<ReportFilter> Filters { get; set; } = new();
    public List<string>? GroupBy { get; set; }
    public List<ReportAggregate>? Aggregates { get; set; }
    public List<ReportSort>? Sorts { get; set; }
    public string ExportFormat { get; set; } = "JSON";
}

public class ReportFilter
{
    public string Field { get; set; } = string.Empty;
    public string Operator { get; set; } = "EQUALS";
    public List<string> Values { get; set; } = new();
}

public class ReportAggregate
{
    public string Field { get; set; } = string.Empty;
    public string Function { get; set; } = "SUM"; // SUM, AVG, COUNT, MIN, MAX
}

public class ReportSort
{
    public string Field { get; set; } = string.Empty;
    public string Direction { get; set; } = "ASC";
}
