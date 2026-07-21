using Microsoft.AspNetCore.Identity;

namespace Netmu.Models;

public class ApplicationUser : IdentityUser<Guid>
{
    public string DeviceToken { get; set; } = string.Empty;
    public UserStatus Status { get; set; } = UserStatus.Active;
    public ICollection<Notification> Notifications { get; set; } = [];
}