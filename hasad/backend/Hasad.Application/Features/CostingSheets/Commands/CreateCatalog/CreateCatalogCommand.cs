using FluentValidation;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using Hasad.Domain.Constants;
using Hasad.Domain.Entities;
using MediatR;

namespace Hasad.Application.Features.CostingSheets.Commands.CreateCatalog;

public record CreateCatalogCommand(string Name, string? Description) : IRequest<Result<Guid>>;

public class CreateCatalogCommandHandler : IRequestHandler<CreateCatalogCommand, Result<Guid>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public CreateCatalogCommandHandler(IApplicationDbContext context, ICurrentUserService currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<Guid>> Handle(CreateCatalogCommand request, CancellationToken cancellationToken)
    {
        if (!_currentUser.IsInRole(AppRoles.SuperAdmin) && !_currentUser.IsInRole(AppRoles.Administrator))
        {
            return Result<Guid>.Failure(new[] { "Access Denied: Only administrators can create pricing catalogs." });
        }

        var catalog = new CostingSheetCatalog
        {
            Id = Guid.NewGuid(),
            Name = request.Name,
            Description = request.Description,
            CreatedAt = DateTime.UtcNow,
            CreatedBy = _currentUser.UserId ?? "System"
        };

        _context.CostingSheetCatalogs.Add(catalog);
        await _context.SaveChangesAsync(cancellationToken);

        return Result<Guid>.Success(catalog.Id);
    }
}

public class CreateCatalogCommandValidator : AbstractValidator<CreateCatalogCommand>
{
    public CreateCatalogCommandValidator()
    {
        RuleFor(v => v.Name).NotEmpty().MaximumLength(200);
    }
}
