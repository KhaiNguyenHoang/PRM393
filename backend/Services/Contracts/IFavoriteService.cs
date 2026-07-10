using Netmu.Dtos;

namespace Netmu.Services.Contracts;

public interface IFavoriteService
{
    Task AddFavoriteAsync(Guid userId, Guid movieId);
    Task RemoveFavoriteAsync(Guid userId, Guid movieId);
    Task<Pagination<FavoriteMovieDtoResponse>> GetFavoritesAsync(Guid userId, PaginationParam param);
}
