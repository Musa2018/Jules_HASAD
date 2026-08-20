using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.DamageReports.Commands.TransitionDamageReport;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using Hasad.Infrastructure.Persistence;
using Hasad.Infrastructure.Persistence.Seed;
using Hasad.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;

namespace Hasad.Application.Tests;

public class DamageWorkflowTests
{
    private readonly Mock<ICurrentUserService> _currentUserMock;

    public DamageWorkflowTests()
    {
        _currentUserMock = new Mock<ICurrentUserService>();
    }

    private async Task<ApplicationDbContext> CreateContextAsync()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        var context = new ApplicationDbContext(options, _currentUserMock.Object);
        await DbInitializer.SeedWorkflowDataAsync(context);
        return context;
    }

    [Fact]
    public async Task IsTransitionValid_EngineerCanSubmitDraft()
    {
        var context = await CreateContextAsync();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);

        var result = await service.IsTransitionValidAsync(DamageReportStatus.Draft, DamageReportStatus.TechReview, AppRoles.AgriculturalEngineer);

        Assert.True(result);
    }

    [Fact]
    public async Task IsTransitionValid_LegalReviewer_CanMoveToMinArchive()
    {
        var context = await CreateContextAsync();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);

        // In new workflow: LegalReview -> MinArchive
        var result = await service.IsTransitionValidAsync(DamageReportStatus.LegalReview, DamageReportStatus.MinArchive, AppRoles.LegalReviewer);

        Assert.True(result);
    }

    [Fact]
    public async Task CanTransition_Fails_WhenReturningWithoutComment()
    {
        var context = await CreateContextAsync();
        var directorateId = Guid.NewGuid();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);

        _currentUserMock.Setup(x => x.UserId).Returns("user1");
        _currentUserMock.Setup(x => x.IsInRole(AppRoles.TechnicalReviewer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(directorateId);

        var report = new DamageReport
        {
            StatusId = DamageReportStatus.TechReview,
            DirectorateId = directorateId
        };

        // Attempting to return TechReview -> Draft without comment
        var result = await service.CanTransitionAsync(report, DamageReportStatus.Draft, null);

        Assert.False(result);
    }

    [Fact]
    public async Task CanTransition_Succeeds_WhenReturningWithComment()
    {
        var context = await CreateContextAsync();
        var directorateId = Guid.NewGuid();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);

        _currentUserMock.Setup(x => x.UserId).Returns("user1");
        _currentUserMock.Setup(x => x.IsInRole(AppRoles.TechnicalReviewer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(directorateId);

        var report = new DamageReport
        {
            StatusId = DamageReportStatus.TechReview,
            DirectorateId = directorateId
        };

        var result = await service.CanTransitionAsync(report, DamageReportStatus.Draft, "Correction needed");

        Assert.True(result);
    }

    [Fact]
    public async Task CanTransition_Fails_WhenOutsideScope()
    {
        var context = await CreateContextAsync();
        var myDirectorateId = Guid.NewGuid();
        var otherDirectorateId = Guid.NewGuid();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);

        _currentUserMock.Setup(x => x.UserId).Returns("user1");
        _currentUserMock.Setup(x => x.IsInRole(AppRoles.TechnicalReviewer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(myDirectorateId);

        var report = new DamageReport
        {
            StatusId = DamageReportStatus.TechReview,
            DirectorateId = otherDirectorateId
        };

        // Even with valid role, scope mismatch should fail
        var result = await service.CanTransitionAsync(report, DamageReportStatus.ArchiveDir, null);

        Assert.False(result);
    }

    [Fact]
    public async Task Handle_TransitionCommand_SucceedsWithoutFarmNavigation()
    {
        var context = await CreateContextAsync();
        var directorateId = Guid.NewGuid();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);
        var pdfMock = new Mock<IPDFService>();
        var storageMock = new Mock<IFileStorageService>();
        var notifyMock = new Mock<INotificationService>();

        var handler = new TransitionDamageReportCommandHandler(context, service, _currentUserMock.Object, pdfMock.Object, storageMock.Object, notifyMock.Object);

        _currentUserMock.Setup(x => x.UserId).Returns("eng1");
        _currentUserMock.Setup(x => x.IsInRole(AppRoles.AgriculturalEngineer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(directorateId);

        var farm = new Farm { Id = Guid.NewGuid(), LocalFarmName = "Test Farm", DirectorateId = directorateId };
        context.Farms.Add(farm);

        var report = new DamageReport
        {
            Id = Guid.NewGuid(),
            StatusId = DamageReportStatus.Draft,
            ReportNumber = "REP-001",
            DirectorateId = directorateId,
            GovernorateId = Guid.NewGuid(),
            FarmId = farm.Id,
            Items = new List<DamageItem> { new DamageItem { Id = Guid.NewGuid(), EstimatedLoss = 100, Quantity = 1 } }
        };
        context.DamageReports.Add(report);
        await context.SaveChangesAsync();

        context.ChangeTracker.Clear();

        var command = new TransitionDamageReportCommand(report.Id, DamageReportStatus.TechReview);

        var result = await handler.Handle(command, CancellationToken.None);

        if (!result.Succeeded)
        {
            throw new Exception("Transition failed: " + string.Join(", ", result.Errors));
        }

        Assert.True(result.Succeeded);
        var updatedReport = await context.DamageReports.FindAsync(report.Id);
        Assert.Equal(DamageReportStatus.TechReview, updatedReport!.StatusId);
    }

    [Fact]
    public async Task CanTransition_Succeeds_WhenDirectorateMatches()
    {
        var context = await CreateContextAsync();
        var directorateId = Guid.NewGuid();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);

        _currentUserMock.Setup(x => x.UserId).Returns("user1");
        _currentUserMock.Setup(x => x.IsInRole(AppRoles.TechnicalReviewer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(directorateId);

        var report = new DamageReport
        {
            StatusId = DamageReportStatus.TechReview,
            DirectorateId = directorateId
        };

        var result = await service.CanTransitionAsync(report, DamageReportStatus.ArchiveDir, null);

        Assert.True(result);
    }
}
