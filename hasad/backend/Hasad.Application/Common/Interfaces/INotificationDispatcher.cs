namespace Hasad.Application.Common.Interfaces;

public interface INotificationDispatcher
{
    Task SendNotificationAsync(Guid notificationId, string targetUserId);
    Task SendBulkNotificationAsync(Guid notificationId, IEnumerable<string> targetUserIds);
}

public interface IFcmHttpV1Client
{
    Task SendRawPushV1Async(string deviceToken, string title, string body, string? payloadJson);
}

public interface IApnsService
{
    Task SendDirectPushAsync(string deviceToken, string title, string body, string? payloadJson);
}
