using Hasad.Application.Features.Farmers.Commands.CreateFarmer;
using Hasad.Application.Features.Farmers.Commands.UpdateFarmer;
using Xunit;

namespace Hasad.Application.Tests;

public class FarmerValidatorTests
{
    [Fact]
    public void CreateFarmerValidator_Fails_WhenClientIdIsEmpty()
    {
        var validator = new CreateFarmerCommandValidator();
        var command = new CreateFarmerCommand(Guid.Empty, "Name", "123", "123", "Address");

        var result = validator.Validate(command);

        Assert.False(result.IsValid);
        Assert.Contains(result.Errors, e => e.PropertyName == "ClientId");
    }

    [Fact]
    public void UpdateFarmerValidator_Fails_WhenRowVersionIsEmpty()
    {
        var validator = new UpdateFarmerCommandValidator();
        var command = new UpdateFarmerCommand(Guid.NewGuid(), Guid.NewGuid(), "Name", "123", "123", "Address", "");

        var result = validator.Validate(command);

        Assert.False(result.IsValid);
        Assert.Contains(result.Errors, e => e.PropertyName == "RowVersion");
    }
}
