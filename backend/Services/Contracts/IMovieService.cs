using Netmu.Dtos;

namespace Netmu.Services.Contracts;

public interface IMovieService
{
    Task<Guid> CreateMovieAsync(MovieDtoRequest request);
    Task<MovieDtoResponse> GetMovieAsync(Guid id);
    Task<Pagination<MovieDtoResponse>> GetMoviesAsync(PaginationParam param);
    Task<MovieDtoResponse> UpdateMovieAsync(Guid id, MovieDtoRequest request);
    Task DeleteMovieAsync(Guid id);
}