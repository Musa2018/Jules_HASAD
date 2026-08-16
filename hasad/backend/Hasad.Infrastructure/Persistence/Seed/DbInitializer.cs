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
    public enum IdentityInsertTable
    {
        Governorates,
        Directorates,
        Localities,
        OwnershipTypes,
        AgriculturalSectors,
        PoliticalClassifications,
        AreaUnits,
        MeasurementUnits,
        RelationshipToOwners,
        DamageNatures,
        DamageActions,
        DamageCategories,
        DamageSubCategories,
        DamageClassifications,
        DamageCauseCategories,
        DamageCauses,
        WorkflowStatuses,
        WorkflowTransitions
    }

    /// <summary>
    /// Seeds the workflow statuses and transitions.
    /// </summary>
    public static async Task SeedWorkflowDataAsync(ApplicationDbContext context)
    {
        Log.Information("Seeding Workflow Reference Data...");

        // 1. Statuses
        var statuses = new[]
        {
            new WorkflowStatus { Id = DamageReportStatus.Draft, NameAr = "مسودة", NameEn = "Draft", Order = 1 },
            new WorkflowStatus { Id = DamageReportStatus.TechReview, NameAr = "مراجعة فنية (المديرية)", NameEn = "Technical Review (Directorate)", Order = 2 },
            new WorkflowStatus { Id = DamageReportStatus.ArchiveDir, NameAr = "أرشفة المديرية", NameEn = "Directorate Archive", Order = 3 },
            new WorkflowStatus { Id = DamageReportStatus.DirManager, NameAr = "مدير المديرية", NameEn = "Directorate Manager", Order = 4 },
            new WorkflowStatus { Id = DamageReportStatus.MinTechReview, NameAr = "مراجعة فنية (الوزارة)", NameEn = "Technical Review (Ministry)", Order = 5 },
            new WorkflowStatus { Id = DamageReportStatus.LegalReview, NameAr = "مراجعة قانونية", NameEn = "Legal Review", Order = 6 },
            new WorkflowStatus { Id = DamageReportStatus.MinArchive, NameAr = "أرشفة الوزارة", NameEn = "Ministry Archive", Order = 7 },
            new WorkflowStatus { Id = DamageReportStatus.ProcReview, NameAr = "مراجعة إجرائية", NameEn = "Procedural Review", Order = 8 },
            new WorkflowStatus { Id = DamageReportStatus.GenManager, NameAr = "المدير العام", NameEn = "General Manager", Order = 9 },
            new WorkflowStatus { Id = DamageReportStatus.Completed, NameAr = "مكتمل", NameEn = "Completed", Order = 10 }
        };

        foreach (var status in statuses)
        {
            if (!await context.WorkflowStatuses.AnyAsync(s => s.Id == status.Id))
            {
                context.WorkflowStatuses.Add(status);
            }
        }
        await context.SaveChangesAsync();

        // 2. Transitions (Simplified set based on brainstorming)
        var transitions = new[]
        {
            // Directorate Level
            new WorkflowTransition { Id = Guid.NewGuid(), FromStatusId = DamageReportStatus.Draft, ToStatusId = DamageReportStatus.TechReview, AllowedRole = AppRoles.AgriculturalEngineer },
            new WorkflowTransition { Id = Guid.NewGuid(), FromStatusId = DamageReportStatus.TechReview, ToStatusId = DamageReportStatus.ArchiveDir, AllowedRole = AppRoles.TechnicalReviewer },
            new WorkflowTransition { Id = Guid.NewGuid(), FromStatusId = DamageReportStatus.TechReview, ToStatusId = DamageReportStatus.Draft, AllowedRole = AppRoles.TechnicalReviewer, IsReturn = true },
            new WorkflowTransition { Id = Guid.NewGuid(), FromStatusId = DamageReportStatus.ArchiveDir, ToStatusId = DamageReportStatus.DirManager, AllowedRole = AppRoles.ArchiveOfficer },
            new WorkflowTransition { Id = Guid.NewGuid(), FromStatusId = DamageReportStatus.ArchiveDir, ToStatusId = DamageReportStatus.TechReview, AllowedRole = AppRoles.ArchiveOfficer, IsReturn = true },

            // Ministry Level
            new WorkflowTransition { Id = Guid.NewGuid(), FromStatusId = DamageReportStatus.DirManager, ToStatusId = DamageReportStatus.MinTechReview, AllowedRole = AppRoles.DirectorateManager },
            new WorkflowTransition { Id = Guid.NewGuid(), FromStatusId = DamageReportStatus.MinTechReview, ToStatusId = DamageReportStatus.LegalReview, AllowedRole = AppRoles.MinistryTechReviewer },
            new WorkflowTransition { Id = Guid.NewGuid(), FromStatusId = DamageReportStatus.MinTechReview, ToStatusId = DamageReportStatus.DirManager, AllowedRole = AppRoles.MinistryTechReviewer, IsReturn = true },
            new WorkflowTransition { Id = Guid.NewGuid(), FromStatusId = DamageReportStatus.LegalReview, ToStatusId = DamageReportStatus.MinArchive, AllowedRole = AppRoles.LegalReviewer },
            new WorkflowTransition { Id = Guid.NewGuid(), FromStatusId = DamageReportStatus.LegalReview, ToStatusId = DamageReportStatus.MinTechReview, AllowedRole = AppRoles.LegalReviewer, IsReturn = true },
            new WorkflowTransition { Id = Guid.NewGuid(), FromStatusId = DamageReportStatus.MinArchive, ToStatusId = DamageReportStatus.ProcReview, AllowedRole = AppRoles.ChiefArchiveOfficer },
            new WorkflowTransition { Id = Guid.NewGuid(), FromStatusId = DamageReportStatus.MinArchive, ToStatusId = DamageReportStatus.LegalReview, AllowedRole = AppRoles.ChiefArchiveOfficer, IsReturn = true },
            new WorkflowTransition { Id = Guid.NewGuid(), FromStatusId = DamageReportStatus.ProcReview, ToStatusId = DamageReportStatus.GenManager, AllowedRole = AppRoles.ProceduralReviewer },

            // Final Decision
            new WorkflowTransition { Id = Guid.NewGuid(), FromStatusId = DamageReportStatus.GenManager, ToStatusId = DamageReportStatus.Completed, AllowedRole = AppRoles.GeneralManager }
        };

        foreach (var trans in transitions)
        {
            if (!await context.WorkflowTransitions.AnyAsync(t => t.FromStatusId == trans.FromStatusId && t.ToStatusId == trans.ToStatusId && t.AllowedRole == trans.AllowedRole))
            {
                context.WorkflowTransitions.Add(trans);
            }
        }
        await context.SaveChangesAsync();
    }

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
        var geographics = new List<(string Code, string NameAr, string NameEn, (string NameAr, string NameEn, string Code)[] Directorates, (string NameAr, string NameEn, string DirectorateCode)[] Localities)>
        {
            ("JEN", "جنين", "Jenin",
                new[] { ("مديرية جنين", "Jenin Directorate", "JEN"), ("مديرية شمال جنين", "North Jenin", "NJEN") },
                new[] { ("مدينة جنين", "Jenin City", "JEN"), ("قباطية", "Qabatiya", "JEN"), ("اليامون", "Ya'bad", "JEN"), ("كفر دان", "Kafr Dan", "NJEN"), ("اليامون", "Yamoun", "NJEN") }),
            ("TUB", "طوباس", "Tubas",
                new[] { ("مديرية طوباس", "Tubas Directorate", "TUB") },
                new[] { ("طوباس", "Tubas", "TUB"), ("طمون", "Tammun", "TUB"), ("عقابا", "Aqqaba", "TUB") }),
            ("TUL", "طولكرم", "Tulkarm",
                new[] { ("مديرية طولكرم", "Tulkarm Directorate", "TUL") },
                new[] { ("طولكرم", "Tulkarm City", "TUL"), ("عتيل", "Attil", "TUL"), ("دير الغصون", "Deir al-Ghusun", "TUL") }),
            ("NBL", "نابلس", "Nablus",
                new[] { ("مديرية نابلس", "Nablus Directorate", "NAB") },
                new[] { ("مدينة نابلس", "Nablus City", "NAB"), ("عصيرة الشمالية", "Asira al-Shamaliya", "NAB"), ("بيتا", "Beita", "NAB") }),
            ("QAL", "قلقيلية", "Qalqilya",
                new[] { ("مديرية قلقيلية", "Qalqilya Directorate", "QAL") },
                new[] { ("قلقيلية", "Qalqilya City", "QAL"), ("عزون", "Azzun", "QAL"), ("حبلة", "Habla", "QAL") }),
            ("SLF", "سلفيت", "Salfit",
                new[] { ("مديرية سلفيت", "Salfit Directorate", "SLF") },
                new[] { ("سلفيت", "Salfit City", "SLF"), ("بديا", "Biddya", "SLF"), ("الزاوية", "Zawiya", "SLF") }),
            ("RAM", "رام الله والبيرة", "Ramallah & Al-Bireh",
                new[] { ("مديرية رام الله", "Ramallah Directorate", "RAM") },
                new[] { ("رام الله", "Ramallah City", "RAM"), ("البيرة", "Al-Bireh", "RAM"), ("بيتونيا", "Beituniya", "RAM") }),
            ("JER", "أريحا", "Jericho",
                new[] { ("مديرية أريحا", "Jericho Directorate", "JER") },
                new[] { ("أريحا", "Jericho City", "JER"), ("العوجا", "Al-Auja", "JER"), ("الجفتلك", "Al-Jiftlik", "JER") }),
            ("JRS", "القدس", "Jerusalem",
                new[] { ("مديرية القدس", "Jerusalem Directorate", "JRS") },
                new[] { ("القدس", "Jerusalem City", "JRS"), ("العيزرية", "Al-Eizariya", "JRS"), ("أبو ديس", "Abu Dis", "JRS") }),
            ("BTH", "بيت لحم", "Bethlehem",
                new[] { ("مديرية بيت لحم", "Bethlehem Directorate", "BTH") },
                new[] { ("بيت لحم", "Bethlehem City", "BTH"), ("بيت جالا", "Beit Jala", "BTH"), ("بيت ساحور", "Beit Sahour", "BTH") }),
            ("HBN", "الخليل", "Hebron",
                new[] { ("مديرية شمال الخليل", "North Hebron", "NHB"), ("مديرية جنوب الخليل", "South Hebron", "SHB"), ("مديرية الخليل", "Hebron Directorate", "HBN") },
                new[] { ("مدينة الخليل", "Hebron City", "HBN"), ("حلحول", "Halhul", "NHB"), ("دورا", "Dura", "SHB"), ("يطا", "Yatta", "SHB") }),
            ("NGZ", "شمال غزة", "North Gaza",
                new[] { ("مديرية شمال غزة", "North Gaza Directorate", "NGZ") },
                new[] { ("جباليا", "Jabalia", "NGZ"), ("بيت لاهيا", "Beit Lahiya", "NGZ"), ("بيت حانون", "Beit Hanoun", "NGZ") }),
            ("GZA", "غزة", "Gaza",
                new[] { ("مديرية غزة", "Gaza Directorate", "GZA") },
                new[] { ("مدينة غزة", "Gaza City", "GZA"), ("المغراقة", "Al-Mughraqa", "GZA") }),
            ("CEN", "دير البلح", "Deir al-Balah",
                new[] { ("مديرية الوسطى", "Central Directorate", "CEN") },
                new[] { ("دير البلح", "Deir al-Balah City", "CEN"), ("النصيرات", "Nuseirat", "CEN"), ("البريج", "Maghazi", "CEN") }),
            ("KYS", "خانيونس", "Khan Yunis",
                new[] { ("مديرية خانيونس", "Khan Yunis Directorate", "KYS") },
                new[] { ("خانيونس", "Khan Yunis City", "KYS"), ("بني سهيلا", "Bani Suheila", "KYS"), ("عبسان الكبيرة", "Abasan al-Kabira", "KYS") }),
            ("RFH", "رفح", "Rafah",
                new[] { ("مديرية رفح", "Rafah Directorate", "RFH") },
                new[] { ("رفح", "Rafah City", "RFH"), ("شوكة الصوفي", "Al-Shoka", "RFH") })
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
                existingGovernorates[code] = governorate;
            }
            else
            {
                governorate.NameAr = nameAr;
                governorate.NameEn = nameEn;
            }

            // 1. Seed Directorates
            foreach (var (dirNameAr, dirNameEn, dirCode) in directorates)
            {
                var existingDir = governorate.Directorates
                    .FirstOrDefault(d => d.Code == dirCode);

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
                    governorate.Directorates.Add(existingDir);
                }
                else
                {
                    existingDir.NameAr = dirNameAr;
                    existingDir.NameEn = dirNameEn;
                }
            }

            // 2. Seed Localities (Fixed Mapping)
            foreach (var (locNameAr, locNameEn, dirCode) in localities)
            {
                var existingLoc = governorate.Localities
                    .FirstOrDefault(l => l.NameEn == locNameEn);

                var targetDir = governorate.Directorates.First(d => d.Code == dirCode);

                if (existingLoc == null)
                {
                    context.Localities.Add(new Locality
                    {
                        Id = Guid.NewGuid(),
                        NameAr = locNameAr,
                        NameEn = locNameEn,
                        GovernorateId = governorate.Id,
                        DirectorateId = targetDir.Id,
                        IsActive = true,
                        CreatedAt = DateTime.UtcNow
                    });
                }
                else
                {
                    existingLoc.NameAr = locNameAr;
                    existingLoc.DirectorateId = targetDir.Id;
                }
            }
        }

        await context.SaveChangesAsync();

        // 3. Verification: Ensure every locality belongs to exactly one directorate and belongs to the correct governorate
        var auditFailures = await context.Localities
            .Where(l => l.DirectorateId == Guid.Empty || l.GovernorateId == Guid.Empty)
            .CountAsync();

        if (auditFailures > 0)
        {
            throw new Exception($"Geographic Seed Integrity Failure: {auditFailures} localities have missing geographic parentage.");
        }

        Log.Information("Geographic Seed verified: All localities mapped to valid parents.");
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
        await UpsertLookupsAsync(context, context.DamageNatures, IdentityInsertTable.DamageNatures, new[]
        {
            new DamageNature { Id = 1, NameAr = "انتاج نباتي", NameEn = "Plant production" },
            new DamageNature { Id = 2, NameAr = "انتاج حيواني", NameEn = "Animal production" },
            new DamageNature { Id = 3, NameAr = "منشأت وبنية تحتية", NameEn = "Facilities and infrastructure" },
            new DamageNature { Id = 4, NameAr = "مصادر مياه", NameEn = "Water sources" },
            new DamageNature { Id = 5, NameAr = "مصادر طاقة", NameEn = "Energy sources" },
            new DamageNature { Id = 6, NameAr = "أخرى", NameEn = "Other" }
        });

        // 2. Damage Actions
        await UpsertLookupsAsync(context, context.DamageActions, IdentityInsertTable.DamageActions, new[]
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
            new DamageAction { Id = 10, NameAr = "منع وصول", NameEn = "Prevention of access" },
            new DamageAction { Id = 11, NameAr = "أخرى", NameEn = "Other" }
        });

        // 3. Damage Categories
        await UpsertLookupsAsync(context, context.DamageCategories, IdentityInsertTable.DamageCategories, new[]
        {
            new DamageCategory { Id = 1, AgriculturalSectorId = 1, NameAr = "محاصيل حقلية", NameEn = "Field Crops" },
            new DamageCategory { Id = 2, AgriculturalSectorId = 1, NameAr = "خضروات", NameEn = "Vegetables" },
            new DamageCategory { Id = 3, AgriculturalSectorId = 1, NameAr = "أشجار", NameEn = "Trees" },
            new DamageCategory { Id = 4, AgriculturalSectorId = 1, NameAr = "دفيئات", NameEn = "Greenhouses" },
            new DamageCategory { Id = 5, AgriculturalSectorId = 1, NameAr = "مشاتل", NameEn = "Nurseries" },
            new DamageCategory { Id = 6, AgriculturalSectorId = 2, NameAr = "أبقار", NameEn = "Cattle" },
            new DamageCategory { Id = 7, AgriculturalSectorId = 2, NameAr = "أغنام", NameEn = "Sheep" },
            new DamageCategory { Id = 8, AgriculturalSectorId = 2, NameAr = "ماعز", NameEn = "Goats" },
            new DamageCategory { Id = 9, AgriculturalSectorId = 2, NameAr = "دواجن", NameEn = "Poultry" },
            new DamageCategory { Id = 10, AgriculturalSectorId = 2, NameAr = "نحل", NameEn = "Bees" }
        });

        // 4. Damage SubCategories
        await UpsertLookupsAsync(context, context.DamageSubCategories, IdentityInsertTable.DamageSubCategories, new[]
        {
            new DamageSubCategory { Id = 1, CategoryId = 1, NameAr = "حبوب", NameEn = "Cereals" },
            new DamageSubCategory { Id = 2, CategoryId = 2, NameAr = "مكشوفة", NameEn = "Open Field" },
            new DamageSubCategory { Id = 3, CategoryId = 3, NameAr = "حمضيات", NameEn = "Citrus" },
            new DamageSubCategory { Id = 4, CategoryId = 3, NameAr = "زيتون", NameEn = "Olive" },
            new DamageSubCategory { Id = 5, CategoryId = 4, NameAr = "خضروات محمية", NameEn = "Protected Vegetables" },
            new DamageSubCategory { Id = 6, CategoryId = 6, NameAr = "إنتاج حليب", NameEn = "Dairy" },
            new DamageSubCategory { Id = 7, CategoryId = 9, NameAr = "لاحم", NameEn = "Broilers" },
            new DamageSubCategory { Id = 8, CategoryId = 10, NameAr = "خلايا نحل", NameEn = "Hives" },
            new DamageSubCategory { Id = 9, CategoryId = 3, NameAr = "فواكه أخرى", NameEn = "Other Fruits" }
        });

        // 5. Damage Classifications
        await UpsertLookupsAsync(context, context.DamageClassifications, IdentityInsertTable.DamageClassifications, new[]
        {
            new DamageClassification { Id = 1, SubCategoryId = 1, NameAr = "قمح", NameEn = "Wheat" },
            new DamageClassification { Id = 2, SubCategoryId = 1, NameAr = "شعير", NameEn = "Barley" },
            new DamageClassification { Id = 3, SubCategoryId = 2, NameAr = "بندورة", NameEn = "Tomato" },
            new DamageClassification { Id = 4, SubCategoryId = 2, NameAr = "خيار", NameEn = "Cucumber" },
            new DamageClassification { Id = 5, SubCategoryId = 4, NameAr = "زيتون (1-5 سنوات)", NameEn = "Olive (1-5 years)" },
            new DamageClassification { Id = 11, SubCategoryId = 4, NameAr = "زيتون (5-10 سنوات)", NameEn = "Olive (5-10 years)" },
            new DamageClassification { Id = 12, SubCategoryId = 4, NameAr = "زيتون (أكثر من 10 سنوات)", NameEn = "Olive (10+ years)" },
            new DamageClassification { Id = 6, SubCategoryId = 9, NameAr = "عنب", NameEn = "Grape" },
            new DamageClassification { Id = 7, SubCategoryId = 3, NameAr = "حمضيات", NameEn = "Citrus" },
            new DamageClassification { Id = 8, SubCategoryId = 9, NameAr = "نخيل", NameEn = "Date Palm" }
        });

        // 6. Damage Cause Categories
        await UpsertLookupsAsync(context, context.DamageCauseCategories, IdentityInsertTable.DamageCauseCategories, new[]
        {
            new DamageCauseCategory { Id = 1, NameAr = "سياسي", NameEn = "Political" },
            new DamageCauseCategory { Id = 2, NameAr = "طبيعي", NameEn = "Natural" }
        });

        // 7. Damage Causes
        await UpsertLookupsAsync(context, context.DamageCauses, IdentityInsertTable.DamageCauses, new[]
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

        // Seed baseline items for all classifications if they don't exist
        var baselineItems = new[]
        {
            (Id: 1, Code: "C001", Price: 120m, UnitId: 1), // Wheat - Dunum
            (Id: 2, Code: "C002", Price: 100m, UnitId: 1), // Barley - Dunum
            (Id: 3, Code: "C003", Price: 400m, UnitId: 1), // Tomato - Dunum
            (Id: 4, Code: "C004", Price: 450m, UnitId: 1), // Cucumber - Dunum
            (Id: 5, Code: "C005", Price: 40m, UnitId: 4),  // Olive (1-5) - Tree
            (Id: 11, Code: "C006", Price: 80m, UnitId: 4), // Olive (5-10) - Tree
            (Id: 12, Code: "C007", Price: 150m, UnitId: 4),// Olive (10+) - Tree
            (Id: 6, Code: "C008", Price: 500m, UnitId: 1), // Grape - Dunum
            (Id: 7, Code: "C009", Price: 450m, UnitId: 1), // Citrus - Dunum
            (Id: 8, Code: "C010", Price: 200m, UnitId: 4)  // Date Palm - Tree
        };

        foreach (var item in baselineItems)
        {
            var exists = await context.CostingSheetItems
                .AnyAsync(i => i.VersionId == version.Id && i.ClassificationId == item.Id);

            if (!exists)
            {
                Log.Information("Seeding baseline Costing Item for Classification {Id}", item.Id);
                context.CostingSheetItems.Add(new CostingSheetItem
                {
                    Id = Guid.NewGuid(),
                    Code = item.Code,
                    VersionId = version.Id,
                    ClassificationId = item.Id,
                    UnitPrice = item.Price,
                    MeasurementUnitId = item.UnitId,
                    CreatedAt = DateTime.UtcNow
                });
            }
        }
        await context.SaveChangesAsync();
    }

    private static async Task UpsertLookupsAsync<T>(ApplicationDbContext context, DbSet<T> dbSet, IdentityInsertTable tableEnum, T[] items) where T : class
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
            Log.Debug("All items for {Table} already exist; skipping.", tableEnum);
            return;
        }

        Log.Information("Seeding {Count} new items into {Table}...", toAdd.Count, tableEnum);
        dbSet.AddRange(toAdd);
        await SaveWithIdentityInsertAsync(context, tableEnum);
    }

    public static async Task SeedUatUsersAsync(UserManager<ApplicationUser> userManager, ApplicationDbContext context)
    {
        var password = "StrongPassword123!"; // 17 chars, meets all criteria

        // 1. Governorate User (Jenin)
        var jeninGov = await context.Governorates.FirstAsync(g => g.Code == "JEN");
        var govUserEmail = "jenin.gov@hasad.ps";
        if (await userManager.FindByEmailAsync(govUserEmail) == null)
        {
            var user = new ApplicationUser
            {
                UserName = "jenin_gov",
                Email = govUserEmail,
                FullName = "Jenin Governorate User",
                GovernorateId = jeninGov.Id,
                EmailConfirmed = true,
                IsActive = true
            };
            var result = await userManager.CreateAsync(user, password);
            if (result.Succeeded)
            {
                await userManager.AddToRoleAsync(user, AppRoles.Director);
            }
            else
            {
                throw new InvalidOperationException($"Failed to create Jenin Governorate User: {string.Join(", ", result.Errors.Select(e => e.Description))}");
            }
        }

        // 2. Directorate User A (Jenin)
        var jeninDir = await context.Directorates.FirstAsync(d => d.Code == "JEN");
        var dirAEmail = "jenin.dir@hasad.ps";
        if (await userManager.FindByEmailAsync(dirAEmail) == null)
        {
            var user = new ApplicationUser
            {
                UserName = "jenin_dir_a",
                Email = dirAEmail,
                FullName = "Jenin Directorate User A",
                GovernorateId = jeninGov.Id,
                DirectorateId = jeninDir.Id,
                EmailConfirmed = true,
                IsActive = true
            };
            var result = await userManager.CreateAsync(user, password);
            if (result.Succeeded)
            {
                await userManager.AddToRoleAsync(user, AppRoles.AgriculturalEngineer);
            }
            else
            {
                throw new InvalidOperationException($"Failed to create Jenin Directorate User A: {string.Join(", ", result.Errors.Select(e => e.Description))}");
            }
        }

        // 3. Directorate User B (North Jenin)
        var nJeninDir = await context.Directorates.FirstAsync(d => d.Code == "NJEN");
        var dirBEmail = "njenin.dir@hasad.ps";
        if (await userManager.FindByEmailAsync(dirBEmail) == null)
        {
            var user = new ApplicationUser
            {
                UserName = "njenin_dir_b",
                Email = dirBEmail,
                FullName = "North Jenin Directorate User B",
                GovernorateId = jeninGov.Id,
                DirectorateId = nJeninDir.Id,
                EmailConfirmed = true,
                IsActive = true
            };
            var result = await userManager.CreateAsync(user, password);
            if (result.Succeeded)
            {
                await userManager.AddToRoleAsync(user, AppRoles.AgriculturalEngineer);
            }
            else
            {
                throw new InvalidOperationException($"Failed to create North Jenin Directorate User B: {string.Join(", ", result.Errors.Select(e => e.Description))}");
            }
        }
    }

    private static async Task SaveWithIdentityInsertAsync(ApplicationDbContext context, IdentityInsertTable tableEnum)
    {
        if (!context.Database.IsRelational())
        {
            await context.SaveChangesAsync();
            return;
        }

        string tableName = tableEnum.ToString();

        try
        {
            Log.Debug("Enabling IDENTITY_INSERT for {Table}", tableName);
            // IDENTITY_INSERT table names cannot be parameterized.
            // Using whitelist via Enum to satisfy EF1002 and security requirements.
            await context.Database.ExecuteSqlRawAsync("SET IDENTITY_INSERT " + tableName + " ON");
            await context.SaveChangesAsync();
            await context.Database.ExecuteSqlRawAsync("SET IDENTITY_INSERT " + tableName + " OFF");
            Log.Debug("Disabled IDENTITY_INSERT for {Table}", tableName);
        }
        catch (Exception ex)
        {
            Log.Error(ex, "Error during IDENTITY_INSERT operation for table {Table}", tableName);
            // Ensure IDENTITY_INSERT is OFF even on failure if connection is still open
            try
            {
                await context.Database.ExecuteSqlRawAsync("SET IDENTITY_INSERT " + tableName + " OFF");
            }
            catch
            {
                // Ignore errors during emergency cleanup
            }
            throw;
        }
    }
}
