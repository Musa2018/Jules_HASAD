using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.Assistances.Commands.CreateAssistance;
using Hasad.Application.Features.Assistances.Commands.ApproveAssistance;
using Hasad.Application.Features.Assistances.Commands.RecalculateAssistance;
using Hasad.Application.Features.Assistances.Queries.GetAssistanceByReportId;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using Hasad.Infrastructure.Persistence;
using Hasad.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;

namespace Hasad.Application.Tests;

public class AssistanceTests
{
    private readonly Mock<ICurrentUserService> _currentUserMock;

    public AssistanceTests()
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
    public async Task CreateAssistance_UsesActiveRule_AndCalculatesAmount()
    {
        var context = CreateContext();
        var reportId = Guid.NewGuid();
        var ruleId = Guid.NewGuid();

        context.AssistanceRules.Add(new AssistanceRule
        {
            Id = ruleId,
            Multiplier = 0.5m,
            IsActive = true,
            Name = "50% Rule"
        });

        context.DamageReports.Add(new DamageReport
        {
            Id = reportId,
            FarmId = Guid.NewGuid(), // Assuming a random farm ID for the test or create a farm
            Items = new List<DamageItem>
            {
                new DamageItem { EstimatedLoss = 1000 }
            }
        });
        await context.SaveChangesAsync();

        var service = new AssistanceService();
        var currentUserServiceMock = new Mock<ICurrentUserService>();
        currentUserServiceMock.Setup(x => x.UserName).Returns("testuser");

        var handler = new CreateAssistanceCommandHandler(context, service, currentUserServiceMock.Object);
        var command = new CreateAssistanceCommand(Guid.NewGuid(), reportId, "Test remarks");

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Equal(500, result.Data!.CalculatedAmount); // 1000 * 0.5
        Assert.Equal(AssistanceStatus.Calculated, result.Data.Status);

        var auditLog = await context.AssistanceAuditLogs.FirstOrDefaultAsync(l => l.AssistanceId == result.Data.Id);
        Assert.NotNull(auditLog);
        Assert.Equal("testuser", auditLog.ChangedBy);
    }

    [Fact]
    public async Task ApproveAssistance_Succeeds_WhenInSubmittedStatus()
    {
        var context = CreateContext();
        var compId = Guid.NewGuid();
        var assistance = new Assistance
        {
            Id = compId,
            Status = AssistanceStatus.Submitted,
            RowVersion = new byte[] { 1, 2, 3, 4 },
            CalculatedAmount = 500
        };
        context.Assistances.Add(assistance);
        await context.SaveChangesAsync();

        var currentUserServiceMock = new Mock<ICurrentUserService>();
        currentUserServiceMock.Setup(x => x.UserName).Returns("admin");

        var handler = new ApproveAssistanceCommandHandler(context, currentUserServiceMock.Object);
        var command = new ApproveAssistanceCommand(compId, 600, "Approved with adjustment", Convert.ToBase64String(assistance.RowVersion));

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Equal(AssistanceStatus.Approved, result.Data!.Status);
        Assert.Equal(600, result.Data.ApprovedAmount);
    }

    [Fact]
    public async Task ApproveAssistance_Fails_WhenInDraftStatus()
    {
        var context = CreateContext();
        var compId = Guid.NewGuid();
        var assistance = new Assistance
        {
            Id = compId,
            Status = AssistanceStatus.Draft,
            RowVersion = new byte[] { 1, 2, 3, 4 }
        };
        context.Assistances.Add(assistance);
        await context.SaveChangesAsync();

        var currentUserServiceMock = new Mock<ICurrentUserService>();
        var handler = new ApproveAssistanceCommandHandler(context, currentUserServiceMock.Object);
        var command = new ApproveAssistanceCommand(compId, 600, "Should fail", Convert.ToBase64String(assistance.RowVersion));

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.False(result.Succeeded);
        Assert.Contains("Invalid status transition", result.Errors[0]);
    }

    [Theory]
    [InlineData(AssistanceStatus.Calculated, AssistanceStatus.Approved)]
    [InlineData(AssistanceStatus.Submitted, AssistanceStatus.Draft)]
    [InlineData(AssistanceStatus.Approved, AssistanceStatus.Draft)]
    public void AssistanceStatus_InvalidTransitions_ShouldReturnFalse(string current, string next)
    {
        Assert.False(AssistanceStatus.CanTransition(current, next));
    }

    [Theory]
    [InlineData(AssistanceStatus.Draft, AssistanceStatus.Calculated)]
    [InlineData(AssistanceStatus.Calculated, AssistanceStatus.Submitted)]
    [InlineData(AssistanceStatus.Submitted, AssistanceStatus.Approved)]
    [InlineData(AssistanceStatus.Approved, AssistanceStatus.Paid)]
    public void AssistanceStatus_ValidTransitions_ShouldReturnTrue(string current, string next)
    {
        Assert.True(AssistanceStatus.CanTransition(current, next));
    }
}
