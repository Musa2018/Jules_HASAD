using System.Net.Http;
using System.Text;
using System.Threading.RateLimiting;
using Asp.Versioning;
using FluentValidation;
using Hasad.Api.Middleware;
using Hasad.Application.Common.Behaviors;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Common.Options;
using Hasad.Domain.Identity;
using Hasad.Infrastructure.Persistence;
using Hasad.Infrastructure.Persistence.Seed;
using Hasad.Infrastructure.Services;
using Hasad.Application.Features.Reporting.Services;
using Hasad.Infrastructure.Hubs;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Add Serilog
Log.Logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .CreateLogger();

builder.Host.UseSerilog();

// Add Database
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
Log.Information("Connecting to database: {ConnectionString}", connectionString);

builder.Services.AddDbContext<ApplicationDbContext>(options =>
{
    options.UseSqlServer(connectionString,
        o =>
        {
            o.MigrationsAssembly(typeof(ApplicationDbContext).Assembly.FullName);
            o.UseQuerySplittingBehavior(QuerySplittingBehavior.SplitQuery);
        });
});

builder.Services.AddScoped<IApplicationDbContext>(provider => provider.GetRequiredService<ApplicationDbContext>());

// Add Identity with lockout and password policy
builder.Services.AddIdentity<ApplicationUser, IdentityRole>(options =>
{
    options.Password.RequiredLength = 12;
    options.Password.RequireDigit = true;
    options.Password.RequireUppercase = true;
    options.Password.RequireLowercase = true;
    options.Password.RequireNonAlphanumeric = true;
    options.Lockout.AllowedForNewUsers = true;
    options.Lockout.MaxFailedAccessAttempts = 5;
    options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(15);
    options.User.RequireUniqueEmail = true;
})
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders();

// Bind and validate JWT options (key comes from environment variables or user secrets, never the repo)
builder.Services.AddOptions<JwtOptions>()
    .Bind(builder.Configuration.GetSection(JwtOptions.SectionName))
    .Validate(o => !string.IsNullOrWhiteSpace(o.Key) && o.Key.Length >= JwtOptions.MinimumKeyLength,
        $"JwtSettings:Key is missing or shorter than {JwtOptions.MinimumKeyLength} characters. " +
        "Provide it via the JwtSettings__Key environment variable or 'dotnet user-secrets'.")
    .Validate(o => !string.IsNullOrWhiteSpace(o.Issuer), "JwtSettings:Issuer is required.")
    .Validate(o => !string.IsNullOrWhiteSpace(o.Audience), "JwtSettings:Audience is required.")
    .Validate(o => o.AccessTokenMinutes > 0, "JwtSettings:AccessTokenMinutes must be positive.")
    .Validate(o => o.RefreshTokenDays > 0, "JwtSettings:RefreshTokenDays must be positive.")
    .ValidateOnStart();

var jwtOptions = builder.Configuration.GetSection(JwtOptions.SectionName).Get<JwtOptions>() ?? new JwtOptions();
if (string.IsNullOrWhiteSpace(jwtOptions.Key) || jwtOptions.Key.Length < JwtOptions.MinimumKeyLength)
{
    throw new InvalidOperationException(
        $"JwtSettings:Key is missing or shorter than {JwtOptions.MinimumKeyLength} characters. " +
        "Provide it via the JwtSettings__Key environment variable or 'dotnet user-secrets'.");
}

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = !builder.Environment.IsDevelopment();
    options.SaveToken = true;
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtOptions.Key)),
        ValidateIssuer = true,
        ValidIssuer = jwtOptions.Issuer,
        ValidateAudience = true,
        ValidAudience = jwtOptions.Audience,
        ValidateLifetime = true,
        ClockSkew = TimeSpan.FromMinutes(1),
        NameClaimType = System.Security.Claims.ClaimTypes.Name,
        RoleClaimType = System.Security.Claims.ClaimTypes.Role
    };

    options.Events = new JwtBearerEvents
    {
        OnMessageReceived = context =>
        {
            var accessToken = context.Request.Query["access_token"];
            var path = context.HttpContext.Request.Path;
            if (!string.IsNullOrEmpty(accessToken) && path.StartsWithSegments("/hubs"))
            {
                context.Token = accessToken;
            }
            return Task.CompletedTask;
        }
    };
});

// Rate limiting for authentication endpoints (per client IP)
builder.Services.AddRateLimiter(options =>
{
    options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
    options.AddPolicy("auth", httpContext =>
        RateLimitPartition.GetFixedWindowLimiter(
            httpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown",
            _ => new FixedWindowRateLimiterOptions
            {
                PermitLimit = 10,
                Window = TimeSpan.FromMinutes(1),
                QueueLimit = 0
            }));
});

builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("SuperAdminOnly", policy =>
        policy.RequireRole("SuperAdmin")
              .RequireClaim("SuperAdminScope", "GlobalAccess"));
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAdminClient", policy =>
    {
        policy.WithOrigins(
                  "http://localhost:5000",
                  "http://localhost:5080",
                  "https://localhost:5001",
                  "https://localhost:7001"
              )
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials();
    });
});

// Add API Versioning
builder.Services.AddApiVersioning(options =>
{
    options.DefaultApiVersion = new ApiVersion(1, 0);
    options.AssumeDefaultVersionWhenUnspecified = true;
    options.ReportApiVersions = true;
});

builder.Services.AddMediatR(cfg =>
{
    cfg.RegisterServicesFromAssembly(typeof(Hasad.Application.Features.Accounts.Commands.Login.LoginCommand).Assembly);
    cfg.AddOpenBehavior(typeof(ValidationBehavior<,>));
});
builder.Services.AddValidatorsFromAssembly(typeof(Hasad.Application.Features.Accounts.Commands.Login.LoginCommandValidator).Assembly);

builder.Services.AddSingleton(TimeProvider.System);
builder.Services.AddScoped<ITokenService, TokenService>();
builder.Services.AddScoped<IRefreshTokenStore, RefreshTokenStore>();
builder.Services.AddScoped<IFileStorageService, LocalFileStorageService>();
builder.Services.AddScoped<IEmailService, SmtpEmailService>();
builder.Services.AddScoped<INotificationService, NotificationService>();
builder.Services.AddScoped<IAssistanceService, AssistanceService>();
builder.Services.AddScoped<ICostingService, CostingService>();
builder.Services.AddScoped<IPDFService, PDFService>();
builder.Services.AddScoped<IDamageReportNumberService, DamageReportNumberService>();
builder.Services.AddScoped<IDamageWorkflowService, DamageWorkflowService>();
builder.Services.AddSingleton<IReportMetadataService, ReportMetadataService>();
builder.Services.AddScoped<IDynamicQueryEngine, DynamicQueryEngine>();
builder.Services.AddScoped<IReportExportService, ReportExportService>();
builder.Services.AddScoped<ICurrentUserService, CurrentUserService>();
builder.Services.AddSignalR();
builder.Services.AddHttpContextAccessor();

// Notifications
builder.Services.Configure<PushNotificationOptions>(builder.Configuration.GetSection(PushNotificationOptions.SectionName));
builder.Services.AddHttpClient<IFcmHttpV1Client, FcmHttpV1Client>();
builder.Services.AddHttpClient<IApnsService, ApnsService>(client => {
    client.DefaultRequestVersion = new Version(2, 0);
    client.DefaultVersionPolicy = HttpVersionPolicy.RequestVersionExact;
});
builder.Services.AddScoped<INotificationDispatcher, NotificationDispatcher>();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo { Title = "HASAD API", Version = "v1" });
    options.AddSecurityDefinition("Bearer", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = Microsoft.OpenApi.Models.ParameterLocation.Header,
        Description = "JWT Authorization header using the Bearer scheme. Example: \"Bearer {token}\""
    });
    options.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement
    {
        {
            new Microsoft.OpenApi.Models.OpenApiSecurityScheme
            {
                Reference = new Microsoft.OpenApi.Models.OpenApiReference
                {
                    Type = Microsoft.OpenApi.Models.ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
    options.CustomSchemaIds(type => type.FullName);
});

var app = builder.Build();

// Seed Database
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    try
    {
        var context = services.GetRequiredService<ApplicationDbContext>();
        if (context.Database.IsRelational())
        {
            var pending = (await context.Database.GetPendingMigrationsAsync()).ToList();
            await context.Database.MigrateAsync();
            Log.Information("Database schema is up to date; applied {Count} pending migration(s).", pending.Count);
        }
        else
        {
            await context.Database.EnsureCreatedAsync();
            Log.Information("Non-relational provider detected; database created via EnsureCreatedAsync.");
        }

        var roleManager = services.GetRequiredService<RoleManager<IdentityRole>>();
        await DbInitializer.SeedRolesAsync(roleManager);
            await DbInitializer.SeedAssistanceRulesAsync(context);
        await DbInitializer.SeedGeographicsAsync(context);
        await DbInitializer.SeedDamageReferenceDataAsync(context);
        await DbInitializer.SeedWorkflowDataAsync(context);

        var seedAdminEmail = app.Configuration["SeedAdmin:Email"];
        var seedAdminPassword = app.Configuration["SeedAdmin:Password"];
        Log.Information("Attempting to seed SuperAdmin: {Email}", seedAdminEmail ?? "MISSING");

        if (!string.IsNullOrWhiteSpace(seedAdminEmail) && !string.IsNullOrWhiteSpace(seedAdminPassword))
        {
            var userManager = services.GetRequiredService<UserManager<ApplicationUser>>();
            var result = await DbInitializer.SeedSuperAdminAsync(userManager, seedAdminEmail, seedAdminPassword);
            if (result is { Succeeded: false })
            {
                throw new InvalidOperationException(
                    $"Seeding the SuperAdmin failed: {string.Join("; ", result.Errors.Select(e => e.Description))}");
            }

            if (result is null)
            {
                Log.Information("SuperAdmin account already exists; seeding skipped.");
            }
            else
            {
                Log.Information("SuperAdmin account seeded successfully.");
            }

            // Ensure AdminUser entity exists for auditing
            var adminIdentity = await userManager.FindByEmailAsync(seedAdminEmail);
            if (adminIdentity != null && !await context.AdminUsers.AnyAsync(a => a.UserId == adminIdentity.Id))
            {
                context.AdminUsers.Add(new Hasad.Domain.Entities.AdminUser
                {
                    AdminId = Guid.NewGuid().ToString(),
                    UserId = adminIdentity.Id,
                    Role = "SuperAdmin",
                    IsActive = true,
                    CreatedAt = DateTime.UtcNow
                });
                await context.SaveChangesAsync();
                Log.Information("AdminUser record created for SuperAdmin.");
            }

            // Seed UAT Users
            await DbInitializer.SeedUatUsersAsync(userManager, context);
            Log.Information("UAT Users seeded successfully.");
        }
        else
        {
            Log.Information("SeedAdmin credentials not configured; skipping SuperAdmin seeding.");
        }
    }
    catch (Exception ex)
    {
        Log.Fatal(ex, "An error occurred during database migration or seeding.");
        throw;
    }
}

// Middleware
app.UseMiddleware<ExceptionMiddleware>();

app.UseStaticFiles(); // Serve files from wwwroot if exists

var uploadsPath = Path.Combine(app.Environment.WebRootPath ?? app.Environment.ContentRootPath, "uploads");
if (!Directory.Exists(uploadsPath))
{
    Directory.CreateDirectory(uploadsPath);
}

app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = new Microsoft.Extensions.FileProviders.PhysicalFileProvider(uploadsPath),
    RequestPath = "/uploads"
});

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseSerilogRequestLogging();
app.UseHttpsRedirection();

app.UseRouting();

// CORS must be after UseRouting and before UseAuthentication
app.UseCors("AllowAdminClient");

app.UseRateLimiter();
app.UseAuthentication();
app.UseAuthorization();

app.MapGet("/health", () => Results.Ok(new { status = "Healthy", timestamp = DateTime.UtcNow }));
app.MapHub<NotificationHub>("/hubs/notifications").RequireCors("AllowAdminClient");
app.MapHub<AdminDashboardHub>("/hubs/admin-dashboard").RequireCors("AllowAdminClient");
app.MapControllers();

app.Run();
