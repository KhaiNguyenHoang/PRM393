using System.ComponentModel.DataAnnotations;

namespace Netmu.Dtos;

public class ReviewDtoRequest
{
    [Required]
    [MaxLength(1000)]
    public string Content { get; set; } = string.Empty;
    public int? Rating { get; set; }
}

public class ReviewDtoResponse
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    public string UserName { get; set; } = string.Empty;
    public Guid MovieId { get; set; }
    public string Content { get; set; } = string.Empty;
    public int? Rating { get; set; }
    public DateTimeOffset CreatedAt { get; set; }
}
