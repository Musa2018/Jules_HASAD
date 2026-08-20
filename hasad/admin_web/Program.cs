using System.Net.Http;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using Blazored.LocalStorage;
using Hasad.AdminWeb;
using Hasad.AdminWeb.Services;

var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.RootComponents.Add<App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");

var apiBaseUrl = builder.Configuration["ApiBaseUrl"] ?? "http://localhost:5271/";

builder.Services.AddBlazoredLocalStorage();
builder.Services.AddScoped<AuthMessageHandler>();

builder.Services.AddHttpClient("AdminApi", client => client.BaseAddress = new Uri(apiBaseUrl))
    .AddHttpMessageHandler<AuthMessageHandler>();

// Supply the default HttpClient from the factory
builder.Services.AddScoped(sp => sp.GetRequiredService<IHttpClientFactory>().CreateClient("AdminApi"));

builder.Services.AddScoped<AdminApiClient>();
builder.Services.AddScoped<DashboardHubClient>();

await builder.Build().RunAsync();
