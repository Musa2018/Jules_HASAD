using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.DamageReports.Commands.CreateDamageReport;
using Hasad.Application.Features.DamageReports.Queries.GetDamageReportsByFarm;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using Hasad.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace Hasad.Application.Tests;

public class DamageReportCommandHandlerTests
{
    private readonly Mock<ICurrentUserService> _currentUserMock;
    private readonly Mock<IDamageReportNumberService> _numberServiceMock;
    private readonly Mock<ICostingService> _costingServiceMock;
    private readonly Mock<ILogger<CreateDamageReportCommandHandler>> _loggerMock;

    public DamageReportCommandHandlerTests()
    {
        _currentUserMock = new Mock<ICurrentUserService>();
        _currentUserMock.Setup(x => x.UserId).Returns(Guid.NewGuid().ToString());

        _numberServiceMock = new Mock<IDamageReportNumberService>();
        _numberServiceMock.Setup(x => x.GeneratePermanentNumberAsync(It.IsAny<Guid>(), It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync("000001-TEST-2026");

        _costingServiceMock = new Mock<ICostingService>();
        _costingServiceMock.Setup(x => x.GetUnitPriceAsync(It.IsAny<int>(), It.IsAny<Guid>(), It.IsAny<DateTime>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(Hasad.Application.Common.Models.Result<decimal>.Success(100m));

        _loggerMock = new Mock<ILogger<CreateDamageReportCommandHandler>>();
    }

    private ApplicationDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        return new ApplicationDbContext(options, _currentUserMock.Object);
    }

    [Fact]
    public async Task CreateDamageReport_Succeeds_WithItemsAndNumber()
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
        var farm = new Farm
        {
            Id = Guid.NewGuid(),
            FarmerId = farmer.Id,
            LocalFarmName = "Farm",
            DirectorateId = Guid.NewGuid()
        };
        context.Farmers.Add(farmer);
        context.Farms.Add(farm);
        await context.SaveChangesAsync();

        var handler = new CreateDamageReportCommandHandler(context, _currentUserMock.Object, _numberServiceMock.Object, _costingServiceMock.Object, _loggerMock.Object);
        var command = new CreateDamageReportCommand(
            Guid.NewGuid(),
            "TEMP-001",
            farm.Id,
            DateTime.UtcNow,
            1, // AgriculturalSectorId
            1, // DamageCauseCategoryId
            1, // DamageCauseId
            null,
            null,
            "Test Notes",
            new List<CreateDamageItemInput>
            {
                new(Guid.NewGuid(), 1, 1, 1, Guid.NewGuid(), 100, "Tree", 10, 50, 100, 1000)
            });

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Equal("000001-TEST-2026", result.Data!.ReportNumber);
        Assert.Single(result.Data!.Items);
        Assert.Equal(DamageReportStatus.PendingTechnicalVerification, result.Data.StatusId);
    }

    [Fact]
    public async Task CreateDamageReport_OpensExisting_WhenDuplicateOnSameDay()
    {
        var context = CreateContext();
        var farmId = Guid.NewGuid();
        var date = DateTime.UtcNow.Date;
        var causeId = 1;
        var reportId = Guid.NewGuid();

        context.DamageReports.Add(new DamageReport
        {
            Id = reportId,
            ClientId = Guid.NewGuid(),
            FarmId = farmId,
            DamageDate = date,
            DamageCauseId = causeId,
            StatusId = "Draft",
            RowVersion = new byte[] { 1 }
        });

        var farmer = new Farmer { Id = Guid.NewGuid(), IdTypeId = 1, IdNumber = "1", FirstNameAr = "A", FatherNameAr = "B", GrandfatherNameAr = "C", FamilyNameAr = "D" };
        var farm = new Farm { Id = farmId, FarmerId = farmer.Id, LocalFarmName = "F", DirectorateId = Guid.NewGuid() };
        context.Farmers.Add(farmer);
        context.Farms.Add(farm);
        await context.SaveChangesAsync();

        var handler = new CreateDamageReportCommandHandler(context, _currentUserMock.Object, _numberServiceMock.Object, _costingServiceMock.Object, _loggerMock.Object);
        var command = new CreateDamageReportCommand(
            Guid.NewGuid(), "T1", farmId, date, 1, 1, causeId, null, null, "", new List<CreateDamageItemInput>());

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Equal(reportId, result.Data!.Id);
    }

    [Fact]
    public async Task CreateDamageReport_Fails_WhenEngineerOutsideDirectorate()
    {
        var context = CreateContext();
        var userDirectorateId = Guid.NewGuid();
        var farmDirectorateId = Guid.NewGuid();

        _currentUserMock.Setup(x => x.IsInRole("AgriculturalEngineer")).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(userDirectorateId);

        var farmer = new Farmer { Id = Guid.NewGuid(), IdTypeId = 1, IdNumber = "1", FirstNameAr = "A", FatherNameAr = "B", GrandfatherNameAr = "C", FamilyNameAr = "D" };
        var farm = new Farm { Id = Guid.NewGuid(), FarmerId = farmer.Id, LocalFarmName = "F", DirectorateId = farmDirectorateId };
        context.Farmers.Add(farmer);
        context.Farms.Add(farm);
        await context.SaveChangesAsync();

        var handler = new CreateDamageReportCommandHandler(context, _currentUserMock.Object, _numberServiceMock.Object, _costingServiceMock.Object, _loggerMock.Object);
        var command = new CreateDamageReportCommand(
            Guid.NewGuid(), "T1", farm.Id, DateTime.UtcNow, 1, 1, 1, null, null, "", new List<CreateDamageItemInput>());

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.False(result.Succeeded);
        Assert.Contains("within your assigned directorate", result.Errors[0]);
    }

    [Fact]
    public async Task GetDamageReportsByFarm_ReturnsReports()
    {
        var context = CreateContext();
        var farmId = Guid.NewGuid();
        context.DamageReports.Add(new DamageReport
        {
            Id = Guid.NewGuid(),
            ClientId = Guid.NewGuid(),
            FarmId = farmId,
            DamageDate = DateTime.UtcNow,
            StatusId = "Draft",
            RowVersion = new byte[] { 1 }
        });
        await context.SaveChangesAsync();

        var handler = new GetDamageReportsByFarmQueryHandler(context, _currentUserMock.Object);
        var query = new GetDamageReportsByFarmQuery(farmId);

        var result = await handler.Handle(query, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Single(result.Data!);
    }
}
