using Hasad.Domain.Identity;
using Microsoft.AspNetCore.Identity;

namespace Hasad.Infrastructure.Persistence.Seed;

public static class DbInitializer
{
    public static async Task SeedRolesAndUsersAsync(RoleManager<IdentityRole> roleManager, UserManager<ApplicationUser> userManager)
    {
        string[] roleNames = { "SuperAdmin", "Administrator", "AgriculturalEngineer", "FieldSurveyor", "Farmer", "ReadOnly" };

        foreach (var roleName in roleNames)
        {
            if (!await roleManager.RoleExistsAsync(roleName))
            {
                await roleManager.CreateAsync(new IdentityRole(roleName));
            }
        }

        // Seed default Super Admin
        var adminUser = await userManager.FindByEmailAsync("admin@hasad.ps");
        if (adminUser == null)
        {
            var user = new ApplicationUser
            {
                UserName = "admin@hasad.ps",
                Email = "admin@hasad.ps",
                FullName = "Super Admin",
                EmailConfirmed = true
            };

            var result = await userManager.CreateAsync(user, "Admin123!");
            if (result.Succeeded)
            {
                await userManager.AddToRoleAsync(user, "SuperAdmin");
            }
        }
    }
}
