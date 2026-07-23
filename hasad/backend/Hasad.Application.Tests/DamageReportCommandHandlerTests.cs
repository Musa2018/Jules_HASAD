using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.DamageReports.Commands.CreateDamageReport;
using Hasad.Application.Features.DamageReports.Queries.GetDamageReportsByFarm;
using Hasad.Domain.Entities;
using Hasad.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;

namespace Hasad.Application.Tests;

public class DamageReportCommandHandlerTests
{
    private readonly Mock<ICurrentUserService> _currentUserMock;

    public DamageReportCommandHandlerTests()
    {
        _currentUserMock = new Mock<ICurrentUserService>();
        _currentUserMock.Setup(x => x.UserId).Returns(Guid.NewGuid().ToString());
    }

    private ApplicationDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        return new ApplicationDbContext(options);
    }

    [Fact]
    public async Task CreateDamageReport_Succeeds_WithItems()
    {
        var context = CreateContext();
        var farmer = new Farmer
        {
            Id = Guid.NewGuid(),
            FirstNameAr = "مزارع",
            FatherNameAr = "اختبار",
            GrandfatherNameAr = "في",
            FamilyNameAr = "النظام",
            IdTypeId = 1,
            IdNumber = "123456789"
        };
        var farm = new Farm { Id = Guid.NewGuid(), FarmerId = farmer.Id, LocalFarmName = "Farm" };
        context.Farmers.Add(farmer);
        context.Farms.Add(farm);
        await context.SaveChangesAsync();

        var handler = new CreateDamageReportCommandHandler(context, _currentUserMock.Object);
        var command = new CreateDamageReportCommand(
            Guid.NewGuid(),
            farm.Id,
            farmer.Id,
            DateTime.UtcNow,
            Guid.NewGuid().ToString(),
            Guid.NewGuid().ToString(),
            null,
            null,
            "Test Notes",
            new List<CreateDamageItemInput>
            {
                new(Guid.NewGuid(), "Plant", "Fruit", "Olive", "Fire", 10, 50, 100, 1000)
            });

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Single(result.Data!.Items);
        Assert.Equal("Submitted", result.Data.StatusId);
        Assert.Single(context.DamageReports);
        Assert.Single(context.DamageItems);
    }

    [Fact]
    public async Task GetDamageReportsByFarm_ReturnsReports()
    {
        var context = CreateContext();
        var farmId = Guid.NewGuid();
        context.DamageReports.Add(new DamageReport
        {
            Id = Guid.NewGuid(),
            FarmId = farmId,
            FarmerId = Guid.NewGuid(),
            DamageDate = DateTime.UtcNow,
            GovernorateId = Guid.NewGuid().ToString(),
            LocalityId = Guid.NewGuid().ToString(),
            StatusId = "Draft",
            RowVersion = new byte[] { 1 }
        });
        await context.SaveChangesAsync();

        var handler = new GetDamageReportsByFarmQueryHandler(context);
        var query = new GetDamageReportsByFarmQuery(farmId);

        var result = await handler.Handle(query, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Single(result.Data!);
    }

    [Fact]
    public async Task CreateDamageReport_Fails_WhenGovernorateScopingMismatches()
    {
        var context = CreateContext();
        var userGovId = Guid.NewGuid();
        _currentUserMock.Setup(x => x.IsInRole("Director")).Returns(true);
        _currentUserMock.Setup(x => x.GovernorateId).Returns(userGovId);

        var handler = new CreateDamageReportCommandHandler(context, _currentUserMock.Object);
        var command = new CreateDamageReportCommand(
            Guid.NewGuid(),
            Guid.NewGuid(),
            Guid.NewGuid(),
            DateTime.UtcNow,
            Guid.NewGuid().ToString(), // Different
            Guid.NewGuid().ToString(),
            null, null, "", new List<CreateDamageItemInput>());

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.False(result.Succeeded);
        Assert.Contains("Access Denied", result.Errors[0]);
    }
}
