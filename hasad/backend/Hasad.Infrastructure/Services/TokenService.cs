using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Options;
using Hasad.Domain.Identity;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Identity;

namespace Hasad.Infrastructure.Services;

/// <summary>
/// Creates signed JWT access tokens using the configured <see cref="JwtOptions"/>.
/// </summary>
public class TokenService : ITokenService
{
    private readonly JwtOptions _options;

    /// <summary>Initializes the service.</summary>
    public TokenService(IOptions<JwtOptions> options)
    {
        _options = options.Value;
    }

    /// <inheritdoc />
    public string CreateAccessToken(ApplicationUser user, IEnumerable<string> roles, IEnumerable<Claim>? additionalClaims = null)
    {
        var key = Encoding.UTF8.GetBytes(_options.Key);

        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, user.Id),
            new(ClaimTypes.Name, user.UserName!),
            new(ClaimTypes.Email, user.Email!),
            new("FullName", user.FullName)
        };

        if (user.GovernorateId.HasValue)
        {
            claims.Add(new Claim("governorate_id", user.GovernorateId.Value.ToString()));
        }

        if (user.DirectorateId.HasValue)
        {
            claims.Add(new Claim("directorate_id", user.DirectorateId.Value.ToString()));
        }

        if (additionalClaims != null)
        {
            claims.AddRange(additionalClaims);
        }

        foreach (var role in roles)
        {
            claims.Add(new Claim(ClaimTypes.Role, role));
            claims.Add(new Claim("role", role)); // Add lowercase 'role' for some client libraries

            if (role == "SuperAdmin")
            {
                // Explicitly ensure SuperAdminScope is present in the token regardless of DB state
                if (claims.All(c => c.Type != "SuperAdminScope"))
                {
                    claims.Add(new Claim("SuperAdminScope", "GlobalAccess"));
                }

                // Add an explicit 'is_superadmin' boolean claim for easier JS/Blazor checks
                claims.Add(new Claim("is_superadmin", "true"));
            }
        }

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Issuer = _options.Issuer,
            Audience = _options.Audience,
            Expires = DateTime.UtcNow.AddMinutes(_options.AccessTokenMinutes),
            SigningCredentials = new SigningCredentials(
                new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };

        var tokenHandler = new JwtSecurityTokenHandler();
        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}
