namespace Hasad.Application.Common.Options;

public class PushNotificationOptions
{
    public const string SectionName = "PushNotifications";

    public FcmOptions Fcm { get; set; } = new();
    public ApnsOptions Apns { get; set; } = new();
}

public class FcmOptions
{
    public string ProjectId { get; set; } = string.Empty;
    public string ServiceAccountJson { get; set; } = string.Empty;
}

public class ApnsOptions
{
    public string BundleId { get; set; } = string.Empty;
    public string TeamId { get; set; } = string.Empty;
    public string KeyId { get; set; } = string.Empty;
    public string PrivateKey { get; set; } = string.Empty;
    public bool UseSandbox { get; set; } = true;
}
