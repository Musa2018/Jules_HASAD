using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.Farms.Commands.CreateFarm;
using Hasad.Application.Features.Farms.Commands.UpdateFarm;
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
        return new ApplicationDbContext(options);
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
            1, // AreaUnitId
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
}
