using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Netmu.Models;
using Netmu.Repositories.Contracts;
using Netmu.Services.Contracts;
using Notification = FirebaseAdmin.Messaging.Notification;
using Netmu.Dtos;

namespace Netmu.Services.Implementations;

public class FcmSettings
{
    public string CredentialFileLocation { get; set; } = string.Empty;
    public string[] Scopes { get; set; } = [];
}

public class Fcm(IOptions<FcmSettings> settings)
{
    private readonly FirebaseApp _app = FirebaseApp.Create(new AppOptions()
    {
        Credential = GetCredential(settings.Value.CredentialFileLocation, settings.Value.Scopes),
    });

    /// <summary>
    /// Helper method to get Google credential for FCM
    /// </summary>
    /// <returns>Google access token</returns>
    private static GoogleCredential GetCredential(string credentialFileLocation, string[] scopes)
    {
        var credential = CredentialFactory
            .FromFile(credentialFileLocation, JsonCredentialParameters.ServiceAccountCredentialType)
            .CreateScoped(scopes);
        return credential;
    }

    /// <summary>
    /// Send a push notification to multiple devices (broadcast)
    /// </summary>
    /// <param name="devices"></param>
    /// <param name="payload"></param>
    /// <returns></returns>
    public async Task<bool> SendNotificationsAsync(List<string> devices, MessagePayload payload)
    {
        // Create messages list
        var messages = devices.Select(device => new Message()
        {
            // Set push notification
            Notification = new Notification()
            {
                Title = payload.Title,
                Body = payload.Body,
            },

            // Set data message
            Data = new Dictionary<string, string>()
            {
                ["JsonData"] = payload.Data,
            },

            Token = device,

            // Android specific configuration
            Android = new AndroidConfig(),

            // Apple specific configuration
            Apns = new ApnsConfig(),

            // Topic
        });

        var resp = await FirebaseMessaging.GetMessaging(_app).SendEachAsync(messages);
        return resp.FailureCount <= 0;
    }
}

public class NotificationService(
    UserManager<ApplicationUser> userManager,
    IUnitOfWork uow,
    Fcm fcm,
    ILogger<NotificationService> logger) : INotificationService
{
    public async Task<bool> BroadcastAsync(MessagePayload payload)
    {
        // Get the list of all users
        var users = userManager.Users.ToList();

        // Create notification for each users
        var notifications = users.Select(user => new Netmu.Models.Notification()
        {
            ReceiverId = user.Id,
            Title = payload.Title,
            Message = payload.Body,
        }).ToList();

        await ((INotificationRepository)uow.Repo<Netmu.Models.Notification>()).CreateBatchAsync(notifications);
        await uow.SaveChangesAsync();

        // Send notifications
        var tokens = users
            .Where(u => !string.IsNullOrEmpty(u.DeviceToken))
            .Select(u => u.DeviceToken)
            .ToList();
        var result = await fcm.SendNotificationsAsync(tokens, payload);
        if (!result)
        {
            logger.LogError("Failed to send notifications");
        }
        return result;
    }

    public async Task<IEnumerable<NotificationDto>> GetAllAsync(Guid receiverId)
    {
        var notifications = await ((INotificationRepository)uow.Repo<Netmu.Models.Notification>()).GetAllAsync(receiverId);
        return notifications.Select(x => new NotificationDto()
        {
            Title = x.Title,
            Message = x.Message,   
        });
    }
}