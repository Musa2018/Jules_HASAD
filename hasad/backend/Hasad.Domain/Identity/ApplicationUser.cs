using Microsoft.AspNetCore.Identity;

namespace Hasad.Domain.Identity;

public class ApplicationUser : IdentityUser
{
    public string FullName { get; set; } = string.Empty;
}
