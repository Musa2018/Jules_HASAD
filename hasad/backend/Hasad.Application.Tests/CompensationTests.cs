using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.Compensations.Commands.CreateCompensation;
using Hasad.Application.Features.Compensations.Queries.GetCompensationByReportId;
using Hasad.Domain.Entities;
using Hasad.Infrastructure.Persistence;
using Hasad.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace Hasad.Application.Tests;

public class CompensationTests
{
    private ApplicationDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        return new ApplicationDbContext(options);
    }

    [Fact]
    public async Task CreateCompensation_Succeeds_AndCalculatesAmount()
    {
        var context = CreateContext();
        var reportId = Guid.NewGuid();
        context.DamageReports.Add(new DamageReport
        {
            Id = reportId,
            Items = new List<DamageItem>
            {
                new DamageItem { EstimatedLoss = 1000 }
            }
        });
        await context.SaveChangesAsync();

        var service = new CompensationService();
        var handler = new CreateCompensationCommandHandler(context, service);
        var command = new CreateCompensationCommand(Guid.NewGuid(), reportId, "Test remarks");

        var result = await handler.Handle(command, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Equal(800, result.Data!.CalculatedAmount); // 1000 * 0.8
        Assert.Equal("Calculated", result.Data.Status);
    }

    [Fact]
    public async Task GetCompensationByReportId_ReturnsNull_WhenNotExists()
    {
        var context = CreateContext();
        var handler = new GetCompensationByReportIdQueryHandler(context);
        var query = new GetCompensationByReportIdQuery(Guid.NewGuid());

        var result = await handler.Handle(query, CancellationToken.None);

        Assert.True(result.Succeeded);
        Assert.Null(result.Data);
    }
}
