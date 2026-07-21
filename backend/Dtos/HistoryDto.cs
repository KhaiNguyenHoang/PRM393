namespace Netmu.Dtos;

public class CreateHistoryDto
{
    public Guid MovieId { get; set; }
    public int ProgressInSeconds { get; set; }
}

public class HistoryDto
{
    public Guid Id { get; set; }
    public Guid MovieId { get; set; }
    public string MovieTitle { get; set; } = string.Empty;
    public string MovieImageUrl { get; set; } = string.Empty;
    public DateTimeOffset WatchedAt { get; set; }
    public int ProgressInSeconds { get; set; }
}
