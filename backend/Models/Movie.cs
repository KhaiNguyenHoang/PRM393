using System.ComponentModel.DataAnnotations;

namespace Netmu.Models;

public class Movie : Base
{
    [MaxLength(100)]
    public string Title { get; set; } = string.Empty;
    [MaxLength(500)]
    public string Description { get; set; } = string.Empty;
    public int DurationInMinutes { get; set; }
    [MaxLength(300)]
    public string VideoUrl { get; set; } = string.Empty;
    [MaxLength(300)]
    public string ImageUrl { get; set; } = string.Empty;

    public ICollection<MovieGenre> MovieGenres { get; set; } = [];
    public ICollection<MovieDirector> MovieDirectors { get; set; } = [];
    public ICollection<MovieActor> MovieActors { get; set; } = [];
}
