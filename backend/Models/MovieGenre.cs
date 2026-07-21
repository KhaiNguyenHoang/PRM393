namespace Netmu.Models;

public class MovieGenre : Base
{
    public Guid MovieId { get; set; }
    public Movie Movie { get; set; } = null!;
    public Guid GenreId { get; set; }
    public Genre Genre { get; set; } = null!;
}
