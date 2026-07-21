namespace Netmu.Models;

public class PlaylistMovie : Base
{
    public Guid PlaylistId { get; set; }
    public Playlist Playlist { get; set; } = null!;

    public Guid MovieId { get; set; }
    public Movie Movie { get; set; } = null!;
}
