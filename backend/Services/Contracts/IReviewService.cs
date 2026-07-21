using Netmu.Dtos;

namespace Netmu.Services.Contracts;

public interface IReviewService
{
    Task<Guid> AddReviewAsync(Guid userId, Guid movieId, ReviewDtoRequest request);
    Task UpdateReviewAsync(Guid userId, Guid reviewId, ReviewDtoRequest request);
    Task DeleteReviewAsync(Guid userId, Guid reviewId);
    Task<Pagination<ReviewDtoResponse>> GetReviewsAsync(Guid movieId, PaginationParam param);
}
