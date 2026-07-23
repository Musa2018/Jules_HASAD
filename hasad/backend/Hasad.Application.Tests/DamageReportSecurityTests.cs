using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.DamageReports.Commands.CreateDamageReport;
using Hasad.Application.Features.DamageReports.Commands.UpdateDamageReport;
using Hasad.Application.Features.DamageReports.Commands.DeleteDamageReport;
using Hasad.Application.Features.DamageReports.Commands.UpdateDamageItem;
using Hasad.Application.Features.DamageReports.Commands.UploadAttachment;
using Hasad.Application.Features.DamageReports.Queries.GetDamageReportById;
using Hasad.Domain.Entities;
using Hasad.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;
using Hasad.Domain.Constants;

namespace Hasad.Application.Tests;

public class DamageReportSecurityTests
{
    private readonly Mock<ICurrentUserService> _currentUserMock;
    private readonly Mock<IDamageReportNumberService> _numberServiceMock;
    private readonly Mock<IFileStorageService> _storageServiceMock;

    public DamageReportSecurityTests()
    {
        _currentUserMock = new Mock<ICurrentUserService>();
        _numberServiceMock = new Mock<IDamageReportNumberService>();
        _storageServiceMock = new Mock<IFileStorageService>();

        _numberServiceMock.Setup(x => x.GeneratePermanentNumberAsync(It.IsAny<Guid>(), It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync("000001-TEST-2026");
    }

    private ApplicationDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        return new ApplicationDbContext(options, _currentUserMock.Object);
    }

    [Fact]
    public async Task CreateDamageReport_Succeeds_WhenEngineerInSameDirectorateAsFarm()
    {
        var context = CreateContext();
        var directorateId = Guid.NewGuid();

        _currentUserMock.Setup(x => x.IsInRole(AppRoles.AgriculturalEngineer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(directorateId);

        var farm = new Farm { Id = Guid.NewGuid(), DirectorateId = directorateId };
        var farmer = new Farmer { Id = Guid.NewGuid(), IdTypeId = 1, IdNumber = "1", FirstNameAr = "A", FatherNameAr = "B", GrandfatherNameAr = "C", FamilyNameAr = "D" };
        context.Farms.Add(farm);
        context.Farmers.Add(farmer);
        await context.SaveChangesAsync();

        var handler = new CreateDamageReportCommandHandler(context, _currentUserMock.Object, _numberServiceMock.Object);
        var command = CreateValidCreateCommand(farm.Id, farmer.Id);

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
    }

    [Fact]
    public async Task CreateDamageReport_Fails_WhenEngineerInDifferentDirectorate()
    {
        var context = CreateContext();
        var myDirectorateId = Guid.NewGuid();
        var otherDirectorateId = Guid.NewGuid();

        _currentUserMock.Setup(x => x.IsInRole(AppRoles.AgriculturalEngineer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(myDirectorateId);

        var farm = new Farm { Id = Guid.NewGuid(), DirectorateId = otherDirectorateId };
        var farmer = new Farmer { Id = Guid.NewGuid(), IdTypeId = 1, IdNumber = "1", FirstNameAr = "A", FatherNameAr = "B", GrandfatherNameAr = "C", FamilyNameAr = "D" };
        context.Farms.Add(farm);
        context.Farmers.Add(farmer);
        await context.SaveChangesAsync();

        var handler = new CreateDamageReportCommandHandler(context, _currentUserMock.Object, _numberServiceMock.Object);
        var command = CreateValidCreateCommand(farm.Id, farmer.Id);

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.False(result.Succeeded);
        Assert.Contains("Access Denied", result.Errors[0]);
    }

    [Fact]
    public async Task UpdateDamageReport_Fails_WhenEngineerOutsideDirectorate()
    {
        var context = CreateContext();
        var myDirectorateId = Guid.NewGuid();
        var otherDirectorateId = Guid.NewGuid();

        _currentUserMock.Setup(x => x.IsInRole(AppRoles.AgriculturalEngineer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(myDirectorateId);

        var report = new DamageReport
        {
            Id = Guid.NewGuid(),
            FarmId = Guid.NewGuid(),
            StatusId = DamageReportStatus.Draft,
            RowVersion = new byte[] { 1, 2, 3 },
            DirectorateId = otherDirectorateId
        };
        // We'll rely on the Farm join for now if the field isn't there,
        // but the plan says we add it.
        // Since we are in Phase 1, we write tests that will fail.

        context.DamageReports.Add(report);
        await context.SaveChangesAsync();

        var handler = new UpdateDamageReportCommandHandler(context, _currentUserMock.Object); // Update handler now needs ICurrentUserService
        var command = new UpdateDamageReportCommand(report.Id, DateTime.UtcNow, 1, 1, null, null, Guid.NewGuid(), Guid.NewGuid(), null, null, "Notes", Convert.ToBase64String(report.RowVersion));

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.False(result.Succeeded);
        Assert.Contains("Access Denied", result.Errors[0]);
    }

    [Fact]
    public async Task DeleteDamageReport_Fails_WhenEngineerOutsideDirectorate()
    {
        var context = CreateContext();
        var myDirectorateId = Guid.NewGuid();

        _currentUserMock.Setup(x => x.IsInRole(AppRoles.AgriculturalEngineer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(myDirectorateId);

        var report = new DamageReport { Id = Guid.NewGuid() };
        context.DamageReports.Add(report);
        await context.SaveChangesAsync();

        var handler = new DeleteDamageReportCommandHandler(context, _currentUserMock.Object);
        var result = await handler.Handle(new DeleteDamageReportCommand(report.Id), CancellationToken.None);

        Assert.False(result.Succeeded);
        Assert.Contains("Access Denied", result.Errors[0]);
    }

    [Fact]
    public async Task UpdateDamageItem_Fails_WhenEngineerOutsideReportScope()
    {
        var context = CreateContext();
        var myDirectorateId = Guid.NewGuid();

        _currentUserMock.Setup(x => x.IsInRole(AppRoles.AgriculturalEngineer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(myDirectorateId);

        var report = new DamageReport { Id = Guid.NewGuid() };
        var item = new DamageItem { Id = Guid.NewGuid(), DamageReportId = report.Id, RowVersion = new byte[] { 1 } };
        context.DamageReports.Add(report);
        context.DamageItems.Add(item);
        await context.SaveChangesAsync();

        var handler = new UpdateDamageItemCommandHandler(context, _currentUserMock.Object);
        var command = new UpdateDamageItemCommand(item.Id, 1, Guid.NewGuid(), 10, "U", 1, 1, 1, 1, Convert.ToBase64String(item.RowVersion));

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.False(result.Succeeded);
        Assert.Contains("Access Denied", result.Errors[0]);
    }

    [Fact]
    public async Task UploadAttachment_Fails_WhenEngineerOutsideReportScope()
    {
        var context = CreateContext();
        var myDirectorateId = Guid.NewGuid();

        _currentUserMock.Setup(x => x.IsInRole(AppRoles.AgriculturalEngineer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(myDirectorateId);

        var report = new DamageReport { Id = Guid.NewGuid() };
        context.DamageReports.Add(report);
        await context.SaveChangesAsync();

        var handler = new UploadAttachmentCommandHandler(context, _storageServiceMock.Object, _currentUserMock.Object);
        var command = new UploadAttachmentCommand(report.Id, Guid.NewGuid(), new MemoryStream(), "file.png", "image/png", 1024, null, null, null);

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.False(result.Succeeded);
        Assert.Contains("Access Denied", result.Errors[0]);
    }

    private CreateDamageReportCommand CreateValidCreateCommand(Guid farmId, Guid farmerId)
    {
        return new CreateDamageReportCommand(
            Guid.NewGuid(), "TEMP", 2026, farmId, farmerId, DateTime.UtcNow, 1, 1, null, null, Guid.NewGuid(), Guid.NewGuid(), null, null, "", new List<CreateDamageItemInput>());
    }
}
