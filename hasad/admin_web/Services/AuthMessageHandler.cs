using System.Net.Http.Headers;
using Blazored.LocalStorage;

namespace Hasad.AdminWeb.Services;

public class AuthMessageHandler : DelegatingHandler
{
    private readonly ILocalStorageService _localStorage;

    public AuthMessageHandler(ILocalStorageService localStorage)
    {
        _localStorage = localStorage;
    }

    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
    {
        var token = await _localStorage.GetItemAsync<string>("authToken");

        if (!string.IsNullOrWhiteSpace(token))
        {
            // Clean the token (remove quotes if present)
            var cleanToken = token.Trim('"').Trim();
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", cleanToken);
        }

        return await base.SendAsync(request, cancellationToken);
    }
}
