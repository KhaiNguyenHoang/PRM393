using System.ComponentModel.DataAnnotations;

namespace Netmu.Models;

public class Movie : Base
{
    [MaxLength(100)]
    public string Title { get; set; } = string.Empty;
    [MaxLength(500)]
    public string Description { get; set; } = string.Empty;
    [MaxLength(100)]
    public string Director { get; set; } = string.Empty;
    public List<string> Genres { get; set; } = [];
    public int DurationInMinutes { get; set; }
    [MaxLength(300)]
    public string VideoUrl { get; set; } = string.Empty;
    [MaxLength(300)]
    public string ImageUrl { get; set; } = string.Empty;
}