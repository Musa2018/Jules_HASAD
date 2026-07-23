using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.DamageReports.Commands.TransitionDamageReport;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using Hasad.Infrastructure.Persistence;
using Hasad.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;

namespace Hasad.Application.Tests;

public class DamageWorkflowTests
{
    private readonly Mock<ICurrentUserService> _currentUserMock;
    private readonly IDamageWorkflowService _workflowService;

    public DamageWorkflowTests()
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
    public void IsTransitionValid_EngineerCanSubmitDraft()
    {
        var context = CreateContext();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);

        var result = service.IsTransitionValid("Draft", "Submitted", AppRoles.AgriculturalEngineer);

        Assert.True(result);
    }

    [Fact]
    public void IsTransitionValid_FarmerCannotSubmit()
    {
        var context = CreateContext();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);

        var result = service.IsTransitionValid("Draft", "Submitted", AppRoles.Farmer);

        Assert.False(result);
    }

    [Fact]
    public async Task TransitionAsync_CreatesHistoryRecord()
    {
        var context = CreateContext();
        _currentUserMock.Setup(x => x.UserId).Returns("user-1");
        var service = new DamageWorkflowService(context, _currentUserMock.Object);

        var report = new DamageReport { Id = Guid.NewGuid(), StatusId = "Draft", GovernorateId = Guid.NewGuid(), DirectorateId = Guid.NewGuid(), LocalityId = Guid.NewGuid() };
        context.DamageReports.Add(report);
        await context.SaveChangesAsync();

        await service.TransitionAsync(report, "Submitted", "Test Comment");
        await context.SaveChangesAsync();

        var history = await context.DamageWorkflowHistories.FirstOrDefaultAsync();
        Assert.NotNull(history);
        Assert.Equal("Draft", history.FromStatus);
        Assert.Equal("Submitted", history.ToStatus);
        Assert.Equal("Test Comment", history.Comment);
        Assert.Equal("user-1", history.ChangedByUserId);
        Assert.Equal("Submitted", report.StatusId);
    }

    [Fact]
    public async Task Handle_TransitionCommand_FailsIfInvalidTransition()
    {
        var context = CreateContext();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);
        var handler = new TransitionDamageReportCommandHandler(context, service, _currentUserMock.Object);

        var reportId = Guid.NewGuid();
        context.DamageReports.Add(new DamageReport { Id = reportId, StatusId = "Draft", GovernorateId = Guid.NewGuid(), DirectorateId = Guid.NewGuid(), LocalityId = Guid.NewGuid() });
        await context.SaveChangesAsync();

        _currentUserMock.Setup(x => x.IsInRole(It.IsAny<string>())).Returns(false);
        _currentUserMock.Setup(x => x.IsInRole(AppRoles.AgriculturalEngineer)).Returns(true);

        // Engineer cannot move from Draft to Approved directly
        var command = new TransitionDamageReportCommand(reportId, "Approved");

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.False(result.Succeeded);
        Assert.Contains("Invalid transition", result.Errors[0]);
    }

    [Fact]
    public async Task Handle_TransitionCommand_SucceedsForGMOverride()
    {
        var context = CreateContext();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);
        var handler = new TransitionDamageReportCommandHandler(context, service, _currentUserMock.Object);

        var reportId = Guid.NewGuid();
        context.DamageReports.Add(new DamageReport { Id = reportId, StatusId = "Draft", GovernorateId = Guid.NewGuid(), DirectorateId = Guid.NewGuid(), LocalityId = Guid.NewGuid() });
        await context.SaveChangesAsync();

        _currentUserMock.Setup(x => x.IsInRole(AppRoles.GeneralManager)).Returns(true);

        var command = new TransitionDamageReportCommand(reportId, "Approved", "GM Override", true);

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        var report = await context.DamageReports.FindAsync(reportId);
        Assert.Equal("Approved", report!.StatusId);

        var history = await context.DamageWorkflowHistories.FirstAsync();
        Assert.True(history.IsOverride);
    }
}
