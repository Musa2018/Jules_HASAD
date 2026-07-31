using FluentAssertions;
using Hasad.Application.Features.DamageReports.Commands.AddDamageItem;
using Xunit;

namespace Hasad.Application.Tests;

public class AddDamageItemCommandTests
{
    private readonly AddDamageItemCommandValidator _validator = new();

    [Fact]
    public void Validator_ShouldRejectEmptyIds()
    {
        var command = new AddDamageItemCommand(
            Guid.Empty,
            Guid.Empty,
            0,
            0,
            0,
            Guid.Empty,
            0,
            "",
            0,
            0,
            0,
            0);

        var result = _validator.Validate(command);

        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == nameof(AddDamageItemCommand.DamageReportId));
        result.Errors.Should().Contain(e => e.PropertyName == nameof(AddDamageItemCommand.ClientId));
        result.Errors.Should().Contain(e => e.PropertyName == nameof(AddDamageItemCommand.DamageNatureId));
        result.Errors.Should().Contain(e => e.PropertyName == nameof(AddDamageItemCommand.DamageActionId));
        result.Errors.Should().Contain(e => e.PropertyName == nameof(AddDamageItemCommand.ClassificationId));
        result.Errors.Should().Contain(e => e.PropertyName == nameof(AddDamageItemCommand.CostingSheetId));
    }

    [Fact]
    public void Validator_ShouldRejectInvalidValuation()
    {
        var command = new AddDamageItemCommand(
            Guid.NewGuid(),
            Guid.NewGuid(),
            1,
            1,
            1,
            Guid.NewGuid(),
            -1, // CalculatedUnitPrice
            "Tree",
            10,
            110, // DamagePercentage > 100
            5,
            -50); // EstimatedLoss

        var result = _validator.Validate(command);

        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == nameof(AddDamageItemCommand.CalculatedUnitPrice));
        result.Errors.Should().Contain(e => e.PropertyName == nameof(AddDamageItemCommand.DamagePercentage));
        result.Errors.Should().Contain(e => e.PropertyName == nameof(AddDamageItemCommand.EstimatedLoss));
    }

    [Fact]
    public void Validator_ShouldAcceptValidCommand()
    {
        var command = new AddDamageItemCommand(
            Guid.NewGuid(),
            Guid.NewGuid(),
            1,
            1,
            1,
            Guid.NewGuid(),
            100,
            "Tree",
            10,
            50,
            5,
            500);

        var result = _validator.Validate(command);

        result.IsValid.Should().BeTrue();
    }
}
