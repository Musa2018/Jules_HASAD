using Hasad.Domain.Entities;
using Hasad.Infrastructure.Persistence;
using Hasad.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;
using Hasad.Application.Common.Interfaces;

namespace Hasad.Application.Tests;

public class DamageReportNumberServiceTests
{
    private readonly Mock<ICurrentUserService> _currentUserMock;

    public DamageReportNumberServiceTests()
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
    public async Task GeneratePermanentNumber_UsesGovernorateAndDirectorateCodes()
    {
        var context = CreateContext();
        var governorateId = Guid.NewGuid();
        var directorateId = Guid.NewGuid();

        context.Governorates.Add(new Governorate { Id = governorateId, Code = "NBL", NameAr = "نابلس", NameEn = "Nablus" });
        context.Directorates.Add(new Directorate
        {
            Id = directorateId,
            GovernorateId = governorateId,
            Code = "NAB",
            NameAr = "نابلس",
            NameEn = "Nablus"
        });
        await context.SaveChangesAsync();

        var service = new DamageReportNumberService(context);

        var number = await service.GeneratePermanentNumberAsync(directorateId, 2026);
        Assert.Equal("NBL-NAB-2026-000001", number);
    }

    [Fact]
    public async Task GeneratePermanentNumber_WorksWhenCodesAreIdentical()
    {
        var context = CreateContext();
        var governorateId = Guid.NewGuid();
        var directorateId = Guid.NewGuid();

        context.Governorates.Add(new Governorate { Id = governorateId, Code = "JEN", NameAr = "جنين", NameEn = "Jenin" });
        context.Directorates.Add(new Directorate
        {
            Id = directorateId,
            GovernorateId = governorateId,
            Code = "JEN",
            NameAr = "جنين",
            NameEn = "Jenin"
        });
        await context.SaveChangesAsync();

        var service = new DamageReportNumberService(context);

        var number = await service.GeneratePermanentNumberAsync(directorateId, 2026);
        Assert.Equal("JEN-JEN-2026-000001", number);
    }

    [Fact]
    public async Task GeneratePermanentNumber_IncrementsAcrossYears_ForSameDirectorate()
    {
        var context = CreateContext();
        var governorateId = Guid.NewGuid();
        var directorateId = Guid.NewGuid();

        context.Governorates.Add(new Governorate { Id = governorateId, Code = "JEN", NameAr = "جنين", NameEn = "Jenin" });
        var directorate = new Directorate
        {
            Id = directorateId,
            GovernorateId = governorateId,
            Code = "JEN",
            NameAr = "جنين",
            NameEn = "Jenin"
        };
        context.Directorates.Add(directorate);
        await context.SaveChangesAsync();

        var service = new DamageReportNumberService(context);

        // First report in 2026
        var number1 = await service.GeneratePermanentNumberAsync(directorateId, 2026);
        await context.SaveChangesAsync();
        Assert.Equal("JEN-JEN-2026-000001", number1);

        // Second report in 2019 (Historical)
        var number2 = await service.GeneratePermanentNumberAsync(directorateId, 2019);
        await context.SaveChangesAsync();
        Assert.Equal("JEN-JEN-2019-000002", number2);

        // Third report in 2026
        var number3 = await service.GeneratePermanentNumberAsync(directorateId, 2026);
        await context.SaveChangesAsync();
        Assert.Equal("JEN-JEN-2026-000003", number3);
    }
}
