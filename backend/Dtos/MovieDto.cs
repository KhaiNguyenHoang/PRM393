using System.ComponentModel;

namespace Netmu.Dtos;

public class MovieDtoRequest
{
    [Description("Movie title")]
    public string Title { get; set; } = string.Empty;
    [Description("Movie description")]
    public string Description { get; set; } = string.Empty;
    [Description("Movie director")]
    public string Director { get; set; } = string.Empty;
    [Description("Movie geners")]
    public List<string> Genres { get; set; } = [];
    [Description("Movie duration (in minutes)")]
    public int DurationInMinutes { get; set; }
    [Description("Movie video url")]
    public string VideoUrl { get; set; } = string.Empty; 
    [Description("Movie image url")]
    public string ImageUrl { get; set; } = string.Empty;
}

public class MovieDtoResponse
{
    [Description("Movie ID")]
    public Guid Id { get; set; }
    [Description("Movie title")]
    public string Title { get; set; } = string.Empty;
    [Description("Movie description")]
    public string Description { get; set; } = string.Empty;
    [Description("Movie director")]
    public string Director { get; set; } = string.Empty;
    [Description("Movie geners")]
    public List<string> Genres { get; set; } = [];
    [Description("Movie duration (in minutes)")]
    public int DurationInMinutes { get; set; }
    [Description("Movie video url")]
    public string VideoUrl { get; set; } = string.Empty; 
    [Description("Movie image url")]
    public string ImageUrl { get; set; } = string.Empty;
}