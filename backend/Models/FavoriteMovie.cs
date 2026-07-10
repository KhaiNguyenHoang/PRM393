using System.ComponentModel.DataAnnotations;

namespace Netmu.Models;

public class FavoriteMovie : Base
{
    public Guid UserId { get; set; }
    public ApplicationUser User { get; set; } = null!;
    public Guid MovieId { get; set; }
    public Movie Movie { get; set; } = null!;
}
