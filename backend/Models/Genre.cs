using System.ComponentModel.DataAnnotations;

namespace Netmu.Models;

public class Genre : Base
{
    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;
}
