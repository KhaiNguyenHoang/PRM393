using System.ComponentModel.DataAnnotations;

namespace Netmu.Models;

public class Playlist : Base
{
    public Guid UserId { get; set; }
    public ApplicationUser User { get; set; } = null!;

    [Required]
    [MaxLength(255)]
    public string Name { get; set; } = string.Empty;

    public ICollection<PlaylistMovie> PlaylistMovies { get; set; } = new List<PlaylistMovie>();
}
