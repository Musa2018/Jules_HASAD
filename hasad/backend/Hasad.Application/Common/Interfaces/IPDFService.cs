using Hasad.Domain.Entities;

namespace Hasad.Application.Common.Interfaces;

public interface IPDFService
{
    /// <summary>
    /// Generates a PDF for the damage assessment form.
    /// </summary>
    Task<byte[]> GenerateDamageAssessmentFormAsync(DamageReport report, List<DamageWorkflowHistory> histories);

    /// <summary>
    /// Generates a PDF for the official damage certificate.
    /// </summary>
    Task<byte[]> GenerateDamageCertificateAsync(DamageReport report);
}
