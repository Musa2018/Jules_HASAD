using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.ReferenceData.Queries.GetReferenceData;
using Hasad.Domain.Entities;
using Hasad.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace Hasad.Application.Tests;

public class ReferenceDataTests
{
    private readonly ApplicationDbContext _context;
    private readonly Mock<ICurrentUserService> _currentUserMock;

    public ReferenceDataTests()
    {
        _currentUserMock = new Mock<ICurrentUserService>();
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        _context = new ApplicationDbContext(options, _currentUserMock.Object);
    }

    [Fact]
    public async Task GetReferenceData_ReturnsAllLookupDatasets()
    {
        // Arrange
        _context.OwnershipTypes.Add(new OwnershipType { Id = 1, NameAr = "ملك", NameEn = "Owned" });
        _context.AgriculturalSectors.Add(new AgriculturalSector { Id = 1, NameAr = "نباتي", NameEn = "Plant" });
        _context.PoliticalClassifications.Add(new PoliticalClassification { Id = 1, NameAr = "A", NameEn = "A" });
        _context.MeasurementUnits.Add(new MeasurementUnit { Id = 1, NameAr = "دونم", NameEn = "Dunum", Category = "Area" });
        _context.RelationshipToOwners.Add(new RelationshipToOwner { Id = 1, NameAr = "المالك نفسه", NameEn = "Owner Himself" });
        await _context.SaveChangesAsync();

        var handler = new GetReferenceDataQueryHandler(_context);

        // Act
        var result = await handler.Handle(new GetReferenceDataQuery(), CancellationToken.None);

        // Assert
        Assert.NotNull(result);
        Assert.Single(result.OwnershipTypes);
        Assert.Single(result.AgriculturalSectors);
        Assert.Single(result.PoliticalClassifications);
        Assert.Single(result.AreaUnits);
        Assert.Single(result.RelationshipToOwners);

        Assert.Equal("Owned", result.OwnershipTypes[0].NameEn);
        Assert.Equal("Plant", result.AgriculturalSectors[0].NameEn);
        Assert.Equal("A", result.PoliticalClassifications[0].NameEn);
        Assert.Equal("Dunum", result.AreaUnits[0].NameEn);
        Assert.Equal("Area", result.AreaUnits[0].Category);
        Assert.Equal("Owner Himself", result.RelationshipToOwners[0].NameEn);
    }
}
