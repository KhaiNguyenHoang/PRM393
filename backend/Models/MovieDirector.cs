namespace Netmu.Models;

public class MovieDirector : Base
{
    public Guid MovieId { get; set; }
    public Movie Movie { get; set; } = null!;
    public Guid DirectorId { get; set; }
    public Director Director { get; set; } = null!;
}
