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
        // تمرير المتغيرات الجديدة بما يتوافق مع هيكل Command الجديد
        var command = new CreateFarmerCommand(
            Guid.Empty, // هذا هو الحقل الذي سيؤدي لفشل التحقق وهو المطلوب اختباره
            1,
            "123456789",
            "أحمد", "محمد", "علي", "محمود",
            "", "", "", "",
            new DateOnly(1985, 1, 1),
            "0599123456",
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
            "0599123456",
            "GOV-1",
            "LOC-1",
            "Address",
            ""); // هذا هو الحقل الفارغ (RowVersion) الذي سيؤدي لفشل التحقق

        var result = validator.Validate(command);

        Assert.False(result.IsValid);
        Assert.Contains(result.Errors, e => e.PropertyName == "RowVersion");
    }
}