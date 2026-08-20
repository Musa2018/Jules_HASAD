using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Options;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Serilog;

namespace Hasad.Infrastructure.Services;

public class ApnsService : IApnsService
{
    private readonly HttpClient _httpClient;
    private readonly ApnsOptions _options;
    private string? _cachedToken;
    private DateTime _tokenExpiration;

    public ApnsService(HttpClient httpClient, IOptions<PushNotificationOptions> options)
    {
        _httpClient = httpClient;
        _options = options.Value.Apns;
    }

    private string GetJwtToken()
    {
        if (_cachedToken != null && DateTime.UtcNow < _tokenExpiration)
        {
            return _cachedToken;
        }

        var privateKeyBase64 = _options.PrivateKey
            .Replace("-----BEGIN PRIVATE KEY-----", "")
            .Replace("-----END PRIVATE KEY-----", "")
            .Replace("\n", "")
            .Replace("\r", "")
            .Trim();

        using var dsa = ECDsa.Create();
        dsa.ImportPkcs8PrivateKey(Convert.FromBase64String(privateKeyBase64), out _);

        var securityKey = new ECDsaSecurityKey(dsa) { KeyId = _options.KeyId };
        var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.EcdsaSha256);

        var header = new { alg = "ES256", kid = _options.KeyId };
        var payload = new
        {
            iss = _options.TeamId,
            iat = DateTimeOffset.UtcNow.ToUnixTimeSeconds()
        };

        var handler = new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler();
        var token = handler.CreateToken(new SecurityTokenDescriptor
        {
            Issuer = _options.TeamId,
            IssuedAt = DateTime.UtcNow,
            SigningCredentials = credentials
        });

        _cachedToken = handler.WriteToken(token);
        _tokenExpiration = DateTime.UtcNow.AddMinutes(50); // APNs tokens are valid for 1 hour

        return _cachedToken;
    }

    public async Task SendDirectPushAsync(string deviceToken, string title, string body, string? payloadJson)
    {
        try
        {
            var jwt = GetJwtToken();
            var baseUrl = _options.UseSandbox
                ? "https://api.sandbox.push.apple.com"
                : "https://api.push.apple.com";

            var url = $"{baseUrl}/3/device/{deviceToken}";

            var apnsPayload = new
            {
                aps = new
                {
                    alert = new { title, body },
                    sound = "default",
                    badge = 1
                },
                custom = string.IsNullOrEmpty(payloadJson)
                    ? null
                    : JsonSerializer.Deserialize<object>(payloadJson)
            };

            var request = new HttpRequestMessage(HttpMethod.Post, url);
            request.Version = new Version(2, 0); // Force HTTP/2
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", jwt);
            request.Headers.Add("apns-topic", _options.BundleId);
            request.Headers.Add("apns-priority", "10");
            request.Headers.Add("apns-push-type", "alert");

            request.Content = new StringContent(JsonSerializer.Serialize(apnsPayload), Encoding.UTF8, "application/json");

            var response = await _httpClient.SendAsync(request);
            if (!response.IsSuccessStatusCode)
            {
                var error = await response.Content.ReadAsStringAsync();
                Log.Error("APNs Push failed for token {Token}: {Error}", deviceToken, error);
            }
        }
        catch (Exception ex)
        {
            Log.Error(ex, "Exception during APNs Push to {Token}", deviceToken);
        }
    }
}
