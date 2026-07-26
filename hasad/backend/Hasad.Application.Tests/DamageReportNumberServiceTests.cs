using Hasad.Application.Common.Interfaces;
using Hasad.Domain.Entities;
using Hasad.Infrastructure.Persistence;
using Hasad.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;

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
    public async Task GeneratePermanentNumberAsync_ReturnsCorrectFormat()
    {
        var context = CreateContext();
        var gov = new Governorate { Id = Guid.NewGuid(), Code = "NBL", NameAr = "نابلس", NameEn = "Nablus" };
        var dir = new Directorate { Id = Guid.NewGuid(), Code = "NAB", NameAr = "مديرية نابلس", NameEn = "Nablus Directorate", GovernorateId = gov.Id };
        context.Governorates.Add(gov);
        context.Directorates.Add(dir);
        await context.SaveChangesAsync();

        var service = new DamageReportNumberService(context);
        var number = await service.GeneratePermanentNumberAsync(dir.Id, 2026);

        Assert.Equal("NBL-NAB-2026-000001", number);
    }

    [Fact]
    public async Task GeneratePermanentNumberAsync_IncrementsSequence()
    {
        var context = CreateContext();
        var gov = new Governorate { Id = Guid.NewGuid(), Code = "NBL", NameAr = "نابلس", NameEn = "Nablus" };
        var dir = new Directorate { Id = Guid.NewGuid(), Code = "NAB", NameAr = "مديرية نابلس", NameEn = "Nablus Directorate", GovernorateId = gov.Id };
        context.Governorates.Add(gov);
        context.Directorates.Add(dir);
        await context.SaveChangesAsync();

        var service = new DamageReportNumberService(context);
        await service.GeneratePermanentNumberAsync(dir.Id, 2026);
        await context.SaveChangesAsync();
        var number2 = await service.GeneratePermanentNumberAsync(dir.Id, 2026);
        await context.SaveChangesAsync();

        Assert.Equal("NBL-NAB-2026-000002", number2);
    }

    [Fact]
    public async Task GeneratePermanentNumberAsync_IsolatesByDirectorate()
    {
        var context = CreateContext();
        var gov = new Governorate { Id = Guid.NewGuid(), Code = "NBL", NameAr = "نابلس", NameEn = "Nablus" };
        var dir1 = new Directorate { Id = Guid.NewGuid(), Code = "NAB", NameAr = "مديرية نابلس", NameEn = "Nablus Directorate", GovernorateId = gov.Id };
        var dir2 = new Directorate { Id = Guid.NewGuid(), Code = "SNB", NameAr = "مديرية جنوب نابلس", NameEn = "South Nablus", GovernorateId = gov.Id };
        context.Governorates.Add(gov);
        context.Directorates.AddRange(dir1, dir2);
        await context.SaveChangesAsync();

        var service = new DamageReportNumberService(context);
        await service.GeneratePermanentNumberAsync(dir1.Id, 2026);
        var numberDir2 = await service.GeneratePermanentNumberAsync(dir2.Id, 2026);

        Assert.Equal("NBL-SNB-2026-000001", numberDir2);
    }

    [Fact]
    public async Task GeneratePermanentNumberAsync_IsolatesByYear()
    {
        var context = CreateContext();
        var gov = new Governorate { Id = Guid.NewGuid(), Code = "NBL", NameAr = "نابلس", NameEn = "Nablus" };
        var dir = new Directorate { Id = Guid.NewGuid(), Code = "NAB", NameAr = "مديرية نابلس", NameEn = "Nablus Directorate", GovernorateId = gov.Id };
        context.Governorates.Add(gov);
        context.Directorates.Add(dir);
        await context.SaveChangesAsync();

        var service = new DamageReportNumberService(context);
        await service.GeneratePermanentNumberAsync(dir.Id, 2026);
        var number2027 = await service.GeneratePermanentNumberAsync(dir.Id, 2027);

        Assert.Equal("NBL-NAB-2027-000001", number2027);
    }
}
