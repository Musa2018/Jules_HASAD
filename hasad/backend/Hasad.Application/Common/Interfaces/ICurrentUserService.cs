namespace Hasad.Application.Common.Interfaces;

public interface ICurrentUserService
{
    string? UserId { get; }
    string? UserName { get; }
    Guid? GovernorateId { get; }
    Guid? DirectorateId { get; }
    bool IsInRole(string role);
}
