namespace Netmu.Dtos;

public class PlaylistDtoRequest
{
    public string Name { get; set; } = string.Empty;
}

public class PlaylistDtoResponse
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public int MovieCount { get; set; }
    public DateTime CreatedAt { get; set; }
    public List<Guid> MovieIds { get; set; } = new();
}
