using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Application.Features.DamageReports.Commands.AddDamageItem;
using Hasad.Domain.Entities;
using Moq;
using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore;
using Hasad.Infrastructure.Persistence;
using Hasad.Application.Features.DamageReports.Models;

namespace Hasad.Application.Tests;

public class ValuationSecurityTests
{
    [Fact]
    public async Task AddDamageItem_ShouldIgnoreClientValues_AndRecalculateAuthoritatively()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        var currentUserMock = new Mock<ICurrentUserService>();
        using var context = new ApplicationDbContext(options, currentUserMock.Object);

        var reportId = Guid.NewGuid();
        var directorateId = Guid.NewGuid();

        context.DamageReports.Add(new DamageReport
        {
            Id = reportId,
            StatusId = "PendingTechnicalVerification",
            DirectorateId = directorateId,
            DamageDate = DateTime.UtcNow
        });
        await context.SaveChangesAsync();

        currentUserMock.Setup(u => u.UserId).Returns("surveyor-1");
        currentUserMock.Setup(u => u.IsInRole(It.IsAny<string>())).Returns(false); // Admin/Manager logic

        var loggerMock = new Mock<ILogger<AddDamageItemCommandHandler>>();

        var costingServiceMock = new Mock<ICostingService>();
        decimal authoritativePrice = 150m;
        costingServiceMock.Setup(s => s.GetUnitPriceAsync(It.IsAny<int>(), It.IsAny<Guid>(), It.IsAny<DateTime>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(Result<decimal>.Success(authoritativePrice));

        var handler = new AddDamageItemCommandHandler(context, currentUserMock.Object, costingServiceMock.Object, loggerMock.Object);

        var maliciousCommand = new AddDamageItemCommand(
            DamageReportId: reportId,
            ClientId: Guid.NewGuid(),
            DamageNatureId: 1,
            DamageActionId: 1,
            ClassificationId: 1,
            CostingSheetId: Guid.NewGuid(),
            CalculatedUnitPrice: 999999m, // MALICIOUS
            MeasurementUnitSnapshot: "Tree",
            AffectedArea: 0,
            DamagePercentage: 50,
            Quantity: 10,
            EstimatedLoss: 8888888m // MALICIOUS
        );

        // Act
        var result = await handler.Handle(maliciousCommand, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.NotNull(result.Data);

        // Backend should recalculate: 10 * 150 * (50/100) = 750
        decimal expectedLoss = 10 * authoritativePrice * 0.5m;

        Assert.Equal(authoritativePrice, result.Data.CalculatedUnitPrice);
        Assert.Equal(expectedLoss, result.Data.EstimatedLoss);

        var savedItem = await context.DamageItems.FirstAsync(i => i.ClientId == maliciousCommand.ClientId);
        Assert.Equal(authoritativePrice, savedItem.CalculatedUnitPrice);
        Assert.Equal(expectedLoss, savedItem.EstimatedLoss);
    }
}
