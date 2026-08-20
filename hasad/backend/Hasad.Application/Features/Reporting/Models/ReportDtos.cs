namespace Hasad.Application.Features.Reporting.Models;

public class ReportResultDto
{
    public string ReportId { get; set; } = string.Empty;
    public List<string> Columns { get; set; } = new();
    public List<IDictionary<string, object>> Rows { get; set; } = new();
    public int TotalCount { get; set; }
    public int PageIndex { get; set; }
    public int PageSize { get; set; }
    public IDictionary<string, object>? Aggregates { get; set; }
}

public class PagedReportResponse<T>
{
    public T Data { get; set; } = default!;
    public int PageIndex { get; set; }
    public int TotalPages { get; set; }
    public int TotalCount { get; set; }
    public bool HasPreviousPage => PageIndex > 1;
    public bool HasNextPage => PageIndex < TotalPages;

    public PagedReportResponse(T data, int count, int pageIndex, int pageSize)
    {
        PageIndex = pageIndex;
        TotalPages = (int)Math.Ceiling(count / (double)pageSize);
        TotalCount = count;
        Data = data;
    }
}
