using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Models;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Application.Features.DamageReports.Commands.DeleteAttachment;

public record DeleteAttachmentCommand(Guid Id) : IRequest<Result<Unit>>;

public class DeleteAttachmentCommandHandler : IRequestHandler<DeleteAttachmentCommand, Result<Unit>>
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;
    private readonly IFileStorageService _storageService;

    public DeleteAttachmentCommandHandler(IApplicationDbContext context, ICurrentUserService currentUser, IFileStorageService storageService)
    {
        _context = context;
        _currentUser = currentUser;
        _storageService = storageService;
    }

    public async Task<Result<Unit>> Handle(DeleteAttachmentCommand request, CancellationToken cancellationToken)
    {
        var attachment = await _context.DamageReportAttachments
            .FirstOrDefaultAsync(a => a.Id == request.Id, cancellationToken);

        if (attachment == null) return Result<Unit>.Failure(new[] { "Attachment not found." });

        // Logic delete (Soft delete)
        attachment.IsDeleted = true;
        attachment.DeletedAt = DateTime.UtcNow;
        attachment.DeletedBy = _currentUser.UserId;

        // Optionally delete physical file if not needed anymore
        // await _storageService.DeleteAsync(attachment.RemotePath, cancellationToken);

        await _context.SaveChangesAsync(cancellationToken);

        return Result<Unit>.Success(Unit.Value);
    }
}
