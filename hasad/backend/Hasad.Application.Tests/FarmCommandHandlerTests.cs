using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.Farms.Commands.CreateFarm;
using Hasad.Application.Features.Farms.Commands.UpdateFarm;
using Hasad.Application.Features.Farms.Commands.DeleteFarm;
using Hasad.Application.Features.Farms.Queries.GetFarmById;
using Hasad.Application.Features.Farms.Queries.GetFarmsByFarmer;
using Hasad.Domain.Entities;
using Hasad.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;

namespace Hasad.Application.Tests;

public class FarmCommandHandlerTests
{
    private readonly Mock<ICurrentUserService> _currentUserMock;

    public FarmCommandHandlerTests()
    {
        _currentUserMock = new Mock<ICurrentUserService>();
        _currentUserMock.Setup(x => x.UserId).Returns(Guid.NewGuid().ToString());
    }

    private ApplicationDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        return new ApplicationDbContext(options, _currentUserMock.Object);
    }

    [Fact]
    public async Task CreateFarm_Succeeds_WhenDataIsValid()
    {
        var context = CreateContext();
        var farmer = new Farmer
        {
            Id = Guid.NewGuid(),
            FirstNameAr = "مزارع",
            IdTypeId = 1,
            IdNumber = "123456789"
        };
        context.Farmers.Add(farmer);
        await context.SaveChangesAsync();

        var handler = new CreateFarmCommandHandler(context, _currentUserMock.Object);
        var command = new CreateFarmCommand(
            Guid.NewGuid(),
            farmer.Id,
            "My Farm",
            1, // OwnershipTypeId (ملك)
            null, // OwnerFarmerId
            null, // RelationshipToOwnerId
            Guid.NewGuid(), // GovernorateId
            Guid.NewGuid(), // DirectorateId
            Guid.NewGuid(), // LocalityId
            "Basin 1",
            "Parcel 2",
            100.5m,
            1, // MeasurementUnitId
            1, // AgriculturalSectorId
            1, // PoliticalClassificationId
            31.5,
            34.5,
            "Notes");

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.NotNull(result.Data);
        Assert.Equal("My Farm", result.Data.LocalFarmName);
        Assert.Single(context.Farms);
    }

    [Fact]
    public async Task CreateFarm_IsIdempotent_WhenClientIdExists()
    {
        var context = CreateContext();
        var clientId = Guid.NewGuid();
        var farmer = new Farmer
        {
            Id = Guid.NewGuid(),
            FirstNameAr = "مزارع",
            IdTypeId = 1,
            IdNumber = "123456789"
        };
        context.Farmers.Add(farmer);
        context.Farms.Add(new Farm
        {
            Id = Guid.NewGuid(),
            ClientId = clientId,
            FarmerId = farmer.Id,
            LocalFarmName = "Existing",
            RowVersion = new byte[] { 1 }
        });
        await context.SaveChangesAsync();

        var handler = new CreateFarmCommandHandler(context, _currentUserMock.Object);
        var command = new CreateFarmCommand(
            clientId,
            farmer.Id,
            "New Name",
            1, null, null, Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(),
            "B", "P", 1, 1, 1, 1, null, null, "O");

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Equal("Existing", result.Data!.LocalFarmName);
        Assert.Single(context.Farms);
    }

    [Fact]
    public async Task UpdateFarm_Fails_WhenVersionMismatches()
    {
        var context = CreateContext();
        var farmer = new Farmer
        {
            Id = Guid.NewGuid(),
            FirstNameAr = "مزارع",
            IdTypeId = 1,
            IdNumber = "123456789"
        };
        var farm = new Farm
        {
            Id = Guid.NewGuid(),
            ClientId = Guid.NewGuid(),
            FarmerId = farmer.Id,
            LocalFarmName = "Old",
            RowVersion = new byte[] { 1 }
        };
        context.Farmers.Add(farmer);
        context.Farms.Add(farm);
        await context.SaveChangesAsync();

        var handler = new UpdateFarmCommandHandler(context, _currentUserMock.Object);
        var command = new UpdateFarmCommand(
            farm.Id,
            farm.ClientId,
            farmer.Id,
            "New",
            1, null, null, Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(),
            "B", "P", 2, 1, 1, 1, null, null, "O",
            Convert.ToBase64String(new byte[] { 2 }));

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.False(result.Succeeded);
        Assert.Contains("CONFLICT", result.Errors[0]);
    }

    [Fact]
    public async Task CreateFarm_Fails_WhenDirectorateScopingMismatches()
    {
        var context = CreateContext();
        var farmer = new Farmer { Id = Guid.NewGuid() };
        context.Farmers.Add(farmer);
        await context.SaveChangesAsync();

        var userDirectorateId = Guid.NewGuid();
        _currentUserMock.Setup(x => x.IsInRole("FieldSurveyor")).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(userDirectorateId);

        var handler = new CreateFarmCommandHandler(context, _currentUserMock.Object);
        var command = new CreateFarmCommand(
            Guid.NewGuid(), farmer.Id, "Farm", 1, null, null,
            Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), // Different DirectorateId
            "B", "P", 10, 1, 1, 1, null, null, null);

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.False(result.Succeeded);
        Assert.Contains("Access Denied", result.Errors[0]);
    }

    [Fact]
    public async Task CreateFarm_Succeeds_WhenFarmerIsFromDifferentGovernorate()
    {
        var context = CreateContext();
        var userDirectorateId = Guid.NewGuid();
        var userGovernorateId = Guid.NewGuid();

        // Farmer from Bethlehem
        var farmer = new Farmer
        {
            Id = Guid.NewGuid(),
            GovernorateId = Guid.NewGuid().ToString(), // Different Gov
            FirstNameAr = "Bethlehem Farmer",
            IdTypeId = 1,
            IdNumber = "123"
        };
        context.Farmers.Add(farmer);
        await context.SaveChangesAsync();

        _currentUserMock.Setup(x => x.IsInRole("AgriculturalEngineer")).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(userDirectorateId);
        _currentUserMock.Setup(x => x.GovernorateId).Returns(userGovernorateId);

        var handler = new CreateFarmCommandHandler(context, _currentUserMock.Object);
        var command = new CreateFarmCommand(
            Guid.NewGuid(),
            farmer.Id,
            "Jericho Farm",
            1, null, null,
            userGovernorateId,
            userDirectorateId, // Match Engineer scope
            Guid.NewGuid(),
            "B", "P", 10, 1, 1, 1, null, null, null);

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.NotNull(result.Data);
        Assert.Equal("Jericho Farm", result.Data.LocalFarmName);
    }

    [Fact]
    public async Task CreateFarm_Fails_WhenFarmIsOutsideDirectorateScope()
    {
        var context = CreateContext();
        var farmer = new Farmer { Id = Guid.NewGuid() };
        context.Farmers.Add(farmer);
        await context.SaveChangesAsync();

        var userDirectorateId = Guid.NewGuid();
        _currentUserMock.Setup(x => x.IsInRole("AgriculturalEngineer")).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(userDirectorateId);

        var handler = new CreateFarmCommandHandler(context, _currentUserMock.Object);
        var command = new CreateFarmCommand(
            Guid.NewGuid(), farmer.Id, "Bethlehem Farm", 1, null, null,
            Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), // Outside scope
            "B", "P", 1, 1, 1, 1, null, null, null);

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.False(result.Succeeded);
        Assert.Contains("Access Denied", result.Errors[0]);
    }

    [Fact]
    public async Task DeleteFarm_PopulatesAuditFields_Automatically()
    {
        var context = CreateContext();
        var userId = Guid.NewGuid().ToString();
        _currentUserMock.Setup(x => x.UserId).Returns(userId);

        var farm = new Farm
        {
            Id = Guid.NewGuid(),
            LocalFarmName = "To Delete",
            DirectorateId = Guid.NewGuid() // Match default if any roles set
        };
        context.Farms.Add(farm);
        await context.SaveChangesAsync();

        var handler = new DeleteFarmCommandHandler(context, _currentUserMock.Object);
        var command = new DeleteFarmCommand(farm.Id);

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);

        // We need a fresh context or use IgnoreQueryFilters to see the deleted record
        var deletedFarm = await context.Farms
            .IgnoreQueryFilters()
            .FirstOrDefaultAsync(f => f.Id == farm.Id);

        Assert.NotNull(deletedFarm);
        Assert.True(deletedFarm.IsDeleted);
        Assert.NotNull(deletedFarm.DeletedAt);
        Assert.Equal(userId, deletedFarm.DeletedBy);
    }

    [Fact]
    public async Task DeleteFarm_Fails_WhenLinkedToDamageReport()
    {
        var context = CreateContext();
        var farm = new Farm { Id = Guid.NewGuid(), DirectorateId = Guid.NewGuid() };
        var report = new DamageReport { Id = Guid.NewGuid(), ClientId = Guid.NewGuid(), FarmId = farm.Id, StatusId = "Draft" };

        context.Farms.Add(farm);
        context.DamageReports.Add(report);
        await context.SaveChangesAsync();

        var handler = new DeleteFarmCommandHandler(context, _currentUserMock.Object);
        var command = new DeleteFarmCommand(farm.Id);

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.False(result.Succeeded);
        Assert.Contains("لا يمكن حذف المزرعة", result.Errors[0]);
    }
}
