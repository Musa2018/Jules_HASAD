using Hasad.Application.Features.Reporting.Services;
using Xunit;

namespace Hasad.Application.Tests;

public class ReportingMetadataTests
{
    private readonly ReportMetadataService _service;

    public ReportingMetadataTests()
    {
        _service = new ReportMetadataService();
    }

    [Fact]
    public async Task GetMetadata_ShouldReturnMetadata_ForValidReportId()
    {
        var result = await _service.GetMetadataAsync("damage_summary");
        Assert.NotNull(result);
        Assert.Equal("vw_DamageSummary", result.DataSourceViewName);
    }

    [Fact]
    public async Task GetMetadata_ShouldReturnNull_ForInvalidReportId()
    {
        var result = await _service.GetMetadataAsync("non_existent_report");
        Assert.Null(result);
    }

    [Theory]
    [InlineData("EQUALS", true)]
    [InlineData("BETWEEN", true)]
    [InlineData("DROP TABLE Users", false)]
    [InlineData("DELETE", false)]
    public void IsOperatorValid_ShouldValidateCorrectly(string op, bool expected)
    {
        var result = _service.IsOperatorValid(op);
        Assert.Equal(expected, result);
    }

    [Theory]
    [InlineData("SUM", true)]
    [InlineData("AVG", true)]
    [InlineData("SLEEP(5000)", false)]
    public void IsAggregateValid_ShouldValidateCorrectly(string func, bool expected)
    {
        var result = _service.IsAggregateValid(func);
        Assert.Equal(expected, result);
    }
}
