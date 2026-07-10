using Netmu.Dtos;
using Netmu.Exceptions;
using Netmu.Models;
using Netmu.Repositories.Contracts;
using Netmu.Services.Contracts;

namespace Netmu.Services.Implementations;

public class FavoriteService(IUnitOfWork uow) : IFavoriteService
{
    public async Task AddFavoriteAsync(Guid userId, Guid movieId)
    {
        var existing = await uow.Repo<FavoriteMovie>().GetPagedListAsync(1, 1, x => x.UserId == userId && x.MovieId == movieId);
        if (existing.Count > 0) return;

        var movie = await uow.Repo<Movie>().GetByIdAsync(movieId);
        if (movie == null) throw new NotFoundException("Movie not found");

        var favorite = new FavoriteMovie
        {
            UserId = userId,
            MovieId = movieId
        };
        await uow.Repo<FavoriteMovie>().CreateAsync(favorite);
        await uow.SaveChangesAsync();
    }

    public async Task RemoveFavoriteAsync(Guid userId, Guid movieId)
    {
        var existing = await uow.Repo<FavoriteMovie>().GetPagedListAsync(1, 1, x => x.UserId == userId && x.MovieId == movieId);
        var favorite = existing.FirstOrDefault();
        if (favorite != null)
        {
            uow.Repo<FavoriteMovie>().SoftDelete(favorite);
            await uow.SaveChangesAsync();
        }
    }

    public async Task<Pagination<FavoriteMovieDtoResponse>> GetFavoritesAsync(Guid userId, PaginationParam param)
    {
        var favorites = await uow.Repo<FavoriteMovie>().GetPagedListAsync(param.Page, param.Size, x => x.UserId == userId);
        
        var resp = new List<FavoriteMovieDtoResponse>();
        foreach (var fav in favorites)
        {
            var movie = await uow.Repo<Movie>().GetByIdAsync(fav.MovieId);
            if (movie != null)
            {
                resp.Add(new FavoriteMovieDtoResponse
                {
                    Id = fav.Id,
                    MovieId = fav.MovieId,
                    Title = movie.Title,
                    ImageUrl = movie.ImageUrl,
                    CreatedAt = fav.CreatedAt
                });
            }
        }

        var metadata = new PaginationMetadata
        {
            CurrentPage = favorites.PageNumber,
            HasNextPage = favorites.HasNextPage,
            HasPreviousPage = favorites.HasPreviousPage,
            PageCount = favorites.PageCount,
            PageSize = favorites.PageSize,
            TotalItemCount = favorites.TotalItemCount,
        };

        return new Pagination<FavoriteMovieDtoResponse>(metadata, resp);
    }
}
