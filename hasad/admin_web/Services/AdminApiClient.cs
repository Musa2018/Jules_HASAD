using System.Net.Http.Headers;
using System.Net.Http.Json;
using Blazored.LocalStorage;
using Hasad.Application.Features.Reporting.Models;
using Hasad.Application.Features.Accounts.Models;

namespace Hasad.AdminWeb.Services;

public class AdminApiClient
{
    private readonly HttpClient _httpClient;

    public AdminApiClient(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    public async Task<AuthResponse?> LoginAsync(string email, string password)
    {
        // Login endpoint shouldn't have the auth header if we are trying to log in,
        // but since we don't have a token yet, the AuthMessageHandler will just bypass it.
        var response = await _httpClient.PostAsJsonAsync("api/v1/accounts/login", new { email, password });
        if (response.IsSuccessStatusCode)
        {
            var result = await response.Content.ReadFromJsonAsync<Hasad.Application.Common.Models.Result<AuthResponse>>();
            return result?.Data;
        }
        return null;
    }

    public async Task<DashboardOverviewDto?> GetDashboardOverviewAsync()
    {
        return await _httpClient.GetFromJsonAsync<DashboardOverviewDto>("api/admin/dashboard/overview");
    }

    public async Task<bool> BroadcastNotificationAsync(object request)
    {
        var response = await _httpClient.PostAsJsonAsync("api/admin/dashboard/broadcast-notification", request);
        return response.IsSuccessStatusCode;
    }

    public async Task<ReportResultDto?> ExecuteReportAsync(ReportRequest request)
    {
        var response = await _httpClient.PostAsJsonAsync("api/report/execute", request);
        if (response.IsSuccessStatusCode)
        {
            return await response.Content.ReadFromJsonAsync<ReportResultDto>();
        }
        return null;
    }

    public async Task<byte[]?> DownloadReportExcelAsync(ReportRequest request)
    {
        var response = await _httpClient.PostAsJsonAsync("api/report/export/excel", request);
        if (response.IsSuccessStatusCode)
        {
            return await response.Content.ReadAsByteArrayAsync();
        }
        return null;
    }
}
