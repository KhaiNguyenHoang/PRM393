using Microsoft.AspNetCore.Identity;
using Netmu.Dtos;
using Netmu.Exceptions;
using Netmu.Models;
using Netmu.Repositories.Contracts;
using Netmu.Services.Contracts;

namespace Netmu.Services.Implementations;

public class ReviewService(IUnitOfWork uow, UserManager<ApplicationUser> userManager) : IReviewService
{
    public async Task<Guid> AddReviewAsync(Guid userId, Guid movieId, ReviewDtoRequest request)
    {
        var movie = await uow.Repo<Movie>().GetByIdAsync(movieId);
        if (movie == null) throw new NotFoundException("Movie not found");

        var review = new Review
        {
            UserId = userId,
            MovieId = movieId,
            Content = request.Content,
            Rating = request.Rating
        };

        await uow.Repo<Review>().CreateAsync(review);
        await uow.SaveChangesAsync();
        return review.Id;
    }

    public async Task<Pagination<ReviewDtoResponse>> GetReviewsAsync(Guid movieId, PaginationParam param)
    {
        var reviews = await uow.Repo<Review>().GetPagedListAsync(param.Page, param.Size, x => x.MovieId == movieId);

        var resp = new List<ReviewDtoResponse>();
        foreach (var review in reviews)
        {
            var user = await userManager.FindByIdAsync(review.UserId.ToString());
            resp.Add(new ReviewDtoResponse
            {
                Id = review.Id,
                UserId = review.UserId,
                UserName = user?.UserName ?? "Unknown",
                MovieId = review.MovieId,
                Content = review.Content,
                Rating = review.Rating,
                CreatedAt = review.CreatedAt
            });
        }

        var metadata = new PaginationMetadata
        {
            CurrentPage = reviews.PageNumber,
            HasNextPage = reviews.HasNextPage,
            HasPreviousPage = reviews.HasPreviousPage,
            PageCount = reviews.PageCount,
            PageSize = reviews.PageSize,
            TotalItemCount = reviews.TotalItemCount,
        };

        return new Pagination<ReviewDtoResponse>(metadata, resp);
    }
}
