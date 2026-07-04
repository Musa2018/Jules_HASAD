using Microsoft.AspNetCore.Identity;

namespace Hasad.Infrastructure.Identity;

public class ApplicationUser : IdentityUser
{
    public string FullName { get; set; } = string.Empty;
}
