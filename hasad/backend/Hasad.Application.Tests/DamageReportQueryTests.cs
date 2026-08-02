using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.DamageReports.Queries.GetDamageReportsByFarm;
using Hasad.Application.Features.DamageReports.Queries.GetDamageReportsByFarmer;
using Hasad.Domain.Entities;
using Moq;
using Microsoft.EntityFrameworkCore;
using Xunit;
using Hasad.Infrastructure.Persistence;

namespace Hasad.Application.Tests;

public class DamageReportQueryTests
{
    private readonly Mock<ICurrentUserService> _currentUserMock;
    private readonly DbContextOptions<ApplicationDbContext> _options;

    public DamageReportQueryTests()
    {
        _currentUserMock = new Mock<ICurrentUserService>();
        _options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
    }

    [Fact]
    public async Task GetDamageReportsByFarm_ShouldIncludeItems()
    {
        // Arrange
        var farmId = Guid.NewGuid();
        var reportId = Guid.NewGuid();

        using var context = new ApplicationDbContext(_options, _currentUserMock.Object);

        var report = new DamageReport
        {
            Id = reportId,
            FarmId = farmId,
            DamageDate = DateTime.UtcNow,
            StatusId = "Draft",
            Items = new List<DamageItem>
            {
                new DamageItem { Id = Guid.NewGuid(), ClientId = Guid.NewGuid(), Quantity = 10, EstimatedLoss = 100, MeasurementUnitSnapshot = "Unit" },
                new DamageItem { Id = Guid.NewGuid(), ClientId = Guid.NewGuid(), Quantity = 20, EstimatedLoss = 200, MeasurementUnitSnapshot = "Unit" }
            }
        };

        context.DamageReports.Add(report);
        await context.SaveChangesAsync();

        var handler = new GetDamageReportsByFarmQueryHandler(context, _currentUserMock.Object);
        var query = new GetDamageReportsByFarmQuery(farmId);

        // Act
        var result = await handler.Handle(query, CancellationToken.None);

        // Assert
        Assert.True(result.Succeeded);
        var reports = result.Data;
        Assert.Single(reports!);
        Assert.Equal(2, reports![0].Items.Count);
    }

    [Fact]
    public async Task GetDamageReportsByFarmer_ShouldIncludeItems()
    {
        // Arrange
        var farmerId = Guid.NewGuid();
        var farmId = Guid.NewGuid();

        using var context = new ApplicationDbContext(_options, _currentUserMock.Object);

        var report = new DamageReport
        {
            Id = Guid.NewGuid(),
            FarmerId = farmerId,
            FarmId = farmId,
            DamageDate = DateTime.UtcNow,
            StatusId = "Draft",
            Items = new List<DamageItem>
            {
                new DamageItem { Id = Guid.NewGuid(), ClientId = Guid.NewGuid(), Quantity = 5, EstimatedLoss = 50, MeasurementUnitSnapshot = "Unit" }
            }
        };

        context.DamageReports.Add(report);
        await context.SaveChangesAsync();

        var handler = new GetDamageReportsByFarmerQueryHandler(context, _currentUserMock.Object);
        var query = new GetDamageReportsByFarmerQuery(farmerId);

        // Act
        var result = await handler.Handle(query, CancellationToken.None);

        // Assert
        Assert.True(result.Succeeded);
        var reports = result.Data;
        Assert.Single(reports!);
        Assert.Single(reports![0].Items);
    }
}
