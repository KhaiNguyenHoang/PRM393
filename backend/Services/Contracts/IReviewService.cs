using Netmu.Dtos;

namespace Netmu.Services.Contracts;

public interface IReviewService
{
    Task<Guid> AddReviewAsync(Guid userId, Guid movieId, ReviewDtoRequest request);
    Task<Pagination<ReviewDtoResponse>> GetReviewsAsync(Guid movieId, PaginationParam param);
}
