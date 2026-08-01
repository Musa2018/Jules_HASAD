using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.DamageReports.Commands.AddDamageItem;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using Moq;
using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore;
using Hasad.Infrastructure.Persistence;

namespace Hasad.Application.Tests;

public class SecurityRegressionTests
{
    [Fact]
    public async Task AddDamageItem_ShouldRestrictAccess_WhenUserInDifferentDirectorate()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        var currentUserMock = new Mock<ICurrentUserService>();
        using var context = new ApplicationDbContext(options, currentUserMock.Object);

        var reportId = Guid.NewGuid();
        var reportDirectorateId = Guid.NewGuid(); // Directorate A
        var userDirectorateId = Guid.NewGuid();   // Directorate B

        context.DamageReports.Add(new DamageReport
        {
            Id = reportId,
            StatusId = DamageReportStatus.PendingTechnicalVerification,
            DirectorateId = reportDirectorateId,
            DamageDate = DateTime.UtcNow
        });
        await context.SaveChangesAsync();

        currentUserMock.Setup(u => u.UserId).Returns("surveyor-1");
        currentUserMock.Setup(u => u.DirectorateId).Returns(userDirectorateId);
        currentUserMock.Setup(u => u.IsInRole(AppRoles.FieldSurveyor)).Returns(true);

        var loggerMock = new Mock<ILogger<AddDamageItemCommandHandler>>();
        var costingServiceMock = new Mock<ICostingService>();

        var handler = new AddDamageItemCommandHandler(context, currentUserMock.Object, costingServiceMock.Object, loggerMock.Object);

        var command = new AddDamageItemCommand(
            DamageReportId: reportId,
            ClientId: Guid.NewGuid(),
            DamageNatureId: 1,
            DamageActionId: 1,
            ClassificationId: 1,
            CostingSheetId: Guid.NewGuid(),
            CalculatedUnitPrice: 100,
            MeasurementUnitSnapshot: "Tree",
            AffectedArea: 0,
            DamagePercentage: 100,
            Quantity: 1,
            EstimatedLoss: 100
        );

        // Act
        var result = await handler.Handle(command, CancellationToken.None);

        // Assert
        Assert.False(result.Succeeded);
        Assert.Contains("Access Denied", result.Errors.First());
    }
}
