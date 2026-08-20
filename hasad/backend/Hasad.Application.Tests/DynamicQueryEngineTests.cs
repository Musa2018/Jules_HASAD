using Hasad.Application.Features.Reporting.Models;
using Hasad.Application.Features.Reporting.Services;
using Xunit;

namespace Hasad.Application.Tests;

public class DynamicQueryEngineTests
{
    private readonly DynamicQueryEngine _engine;
    private readonly ReportDefinitionMetadata _metadata;

    public DynamicQueryEngineTests()
    {
        _engine = new DynamicQueryEngine();
        _metadata = new ReportDefinitionMetadata
        {
            ReportId = "test_report",
            DataSourceViewName = "vw_Test",
            DefaultSortField = "Id",
            AllowedFields = new Dictionary<string, ReportFieldMetadata>
            {
                { "Id", new ReportFieldMetadata { FieldName = "Id", DataType = "number" } },
                { "Name", new ReportFieldMetadata { FieldName = "Name", DataType = "string" } },
                { "DirectorateId", new ReportFieldMetadata { FieldName = "DirectorateId", DataType = "string" } }
            }
        };
    }

    [Fact]
    public void BuildQuery_ShouldIncludeRLS_WhenDirectorateIdProvided()
    {
        var directorateId = Guid.NewGuid();
        var request = new ReportRequest { ReportId = "test_report", SelectedColumns = new List<string> { "Name" } };

        var (sql, parameters) = _engine.BuildQuery(request, _metadata, directorateId, null);

        Assert.Contains("[DirectorateId] = @p0", sql);
        Assert.Equal(directorateId, parameters.Get<Guid>("@p0"));
    }

    [Fact]
    public void BuildQuery_ShouldHandleFilters_Correctly()
    {
        var request = new ReportRequest
        {
            ReportId = "test_report",
            Filters = new List<ReportFilter>
            {
                new ReportFilter { Field = "Name", Operator = "CONTAINS", Values = new List<string> { "Musa" } }
            }
        };

        var (sql, parameters) = _engine.BuildQuery(request, _metadata, null, null);

        Assert.Contains("[Name] LIKE @p0", sql);
        Assert.Equal("%Musa%", parameters.Get<string>("@p0"));
    }

    [Fact]
    public void BuildCountQuery_ShouldReturnCorrectCountSql()
    {
        var request = new ReportRequest { ReportId = "test_report" };

        var (sql, _) = _engine.BuildCountQuery(request, _metadata, null, null);

        Assert.StartsWith("SELECT COUNT(*)", sql);
        Assert.Contains("FROM [vw_Test]", sql);
    }
}
