using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.DamageReports.Commands.CreateDamageReport;
using Hasad.Application.Features.DamageReports.Commands.AddDamageItem;
using Hasad.Application.Features.DamageReports.Queries.GetDamageReportsByFarm;
using Hasad.Application.Features.Farms.Queries.GetFarmsByFarmer;
using Hasad.Application.Features.Farmers.Queries.GetFarmersList;
using Hasad.Domain.Entities;
using Hasad.Infrastructure.Persistence;
using Hasad.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;
using Hasad.Domain.Constants;
using Hasad.Application.Common.Models;

namespace Hasad.Application.Tests;

public class UatProductionValidationTests
{
    private async Task<ApplicationDbContext> GetDbContext(ICurrentUserService? userService = null)
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        var context = new ApplicationDbContext(options, userService ?? new Mock<ICurrentUserService>().Object);

        // Seed Reference Data for Numbering
        var gov = new Governorate { Id = Guid.NewGuid(), NameAr = "جنين", NameEn = "Jenin", Code = "JEN" };
        var dir1 = new Directorate { Id = Guid.NewGuid(), GovernorateId = gov.Id, NameAr = "مديرية جنين", NameEn = "Jenin Directorate", Code = "JEN" };
        var dir2 = new Directorate { Id = Guid.NewGuid(), GovernorateId = gov.Id, NameAr = "مديرية شمال جنين", NameEn = "North Jenin Directorate", Code = "NJEN" };

        context.Governorates.Add(gov);
        context.Directorates.AddRange(dir1, dir2);

        // Seed Mandatory Lookups for Damage Report
        context.AgriculturalSectors.Add(new AgriculturalSector { Id = 1, NameAr = "S", NameEn = "S" });
        context.DamageCauseCategories.Add(new DamageCauseCategory { Id = 1, NameAr = "C", NameEn = "C" });
        context.DamageCauses.Add(new DamageCause { Id = 1, CategoryId = 1, NameAr = "C", NameEn = "C" });

        await context.SaveChangesAsync();

        return context;
    }

    [Fact]
    public async Task UAT_Scenario_MultiFarm_Geographic_Isolation()
    {
        // Setup: Farmer Ahmed with 2 farms in different directorates
        var context = await GetDbContext();
        var jeninDir = await context.Directorates.FirstAsync(d => d.Code == "JEN");
        var nJeninDir = await context.Directorates.FirstAsync(d => d.Code == "NJEN");

        var farmerAhmedId = Guid.NewGuid();
        context.Farmers.Add(new Farmer {
            Id = farmerAhmedId,
            FirstNameAr = "أحمد",
            GovernorateId = jeninDir.GovernorateId,
            LocalityId = Guid.NewGuid(),
            RowVersion = new byte[] { 1 }
        });

        var jeninFarmId = Guid.NewGuid();
        context.Farms.Add(new Farm {
            Id = jeninFarmId,
            FarmerId = farmerAhmedId,
            LocalFarmName = "مزرعة جنين",
            DirectorateId = jeninDir.Id,
            GovernorateId = jeninDir.GovernorateId,
            LocalityId = Guid.NewGuid(),
            Basin = "1", Parcel = "1", RowVersion = new byte[] { 1 }
        });

        var nJeninFarmId = Guid.NewGuid();
        context.Farms.Add(new Farm {
            Id = nJeninFarmId,
            FarmerId = farmerAhmedId,
            LocalFarmName = "مزرعة شمال جنين",
            DirectorateId = nJeninDir.Id,
            GovernorateId = nJeninDir.GovernorateId,
            LocalityId = Guid.NewGuid(),
            Basin = "2", Parcel = "2", RowVersion = new byte[] { 1 }
        });

        await context.SaveChangesAsync();

        // 1. Test Jenin User Visibility
        var jeninUserMock = new Mock<ICurrentUserService>();
        jeninUserMock.Setup(u => u.DirectorateId).Returns(jeninDir.Id);
        jeninUserMock.Setup(u => u.IsInRole(AppRoles.FieldSurveyor)).Returns(true);

        var farmQueryHandler = new GetFarmsByFarmerQueryHandler(context, jeninUserMock.Object);
        var farmsResult = await farmQueryHandler.Handle(new GetFarmsByFarmerQuery(farmerAhmedId), CancellationToken.None);

        Assert.True(farmsResult.Succeeded);
        Assert.NotNull(farmsResult.Data);
        Assert.Single(farmsResult.Data);
        Assert.Equal(jeninFarmId, farmsResult.Data.First().Id);
        Assert.DoesNotContain(farmsResult.Data, f => f.Id == nJeninFarmId);

        // 2. Test North Jenin User Visibility
        var nJeninUserMock = new Mock<ICurrentUserService>();
        nJeninUserMock.Setup(u => u.DirectorateId).Returns(nJeninDir.Id);
        nJeninUserMock.Setup(u => u.IsInRole(AppRoles.FieldSurveyor)).Returns(true);

        farmQueryHandler = new GetFarmsByFarmerQueryHandler(context, nJeninUserMock.Object);
        var nFarmsResult = await farmQueryHandler.Handle(new GetFarmsByFarmerQuery(farmerAhmedId), CancellationToken.None);

        Assert.True(nFarmsResult.Succeeded);
        Assert.NotNull(nFarmsResult.Data);
        Assert.Single(nFarmsResult.Data);
        Assert.Equal(nJeninFarmId, nFarmsResult.Data.First().Id);
        Assert.DoesNotContain(nFarmsResult.Data, f => f.Id == jeninFarmId);
    }

    [Fact]
    public async Task UAT_Scenario_DamageReport_Numbering_And_Duplicate_Prevention()
    {
        var context = await GetDbContext();
        var dir = await context.Directorates.FirstAsync(d => d.Code == "JEN");
        var farmerId = Guid.NewGuid();
        context.Farmers.Add(new Farmer { Id = farmerId, FirstNameAr = "Test", GovernorateId = dir.GovernorateId, LocalityId = Guid.NewGuid(), RowVersion = new byte[] { 1 } });

        var farmId = Guid.NewGuid();
        context.Farms.Add(new Farm {
            Id = farmId,
            FarmerId = farmerId,
            LocalFarmName = "Test Farm",
            DirectorateId = dir.Id,
            GovernorateId = dir.GovernorateId,
            LocalityId = Guid.NewGuid(),
            Basin = "1", Parcel = "1", RowVersion = new byte[] { 1 }
        });
        await context.SaveChangesAsync();

        var numService = new DamageReportNumberService(context);
        var costingMock = new Mock<ICostingService>();
        var userMock = new Mock<ICurrentUserService>();
        userMock.Setup(u => u.UserId).Returns("surveyor-1");
        userMock.Setup(u => u.DirectorateId).Returns(dir.Id);
        userMock.Setup(u => u.IsInRole(It.IsAny<string>())).Returns(true);

        var handler = new CreateDamageReportCommandHandler(context, userMock.Object, numService, costingMock.Object, new Mock<Microsoft.Extensions.Logging.ILogger<CreateDamageReportCommandHandler>>().Object);

        // Act: Create first report
        var date = new DateTime(2026, 7, 31);
        var result1 = await handler.Handle(new CreateDamageReportCommand(Guid.NewGuid(), "TEMP-1", farmId, date, 1, 1, 1, "Notes"), CancellationToken.None);

        if (!result1.Succeeded)
        {
             throw new Exception($"CreateDamageReport failed: {string.Join(", ", result1.Errors)}");
        }

        Assert.True(result1.Succeeded);
        Assert.NotNull(result1.Data);
        Assert.StartsWith("JEN-JEN-2026-", result1.Data.ReportNumber);

        // Act: Try to create duplicate (Same Farm + Same Date)
        var result2 = await handler.Handle(new CreateDamageReportCommand(Guid.NewGuid(), "TEMP-2", farmId, date, 1, 1, 1, "Notes 2"), CancellationToken.None);

        Assert.False(result2.Succeeded);
        Assert.Equal("DAMAGE_REPORT_DUPLICATE", result2.Code);
    }

    [Fact]
    public async Task UAT_Scenario_Financial_Integrity_Verification()
    {
        var context = await GetDbContext();
        var dir = await context.Directorates.FirstAsync(d => d.Code == "JEN");
        var reportId = Guid.NewGuid();
        context.DamageReports.Add(new DamageReport {
            Id = reportId,
            DirectorateId = dir.Id,
            GovernorateId = dir.GovernorateId,
            DamageDate = DateTime.UtcNow,
            RowVersion = new byte[] { 1 }
        });
        await context.SaveChangesAsync();

        var costingMock = new Mock<ICostingService>();
        // Mock authoritative price: 50.0
        costingMock.Setup(c => c.GetUnitPriceAsync(It.IsAny<int>(), It.IsAny<Guid>(), It.IsAny<DateTime>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(Hasad.Application.Common.Models.Result<decimal>.Success(50.0m));

        var userMock = new Mock<ICurrentUserService>();
        userMock.Setup(u => u.DirectorateId).Returns(dir.Id);
        userMock.Setup(u => u.IsInRole(It.IsAny<string>())).Returns(true);

        var handler = new AddDamageItemCommandHandler(context, userMock.Object, costingMock.Object, new Mock<Microsoft.Extensions.Logging.ILogger<AddDamageItemCommandHandler>>().Object);

        // Act: Send malicious payload (fake high prices)
        var command = new AddDamageItemCommand(
            DamageReportId: reportId,
            ClientId: Guid.NewGuid(),
            DamageNatureId: 1,
            DamageActionId: 1,
            ClassificationId: 1,
            CostingSheetId: Guid.NewGuid(),
            CalculatedUnitPrice: 999999.99m, // FAKE
            MeasurementUnitSnapshot: "Unit",
            AffectedArea: 10,
            DamagePercentage: 100,
            Quantity: 2,
            EstimatedLoss: 999999.99m // FAKE
        );

        var result = await handler.Handle(command, CancellationToken.None);

        // Assert: System must have used the authoritative 50.0 price
        Assert.True(result.Succeeded);
        Assert.NotNull(result.Data);
        Assert.Equal(50.0m, result.Data.CalculatedUnitPrice);
        Assert.Equal(100.0m, result.Data.EstimatedLoss); // 2 units * 50.0 = 100.0
    }
}
