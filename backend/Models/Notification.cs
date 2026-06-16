using System.ComponentModel.DataAnnotations;

namespace Netmu.Models;

public class Notification : Base
{
    [MaxLength(100)]
    public string Title { get; set; } = string.Empty;
    [MaxLength(100)]
    public string Message { get; set; } = string.Empty;
    public Guid ReceiverId { get; set; }
    public ApplicationUser Receiver { get; set; } = null!;
}