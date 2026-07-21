using Microsoft.EntityFrameworkCore;
using Netmu.Data;
using X.PagedList.EF;
using Netmu.Dtos;
using Netmu.Exceptions;
using Netmu.Models;
using Netmu.Repositories.Contracts;
using Netmu.Services.Contracts;

namespace Netmu.Services.Implementations;

public class MovieService(AppDbContext context, IUnitOfWork uow, INotificationService service) : IMovieService
{
    private static MovieDtoResponse ToResponse(Movie movie) => new()
    {
        Id = movie.Id,
        Title = movie.Title,
        Description = movie.Description,
        DurationInMinutes = movie.DurationInMinutes,
        ImageUrl = movie.ImageUrl,
        VideoUrl = movie.VideoUrl,
        Genres = movie.MovieGenres
            .Where(mg => mg.Genre != null && !mg.Genre.IsDeleted)
            .Select(mg => new GenreDto { Id = mg.Genre.Id, Name = mg.Genre.Name }).ToList(),
        Directors = movie.MovieDirectors
            .Where(md => md.Director != null && !md.Director.IsDeleted)
            .Select(md => new DirectorDto { Id = md.Director.Id, Name = md.Director.Name, Bio = md.Director.Bio, ImageUrl = md.Director.ImageUrl }).ToList(),
        Actors = movie.MovieActors
            .Where(ma => ma.Actor != null && !ma.Actor.IsDeleted)
            .Select(ma => new ActorDto { Id = ma.Actor.Id, Name = ma.Actor.Name, Bio = ma.Actor.Bio, ImageUrl = ma.Actor.ImageUrl }).ToList(),
    };

    private async Task<Movie?> GetMovieWithRelationsAsync(Guid id)
    {
        return await context.Movies
            .Where(x => x.Id == id && !x.IsDeleted)
            .Include(x => x.MovieGenres).ThenInclude(x => x.Genre)
            .Include(x => x.MovieDirectors).ThenInclude(x => x.Director)
            .Include(x => x.MovieActors).ThenInclude(x => x.Actor)
            .FirstOrDefaultAsync();
    }

    public async Task<Guid> CreateMovieAsync(MovieDtoRequest request)
    {
        var movie = new Movie()
        {
            Title = request.Title,
            Description = request.Description,
            DurationInMinutes = request.DurationInMinutes,
            ImageUrl = request.ImageUrl,
            VideoUrl = request.VideoUrl,
            MovieGenres = [.. request.GenreIds.Select(g => new MovieGenre { GenreId = g })],
            MovieDirectors = [.. request.DirectorIds.Select(d => new MovieDirector { DirectorId = d })],
            MovieActors = [.. request.ActorIds.Select(a => new MovieActor { ActorId = a })],
        };

        await uow.Repo<Movie>().CreateAsync(movie);
        await uow.SaveChangesAsync();
        await service.BroadcastAsync(new()
        {
            Title = "New movie arrived",
            Body = $"New movie {movie.Title} has arrived. Check out soon",
        });
        return movie.Id;
    }

    public async Task<MovieDtoResponse> GetMovieAsync(Guid id)
    {
        var movie = await GetMovieWithRelationsAsync(id);
        if (movie == null)
        {
            throw new NotFoundException("Movie not found");
        }

        return ToResponse(movie);
    }

    public async Task<Pagination<MovieDtoResponse>> GetMoviesAsync(PaginationParam param)
    {
        var keyword = param.SearchKeyword?.ToLower();
        var movies = await context.Movies
            .Where(x => !x.IsDeleted)
            .Where(x => string.IsNullOrWhiteSpace(keyword)
                || x.Title.ToLower().Contains(keyword)
                || x.MovieDirectors.Any(md => md.Director.Name.ToLower().Contains(keyword))
                || x.MovieActors.Any(ma => ma.Actor.Name.ToLower().Contains(keyword))
                || x.MovieGenres.Any(mg => mg.Genre.Name.ToLower().Contains(keyword)))
            .Include(x => x.MovieGenres).ThenInclude(x => x.Genre)
            .Include(x => x.MovieDirectors).ThenInclude(x => x.Director)
            .Include(x => x.MovieActors).ThenInclude(x => x.Actor)
            .OrderByDescending(x => x.UpdatedAt)
            .ToPagedListAsync(param.Page, param.Size);

        var resp = movies.Select(ToResponse);
        var metadata = new PaginationMetadata()
        {
            CurrentPage = movies.PageNumber,
            HasNextPage = movies.HasNextPage,
            HasPreviousPage = movies.HasPreviousPage,
            PageCount = movies.PageCount,
            PageSize = movies.PageSize,
            TotalItemCount = movies.TotalItemCount,
        };
        return new Pagination<MovieDtoResponse>(metadata, resp);
    }

    public async Task<MovieDtoResponse> UpdateMovieAsync(Guid id, MovieDtoRequest request)
    {
        var movie = await GetMovieWithRelationsAsync(id);
        if (movie == null)
        {
            throw new BadRequestException("Movie not found");
        }

        movie.Title = request.Title;
        movie.Description = request.Description;
        movie.DurationInMinutes = request.DurationInMinutes;
        movie.ImageUrl = request.ImageUrl;
        movie.VideoUrl = request.VideoUrl;

        movie.MovieGenres.Clear();
        movie.MovieGenres = [.. request.GenreIds.Select(g => new MovieGenre { MovieId = movie.Id, GenreId = g })];
        movie.MovieDirectors.Clear();
        movie.MovieDirectors = [.. request.DirectorIds.Select(d => new MovieDirector { MovieId = movie.Id, DirectorId = d })];
        movie.MovieActors.Clear();
        movie.MovieActors = [.. request.ActorIds.Select(a => new MovieActor { MovieId = movie.Id, ActorId = a })];

        uow.Repo<Movie>().Update(movie);
        await uow.SaveChangesAsync();

        movie = await GetMovieWithRelationsAsync(id);
        if (movie == null)
        {
            throw new BadRequestException("Movie not found");
        }
        return ToResponse(movie);
    }

    public async Task DeleteMovieAsync(Guid id)
    {
        var movie = await GetMovieWithRelationsAsync(id);
        if (movie == null)
        {
            throw new BadRequestException("Movie not found");
        }

        uow.Repo<Movie>().SoftDelete(movie);
        await uow.SaveChangesAsync();
    }
}
