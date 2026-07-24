using Hasad.Application.Common.Interfaces;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using Hasad.Domain.Enums;
using Hasad.Domain.Identity;
using Hasad.Infrastructure.Persistence;
using Hasad.Infrastructure.Persistence.Seed;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using Xunit;

namespace Hasad.Application.Tests;

public class DbInitializerTests
{
    private static ServiceProvider CreateServices()
    {
        var services = new ServiceCollection();
        services.AddSingleton(new Mock<ICurrentUserService>().Object);
        services.AddDbContext<ApplicationDbContext>(o =>
            o.UseInMemoryDatabase(Guid.NewGuid().ToString()));
        services.AddLogging();
        services
            .AddIdentityCore<ApplicationUser>()
            .AddRoles<IdentityRole>()
            .AddEntityFrameworkStores<ApplicationDbContext>();
        return services.BuildServiceProvider();
    }

    [Fact]
    public async Task SeedRolesAsync_CreatesAllApplicationRoles_AndIsIdempotent()
    {
        using var provider = CreateServices();
        var roleManager = provider.GetRequiredService<RoleManager<IdentityRole>>();

        await DbInitializer.SeedRolesAsync(roleManager);
        await DbInitializer.SeedRolesAsync(roleManager);

        foreach (var role in AppRoles.All())
        {
            Assert.True(await roleManager.RoleExistsAsync(role));
        }
        Assert.Equal(AppRoles.All().Length, await roleManager.Roles.CountAsync());
    }

    [Fact]
    public async Task SeedSuperAdminAsync_CreatesUserWithSuperAdminRole()
    {
        using var provider = CreateServices();
        var roleManager = provider.GetRequiredService<RoleManager<IdentityRole>>();
        var userManager = provider.GetRequiredService<UserManager<ApplicationUser>>();
        await DbInitializer.SeedRolesAsync(roleManager);

        var result = await DbInitializer.SeedSuperAdminAsync(userManager, "admin@hasad.ps", "Str0ng!Passw0rd");

        Assert.NotNull(result);
        Assert.True(result!.Succeeded);
        var user = await userManager.FindByEmailAsync("admin@hasad.ps");
        Assert.NotNull(user);
        Assert.True(await userManager.IsInRoleAsync(user!, "SuperAdmin"));
    }

    [Fact]
    public async Task SeedSuperAdminAsync_ReturnsNull_WhenUserAlreadyExists()
    {
        using var provider = CreateServices();
        var roleManager = provider.GetRequiredService<RoleManager<IdentityRole>>();
        var userManager = provider.GetRequiredService<UserManager<ApplicationUser>>();
        await DbInitializer.SeedRolesAsync(roleManager);
        await DbInitializer.SeedSuperAdminAsync(userManager, "admin@hasad.ps", "Str0ng!Passw0rd");

        var second = await DbInitializer.SeedSuperAdminAsync(userManager, "admin@hasad.ps", "Str0ng!Passw0rd");

        Assert.Null(second);
        Assert.Single(userManager.Users.Where(u => u.Email == "admin@hasad.ps"));
    }

    [Fact]
    public async Task SeedDamageReferenceDataAsync_IsIdempotent()
    {
        using var provider = CreateServices();
        var context = provider.GetRequiredService<ApplicationDbContext>();

        // Ensure prerequisite data exists (AgriculturalSector, MeasurementUnit)
        // These are normally in HasData which is applied by EnsureCreatedAsync in tests
        await context.Database.EnsureCreatedAsync();

        // First run
        await DbInitializer.SeedDamageReferenceDataAsync(context);
        var initialCount = await context.DamageNatures.CountAsync();
        Assert.NotEqual(0, initialCount);

        // Second run
        await DbInitializer.SeedDamageReferenceDataAsync(context);
        var finalCount = await context.DamageNatures.CountAsync();

        Assert.Equal(initialCount, finalCount);
    }

    [Fact]
    public async Task SeedDamageReferenceDataAsync_HandlesPartialData()
    {
        using var provider = CreateServices();
        var context = provider.GetRequiredService<ApplicationDbContext>();
        await context.Database.EnsureCreatedAsync();

        // Manually add one record
        context.DamageNatures.Add(new DamageNature { Id = 1, NameAr = "جفاف", NameEn = "Drought" });
        await context.SaveChangesAsync();

        // Run seed
        await DbInitializer.SeedDamageReferenceDataAsync(context);

        // Verify all 10 natures exist
        Assert.Equal(10, await context.DamageNatures.CountAsync());
        // Verify the manually added one is still there (Id 1)
        Assert.True(await context.DamageNatures.AnyAsync(n => n.Id == 1 && n.NameEn == "Drought"));
    }

    [Fact]
    public async Task SeedDamageReferenceDataAsync_ConcurrentRuns_ShouldNotCreateDuplicates()
    {
        // Note: In-memory DB doesn't support sp_getapplock, so this tests the idempotency logic
        // and EF context thread safety (to some extent, though we use separate scopes).

        var services = new ServiceCollection();
        services.AddSingleton(new Mock<ICurrentUserService>().Object);
        var dbName = Guid.NewGuid().ToString(); // Shared DB for concurrent tasks
        services.AddDbContext<ApplicationDbContext>(o => o.UseInMemoryDatabase(dbName));
        services.AddLogging();
        services.AddIdentityCore<ApplicationUser>().AddRoles<IdentityRole>().AddEntityFrameworkStores<ApplicationDbContext>();
        var provider = services.BuildServiceProvider();

        // Ensure prerequisite data exists (normally in HasData)
        using (var setupScope = provider.CreateScope())
        {
            await setupScope.ServiceProvider.GetRequiredService<ApplicationDbContext>().Database.EnsureCreatedAsync();
        }

        var tasks = Enumerable.Range(0, 10).Select(async _ =>
        {
            using var scope = provider.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            await DbInitializer.SeedDamageReferenceDataAsync(context);
        });

        await Task.WhenAll(tasks);

        using (var verifyScope = provider.CreateScope())
        {
            var context = verifyScope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            // Every lookup table should have exactly the expected number of records, no more.
            Assert.Equal(10, await context.DamageNatures.CountAsync());
            Assert.Equal(10, await context.DamageActions.CountAsync());
            Assert.Equal(11, await context.DamageCategories.CountAsync());
            Assert.Equal(8, await context.DamageSubCategories.CountAsync());
            Assert.Equal(8, await context.DamageClassifications.CountAsync());

            // Costing Catalog should be unique
            Assert.Single(context.CostingSheetCatalogs);
            Assert.Single(context.CostingSheetVersions);
        }
    }
}
