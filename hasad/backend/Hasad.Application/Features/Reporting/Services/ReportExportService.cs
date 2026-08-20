using MiniExcelLibs;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;

namespace Hasad.Application.Features.Reporting.Services;

public class ReportExportService : IReportExportService
{
    public ReportExportService()
    {
        QuestPDF.Settings.License = LicenseType.Community;
    }

    public async Task<byte[]> ExportToExcelAsync(IEnumerable<IDictionary<string, object>> data)
    {
        using var memoryStream = new MemoryStream();
        await memoryStream.SaveAsAsync(data);
        return memoryStream.ToArray();
    }

    public Task<byte[]> ExportToPdfAsync(string title, IEnumerable<IDictionary<string, object>> data)
    {
        var list = data.ToList();
        if (!list.Any()) return Task.FromResult(Array.Empty<byte>());

        var columns = list.First().Keys.ToList();

        var document = Document.Create(container =>
        {
            container.Page(page =>
            {
                page.Size(PageSizes.A4.Landscape());
                page.Margin(1, Unit.Centimetre);
                page.DefaultTextStyle(x => x.FontSize(9).FontFamily("Arial"));

                page.Header().Row(row =>
                {
                    row.RelativeItem().Column(col =>
                    {
                        col.Item().Text(title).SemiBold().FontSize(18).FontColor(Colors.Blue.Medium);
                        col.Item().Text($"تاريخ الاستخراج: {DateTime.Now:yyyy-MM-dd HH:mm}").FontSize(8).Italic();
                    });
                });

                page.Content().PaddingVertical(10).Table(table =>
                {
                    table.ColumnsDefinition(cd =>
                    {
                        foreach (var _ in columns) cd.RelativeColumn();
                    });

                    table.Header(header =>
                    {
                        foreach (var col in columns)
                        {
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(5).Text(col).Bold();
                        }
                    });

                    foreach (var row in list)
                    {
                        foreach (var col in columns)
                        {
                            table.Cell().BorderBottom(1, Unit.Point).BorderColor(Colors.Grey.Lighten4).Padding(5)
                                .Text(row[col]?.ToString() ?? "-");
                        }
                    }
                });

                page.Footer().AlignCenter().Text(x =>
                {
                    x.Span("صفحة ");
                    x.CurrentPageNumber();
                    x.Span(" من ");
                    x.TotalPages();
                });
            });
        });

        using var stream = new MemoryStream();
        document.GeneratePdf(stream);
        return Task.FromResult(stream.ToArray());
    }
}
