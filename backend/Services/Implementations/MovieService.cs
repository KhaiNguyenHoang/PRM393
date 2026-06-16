using Netmu.Dtos;
using Netmu.Exceptions;
using Netmu.Models;
using Netmu.Repositories.Contracts;
using Netmu.Services.Contracts;

namespace Netmu.Services.Implementations;

public class MovieService(IUnitOfWork uow, INotificationService service) : IMovieService
{
    public async Task<Guid> CreateMovieAsync(MovieDtoRequest request)
    {
        var movie = new Movie()
        {
            Title = request.Title,
            Description = request.Description,
            Director = request.Director,
            DurationInMinutes = request.DurationInMinutes,
            Genres = request.Genres,
            ImageUrl = request.ImageUrl,
            VideoUrl = request.VideoUrl,
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
        var movie = await uow.Repo<Movie>().GetByIdAsync(id);
        if (movie == null)
        {
            throw new NotFoundException("Movie not found");
        }

        var resp = new MovieDtoResponse()
        {
            Description = movie.Description,
            Title = movie.Title,
            Director = movie.Director,
            DurationInMinutes = movie.DurationInMinutes,
            Genres = movie.Genres,
            ImageUrl = movie.ImageUrl,
            VideoUrl = movie.VideoUrl,
            Id = movie.Id
        };

        return resp;
    }

    public async Task<Pagination<MovieDtoResponse>> GetMoviesAsync(PaginationParam param)
    {
        var movies = await uow.Repo<Movie>().GetPagedListAsync(param.Page, param.Size);
        var resp = movies.Select(x => new MovieDtoResponse()
        {
            Id = x.Id,
            Title = x.Title,
            Description = x.Description,
            Director = x.Director,
            DurationInMinutes = x.DurationInMinutes,
            Genres = x.Genres,
            ImageUrl = x.ImageUrl,
            VideoUrl = x.VideoUrl,
        });
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
        var movie = await uow.Repo<Movie>().GetByIdAsync(id);
        if (movie == null)
        {
            throw new BadRequestException("Movie not found");
        }

        movie.Title = request.Title;
        movie.Description = request.Description;
        movie.Director = request.Director;
        movie.DurationInMinutes = request.DurationInMinutes;
        movie.Genres = request.Genres;
        movie.ImageUrl = request.ImageUrl;
        movie.VideoUrl = request.VideoUrl;

        uow.Repo<Movie>().Update(movie);
        await uow.SaveChangesAsync();

        return new MovieDtoResponse()
        {
            Id = movie.Id,
            Title = movie.Title,
            Description = movie.Description,
            Director = movie.Director,
            DurationInMinutes = movie.DurationInMinutes,
            Genres = movie.Genres,
            ImageUrl = movie.ImageUrl,
            VideoUrl = movie.VideoUrl,
        };
    }

    public async Task DeleteMovieAsync(Guid id)
    {
        var movie = await uow.Repo<Movie>().GetByIdAsync(id);
        if (movie == null)
        {
            throw new BadRequestException("Movie not found");
        }
        
        uow.Repo<Movie>().SoftDelete(movie);
        await uow.SaveChangesAsync();
    }
}