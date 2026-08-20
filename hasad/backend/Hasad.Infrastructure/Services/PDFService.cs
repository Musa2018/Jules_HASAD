using Hasad.Application.Common.Interfaces;
using Hasad.Domain.Entities;
using System.Text;

namespace Hasad.Infrastructure.Services;

public class PDFService : IPDFService
{
    public Task<byte[]> GenerateDamageAssessmentFormAsync(DamageReport report)
    {
        // Placeholder: Returning a simple text-based "PDF" dummy byte array
        // Real implementation will use a library like QuestPDF or DinkToPdf with HTML templates
        string content = $"DAMAGE ASSESSMENT FORM\nReport Number: {report.ReportNumber}\nFarm: {report.Farm?.LocalFarmName}\nDate: {report.DamageDate}";
        return Task.FromResult(Encoding.UTF8.GetBytes(content));
    }

    public Task<byte[]> GenerateDamageCertificateAsync(DamageReport report)
    {
        // Placeholder
        string content = $"OFFICIAL DAMAGE CERTIFICATE\nReport Number: {report.ReportNumber}\nFarmer ID: {report.FarmerId}\nStatus: COMPLETED";
        return Task.FromResult(Encoding.UTF8.GetBytes(content));
    }
}
