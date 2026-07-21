using Microsoft.EntityFrameworkCore;
using Netmu.Data;
using Netmu.Dtos;
using Netmu.Exceptions;
using Netmu.Models;
using Netmu.Repositories.Contracts;
using Netmu.Services.Contracts;

namespace Netmu.Services.Implementations;

public class PlaylistService(IUnitOfWork uow, AppDbContext context) : IPlaylistService
{
    public async Task<Guid> CreatePlaylistAsync(Guid userId, PlaylistDtoRequest request)
    {
        var playlist = new Playlist
        {
            UserId = userId,
            Name = request.Name
        };

        await uow.Repo<Playlist>().CreateAsync(playlist);
        await uow.SaveChangesAsync();
        return playlist.Id;
    }

    public async Task<List<PlaylistDtoResponse>> GetUserPlaylistsAsync(Guid userId)
    {
        var playlists = await context.Playlists
            .Where(x => x.UserId == userId && !x.IsDeleted)
            .Include(x => x.PlaylistMovies.Where(pm => !pm.IsDeleted))
            .OrderByDescending(x => x.CreatedAt)
            .ToListAsync();

        return playlists.Select(x => new PlaylistDtoResponse
        {
            Id = x.Id,
            Name = x.Name,
            MovieCount = x.PlaylistMovies.Count,
            CreatedAt = x.CreatedAt.DateTime,
            MovieIds = x.PlaylistMovies.Where(pm => !pm.IsDeleted).Select(pm => pm.MovieId).ToList()
        }).ToList();
    }

    public async Task UpdatePlaylistAsync(Guid userId, Guid playlistId, PlaylistDtoRequest request)
    {
        var playlist = await uow.Repo<Playlist>().GetByIdAsync(playlistId);
        if (playlist == null) throw new NotFoundException("Playlist not found");
        if (playlist.UserId != userId) throw new UnauthorizedAccessException("Cannot edit this playlist");

        playlist.Name = request.Name;
        uow.Repo<Playlist>().Update(playlist);
        await uow.SaveChangesAsync();
    }

    public async Task DeletePlaylistAsync(Guid userId, Guid playlistId)
    {
        var playlist = await uow.Repo<Playlist>().GetByIdAsync(playlistId);
        if (playlist == null) throw new NotFoundException("Playlist not found");
        if (playlist.UserId != userId) throw new UnauthorizedAccessException("Cannot delete this playlist");

        // Hard delete playlist movies first, or let cascading handle it.
        // We'll just hard delete the playlist.
        uow.Repo<Playlist>().HardDelete(playlist);
        await uow.SaveChangesAsync();
    }

    public async Task AddMovieToPlaylistAsync(Guid userId, Guid playlistId, Guid movieId)
    {
        var playlist = await uow.Repo<Playlist>().GetByIdAsync(playlistId);
        if (playlist == null) throw new NotFoundException("Playlist not found");
        if (playlist.UserId != userId) throw new UnauthorizedAccessException("Cannot modify this playlist");

        var movie = await uow.Repo<Movie>().GetByIdAsync(movieId);
        if (movie == null) throw new NotFoundException("Movie not found");

        var exists = await context.PlaylistMovies.AnyAsync(x => x.PlaylistId == playlistId && x.MovieId == movieId && !x.IsDeleted);
        if (exists) return; // already in playlist

        var pm = new PlaylistMovie
        {
            PlaylistId = playlistId,
            MovieId = movieId
        };

        await uow.Repo<PlaylistMovie>().CreateAsync(pm);
        await uow.SaveChangesAsync();
    }

    public async Task RemoveMovieFromPlaylistAsync(Guid userId, Guid playlistId, Guid movieId)
    {
        var playlist = await uow.Repo<Playlist>().GetByIdAsync(playlistId);
        if (playlist == null) throw new NotFoundException("Playlist not found");
        if (playlist.UserId != userId) throw new UnauthorizedAccessException("Cannot modify this playlist");

        var pm = await context.PlaylistMovies.FirstOrDefaultAsync(x => x.PlaylistId == playlistId && x.MovieId == movieId && !x.IsDeleted);
        if (pm != null)
        {
            uow.Repo<PlaylistMovie>().HardDelete(pm);
            await uow.SaveChangesAsync();
        }
    }

    public async Task<List<MovieDtoResponse>> GetPlaylistMoviesAsync(Guid userId, Guid playlistId)
    {
        var playlist = await uow.Repo<Playlist>().GetByIdAsync(playlistId);
        if (playlist == null) throw new NotFoundException("Playlist not found");
        if (playlist.UserId != userId) throw new UnauthorizedAccessException("Cannot view this playlist");

        var movies = await context.PlaylistMovies
            .Where(x => x.PlaylistId == playlistId && !x.IsDeleted)
            .Include(x => x.Movie)
                .ThenInclude(x => x.MovieGenres).ThenInclude(x => x.Genre)
            .Include(x => x.Movie)
                .ThenInclude(x => x.MovieDirectors).ThenInclude(x => x.Director)
            .Include(x => x.Movie)
                .ThenInclude(x => x.MovieActors).ThenInclude(x => x.Actor)
            .Select(x => x.Movie)
            .ToListAsync();

        return movies.Select(m => new MovieDtoResponse
        {
            Id = m.Id,
            Title = m.Title,
            Description = m.Description,
            DurationInMinutes = m.DurationInMinutes,
            VideoUrl = m.VideoUrl,
            ImageUrl = m.ImageUrl,
            Genres = m.MovieGenres
                .Where(mg => mg.Genre != null && !mg.Genre.IsDeleted)
                .Select(mg => new GenreDto { Id = mg.Genre.Id, Name = mg.Genre.Name }).ToList(),
            Directors = m.MovieDirectors
                .Where(md => md.Director != null && !md.Director.IsDeleted)
                .Select(md => new DirectorDto { Id = md.Director.Id, Name = md.Director.Name, Bio = md.Director.Bio, ImageUrl = md.Director.ImageUrl }).ToList(),
            Actors = m.MovieActors
                .Where(ma => ma.Actor != null && !ma.Actor.IsDeleted)
                .Select(ma => new ActorDto { Id = ma.Actor.Id, Name = ma.Actor.Name, Bio = ma.Actor.Bio, ImageUrl = ma.Actor.ImageUrl }).ToList(),
        }).ToList();
    }
}
