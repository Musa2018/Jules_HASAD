using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.DamageReports.Commands.CreateDamageReport;
using Hasad.Domain.Entities;
using Hasad.Infrastructure.Persistence;
using Hasad.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace Hasad.Application.Tests;

public class DamageValuationTests
{
    private readonly Mock<ICurrentUserService> _currentUserMock;
    private readonly Mock<IDamageReportNumberService> _numberServiceMock;
    private readonly Mock<ILogger<CreateDamageReportCommandHandler>> _loggerMock;

    public DamageValuationTests()
    {
        _currentUserMock = new Mock<ICurrentUserService>();
        _numberServiceMock = new Mock<IDamageReportNumberService>();
        _loggerMock = new Mock<ILogger<CreateDamageReportCommandHandler>>();

        _numberServiceMock.Setup(x => x.GeneratePermanentNumberAsync(It.IsAny<Guid>(), It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync("000001-TEST-2026");
    }

    private ApplicationDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        return new ApplicationDbContext(options, _currentUserMock.Object);
    }

    [Fact]
    public async Task CreateReport_RecalculatesEstimatedLoss_AndLogsMismatch()
    {
        // Arrange
        var context = CreateContext();
        var costingService = new CostingService(context);
        var handler = new CreateDamageReportCommandHandler(context, _currentUserMock.Object, _numberServiceMock.Object, costingService, _loggerMock.Object);

        var farm = new Farm { Id = Guid.NewGuid(), DirectorateId = Guid.NewGuid() };
        var farmer = new Farmer { Id = Guid.NewGuid(), IdTypeId = 1, IdNumber = "1" };
        var classificationId = 101;
        var costingSheetId = Guid.NewGuid();
        var damageDate = DateTime.UtcNow.Date;

        context.Farms.Add(farm);
        context.Farmers.Add(farmer);
        context.CostingSheets.Add(new CostingSheet
        {
            Id = costingSheetId,
            ClassificationId = classificationId,
            UnitPrice = 50m,
            EffectiveFrom = damageDate.AddDays(-10),
            IsActive = true
        });
        await context.SaveChangesAsync();

        var itemInput = new CreateDamageItemInput(
            Guid.NewGuid(),
            classificationId,
            costingSheetId,
            10m, // Wrong unit price from client
            "Unit",
            10m,
            50m, // 50% damage
            100m, // Quantity 100
            0m // Wrong estimated loss from client
        );

        var command = new CreateDamageReportCommand(
            Guid.NewGuid(), "TEMP", 2026, farm.Id, farmer.Id, damageDate, 1, 1, null, null, Guid.NewGuid(), Guid.NewGuid(), null, null, "",
            new List<CreateDamageItemInput> { itemInput });

        // Act
        var result = await handler.Handle(command, CancellationToken.None);

        // Assert
        Assert.True(result.Succeeded);
        var createdItem = result.Data!.Items.First();

        // Backend math: 100 quantity * 50 unit price * 0.5 percentage = 2500
        Assert.Equal(2500m, createdItem.EstimatedLoss);
        Assert.Equal(50m, createdItem.CalculatedUnitPrice);

        // Verify Warning Log for Mismatch
        _loggerMock.Verify(
            x => x.Log(
                LogLevel.Warning,
                It.IsAny<EventId>(),
                It.Is<It.IsAnyType>((v, t) => v.ToString()!.Contains("Valuation Mismatch")),
                It.IsAny<Exception>(),
                It.Is<Func<It.IsAnyType, Exception?, string>>((v, t) => true)),
            Times.Once);
    }

    [Fact]
    public async Task CreateReport_Fails_WhenCostingSheetDoesNotBelongToClassification()
    {
        // Arrange
        var context = CreateContext();
        var costingService = new CostingService(context);
        var handler = new CreateDamageReportCommandHandler(context, _currentUserMock.Object, _numberServiceMock.Object, costingService, _loggerMock.Object);

        var farm = new Farm { Id = Guid.NewGuid(), DirectorateId = Guid.NewGuid() };
        var farmer = new Farmer { Id = Guid.NewGuid() };
        var classificationId = 101;
        var wrongCostingSheetId = Guid.NewGuid();

        context.Farms.Add(farm);
        context.Farmers.Add(farmer);
        context.CostingSheets.Add(new CostingSheet
        {
            Id = wrongCostingSheetId,
            ClassificationId = 999, // Different!
            UnitPrice = 50m,
            EffectiveFrom = DateTime.UtcNow.AddDays(-10),
            IsActive = true
        });
        await context.SaveChangesAsync();

        var itemInput = new CreateDamageItemInput(Guid.NewGuid(), classificationId, wrongCostingSheetId, 50m, "U", 1, 50, 10, 250);
        var command = new CreateDamageReportCommand(Guid.NewGuid(), "T", 2026, farm.Id, farmer.Id, DateTime.UtcNow, 1, 1, null, null, Guid.NewGuid(), Guid.NewGuid(), null, null, "", new List<CreateDamageItemInput> { itemInput });

        // Act
        var result = await handler.Handle(command, CancellationToken.None);

        // Assert
        Assert.False(result.Succeeded);
        Assert.Contains("does not belong to classification", result.Errors[0]);
    }

    [Fact]
    public async Task CreateReport_Fails_WhenCostingSheetNotActiveOnDamageDate()
    {
        // Arrange
        var context = CreateContext();
        var costingService = new CostingService(context);
        var handler = new CreateDamageReportCommandHandler(context, _currentUserMock.Object, _numberServiceMock.Object, costingService, _loggerMock.Object);

        var farm = new Farm { Id = Guid.NewGuid(), DirectorateId = Guid.NewGuid() };
        var farmer = new Farmer { Id = Guid.NewGuid() };
        var classificationId = 101;
        var costingSheetId = Guid.NewGuid();
        var damageDate = DateTime.UtcNow.Date;

        context.Farms.Add(farm);
        context.Farmers.Add(farmer);
        context.CostingSheets.Add(new CostingSheet
        {
            Id = costingSheetId,
            ClassificationId = classificationId,
            UnitPrice = 50m,
            EffectiveFrom = damageDate.AddDays(1), // Starts tomorrow!
            IsActive = true
        });
        await context.SaveChangesAsync();

        var itemInput = new CreateDamageItemInput(Guid.NewGuid(), classificationId, costingSheetId, 50m, "U", 1, 50, 10, 250);
        var command = new CreateDamageReportCommand(Guid.NewGuid(), "T", 2026, farm.Id, farmer.Id, damageDate, 1, 1, null, null, Guid.NewGuid(), Guid.NewGuid(), null, null, "", new List<CreateDamageItemInput> { itemInput });

        // Act
        var result = await handler.Handle(command, CancellationToken.None);

        // Assert
        Assert.False(result.Succeeded);
        Assert.Contains("was not active on the damage date", result.Errors[0]);
    }
}
