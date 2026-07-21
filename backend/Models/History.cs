namespace Netmu.Models;

public class History : Base
{
    public Guid UserId { get; set; }
    public ApplicationUser User { get; set; } = null!;
    public Guid MovieId { get; set; }
    public Movie Movie { get; set; } = null!;
    public DateTimeOffset WatchedAt { get; set; } = DateTimeOffset.UtcNow;
    public int ProgressInSeconds { get; set; }
}
