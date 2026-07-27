using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.Farmers.Queries.GetFarmersList;
using Hasad.Domain.Entities;
using Hasad.Domain.Enums;
using Hasad.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;

namespace Hasad.Application.Tests;

public class GetFarmersListScopingTests
{
    private readonly Mock<ICurrentUserService> _currentUserMock;

    public GetFarmersListScopingTests()
    {
        _currentUserMock = new Mock<ICurrentUserService>();
    }

    private ApplicationDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        return new ApplicationDbContext(options, _currentUserMock.Object);
    }

    [Fact]
    public async Task Handle_AgriculturalEngineer_AllView_ReturnsFarmersFromAllGovernorates()
    {
        // Arrange
        var context = CreateContext();
        var govA = "GOV-A";
        var govB = "GOV-B";

        context.Farmers.AddRange(new List<Farmer>
        {
            new Farmer { Id = Guid.NewGuid(), FirstNameAr = "Farmer A", GovernorateId = govA, CreatedAt = DateTime.UtcNow },
            new Farmer { Id = Guid.NewGuid(), FirstNameAr = "Farmer B", GovernorateId = govB, CreatedAt = DateTime.UtcNow.AddMinutes(1) }
        });
        await context.SaveChangesAsync();

        _currentUserMock.Setup(m => m.IsInRole("AgriculturalEngineer")).Returns(true);
        _currentUserMock.Setup(m => m.GovernorateId).Returns(Guid.NewGuid()); // Some other gov

        var handler = new GetFarmersListQueryHandler(context, _currentUserMock.Object);

        // Act: All View (IsOperational = false)
        var query = new GetFarmersListQuery(IsOperational: false);
        var result = await handler.Handle(query, CancellationToken.None);

        // Assert
        Assert.True(result.Succeeded);
        Assert.Equal(2, result.Data!.Items.Count);
    }

    [Fact]
    public async Task Handle_AgriculturalEngineer_OperationalView_ReturnsFarmersWithFarmsInHisDirectorate()
    {
        // Arrange
        var context = CreateContext();
        var myDirId = Guid.NewGuid();
        var otherDirId = Guid.NewGuid();

        var farmer1 = new Farmer { Id = Guid.NewGuid(), FirstNameAr = "My Directorate Farmer", GovernorateId = "OtherGov" };
        var farmer2 = new Farmer { Id = Guid.NewGuid(), FirstNameAr = "Other Directorate Farmer", GovernorateId = "OtherGov" };

        context.Farmers.AddRange(farmer1, farmer2);

        context.Farms.Add(new Farm { Id = Guid.NewGuid(), FarmerId = farmer1.Id, DirectorateId = myDirId, LocalFarmName = "Farm 1" });
        context.Farms.Add(new Farm { Id = Guid.NewGuid(), FarmerId = farmer2.Id, DirectorateId = otherDirId, LocalFarmName = "Farm 2" });

        await context.SaveChangesAsync();

        _currentUserMock.Setup(m => m.IsInRole("AgriculturalEngineer")).Returns(true);
        _currentUserMock.Setup(m => m.IsInRole("FieldSurveyor")).Returns(false);
        _currentUserMock.Setup(m => m.DirectorateId).Returns(myDirId);

        var handler = new GetFarmersListQueryHandler(context, _currentUserMock.Object);

        // Act: Operational View (IsOperational = true)
        var query = new GetFarmersListQuery(IsOperational: true);
        var result = await handler.Handle(query, CancellationToken.None);

        // Assert
        Assert.True(result.Succeeded);
        Assert.Single(result.Data!.Items);
        Assert.Equal("My Directorate Farmer", result.Data.Items[0].FirstNameAr);
    }

    [Fact]
    public async Task Handle_AllView_ReturnsLatestFarmersFirst()
    {
        // Arrange
        var context = CreateContext();
        var now = DateTime.UtcNow;

        context.Farmers.AddRange(new List<Farmer>
        {
            new Farmer { Id = Guid.NewGuid(), FirstNameAr = "Oldest", CreatedAt = now.AddMinutes(-10) },
            new Farmer { Id = Guid.NewGuid(), FirstNameAr = "Latest", CreatedAt = now.AddMinutes(-1) },
            new Farmer { Id = Guid.NewGuid(), FirstNameAr = "Middle", CreatedAt = now.AddMinutes(-5) }
        });
        await context.SaveChangesAsync();

        var handler = new GetFarmersListQueryHandler(context, _currentUserMock.Object);

        // Act
        var query = new GetFarmersListQuery(IsOperational: false);
        var result = await handler.Handle(query, CancellationToken.None);

        // Assert
        Assert.True(result.Succeeded);
        Assert.Equal("Latest", result.Data!.Items[0].FirstNameAr);
        Assert.Equal("Middle", result.Data.Items[1].FirstNameAr);
        Assert.Equal("Oldest", result.Data.Items[2].FirstNameAr);
    }
}
