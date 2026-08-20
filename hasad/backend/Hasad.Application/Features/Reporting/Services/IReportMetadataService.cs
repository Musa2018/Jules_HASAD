using Hasad.Application.Features.Reporting.Models;

namespace Hasad.Application.Features.Reporting.Services;

public interface IReportMetadataService
{
    Task<ReportDefinitionMetadata?> GetMetadataAsync(string reportId);
    bool IsOperatorValid(string op);
    bool IsAggregateValid(string func);
}
