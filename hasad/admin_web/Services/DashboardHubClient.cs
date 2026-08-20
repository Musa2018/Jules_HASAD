using Microsoft.AspNetCore.SignalR.Client;
using Microsoft.Extensions.Configuration;
using Blazored.LocalStorage;

namespace Hasad.AdminWeb.Services;

public class DashboardHubClient : IAsyncDisposable
{
    private HubConnection? _hubConnection;
    private readonly ILocalStorageService _localStorage;
    private readonly string _hubUrl;

    public event Action<dynamic>? OnMetricUpdated;

    public DashboardHubClient(ILocalStorageService localStorage, IConfiguration configuration)
    {
        _localStorage = localStorage;
        var baseUrl = configuration["ApiBaseUrl"] ?? "";
        _hubUrl = baseUrl.TrimEnd('/') + "/hubs/admin-dashboard";
    }

    public async Task StartAsync()
    {
        if (_hubConnection != null) return;

        _hubConnection = new HubConnectionBuilder()
            .WithUrl(_hubUrl, options =>
            {
                options.AccessTokenProvider = async () =>
                {
                    var token = await _localStorage.GetItemAsync<string>("authToken");
                    return token?.Trim('"');
                };
            })
            .WithAutomaticReconnect()
            .Build();

        _hubConnection.On<dynamic>("OnMetricUpdated", (metric) =>
        {
            OnMetricUpdated?.Invoke(metric);
        });

        try
        {
            var token = await _localStorage.GetItemAsync<string>("authToken");
            if (string.IsNullOrEmpty(token))
            {
                throw new InvalidOperationException("No authentication token found.");
            }

            await _hubConnection.StartAsync();
            await _hubConnection.InvokeAsync("JoinLiveMonitoringGroup");
        }
        catch (Exception e)
        {
            Console.WriteLine($"SignalR Start Error: {e.Message}");
            throw;
        }
    }

    public bool IsConnected => _hubConnection?.State == HubConnectionState.Connected;

    public async ValueTask DisposeAsync()
    {
        if (_hubConnection != null)
        {
            await _hubConnection.DisposeAsync();
        }
    }
}
