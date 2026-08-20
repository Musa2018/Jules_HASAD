namespace Hasad.Application.Features.Reporting.Services;

public interface IReportExportService
{
    Task<byte[]> ExportToExcelAsync(IEnumerable<IDictionary<string, object>> data);
    Task<byte[]> ExportToPdfAsync(string title, IEnumerable<IDictionary<string, object>> data);
}
