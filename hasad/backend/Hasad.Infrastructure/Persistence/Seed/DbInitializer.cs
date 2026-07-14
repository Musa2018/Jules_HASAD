using Hasad.Domain.Entities;
using Hasad.Domain.Identity;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Infrastructure.Persistence.Seed;

/// <summary>
/// Seeds the role catalogue and, when explicitly configured, an initial administrator.
/// </summary>
public static class DbInitializer
{
    /// <summary>
    /// Ensures all application roles exist.
    /// </summary>
    /// <param name="roleManager">Identity role manager.</param>
    public static async Task SeedRolesAsync(RoleManager<IdentityRole> roleManager)
    {
        string[] roleNames = { "SuperAdmin", "Administrator", "AgriculturalEngineer", "FieldSurveyor", "Farmer", "ReadOnly", "Director", "Finance" };

        foreach (var roleName in roleNames)
        {
            if (!await roleManager.RoleExistsAsync(roleName))
            {
                await roleManager.CreateAsync(new IdentityRole(roleName));
            }
        }
    }

    /// <summary>
    /// Creates the initial SuperAdmin account using externally supplied credentials.
    /// Does nothing when the account already exists.
    /// </summary>
    /// <param name="userManager">Identity user manager.</param>
    /// <param name="email">Administrator email address.</param>
    /// <param name="password">Administrator password; must satisfy the configured password policy.</param>
    /// <returns>The Identity result of the create operation, or null when the user already existed.</returns>
    public static async Task<IdentityResult?> SeedSuperAdminAsync(
        UserManager<ApplicationUser> userManager, string email, string password)
    {
        var existing = await userManager.FindByEmailAsync(email);
        if (existing is not null)
        {
            return null;
        }

        var user = new ApplicationUser
        {
            UserName = email,
            Email = email,
            FullName = "Super Admin",
            EmailConfirmed = true
        };

        var result = await userManager.CreateAsync(user, password);
        if (result.Succeeded)
        {
            await userManager.AddToRoleAsync(user, "SuperAdmin");
        }

        return result;
    }

    /// <summary>
    /// Seeds initial compensation rules.
    /// </summary>
    public static async Task SeedCompensationRulesAsync(ApplicationDbContext context)
    {
        if (!await context.CompensationRules.AnyAsync())
        {
            context.CompensationRules.Add(new CompensationRule
            {
                Id = Guid.NewGuid(),
                Name = "Default 80% Rule",
                Description = "Standard compensation rule (80%)",
                Multiplier = 0.8m,
                IsActive = true,
                CreatedAt = DateTime.UtcNow
            });
            await context.SaveChangesAsync();
        }
    }
}
