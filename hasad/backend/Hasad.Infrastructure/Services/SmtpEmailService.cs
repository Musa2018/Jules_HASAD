using Hasad.Application.Common.Interfaces;
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MimeKit;
using MimeKit.Text;

namespace Hasad.Infrastructure.Services;

public class SmtpEmailService : IEmailService
{
    private readonly IConfiguration _configuration;
    private readonly ILogger<SmtpEmailService> _logger;

    public SmtpEmailService(IConfiguration configuration, ILogger<SmtpEmailService> logger)
    {
        _configuration = configuration;
        _logger = logger;
    }

    public async Task SendEmailAsync(string to, string subject, string body)
    {
        try
        {
            var email = new MimeMessage();
            var from = _configuration["EmailSettings:From"]
                ?? throw new InvalidOperationException("EmailSettings:From is not configured.");
            var host = _configuration["EmailSettings:Host"]
                ?? throw new InvalidOperationException("EmailSettings:Host is not configured.");
            var portStr = _configuration["EmailSettings:Port"] ?? "587";
            var username = _configuration["EmailSettings:Username"]
                ?? throw new InvalidOperationException("EmailSettings:Username is not configured.");
            var password = _configuration["EmailSettings:Password"]
                ?? throw new InvalidOperationException("EmailSettings:Password is not configured.");

            email.From.Add(MailboxAddress.Parse(from));
            email.To.Add(MailboxAddress.Parse(to));
            email.Subject = subject;
            email.Body = new TextPart(TextFormat.Html) { Text = body };

            using var smtp = new SmtpClient();

            // Helpful for debugging connection issues
            smtp.ServerCertificateValidationCallback = (s, c, h, e) => true;

            await smtp.ConnectAsync(
                host,
                int.Parse(portStr),
                SecureSocketOptions.StartTls);

            await smtp.AuthenticateAsync(username, password);

            await smtp.SendAsync(email);
            await smtp.DisconnectAsync(true);

            _logger.LogInformation("Email sent successfully to {To}", to);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to send email to {To}. Error: {Message}", to, ex.Message);
            throw;
        }
    }
}
