using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.Farms.Queries.GetFarmsByFarmer;
using Hasad.Application.Features.Farms.Queries.GetFarmById;
using Hasad.Domain.Entities;
using Moq;
using Microsoft.EntityFrameworkCore;
using Hasad.Infrastructure.Persistence;
using Hasad.Domain.Constants;

namespace Hasad.Application.Tests;

public class MultiFarmSecurityScenariosTests
{
    private readonly DbContextOptions<ApplicationDbContext> _options;

    public MultiFarmSecurityScenariosTests()
    {
        _options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
    }

    [Fact]
    public async Task GetFarmsByFarmer_ShouldOnlyReturnFarmsWithinUserScope()
    {
        // Arrange
        var currentUserMock = new Mock<ICurrentUserService>();
        using var context = new ApplicationDbContext(_options, currentUserMock.Object);

        var farmerId = Guid.NewGuid();
        var jeninDirId = Guid.NewGuid();
        var nJeninDirId = Guid.NewGuid();
        var nablusDirId = Guid.NewGuid();

        context.Farmers.Add(new Farmer { Id = farmerId, FirstNameAr = "Ahmed", GovernorateId = Guid.NewGuid(), LocalityId = Guid.NewGuid(), IsDeleted = false });

        context.Farms.AddRange(new[]
        {
            new Farm { Id = Guid.NewGuid(), FarmerId = farmerId, LocalFarmName = "Farm Jenin", DirectorateId = jeninDirId, GovernorateId = Guid.NewGuid(), LocalityId = Guid.NewGuid(), Basin = "1", Parcel = "1", RowVersion = new byte[] { 1 }, IsDeleted = false },
            new Farm { Id = Guid.NewGuid(), FarmerId = farmerId, LocalFarmName = "Farm N.Jenin", DirectorateId = nJeninDirId, GovernorateId = Guid.NewGuid(), LocalityId = Guid.NewGuid(), Basin = "2", Parcel = "2", RowVersion = new byte[] { 1 }, IsDeleted = false },
            new Farm { Id = Guid.NewGuid(), FarmerId = farmerId, LocalFarmName = "Farm Nablus", DirectorateId = nablusDirId, GovernorateId = Guid.NewGuid(), LocalityId = Guid.NewGuid(), Basin = "3", Parcel = "3", RowVersion = new byte[] { 1 }, IsDeleted = false }
        });
        await context.SaveChangesAsync();

        // Mock Jenin Directorate User
        currentUserMock.Setup(u => u.DirectorateId).Returns(jeninDirId);
        currentUserMock.Setup(u => u.IsInRole("AgriculturalEngineer")).Returns(true);
        currentUserMock.Setup(u => u.IsInRole("FieldSurveyor")).Returns(false);

        var handler = new GetFarmsByFarmerQueryHandler(context, currentUserMock.Object);

        // Act
        var result = await handler.Handle(new GetFarmsByFarmerQuery(farmerId), CancellationToken.None);

        // Assert
        Assert.True(result.Succeeded);
        Assert.NotNull(result.Data);
        Assert.Single(result.Data);
        Assert.Equal("Farm Jenin", result.Data[0].LocalFarmName);
    }

    [Fact]
    public async Task GetFarmById_ShouldReturnFailure_WhenFarmIsOutsideScope()
    {
        // Arrange
        var currentUserMock = new Mock<ICurrentUserService>();
        using var context = new ApplicationDbContext(_options, currentUserMock.Object);

        var jeninDirId = Guid.NewGuid();
        var nablusDirId = Guid.NewGuid();
        var nablusFarmId = Guid.NewGuid();

        context.Farms.Add(new Farm
        {
            Id = nablusFarmId,
            FarmerId = Guid.NewGuid(),
            LocalFarmName = "Nablus Farm",
            DirectorateId = nablusDirId,
            GovernorateId = Guid.NewGuid(),
            LocalityId = Guid.NewGuid(),
            Basin = "3",
            Parcel = "3",
            RowVersion = new byte[] { 1 },
            IsDeleted = false
        });
        await context.SaveChangesAsync();

        // Mock Jenin Directorate User
        currentUserMock.Setup(u => u.DirectorateId).Returns(jeninDirId);
        currentUserMock.Setup(u => u.IsInRole("FieldSurveyor")).Returns(true);

        var handler = new GetFarmByIdQueryHandler(context, currentUserMock.Object);

        // Act
        var result = await handler.Handle(new GetFarmByIdQuery(nablusFarmId), CancellationToken.None);

        // Assert
        Assert.False(result.Succeeded);
        Assert.Contains("Access Denied", result.Errors.First());
    }

    [Fact]
    public async Task ScenarioB_FarmerWithoutLocalFarms_ShouldNotBeVisibleToLocalUser()
    {
        // Arrange
        var currentUserMock = new Mock<ICurrentUserService>();
        using var context = new ApplicationDbContext(_options, currentUserMock.Object);

        var jeninDirId = Guid.NewGuid();
        var nablusDirId = Guid.NewGuid();

        var farmerAliId = Guid.NewGuid();
        // Farmer Ali lives in Jenin (informational) but only has land in Nablus
        context.Farmers.Add(new Farmer { Id = farmerAliId, FirstNameAr = "Ali", GovernorateId = Guid.NewGuid(), LocalityId = Guid.NewGuid(), RowVersion = new byte[] { 1 }, IsDeleted = false });
        context.Farms.Add(new Farm { Id = Guid.NewGuid(), FarmerId = farmerAliId, LocalFarmName = "Ali Nablus Farm", DirectorateId = nablusDirId, GovernorateId = Guid.NewGuid(), LocalityId = Guid.NewGuid(), Basin = "1", Parcel = "1", RowVersion = new byte[] { 1 }, IsDeleted = false });
        await context.SaveChangesAsync();

        // Mock Jenin Directorate User
        currentUserMock.Setup(u => u.DirectorateId).Returns(jeninDirId);
        currentUserMock.Setup(u => u.IsInRole("FieldSurveyor")).Returns(true);

        var handler = new Features.Farmers.Queries.GetFarmersList.GetFarmersListQueryHandler(context, currentUserMock.Object);

        // Act
        var result = await handler.Handle(new Features.Farmers.Queries.GetFarmersList.GetFarmersListQuery(IsOperational: true), CancellationToken.None);

        // Assert
        Assert.True(result.Succeeded);
        Assert.NotNull(result.Data);
        Assert.DoesNotContain(result.Data.Items, f => f.Id == farmerAliId);
    }
}
