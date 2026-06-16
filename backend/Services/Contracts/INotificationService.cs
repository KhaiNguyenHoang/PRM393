using Netmu.Dtos;

namespace Netmu.Services.Contracts;

public class MessagePayload
{
    public string Title { get; set; } = string.Empty;
    public string Body { get; set; } = string.Empty;
    public string Image { get; set; } = string.Empty;
    public string Data { get; set; } = string.Empty; // This should be a JSON string for data message
}

public interface INotificationService
{
    Task<bool> BroadcastAsync(MessagePayload payload);
    Task<IEnumerable<NotificationDto>> GetAllAsync(Guid receiverId);
}