using System.ComponentModel;

namespace Netmu.Dtos;

public class MovieDtoRequest
{
    [Description("Movie title")]
    public string Title { get; set; } = string.Empty;
    [Description("Movie description")]
    public string Description { get; set; } = string.Empty;
    [Description("Movie genre ids")]
    public List<Guid> GenreIds { get; set; } = [];
    [Description("Movie director ids")]
    public List<Guid> DirectorIds { get; set; } = [];
    [Description("Movie actor ids")]
    public List<Guid> ActorIds { get; set; } = [];
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
    [Description("Movie duration (in minutes)")]
    public int DurationInMinutes { get; set; }
    [Description("Movie video url")]
    public string VideoUrl { get; set; } = string.Empty; 
    [Description("Movie image url")]
    public string ImageUrl { get; set; } = string.Empty;
    [Description("Movie genres")]
    public List<GenreDto> Genres { get; set; } = [];
    [Description("Movie directors")]
    public List<DirectorDto> Directors { get; set; } = [];
    [Description("Movie actors")]
    public List<ActorDto> Actors { get; set; } = [];
}

public class GenreDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
}

public class DirectorDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Bio { get; set; } = string.Empty;
    public string ImageUrl { get; set; } = string.Empty;
}

public class ActorDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Bio { get; set; } = string.Empty;
    public string ImageUrl { get; set; } = string.Empty;
}

public class GenreDtoRequest
{
    public string Name { get; set; } = string.Empty;
}

public class DirectorDtoRequest
{
    public string Name { get; set; } = string.Empty;
    public string Bio { get; set; } = string.Empty;
    public string ImageUrl { get; set; } = string.Empty;
}

public class ActorDtoRequest
{
    public string Name { get; set; } = string.Empty;
    public string Bio { get; set; } = string.Empty;
    public string ImageUrl { get; set; } = string.Empty;
}
