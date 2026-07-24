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
    /// Seeds default assistance rules if none exist.
    /// </summary>
    public static async Task SeedAssistanceRulesAsync(ApplicationDbContext context)
    {
        if (await context.AssistanceRules.AnyAsync())
        {
            return;
        }

        context.AssistanceRules.Add(new AssistanceRule
        {
            Id = Guid.NewGuid(),
            Name = "Standard 80% Rule",
            Description = "Standard assistance rule covering 80% of technical valuation.",
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
            ("JEN", "جنين", "Jenin", new[] { ("مديرية جنين", "Jenin Directorate", "JEN") }, new[] { ("مدينة جنين", "Jenin City"), ("قباطية", "Qabatiya"), ("اليامون", "Ya'bad") }),
            ("TUB", "طوباس", "Tubas", new[] { ("مديرية طوباس", "Tubas Directorate", "TUB") }, new[] { ("طوباس", "Tubas"), ("طمون", "Tammun"), ("عقابا", "Aqqaba") }),
            ("TUL", "طولكرم", "Tulkarm", new[] { ("مديرية طولكرم", "Tulkarm Directorate", "TUL") }, new[] { ("طولكرم", "Tulkarm City"), ("عتيل", "Attil"), ("دير الغصون", "Deir al-Ghusun") }),
            ("NBL", "نابلس", "Nablus", new[] { ("مديرية نابلس", "Nablus Directorate", "NAB") }, new[] { ("مدينة نابلس", "Nablus City"), ("عصيرة الشمالية", "Asira al-Shamaliya"), ("بيتا", "Beita") }),
            ("QAL", "قلقيلية", "Qalqilya", new[] { ("مديرية قلقيلية", "Qalqilya Directorate", "QAL") }, new[] { ("قلقيلية", "Qalqilya City"), ("عزون", "Azzun"), ("حبلة", "Habla") }),
            ("SLF", "سلفيت", "Salfit", new[] { ("مديرية سلفيت", "Salfit Directorate", "SLF") }, new[] { ("سلفيت", "Salfit City"), ("بديا", "Biddya"), ("الزاوية", "Zawiya") }),
            ("RAM", "رام الله والبيرة", "Ramallah & Al-Bireh", new[] { ("مديرية رام الله", "Ramallah Directorate", "RAM") }, new[] { ("رام الله", "Ramallah City"), ("البيرة", "Al-Bireh"), ("بيتونيا", "Beituniya") }),
            ("JER", "أريحا", "Jericho", new[] { ("مديرية أريحا", "Jericho Directorate", "JER") }, new[] { ("أريحا", "Jericho City"), ("العوجا", "Al-Auja"), ("الجفتلك", "Al-Jiftlik") }),
            ("JRS", "القدس", "Jerusalem", new[] { ("مديرية القدس", "Jerusalem Directorate", "JRS") }, new[] { ("القدس", "Jerusalem City"), ("العيزرية", "Al-Eizariya"), ("أبو ديس", "Abu Dis") }),
            ("BTH", "بيت لحم", "Bethlehem", new[] { ("مديرية بيت لحم", "Bethlehem Directorate", "BTH") }, new[] { ("بيت لحم", "Bethlehem City"), ("بيت جالا", "Beit Jala"), ("بيت ساحور", "Beit Sahour") }),
            ("HBN", "الخليل", "Hebron", new[] { ("مديرية شمال الخليل", "North Hebron", "NHB"), ("مديرية جنوب الخليل", "South Hebron", "SHB"), ("مديرية الخليل", "Hebron Directorate", "HBN") }, new[] { ("مدينة الخليل", "Hebron City"), ("حلحول", "Halhul"), ("دورا", "Dura"), ("يطا", "Yatta") }),
            ("NGZ", "شمال غزة", "North Gaza", new[] { ("مديرية شمال غزة", "North Gaza Directorate", "NGZ") }, new[] { ("جباليا", "Jabalia"), ("بيت لاهيا", "Beit Lahiya"), ("بيت حانون", "Beit Hanoun") }),
            ("GZA", "غزة", "Gaza", new[] { ("مديرية غزة", "Gaza Directorate", "GZA") }, new[] { ("مدينة غزة", "Gaza City"), ("المغراقة", "Al-Mughraqa") }),
            ("CEN", "دير البلح", "Deir al-Balah", new[] { ("مديرية الوسطى", "Central Directorate", "CEN") }, new[] { ("دير البلح", "Deir al-Balah City"), ("النصيرات", "Nuseirat"), ("البريج", "Maghazi") }),
            ("KYS", "خانيونس", "Khan Yunis", new[] { ("مديرية خانيونس", "Khan Yunis Directorate", "KYS") }, new[] { ("خانيونس", "Khan Yunis City"), ("بني سهيلا", "Bani Suheila"), ("عبسان الكبيرة", "Abasan al-Kabira") }),
            ("RFH", "رفح", "Rafah", new[] { ("مديرية رفح", "Rafah Directorate", "RFH") }, new[] { ("رفح", "Rafah City"), ("شوكة الصوفي", "Al-Shoka") })
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
        Log.Information("Starting Damage Reference Data seeding process...");

        if (!context.Database.IsRelational())
        {
            Log.Information("Non-relational database detected; using simplified seeding logic without locks/identity insert.");
            await SeedDamageReferenceDataInternalAsync(context);
            return;
        }

        var strategy = context.Database.CreateExecutionStrategy();
        await strategy.ExecuteAsync(async () =>
        {
            using var transaction = await context.Database.BeginTransactionAsync();
            try
            {
                // Concurrency Protection: SQL Server Application Lock
                // This prevents multiple instances from running the seed logic simultaneously.
                await context.Database.ExecuteSqlRawAsync(
                    "EXEC sp_getapplock @Resource = 'DamageReferenceSeed', @LockMode = 'Exclusive', @LockOwner = 'Transaction', @LockTimeout = 30000");

                Log.Debug("Acquired database-level lock for seeding.");

                await SeedDamageReferenceDataInternalAsync(context);

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

    private static async Task SeedDamageReferenceDataInternalAsync(ApplicationDbContext context)
    {
        // 1. Damage Natures
        await UpsertLookupsAsync(context, context.DamageNatures, "DamageNatures", new[]
        {
            new DamageNature { Id = 1, NameAr = "جفاف", NameEn = "Drought" },
            new DamageNature { Id = 2, NameAr = "صقيع", NameEn = "Frost" },
            new DamageNature { Id = 3, NameAr = "فيضانات", NameEn = "Flood" },
            new DamageNature { Id = 4, NameAr = "عاصفة", NameEn = "Storm" },
            new DamageNature { Id = 5, NameAr = "حريق", NameEn = "Fire" },
            new DamageNature { Id = 6, NameAr = "آفة", NameEn = "Pest" },
            new DamageNature { Id = 7, NameAr = "مرض", NameEn = "Disease" },
            new DamageNature { Id = 8, NameAr = "موجة حر", NameEn = "Heat Wave" },
            new DamageNature { Id = 9, NameAr = "موجة برد", NameEn = "Cold Wave" },
            new DamageNature { Id = 10, NameAr = "أخرى", NameEn = "Other" }
        });

        // 2. Damage Actions
        await UpsertLookupsAsync(context, context.DamageActions, "DamageActions", new[]
        {
            new DamageAction { Id = 1, NameAr = "حرق", NameEn = "Burning" },
            new DamageAction { Id = 2, NameAr = "تكسير", NameEn = "Breaking" },
            new DamageAction { Id = 3, NameAr = "تدمير", NameEn = "Destruction" },
            new DamageAction { Id = 4, NameAr = "سرقة", NameEn = "Theft" },
            new DamageAction { Id = 5, NameAr = "تسميم", NameEn = "Poisoning" },
            new DamageAction { Id = 6, NameAr = "قلع", NameEn = "Uprooting" },
            new DamageAction { Id = 7, NameAr = "قص", NameEn = "Cutting" },
            new DamageAction { Id = 8, NameAr = "إغراق", NameEn = "Flooding" },
            new DamageAction { Id = 9, NameAr = "تخريب", NameEn = "Vandalism" },
            new DamageAction { Id = 10, NameAr = "أخرى", NameEn = "Other" }
        });

        // 3. Damage Categories
        await UpsertLookupsAsync(context, context.DamageCategories, "DamageCategories", new[]
        {
            new DamageCategory { Id = 1, AgriculturalSectorId = 1, NameAr = "محاصيل حقلية", NameEn = "Field Crops" },
            new DamageCategory { Id = 2, AgriculturalSectorId = 1, NameAr = "خضروات", NameEn = "Vegetables" },
            new DamageCategory { Id = 3, AgriculturalSectorId = 1, NameAr = "أشجار مثمرة", NameEn = "Fruit Trees" },
            new DamageCategory { Id = 4, AgriculturalSectorId = 1, NameAr = "أشجار زيتون", NameEn = "Olive Trees" },
            new DamageCategory { Id = 5, AgriculturalSectorId = 1, NameAr = "دفيئات", NameEn = "Greenhouses" },
            new DamageCategory { Id = 6, AgriculturalSectorId = 1, NameAr = "مشاتل", NameEn = "Nurseries" },
            new DamageCategory { Id = 7, AgriculturalSectorId = 2, NameAr = "أبقار", NameEn = "Cattle" },
            new DamageCategory { Id = 8, AgriculturalSectorId = 2, NameAr = "أغنام", NameEn = "Sheep" },
            new DamageCategory { Id = 9, AgriculturalSectorId = 2, NameAr = "ماعز", NameEn = "Goats" },
            new DamageCategory { Id = 10, AgriculturalSectorId = 2, NameAr = "دواجن", NameEn = "Poultry" },
            new DamageCategory { Id = 11, AgriculturalSectorId = 2, NameAr = "نحل", NameEn = "Bees" }
        });

        // 4. Damage SubCategories
        await UpsertLookupsAsync(context, context.DamageSubCategories, "DamageSubCategories", new[]
        {
            new DamageSubCategory { Id = 1, CategoryId = 1, NameAr = "حبوب", NameEn = "Cereals" },
            new DamageSubCategory { Id = 2, CategoryId = 2, NameAr = "مكشوفة", NameEn = "Open Field" },
            new DamageSubCategory { Id = 3, CategoryId = 3, NameAr = "حمضيات", NameEn = "Citrus" },
            new DamageSubCategory { Id = 4, CategoryId = 3, NameAr = "فواكه أخرى", NameEn = "Other Fruits" },
            new DamageSubCategory { Id = 5, CategoryId = 5, NameAr = "خضروات محمية", NameEn = "Protected Vegetables" },
            new DamageSubCategory { Id = 6, CategoryId = 7, NameAr = "إنتاج حليب", NameEn = "Dairy" },
            new DamageSubCategory { Id = 7, CategoryId = 10, NameAr = "لاحم", NameEn = "Broilers" },
            new DamageSubCategory { Id = 8, CategoryId = 11, NameAr = "خلايا نحل", NameEn = "Hives" }
        });

        // 5. Damage Classifications
        await UpsertLookupsAsync(context, context.DamageClassifications, "DamageClassifications", new[]
        {
            new DamageClassification { Id = 1, SubCategoryId = 1, NameAr = "قمح", NameEn = "Wheat" },
            new DamageClassification { Id = 2, SubCategoryId = 1, NameAr = "شعير", NameEn = "Barley" },
            new DamageClassification { Id = 3, SubCategoryId = 2, NameAr = "بندورة", NameEn = "Tomato" },
            new DamageClassification { Id = 4, SubCategoryId = 2, NameAr = "خيار", NameEn = "Cucumber" },
            new DamageClassification { Id = 5, SubCategoryId = 4, NameAr = "زيتون", NameEn = "Olive" },
            new DamageClassification { Id = 6, SubCategoryId = 4, NameAr = "عنب", NameEn = "Grape" },
            new DamageClassification { Id = 7, SubCategoryId = 3, NameAr = "حمضيات", NameEn = "Citrus" },
            new DamageClassification { Id = 8, SubCategoryId = 4, NameAr = "نخيل", NameEn = "Date Palm" }
        });

        // 6. Damage Cause Categories
        await UpsertLookupsAsync(context, context.DamageCauseCategories, "DamageCauseCategories", new[]
        {
            new DamageCauseCategory { Id = 1, NameAr = "سياسي", NameEn = "Political" },
            new DamageCauseCategory { Id = 2, NameAr = "طبيعي", NameEn = "Natural" }
        });

        // 7. Damage Causes
        await UpsertLookupsAsync(context, context.DamageCauses, "DamageCauses", new[]
        {
            new DamageCause { Id = 1, CategoryId = 1, NameAr = "جيش الاحتلال", NameEn = "Army" },
            new DamageCause { Id = 2, CategoryId = 1, NameAr = "مستوطنين", NameEn = "Settlers" },
            new DamageCause { Id = 3, CategoryId = 1, NameAr = "شركات إسرائيلية", NameEn = "Israeli Companies" },
            new DamageCause { Id = 4, CategoryId = 2, NameAr = "فيضانات", NameEn = "Flood" },
            new DamageCause { Id = 5, CategoryId = 2, NameAr = "حرائق", NameEn = "Fire" },
            new DamageCause { Id = 6, CategoryId = 2, NameAr = "جفاف", NameEn = "Drought" },
            new DamageCause { Id = 7, CategoryId = 2, NameAr = "عواصف", NameEn = "Storm" }
        });

        // 8. Costing Sheets (Idempotent by business name)
        const string catalogName = "Official Pricing Catalog 2026";
        var catalog = await context.CostingSheetCatalogs
            .FirstOrDefaultAsync(c => c.Name == catalogName);

        if (catalog == null)
        {
            Log.Information("Seeding Costing Catalog: {Name}", catalogName);
            catalog = new CostingSheetCatalog
            {
                Id = Guid.NewGuid(),
                Name = catalogName,
                Description = "Baseline pricing for the 2026 damage assessment cycle.",
                CreatedAt = DateTime.UtcNow,
                CreatedBy = "System"
            };
            context.CostingSheetCatalogs.Add(catalog);
            await context.SaveChangesAsync();
        }

        var version = await context.CostingSheetVersions
            .FirstOrDefaultAsync(v => v.CatalogId == catalog.Id && v.VersionNumber == 1);

        if (version == null)
        {
            Log.Information("Seeding Costing Version 1 for {Name}", catalogName);
            version = new CostingSheetVersion
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
            await context.SaveChangesAsync();
        }

        // Seed a baseline item for "Olive" (Id 5) if it doesn't exist
        var existingItem = await context.CostingSheetItems
            .AnyAsync(i => i.VersionId == version.Id && i.ClassificationId == 5);

        if (!existingItem)
        {
            Log.Information("Seeding baseline Costing Item for Olive (Classification 5)");
            context.CostingSheetItems.Add(new CostingSheetItem
            {
                Id = Guid.NewGuid(),
                VersionId = version.Id,
                ClassificationId = 5,
                UnitPrice = 100,
                MeasurementUnitId = 1, // Dunum
                CreatedAt = DateTime.UtcNow
            });
            await context.SaveChangesAsync();
        }
    }

    private static async Task UpsertLookupsAsync<T>(ApplicationDbContext context, DbSet<T> dbSet, string tableName, T[] items) where T : class
    {
        var existingIds = await dbSet.Select(e => EF.Property<int>(e, "Id")).ToListAsync();

        var toAdd = new List<T>();
        foreach (var item in items)
        {
            var idProperty = typeof(T).GetProperty("Id");
            if (idProperty == null) continue;

            var idValue = (int)idProperty.GetValue(item)!;
            if (!existingIds.Contains(idValue))
            {
                toAdd.Add(item);
            }
        }

        if (toAdd.Count == 0)
        {
            Log.Debug("All items for {Table} already exist; skipping.", tableName);
            return;
        }

        Log.Information("Seeding {Count} new items into {Table}...", toAdd.Count, tableName);
        dbSet.AddRange(toAdd);
        await SaveWithIdentityInsertAsync(context, tableName);
    }

    private static async Task SaveWithIdentityInsertAsync(ApplicationDbContext context, string tableName)
    {
        if (!context.Database.IsRelational())
        {
            await context.SaveChangesAsync();
            return;
        }

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
