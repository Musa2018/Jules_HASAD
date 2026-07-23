using System.Text.Json;
using Hasad.Application.Features.Farms.Commands.CreateFarm;
using Hasad.Application.Features.Farms.Commands.UpdateFarm;
using Hasad.Application.Features.Farms.Models;
using Xunit;

namespace Hasad.Application.Tests;

public class FarmCompatibilityTests
{
    private readonly JsonSerializerOptions _jsonOptions = new()
    {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        PropertyNameCaseInsensitive = true
    };

    [Fact]
    public void CreateFarmCommand_DeserializesFrom_LegacyJson()
    {
        // GIVEN a JSON payload with legacy 'areaUnitId'
        var json = "{\"clientId\":\"550e8400-e29b-41d4-a716-446655440000\", \"farmerId\":\"550e8400-e29b-41d4-a716-446655440001\", \"localFarmName\":\"Farm\", \"areaUnitId\":5}";

        // WHEN deserializing into CreateFarmCommand
        var command = JsonSerializer.Deserialize<CreateFarmCommand>(json, _jsonOptions);

        // THEN MeasurementUnitId should be populated from areaUnitId
        Assert.NotNull(command);
        Assert.Equal(5, command.MeasurementUnitId);
    }

    [Fact]
    public void CreateFarmCommand_DeserializesFrom_ModernJson()
    {
        // GIVEN a JSON payload with modern 'measurementUnitId'
        var json = "{\"clientId\":\"550e8400-e29b-41d4-a716-446655440000\", \"farmerId\":\"550e8400-e29b-41d4-a716-446655440001\", \"localFarmName\":\"Farm\", \"measurementUnitId\":10}";

        // WHEN deserializing into CreateFarmCommand
        var command = JsonSerializer.Deserialize<CreateFarmCommand>(json, _jsonOptions);

        // THEN MeasurementUnitId should be populated correctly
        Assert.NotNull(command);
        Assert.Equal(10, command.MeasurementUnitId);
    }

    [Fact]
    public void UpdateFarmCommand_DeserializesFrom_LegacyJson()
    {
        // GIVEN a JSON payload with legacy 'areaUnitId'
        var json = "{\"id\":\"550e8400-e29b-41d4-a716-446655440000\", \"areaUnitId\":7, \"rowVersion\":\"AAAA\"}";

        // WHEN deserializing into UpdateFarmCommand
        var command = JsonSerializer.Deserialize<UpdateFarmCommand>(json, _jsonOptions);

        // THEN MeasurementUnitId should be populated from areaUnitId
        Assert.NotNull(command);
        Assert.Equal(7, command.MeasurementUnitId);
    }

    [Fact]
    public void FarmDto_SerializesWith_BothIds()
    {
        // GIVEN a FarmDto
        var dto = new FarmDto { MeasurementUnitId = 3 };

        // WHEN serializing to JSON
        var json = JsonSerializer.Serialize(dto, _jsonOptions);

        // THEN both keys should be present in the JSON
        Assert.Contains("\"measurementUnitId\":3", json);
        Assert.Contains("\"areaUnitId\":3", json);
    }

    [Fact]
    public void FarmSyncDto_SerializesWith_BothIds()
    {
        // GIVEN a FarmSyncDto
        var dto = new FarmSyncDto { AreaUnitId = 4 };

        // WHEN serializing to JSON
        var json = JsonSerializer.Serialize(dto, _jsonOptions);

        // THEN both keys should be present in the JSON
        Assert.Contains("\"areaUnitId\":4", json);
        Assert.Contains("\"measurementUnitId\":4", json);
    }
}
