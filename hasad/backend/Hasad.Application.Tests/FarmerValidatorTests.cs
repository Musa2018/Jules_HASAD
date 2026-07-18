using Hasad.Application.Features.Farmers.Commands.CreateFarmer;
using Hasad.Application.Features.Farmers.Commands.UpdateFarmer;
using Hasad.Domain.Enums;
using Xunit;

namespace Hasad.Application.Tests;

public class FarmerValidatorTests
{
    [Fact]
    public void CreateFarmerValidator_Fails_WhenClientIdIsEmpty()
    {
        var validator = new CreateFarmerCommandValidator();
        var command = new CreateFarmerCommand(
            Guid.Empty,
            1,
            "123456789",
            "أحمد", "محمد", "علي", "محمود",
            "", "", "", "",
            new DateOnly(1985, 1, 1),
            Gender.Male,
            "0599123456",
            5,
            "GOV-1",
            "LOC-1",
            "Address");

        var result = validator.Validate(command);

        Assert.False(result.IsValid);
        Assert.Contains(result.Errors, e => e.PropertyName == "ClientId");
    }

    [Fact]
    public void UpdateFarmerValidator_Fails_WhenRowVersionIsEmpty()
    {
        var validator = new UpdateFarmerCommandValidator();
        var command = new UpdateFarmerCommand(
            Guid.NewGuid(),
            Guid.NewGuid(),
            1,
            "123456789",
            "أحمد", "محمد", "علي", "محمود",
            "", "", "", "",
            new DateOnly(1985, 1, 1),
            Gender.Male,
            "0599123456",
            5,
            "GOV-1",
            "LOC-1",
            "Address",
            "");

        var result = validator.Validate(command);

        Assert.False(result.IsValid);
        Assert.Contains(result.Errors, e => e.PropertyName == "RowVersion");
    }
}
