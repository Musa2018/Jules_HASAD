using Hasad.Application.Common.Interfaces;
using Hasad.Domain.Entities;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using System.Globalization;

namespace Hasad.Infrastructure.Services;

public class PDFService : IPDFService
{
    private const string DefaultFont = "Arial";

    static PDFService()
    {
        QuestPDF.Settings.License = LicenseType.Community;
    }

    public async Task<byte[]> GenerateDamageAssessmentFormAsync(DamageReport report, List<DamageWorkflowHistory> histories)
    {
        var document = Document.Create(container =>
        {
            container.Page(page =>
            {
                page.Size(PageSizes.A4);
                page.Margin(1, Unit.Centimetre);
                page.PageColor(Colors.White);
                page.DefaultTextStyle(x => x.FontFamily(DefaultFont).FontSize(10));

                page.Header().Element(header => ComposeHeader(header, "استمارة توثيق الأضرار الزراعية"));

                page.Content().PaddingVertical(10).Column(col =>
                {
                    col.Spacing(10);
                    col.Item().Element(c => ComposeFarmerAndFarmSection(c, report));
                    col.Item().Element(c => ComposeAggressorSection(c, report));
                    col.Item().Element(c => ComposeDamageItemsTables(c, report));
                    col.Item().Element(c => ComposeWorkflowHistoryTable(c, histories));
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

        return await Task.FromResult(document.GeneratePdf());
    }

    public async Task<byte[]> GenerateDamageCertificateAsync(DamageReport report)
    {
        var document = Document.Create(container =>
        {
            container.Page(page =>
            {
                page.Size(PageSizes.A4);
                page.Margin(1.5f, Unit.Centimetre);
                page.PageColor(Colors.White);
                page.DefaultTextStyle(x => x.FontFamily(DefaultFont).FontSize(11));

                page.Header().Element(header => ComposeHeader(header, "شهادة ضرر"));

                page.Content().PaddingVertical(20).Column(col =>
                {
                    col.Spacing(15);
                    col.Item().Element(c => ComposeCertificateBody(c, report));
                    col.Item().Element(c => ComposeCertificateItemsTable(c, report));
                    col.Item().Element(c => ComposeSummaryTable(c, report));
                    col.Item().Element(c => ComposeAssistanceTable(c, report));
                    col.Item().PaddingTop(20).Element(c => ComposeCertificateFooter(c));
                });
            });
        });

        return await Task.FromResult(document.GeneratePdf());
    }

    private void ComposeHeader(IContainer container, string title)
    {
        container.Row(row =>
        {
            row.RelativeItem().Column(col =>
            {
                col.Item().Text("دولة فلسطين").Bold().FontSize(14);
                col.Item().Text("وزارة الزراعة").Bold().FontSize(12);
            });

            row.RelativeItem().AlignCenter().Column(col =>
            {
                // Placeholder for Logo
                col.Item().PaddingBottom(5).Height(50).Placeholder();
                col.Item().Text(title).Bold().FontSize(16).Underline();
            });

            row.RelativeItem().AlignRight().Column(col =>
            {
                col.Item().Text("State of Palestine").Bold().FontSize(14);
                col.Item().Text("Ministry of Agriculture").Bold().FontSize(12);
            });
        });
    }

    private void ComposeFarmerAndFarmSection(IContainer container, DamageReport report)
    {
        container.Border(1).Padding(5).Column(col =>
        {
            col.Item().Background(Colors.Grey.Lighten4).Padding(2).Text("بيانات المزارع والحيازة").Bold();

            col.Item().Row(row =>
            {
                row.RelativeItem().Column(c =>
                {
                    c.Item().Text(t => {
                        t.Span("اسم المزارع: ").Bold();
                        t.Span($"{report.Farm?.Farmer?.FirstNameAr} {report.Farm?.Farmer?.FamilyNameAr}");
                    });

                    c.Item().Text(t => {
                        t.Span("رقم الهوية: ").Bold();
                        t.Span(report.Farm?.Farmer?.IdNumber ?? "");
                    });

                    c.Item().Text(t => {
                        t.Span("المحافظة: ").Bold();
                        t.Span(report.Farm?.Governorate?.NameAr ?? "");
                    });

                    c.Item().Text(t => {
                        t.Span("التجمع: ").Bold();
                        t.Span(report.Farm?.Locality?.NameAr ?? "");
                    });
                });

                row.RelativeItem().Column(c =>
                {
                    c.Item().Text(t => {
                        t.Span("اسم المزرعة: ").Bold();
                        t.Span(report.Farm?.LocalFarmName ?? "");
                    });

                    c.Item().Text(t => {
                        t.Span("الحوض/القسيمة: ").Bold();
                        t.Span($"{report.Farm?.Basin} / {report.Farm?.Parcel}");
                    });

                    c.Item().Text(t => {
                        t.Span("المساحة: ").Bold();
                        t.Span($"{report.Farm?.Area} {report.Farm?.MeasurementUnit?.NameAr}");
                    });

                    c.Item().Text(t => {
                        t.Span("الملكية: ").Bold();
                        t.Span(report.Farm?.OwnershipType?.NameAr ?? "");
                    });

                    c.Item().Text(t => {
                        t.Span("التصنيف السياسي: ").Bold();
                        t.Span(report.Farm?.PoliticalClassification?.NameAr ?? "");
                    });
                });
            });
        });
    }

    private void ComposeAggressorSection(IContainer container, DamageReport report)
    {
        container.Border(1).Padding(5).Column(col =>
        {
            col.Item().Text(t => {
                t.Span("جهة الاعتداء: ").Bold();
                t.Span(report.DamageCause?.NameAr ?? report.DamageCauseCategory?.NameAr ?? "");
            });

            col.Item().Text(t => {
                t.Span("تاريخ الضرر: ").Bold();
                t.Span(report.DamageDate.ToString("yyyy-MM-dd"));
            });
        });
    }

    private void ComposeDamageItemsTables(IContainer container, DamageReport report)
    {
        var groupedItems = report.Items.GroupBy(i => i.Classification?.SubCategory?.NameAr ?? "أخرى");

        container.Column(col =>
        {
            foreach (var group in groupedItems)
            {
                col.Item().PaddingTop(10).Column(groupCol =>
                {
                    groupCol.Item().Text(group.Key).Bold().Underline();
                    groupCol.Item().Table(table =>
                    {
                        table.ColumnsDefinition(columns =>
                        {
                            columns.RelativeColumn(3); // الصنف
                            columns.RelativeColumn(2); // طبيعة الضرر
                            columns.RelativeColumn(1); // الكمية
                            columns.RelativeColumn(1); // وحدة القياس
                            columns.RelativeColumn(1); // المساحة المتضررة
                            columns.RelativeColumn(1); // % الضرر
                            columns.RelativeColumn(2); // الخسارة التقديرية
                        });

                        table.Header(header =>
                        {
                            header.Cell().Element(CellStyle).Text("الصنف");
                            header.Cell().Element(CellStyle).Text("طبيعة الضرر");
                            header.Cell().Element(CellStyle).Text("الكمية");
                            header.Cell().Element(CellStyle).Text("الوحدة");
                            header.Cell().Element(CellStyle).Text("المساحة");
                            header.Cell().Element(CellStyle).Text("% الضرر");
                            header.Cell().Element(CellStyle).Text("الخسارة ($)");

                            static IContainer CellStyle(IContainer container) => container.DefaultTextStyle(x => x.Bold()).PaddingVertical(5).BorderBottom(1).AlignCenter();
                        });

                        foreach (var item in group)
                        {
                            table.Cell().Element(CellStyle).Text(item.Classification?.NameAr ?? "");
                            table.Cell().Element(CellStyle).Text(item.DamageNature?.NameAr ?? "");
                            table.Cell().Element(CellStyle).Text(item.Quantity.ToString("N2")).AlignCenter();
                            table.Cell().Element(CellStyle).Text(item.MeasurementUnitSnapshot);
                            table.Cell().Element(CellStyle).Text(item.AffectedArea.ToString("N2")).AlignCenter();
                            table.Cell().Element(CellStyle).Text($"{item.DamagePercentage}%").AlignCenter();
                            table.Cell().Element(CellStyle).Text(item.EstimatedLoss.ToString("C2")).AlignCenter();

                            static IContainer CellStyle(IContainer container) => container.BorderBottom(1).BorderColor(Colors.Grey.Lighten2).PaddingVertical(5).AlignCenter();
                        }
                    });
                });
            }
        });
    }

    private void ComposeWorkflowHistoryTable(IContainer container, List<DamageWorkflowHistory> histories)
    {
        container.PaddingTop(10).Column(col =>
        {
            col.Item().Text("سجل دورة حياة الاستمارة").Bold();
            col.Item().Table(table =>
            {
                table.ColumnsDefinition(columns =>
                {
                    columns.RelativeColumn(2); // الحالة
                    columns.RelativeColumn(2); // المستخدم
                    columns.RelativeColumn(2); // التاريخ
                    columns.RelativeColumn(3); // ملاحظات
                });

                table.Header(header =>
                {
                    header.Cell().Element(CellStyle).Text("اسم الحالة");
                    header.Cell().Element(CellStyle).Text("المستخدم");
                    header.Cell().Element(CellStyle).Text("التاريخ");
                    header.Cell().Element(CellStyle).Text("ملاحظات");

                    static IContainer CellStyle(IContainer container) => container.DefaultTextStyle(x => x.Bold()).PaddingVertical(5).BorderBottom(1).AlignCenter();
                });

                foreach (var history in histories.OrderBy(h => h.ChangedAt))
                {
                    table.Cell().Element(CellStyle).Text(history.ToStatus);
                    table.Cell().Element(CellStyle).Text(history.ChangedByUserId);
                    table.Cell().Element(CellStyle).Text(history.ChangedAt.ToString("yyyy-MM-dd HH:mm")).AlignCenter();
                    table.Cell().Element(CellStyle).Text(history.Comment ?? "");

                    static IContainer CellStyle(IContainer container) => container.BorderBottom(1).BorderColor(Colors.Grey.Lighten2).PaddingVertical(5).AlignCenter();
                }
            });
        });
    }

    private void ComposeCertificateBody(IContainer container, DamageReport report)
    {
        container.Column(col =>
        {
            col.Item().Text(t =>
            {
                t.Span("تشهد وزارة الزراعة أن المزارع ");
                t.Span($"{report.Farm?.Farmer?.FirstNameAr} {report.Farm?.Farmer?.FamilyNameAr}").Bold();
                t.Span(" حامل هوية رقم ");
                t.Span(report.Farm?.Farmer?.IdNumber ?? "").Bold();
                t.Span(" قد تعرضت حيازته الزراعية لأضرار نتيجة ");
                t.Span(report.DamageCause?.NameAr ?? report.DamageCauseCategory?.NameAr ?? "").Bold();
                t.Span(" بتاريخ ");
                t.Span(report.DamageDate.ToString("yyyy-MM-dd")).Bold();
                t.Span("، وذلك طبقاً لاستمارة حصر الأضرار رقم ");
                t.Span(report.ReportNumber).Bold();
                t.Span(".");
            });
        });
    }

    private void ComposeCertificateItemsTable(IContainer container, DamageReport report)
    {
        container.Table(table =>
        {
            table.ColumnsDefinition(columns =>
            {
                columns.RelativeColumn(3); // وصف الضرر
                columns.RelativeColumn(1); // الوحدة
                columns.RelativeColumn(1); // الكمية
                columns.RelativeColumn(1); // قيمة الوحدة
                columns.RelativeColumn(1); // كلي/جزئي
                columns.RelativeColumn(2); // القيمة الإجمالية
            });

            table.Header(header =>
            {
                header.Cell().Element(CellStyle).Text("وصف الضرر");
                header.Cell().Element(CellStyle).Text("الوحدة");
                header.Cell().Element(CellStyle).Text("الكمية");
                header.Cell().Element(CellStyle).Text("قيمة الوحدة");
                header.Cell().Element(CellStyle).Text("كلي/جزئي");
                header.Cell().Element(CellStyle).Text("القيمة الإجمالية");

                static IContainer CellStyle(IContainer container) => container.DefaultTextStyle(x => x.Bold()).PaddingVertical(5).Border(1).AlignCenter().Background(Colors.Grey.Lighten3);
            });

            foreach (var item in report.Items)
            {
                table.Cell().Element(CellStyle).Text(item.Classification?.NameAr ?? "");
                table.Cell().Element(CellStyle).Text(item.MeasurementUnitSnapshot);
                table.Cell().Element(CellStyle).Text(item.Quantity.ToString("N2")).AlignCenter();
                table.Cell().Element(CellStyle).Text(item.CalculatedUnitPrice.ToString("C2")).AlignCenter();
                table.Cell().Element(CellStyle).Text(item.DamagePercentage == 100 ? "كلي" : "جزئي");
                table.Cell().Element(CellStyle).Text(item.EstimatedLoss.ToString("C2")).AlignCenter();

                static IContainer CellStyle(IContainer container) => container.Border(1).PaddingVertical(5).AlignCenter();
            }
        });
    }

    private void ComposeSummaryTable(IContainer container, DamageReport report)
    {
        container.AlignLeft().Width(250).Table(table =>
        {
            table.ColumnsDefinition(columns =>
            {
                columns.RelativeColumn(1);
                columns.RelativeColumn(1);
            });

            table.Cell().Element(CellStyle).Text("إجمالي الخسائر").Bold();
            table.Cell().Element(CellStyle).Text(report.TotalDamage.ToString("C2")).Bold().AlignCenter();

            static IContainer CellStyle(IContainer container) => container.Border(1).Padding(5).Background(Colors.Grey.Lighten4);
        });
    }

    private void ComposeAssistanceTable(IContainer container, DamageReport report)
    {
        container.Column(col =>
        {
            col.Item().Text("المساعدات المستلمة (إن وجدت)").Bold().Underline();
            col.Item().Table(table =>
            {
                table.ColumnsDefinition(columns =>
                {
                    columns.RelativeColumn(2); // الجهة المانحة
                    columns.RelativeColumn(1); // المبلغ
                    columns.RelativeColumn(1); // التاريخ
                    columns.RelativeColumn(2); // السبب
                    columns.RelativeColumn(2); // ملاحظات
                });

                table.Header(header =>
                {
                    header.Cell().Element(CellStyle).Text("الجهة المانحة");
                    header.Cell().Element(CellStyle).Text("المبلغ");
                    header.Cell().Element(CellStyle).Text("التاريخ");
                    header.Cell().Element(CellStyle).Text("السبب");
                    header.Cell().Element(CellStyle).Text("ملاحظات");

                    static IContainer CellStyle(IContainer container) => container.DefaultTextStyle(x => x.Bold()).PaddingVertical(5).Border(1).AlignCenter();
                });

                for (int i = 0; i < 2; i++)
                {
                    table.Cell().Element(CellStyle).Text("");
                    table.Cell().Element(CellStyle).Text("");
                    table.Cell().Element(CellStyle).Text("");
                    table.Cell().Element(CellStyle).Text("");
                    table.Cell().Element(CellStyle).Text("");

                    static IContainer CellStyle(IContainer container) => container.Border(1).PaddingVertical(10).AlignCenter();
                }
            });
        });
    }

    private void ComposeCertificateFooter(IContainer container)
    {
        container.Row(row =>
        {
            row.RelativeItem().Column(col =>
            {
                col.Item().AlignCenter().Text("مدقق الإجراءات").Bold();
                col.Item().PaddingTop(20).AlignCenter().Text("...........................");
            });

            row.RelativeItem().Column(col =>
            {
                col.Item().AlignCenter().Text("مدير دائرة توثيق الأضرار").Bold();
                col.Item().PaddingTop(20).AlignCenter().Text("...........................");
            });

            row.RelativeItem().Column(col =>
            {
                col.Item().AlignCenter().Text("المدير العام").Bold();
                col.Item().PaddingTop(20).AlignCenter().Text("...........................");
            });
        });
    }
}
