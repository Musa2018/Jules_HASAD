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

        var result = service.IsTransitionValid(DamageReportStatus.Draft, DamageReportStatus.TechReview, AppRoles.AgriculturalEngineer);

        Assert.True(result);
    }

    [Fact]
    public void IsTransitionValid_LegalReviewer_CanMoveToProcReview()
    {
        var context = CreateContext();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);

        var result = service.IsTransitionValid(DamageReportStatus.LegalReview, DamageReportStatus.ProcReview, AppRoles.LegalReviewer);

        Assert.True(result);
    }

    [Fact]
    public void CanTransition_Fails_WhenReturningWithoutComment()
    {
        var context = CreateContext();
        var directorateId = Guid.NewGuid();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);

        _currentUserMock.Setup(x => x.UserId).Returns("user1");
        _currentUserMock.Setup(x => x.IsInRole(AppRoles.TechnicalReviewer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(directorateId);

        var report = new DamageReport
        {
            StatusId = DamageReportStatus.TechReview,
            Farm = new Farm { DirectorateId = directorateId }
        };

        // Attempting to return TechReview -> Draft without comment
        var result = service.CanTransition(report, DamageReportStatus.Draft, null);

        Assert.False(result);
    }

    [Fact]
    public void CanTransition_Succeeds_WhenReturningWithComment()
    {
        var context = CreateContext();
        var directorateId = Guid.NewGuid();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);

        _currentUserMock.Setup(x => x.UserId).Returns("user1");
        _currentUserMock.Setup(x => x.IsInRole(AppRoles.TechnicalReviewer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(directorateId);

        var report = new DamageReport
        {
            StatusId = DamageReportStatus.TechReview,
            Farm = new Farm { DirectorateId = directorateId }
        };

        var result = service.CanTransition(report, DamageReportStatus.Draft, "Correction needed");

        Assert.True(result);
    }

    [Fact]
    public void CanTransition_Fails_WhenOutsideScope()
    {
        var context = CreateContext();
        var myDirectorateId = Guid.NewGuid();
        var otherDirectorateId = Guid.NewGuid();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);

        _currentUserMock.Setup(x => x.UserId).Returns("user1");
        _currentUserMock.Setup(x => x.IsInRole(AppRoles.TechnicalReviewer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(myDirectorateId);

        var report = new DamageReport
        {
            StatusId = DamageReportStatus.TechReview,
            Farm = new Farm { DirectorateId = otherDirectorateId }
        };

        var result = service.CanTransition(report, DamageReportStatus.ArchiveDir, null);

        Assert.False(result);
    }

    [Fact]
    public async Task Handle_TransitionCommand_SucceedsForValidFlow()
    {
        var context = CreateContext();
        var directorateId = Guid.NewGuid();
        var service = new DamageWorkflowService(context, _currentUserMock.Object);
        var handler = new TransitionDamageReportCommandHandler(context, service, _currentUserMock.Object);

        _currentUserMock.Setup(x => x.UserId).Returns("eng1");
        _currentUserMock.Setup(x => x.IsInRole(AppRoles.AgriculturalEngineer)).Returns(true);
        _currentUserMock.Setup(x => x.DirectorateId).Returns(directorateId);

        var report = new DamageReport
        {
            Id = Guid.NewGuid(),
            StatusId = DamageReportStatus.Draft,
            Farm = new Farm
            {
                DirectorateId = directorateId,
                GovernorateId = Guid.NewGuid(),
                LocalityId = Guid.NewGuid()
            }
        };
        context.DamageReports.Add(report);
        await context.SaveChangesAsync();

        var command = new TransitionDamageReportCommand(report.Id, DamageReportStatus.TechReview);

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        var updatedReport = await context.DamageReports.FindAsync(report.Id);
        Assert.Equal(DamageReportStatus.TechReview, updatedReport!.StatusId);
    }
}
