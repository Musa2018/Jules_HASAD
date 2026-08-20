using Dapper;
using Hasad.Application.Features.Reporting.Models;

namespace Hasad.Application.Features.Reporting.Services;

public interface IDynamicQueryEngine
{
    (string sql, DynamicParameters parameters) BuildQuery(
        ReportRequest request,
        ReportDefinitionMetadata metadata,
        Guid? directorateId,
        Guid? governorateId);

    (string sql, DynamicParameters parameters) BuildCountQuery(
        ReportRequest request,
        ReportDefinitionMetadata metadata,
        Guid? directorateId,
        Guid? governorateId);
}
