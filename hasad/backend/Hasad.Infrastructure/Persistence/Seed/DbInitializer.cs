using Hasad.Domain.Constants;
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
        foreach (var roleName in AppRoles.All())
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
    /// Seeds the official Palestinian geographic dataset (Governorates and Directorates).
    /// </summary>
    public static async Task SeedGeographicsAsync(ApplicationDbContext context)
    {
        var geographics = new List<(string Code, string NameAr, string NameEn, (string NameAr, string NameEn)[] Directorates)>
        {
            ("JN", "جنين", "Jenin", new[] { ("مديرية جنين", "Jenin Directorate") }),
            ("TB", "طوباس", "Tubas", new[] { ("مديرية طوباس", "Tubas Directorate") }),
            ("TK", "طولكرم", "Tulkarm", new[] { ("مديرية طولكرم", "Tulkarm Directorate") }),
            ("NB", "نابلس", "Nablus", new[] { ("مديرية نابلس", "Nablus Directorate") }),
            ("QL", "قلقيلية", "Qalqilya", new[] { ("مديرية قلقيلية", "Qalqilya Directorate") }),
            ("SL", "سلفيت", "Salfit", new[] { ("مديرية سلفيت", "Salfit Directorate") }),
            ("RM", "رام الله والبيرة", "Ramallah & Al-Bireh", new[] { ("مديرية رام الله", "Ramallah Directorate") }),
            ("JR", "أريحا", "Jericho", new[] { ("مديرية أريحا", "Jericho Directorate") }),
            ("JS", "القدس", "Jerusalem", new[] { ("مديرية القدس", "Jerusalem Directorate") }),
            ("BT", "بيت لحم", "Bethlehem", new[] { ("مديرية بيت لحم", "Bethlehem Directorate") }),
            ("HB", "الخليل", "Hebron", new[] { ("مديرية شمال الخليل", "North Hebron"), ("مديرية جنوب الخليل", "South Hebron"), ("مديرية الخليل", "Hebron Directorate") }),
            ("NG", "شمال غزة", "North Gaza", new[] { ("مديرية شمال غزة", "North Gaza Directorate") }),
            ("GZ", "غزة", "Gaza", new[] { ("مديرية غزة", "Gaza Directorate") }),
            ("DB", "دير البلح", "Deir al-Balah", new[] { ("مديرية الوسطى", "Central Directorate") }),
            ("KY", "خانيونس", "Khan Yunis", new[] { ("مديرية خانيونس", "Khan Yunis Directorate") }),
            ("RF", "رفح", "Rafah", new[] { ("مديرية رفح", "Rafah Directorate") })
        };

        var existingGovernorates = await context.Governorates
            .Include(g => g.Directorates)
            .ToDictionaryAsync(g => g.Code);

        foreach (var (code, nameAr, nameEn, directorates) in geographics)
        {
            if (!existingGovernorates.TryGetValue(code, out var governorate))
            {
                governorate = new Governorate
                {
                    Id = Guid.NewGuid(),
                    Code = code,
                    NameAr = nameAr,
                    NameEn = nameEn,
                    IsActive = true,
                    CreatedAt = DateTime.UtcNow
                };
                context.Governorates.Add(governorate);
            }
            else
            {
                // Optionally update names if they changed
                governorate.NameAr = nameAr;
                governorate.NameEn = nameEn;
            }

            foreach (var (dirNameAr, dirNameEn) in directorates)
            {
                var existingDir = governorate.Directorates
                    .FirstOrDefault(d => d.NameEn == dirNameEn);

                if (existingDir == null)
                {
                    context.Directorates.Add(new Directorate
                    {
                        Id = Guid.NewGuid(),
                        NameAr = dirNameAr,
                        NameEn = dirNameEn,
                        GovernorateId = governorate.Id,
                        IsActive = true,
                        CreatedAt = DateTime.UtcNow
                    });
                }
                else
                {
                    existingDir.NameAr = dirNameAr;
                }
            }
        }

        await context.SaveChangesAsync();
    }
}
