using System.ComponentModel.DataAnnotations;

namespace Netmu.Models;

public class Director : Base
{
    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;
    public string Bio { get; set; } = string.Empty;
    [MaxLength(500)]
    public string ImageUrl { get; set; } = string.Empty;
}
