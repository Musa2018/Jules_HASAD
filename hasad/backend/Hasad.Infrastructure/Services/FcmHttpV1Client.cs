using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using Google.Apis.Auth.OAuth2;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Options;
using Microsoft.Extensions.Options;
using Serilog;

namespace Hasad.Infrastructure.Services;

public class FcmHttpV1Client : IFcmHttpV1Client
{
    private readonly HttpClient _httpClient;
    private readonly FcmOptions _options;
    private GoogleCredential? _credential;

    public FcmHttpV1Client(HttpClient httpClient, IOptions<PushNotificationOptions> options)
    {
        _httpClient = httpClient;
        _options = options.Value.Fcm;
    }

    private async Task<string> GetAccessTokenAsync()
    {
        if (_credential == null)
        {
            _credential = GoogleCredential.FromJson(_options.ServiceAccountJson)
                .CreateScoped("https://www.googleapis.com/auth/firebase.messaging");
        }

        return await _credential.UnderlyingCredential.GetAccessTokenForRequestAsync();
    }

    public async Task SendRawPushV1Async(string deviceToken, string title, string body, string? payloadJson)
    {
        try
        {
            var accessToken = await GetAccessTokenAsync();
            var url = $"https://fcm.googleapis.com/v1/projects/{_options.ProjectId}/messages:send";

            var message = new
            {
                message = new
                {
                    token = deviceToken,
                    notification = new { title, body },
                    data = string.IsNullOrEmpty(payloadJson)
                        ? new Dictionary<string, string>()
                        : JsonSerializer.Deserialize<Dictionary<string, string>>(payloadJson)
                }
            };

            var request = new HttpRequestMessage(HttpMethod.Post, url);
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            request.Content = new StringContent(JsonSerializer.Serialize(message), Encoding.UTF8, "application/json");

            var response = await _httpClient.SendAsync(request);
            if (!response.IsSuccessStatusCode)
            {
                var error = await response.Content.ReadAsStringAsync();
                Log.Error("FCM Push failed for token {Token}: {Error}", deviceToken, error);
            }
        }
        catch (Exception ex)
        {
            Log.Error(ex, "Exception during FCM Push to {Token}", deviceToken);
        }
    }
}
