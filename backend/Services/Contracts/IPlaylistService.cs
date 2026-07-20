using Netmu.Dtos;

namespace Netmu.Services.Contracts;

public interface IPlaylistService
{
    Task<Guid> CreatePlaylistAsync(Guid userId, PlaylistDtoRequest request);
    Task<List<PlaylistDtoResponse>> GetUserPlaylistsAsync(Guid userId);
    Task UpdatePlaylistAsync(Guid userId, Guid playlistId, PlaylistDtoRequest request);
    Task DeletePlaylistAsync(Guid userId, Guid playlistId);
    Task AddMovieToPlaylistAsync(Guid userId, Guid playlistId, Guid movieId);
    Task RemoveMovieFromPlaylistAsync(Guid userId, Guid playlistId, Guid movieId);
    Task<List<MovieDtoResponse>> GetPlaylistMoviesAsync(Guid userId, Guid playlistId);
}
