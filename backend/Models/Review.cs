using System.ComponentModel.DataAnnotations;

namespace Netmu.Models;

public class Review : Base
{
    public Guid UserId { get; set; }
    public ApplicationUser User { get; set; } = null!;
    public Guid MovieId { get; set; }
    public Movie Movie { get; set; } = null!;
    
    [MaxLength(1000)]
    public string Content { get; set; } = string.Empty;
    public int? Rating { get; set; }
}
