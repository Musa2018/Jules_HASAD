using Hasad.Application.Features.Farmers.Commands.CreateFarmer;
using Hasad.Application.Features.Farmers.Commands.DeleteFarmer;
using Hasad.Application.Features.Farmers.Commands.UpdateFarmer;
using Hasad.Application.Features.Farmers.Queries.GetFarmerById;
using Hasad.Application.Features.Farmers.Queries.GetFarmersList;
using Hasad.Domain.Entities;
using Hasad.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace Hasad.Application.Tests;

public class FarmerCommandHandlerTests
{
    private ApplicationDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        return new ApplicationDbContext(options);
    }

    [Fact]
    public async Task CreateFarmer_Succeeds_WhenDataIsValid()
    {
        var context = CreateContext();
        var handler = new CreateFarmerCommandHandler(context);
        var command = new CreateFarmerCommand(Guid.NewGuid(), "John Doe", "123456789", "0599123456", "Gaza");

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.NotNull(result.Data);
        Assert.Equal("John Doe", result.Data.Name);
        Assert.Single(context.Farmers);
    }

    [Fact]
    public async Task CreateFarmer_IsIdempotent_WhenIdExists()
    {
        var context = CreateContext();
        var id = Guid.NewGuid();
        context.Farmers.Add(new Farmer { Id = id, NationalId = "123", Name = "Existing", RowVersion = new byte[] { 1 } });
        await context.SaveChangesAsync();

        var handler = new CreateFarmerCommandHandler(context);
        var command = new CreateFarmerCommand(id, "Different Name", "123", "059", "Address");

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Equal("Existing", result.Data!.Name); // Returned existing record
        Assert.Single(context.Farmers);
    }

    [Fact]
    public async Task UpdateFarmer_Succeeds_WhenDataAndVersionMatch()
    {
        var context = CreateContext();
        var version = new byte[] { 1, 2, 3, 4 };
        var farmer = new Farmer { Id = Guid.NewGuid(), NationalId = "123", Name = "Old Name", RowVersion = version };
        context.Farmers.Add(farmer);
        await context.SaveChangesAsync();

        var handler = new UpdateFarmerCommandHandler(context);
        var command = new UpdateFarmerCommand(farmer.Id, "New Name", "123", "059", "New Address", Convert.ToBase64String(version));

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Equal("New Name", result.Data!.Name);
    }

    [Fact]
    public async Task UpdateFarmer_Fails_WhenVersionMismatches()
    {
        var context = CreateContext();
        var farmer = new Farmer { Id = Guid.NewGuid(), NationalId = "123", Name = "Old", RowVersion = new byte[] { 1 } };
        context.Farmers.Add(farmer);
        await context.SaveChangesAsync();

        var handler = new UpdateFarmerCommandHandler(context);
        var command = new UpdateFarmerCommand(farmer.Id, "New", "123", "059", "Add", Convert.ToBase64String(new byte[] { 2 }));

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.False(result.Succeeded);
        Assert.Contains("CONFLICT", result.Errors[0]);
    }

    [Fact]
    public async Task DeleteFarmer_Succeeds_WhenFarmerExists()
    {
        var context = CreateContext();
        var farmer = new Farmer { Id = Guid.NewGuid(), NationalId = "123", Name = "To Delete", RowVersion = new byte[] { 1 } };
        context.Farmers.Add(farmer);
        await context.SaveChangesAsync();

        var handler = new DeleteFarmerCommandHandler(context);
        var command = new DeleteFarmerCommand(farmer.Id);

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Empty(context.Farmers);
    }

    [Fact]
    public async Task GetFarmerById_ReturnsFarmer_WhenExists()
    {
        var context = CreateContext();
        var farmer = new Farmer { Id = Guid.NewGuid(), NationalId = "123", Name = "Target", RowVersion = new byte[] { 1 } };
        context.Farmers.Add(farmer);
        await context.SaveChangesAsync();

        var handler = new GetFarmerByIdQueryHandler(context);
        var query = new GetFarmerByIdQuery(farmer.Id);

        var result = await handler.Handle(query, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Equal("Target", result.Data!.Name);
        Assert.NotEmpty(result.Data!.RowVersion);
    }

    [Fact]
    public async Task GetFarmersList_ReturnsPaginatedItems()
    {
        var context = CreateContext();
        for (int i = 0; i < 15; i++)
        {
            context.Farmers.Add(new Farmer {
                Id = Guid.NewGuid(),
                NationalId = i.ToString(),
                Name = $"Farmer {i:D2}",
                RowVersion = new byte[] { (byte)i }
            });
        }
        await context.SaveChangesAsync();

        var handler = new GetFarmersListQueryHandler(context);
        var query = new GetFarmersListQuery(PageNumber: 1, PageSize: 10);

        var result = await handler.Handle(query, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Equal(10, result.Data!.Items.Count);
        Assert.Equal(15, result.Data!.TotalCount);
        Assert.Equal(2, result.Data!.TotalPages);
        Assert.NotEmpty(result.Data!.Items[0].RowVersion);
    }
}
