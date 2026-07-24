using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using Hasad.Domain.Enums;
using Hasad.Domain.Identity;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Serilog;

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
            EmailConfirmed = true,
            CreatedAt = DateTime.UtcNow
        };

        var result = await userManager.CreateAsync(user, password);
        if (result.Succeeded)
        {
            await userManager.AddToRoleAsync(user, "SuperAdmin");
        }

        return result;
    }

    /// <summary>
    /// Seeds default compensation rules if none exist.
    /// </summary>
    public static async Task SeedCompensationRulesAsync(ApplicationDbContext context)
    {
        if (await context.CompensationRules.AnyAsync())
        {
            return;
        }

        context.CompensationRules.Add(new CompensationRule
        {
            Id = Guid.NewGuid(),
            Name = "Standard 80% Rule",
            Description = "Standard compensation rule covering 80% of estimated losses.",
            Multiplier = 0.8m,
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        });

        await context.SaveChangesAsync();
    }

    /// <summary>
    /// Seeds the official Palestinian geographic dataset (Governorates and Directorates).
    /// </summary>
    public static async Task SeedGeographicsAsync(ApplicationDbContext context)
    {
        var geographics = new List<(string Code, string NameAr, string NameEn, (string NameAr, string NameEn, string Code)[] Directorates, (string NameAr, string NameEn)[] Localities)>
        {
            ("JN", "جنين", "Jenin", new[] { ("مديرية جنين", "Jenin Directorate", "JEN") }, new[] { ("مدينة جنين", "Jenin City"), ("قباطية", "Qabatiya"), ("اليامون", "Ya'bad") }),
            ("TB", "طوباس", "Tubas", new[] { ("مديرية طوباس", "Tubas Directorate", "TUB") }, new[] { ("طوباس", "Tubas"), ("طمون", "Tammun"), ("عقابا", "Aqqaba") }),
            ("TK", "طولكرم", "Tulkarm", new[] { ("مديرية طولكرم", "Tulkarm Directorate", "TUL") }, new[] { ("طولكرم", "Tulkarm City"), ("عتيل", "Attil"), ("دير الغصون", "Deir al-Ghusun") }),
            ("NB", "نابلس", "Nablus", new[] { ("مديرية نابلس", "Nablus Directorate", "NAB") }, new[] { ("مدينة نابلس", "Nablus City"), ("عصيرة الشمالية", "Asira al-Shamaliya"), ("بيتا", "Beita") }),
            ("QL", "قلقيلية", "Qalqilya", new[] { ("مديرية قلقيلية", "Qalqilya Directorate", "QAL") }, new[] { ("قلقيلية", "Qalqilya City"), ("عزون", "Azzun"), ("حبلة", "Habla") }),
            ("SL", "سلفيت", "Salfit", new[] { ("مديرية سلفيت", "Salfit Directorate", "SLF") }, new[] { ("سلفيت", "Salfit City"), ("بديا", "Biddya"), ("الزاوية", "Zawiya") }),
            ("RM", "رام الله والبيرة", "Ramallah & Al-Bireh", new[] { ("مديرية رام الله", "Ramallah Directorate", "RAM") }, new[] { ("رام الله", "Ramallah City"), ("البيرة", "Al-Bireh"), ("بيتونيا", "Beituniya") }),
            ("JR", "أريحا", "Jericho", new[] { ("مديرية أريحا", "Jericho Directorate", "JER") }, new[] { ("أريحا", "Jericho City"), ("العوجا", "Al-Auja"), ("الجفتلك", "Al-Jiftlik") }),
            ("JS", "القدس", "Jerusalem", new[] { ("مديرية القدس", "Jerusalem Directorate", "JRS") }, new[] { ("القدس", "Jerusalem City"), ("العيزرية", "Al-Eizariya"), ("أبو ديس", "Abu Dis") }),
            ("BT", "بيت لحم", "Bethlehem", new[] { ("مديرية بيت لحم", "Bethlehem Directorate", "BTH") }, new[] { ("بيت لحم", "Bethlehem City"), ("بيت جالا", "Beit Jala"), ("بيت ساحور", "Beit Sahour") }),
            ("HB", "الخليل", "Hebron", new[] { ("مديرية شمال الخليل", "North Hebron", "NHB"), ("مديرية جنوب الخليل", "South Hebron", "SHB"), ("مديرية الخليل", "Hebron Directorate", "HBN") }, new[] { ("مدينة الخليل", "Hebron City"), ("حلحول", "Halhul"), ("دورا", "Dura"), ("يطا", "Yatta") }),
            ("NG", "شمال غزة", "North Gaza", new[] { ("مديرية شمال غزة", "North Gaza Directorate", "NGZ") }, new[] { ("جباليا", "Jabalia"), ("بيت لاهيا", "Beit Lahiya"), ("بيت حانون", "Beit Hanoun") }),
            ("GZ", "غزة", "Gaza", new[] { ("مديرية غزة", "Gaza Directorate", "GZA") }, new[] { ("مدينة غزة", "Gaza City"), ("المغراقة", "Al-Mughraqa") }),
            ("DB", "دير البلح", "Deir al-Balah", new[] { ("مديرية الوسطى", "Central Directorate", "CEN") }, new[] { ("دير البلح", "Deir al-Balah City"), ("النصيرات", "Nuseirat"), ("البريج", "Maghazi") }),
            ("KY", "خانيونس", "Khan Yunis", new[] { ("مديرية خانيونس", "Khan Yunis Directorate", "KYS") }, new[] { ("خانيونس", "Khan Yunis City"), ("بني سهيلا", "Bani Suheila"), ("عبسان الكبيرة", "Abasan al-Kabira") }),
            ("RF", "رفح", "Rafah", new[] { ("مديرية رفح", "Rafah Directorate", "RFH") }, new[] { ("رفح", "Rafah City"), ("شوكة الصوفي", "Al-Shoka") })
        };

        var existingGovernorates = await context.Governorates
            .Include(g => g.Directorates)
            .Include(g => g.Localities)
            .ToDictionaryAsync(g => g.Code);

        foreach (var (code, nameAr, nameEn, directorates, localities) in geographics)
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
                governorate.NameAr = nameAr;
                governorate.NameEn = nameEn;
            }

            foreach (var (dirNameAr, dirNameEn, dirCode) in directorates)
            {
                var existingDir = governorate.Directorates
                    .FirstOrDefault(d => d.NameEn == dirNameEn);

                if (existingDir == null)
                {
                    existingDir = new Directorate
                    {
                        Id = Guid.NewGuid(),
                        NameAr = dirNameAr,
                        NameEn = dirNameEn,
                        Code = dirCode,
                        GovernorateId = governorate.Id,
                        IsActive = true,
                        CreatedAt = DateTime.UtcNow
                    };
                    context.Directorates.Add(existingDir);
                }
                else
                {
                    existingDir.NameAr = dirNameAr;
                    existingDir.Code = dirCode;
                }

                // Temporary logic for seeding localities to directorates:
                // If a locality matches keywords for a directorate, link them.
                // In a real scenario, this would be a specific mapping provided in the dataset.
                foreach (var (locNameAr, locNameEn) in localities)
                {
                    var existingLoc = governorate.Localities
                        .FirstOrDefault(l => l.NameEn == locNameEn);

                    if (existingLoc == null)
                    {
                        context.Localities.Add(new Locality
                        {
                            Id = Guid.NewGuid(),
                            NameAr = locNameAr,
                            NameEn = locNameEn,
                            GovernorateId = governorate.Id,
                            DirectorateId = existingDir.Id, // Assign to the current directorate in this loop
                            IsActive = true,
                            CreatedAt = DateTime.UtcNow
                        });
                    }
                    else
                    {
                        existingLoc.NameAr = locNameAr;
                        existingLoc.DirectorateId = existingDir.Id;
                    }
                }
            }
        }

        await context.SaveChangesAsync();
    }

    /// <summary>
    /// Seeds the damage classification hierarchy and causes.
    /// </summary>
    public static async Task SeedDamageReferenceDataAsync(ApplicationDbContext context)
    {
        if (await context.DamageNatures.AnyAsync())
        {
            Log.Information("Damage reference data already exists; skipping seeding.");
            return;
        }

        Log.Information("Starting Damage Reference Data seeding...");

        var strategy = context.Database.CreateExecutionStrategy();
        await strategy.ExecuteAsync(async () =>
        {
            using var transaction = await context.Database.BeginTransactionAsync();
            try
            {
                // Ensure connection is open for IDENTITY_INSERT commands
                if (context.Database.GetDbConnection().State != System.Data.ConnectionState.Open)
                {
                    await context.Database.OpenConnectionAsync();
                }

                // 1. Damage Natures
                Log.Information("Seeding DamageNatures...");
                context.DamageNatures.AddRange(
                    new DamageNature { Id = 1, NameAr = "نباتي", NameEn = "Plant" },
                    new DamageNature { Id = 2, NameAr = "حيواني", NameEn = "Animal" },
                    new DamageNature { Id = 3, NameAr = "منشآت وبنية تحتية", NameEn = "Infrastructure" }
                );
                await SaveWithIdentityInsertAsync(context, "DamageNatures");

                // 2. Damage Categories
                Log.Information("Seeding DamageCategories...");
                context.DamageCategories.AddRange(
                    new DamageCategory { Id = 1, NatureId = 1, NameAr = "أشجار", NameEn = "Trees" },
                    new DamageCategory { Id = 2, NatureId = 1, NameAr = "محاصيل حقلية", NameEn = "Field Crops" },
                    new DamageCategory { Id = 3, NatureId = 1, NameAr = "خضروات محمية", NameEn = "Protected Crops" }
                );
                await SaveWithIdentityInsertAsync(context, "DamageCategories");

                // 3. Damage SubCategories
                Log.Information("Seeding DamageSubCategories...");
                context.DamageSubCategories.AddRange(
                    new DamageSubCategory { Id = 1, CategoryId = 1, NameAr = "زيتون", NameEn = "Olive" },
                    new DamageSubCategory { Id = 2, CategoryId = 1, NameAr = "لوزيات", NameEn = "Stone Fruits" },
                    new DamageSubCategory { Id = 3, CategoryId = 1, NameAr = "حمضيات", NameEn = "Citrus" }
                );
                await SaveWithIdentityInsertAsync(context, "DamageSubCategories");

                // 4. Damage Classifications
                Log.Information("Seeding DamageClassifications...");
                context.DamageClassifications.AddRange(
                    new DamageClassification { Id = 1, SubCategoryId = 1, NameAr = "عمر 1-5 سنوات", NameEn = "Age 1-5 years" },
                    new DamageClassification { Id = 2, SubCategoryId = 1, NameAr = "عمر 5-10 سنوات", NameEn = "Age 5-10 years" },
                    new DamageClassification { Id = 3, SubCategoryId = 1, NameAr = "عمر فوق 10 سنوات", NameEn = "Age 10+ years" }
                );
                await SaveWithIdentityInsertAsync(context, "DamageClassifications");

                // 5. Costing Sheets (Hierarchy: Catalog -> Version -> Item)
                Log.Information("Seeding Costing Catalog & Versions...");
                var catalog = new CostingSheetCatalog
                {
                    Id = Guid.NewGuid(),
                    Name = "Official Pricing Catalog 2026",
                    Description = "Baseline pricing for the 2026 damage assessment cycle.",
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = "System"
                };
                context.CostingSheetCatalogs.Add(catalog);

                var version = new CostingSheetVersion
                {
                    Id = Guid.NewGuid(),
                    CatalogId = catalog.Id,
                    VersionNumber = 1,
                    Status = CostingSheetStatus.Active,
                    EffectiveFrom = new DateTime(2026, 1, 1),
                    CreatedAt = DateTime.UtcNow,
                    CreatedBy = "System"
                };
                context.CostingSheetVersions.Add(version);

                context.CostingSheetItems.Add(new CostingSheetItem
                {
                    Id = Guid.NewGuid(),
                    VersionId = version.Id,
                    ClassificationId = 2, // Age 5-10 years
                    UnitPrice = 100,
                    MeasurementUnitId = 1, // Dunum (from HasData in DbContext)
                    CreatedAt = DateTime.UtcNow
                });
                await context.SaveChangesAsync();

                // 6. Damage Cause Categories
                Log.Information("Seeding DamageCauseCategories...");
                context.DamageCauseCategories.AddRange(
                    new DamageCauseCategory { Id = 1, NameAr = "سياسي", NameEn = "Political" },
                    new DamageCauseCategory { Id = 2, NameAr = "طبيعي", NameEn = "Natural" }
                );
                await SaveWithIdentityInsertAsync(context, "DamageCauseCategories");

                // 7. Damage Causes
                Log.Information("Seeding DamageCauses...");
                context.DamageCauses.AddRange(
                    new DamageCause { Id = 1, CategoryId = 1, NameAr = "جيش الاحتلال", NameEn = "Army" },
                    new DamageCause { Id = 2, CategoryId = 1, NameAr = "مستوطنين", NameEn = "Settlers" },
                    new DamageCause { Id = 3, CategoryId = 1, NameAr = "شركات إسرائيلية", NameEn = "Israeli Companies" },
                    new DamageCause { Id = 4, CategoryId = 2, NameAr = "فيضانات", NameEn = "Flood" },
                    new DamageCause { Id = 5, CategoryId = 2, NameAr = "حرائق", NameEn = "Fire" },
                    new DamageCause { Id = 6, CategoryId = 2, NameAr = "جفاف", NameEn = "Drought" },
                    new DamageCause { Id = 7, CategoryId = 2, NameAr = "عواصف", NameEn = "Storm" }
                );
                await SaveWithIdentityInsertAsync(context, "DamageCauses");

                await transaction.CommitAsync();
                Log.Information("Damage Reference Data seeding completed successfully.");
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Failed to seed damage reference data. Rolling back transaction.");
                await transaction.RollbackAsync();
                throw;
            }
        });
    }

    private static async Task SaveWithIdentityInsertAsync(ApplicationDbContext context, string tableName)
    {
        try
        {
            Log.Debug("Enabling IDENTITY_INSERT for {Table}", tableName);
            await context.Database.ExecuteSqlRawAsync($"SET IDENTITY_INSERT {tableName} ON");
            await context.SaveChangesAsync();
            await context.Database.ExecuteSqlRawAsync($"SET IDENTITY_INSERT {tableName} OFF");
            Log.Debug("Disabled IDENTITY_INSERT for {Table}", tableName);
        }
        catch (Exception ex)
        {
            Log.Error(ex, "Error during IDENTITY_INSERT operation for table {Table}", tableName);
            // Ensure IDENTITY_INSERT is OFF even on failure if connection is still open
            try
            {
                await context.Database.ExecuteSqlRawAsync($"SET IDENTITY_INSERT {tableName} OFF");
            }
            catch
            {
                // Ignore errors during emergency cleanup
            }
            throw;
        }
    }
}
