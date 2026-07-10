namespace Netmu.Dtos;

public class FavoriteMovieDtoResponse
{
    public Guid Id { get; set; }
    public Guid MovieId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string ImageUrl { get; set; } = string.Empty;
    public DateTimeOffset CreatedAt { get; set; }
}
