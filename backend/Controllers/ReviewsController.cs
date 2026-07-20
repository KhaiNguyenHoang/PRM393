using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Netmu.Dtos;
using Netmu.Services.Contracts;
using System.Security.Claims;

namespace Netmu.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ReviewsController(IReviewService reviewService) : ControllerBase
{
    private Guid GetUserIdFromToken()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
        if (userIdClaim == null || !Guid.TryParse(userIdClaim.Value, out var userId))
        {
            throw new UnauthorizedAccessException("Invalid user ID in token");
        }
        return userId;
    }

    [HttpPost("/api/movies/{movieId:guid}/reviews")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> AddReview(Guid movieId, [FromBody] ReviewDtoRequest request)
    {
        try
        {
            var userId = GetUserIdFromToken();
            await reviewService.AddReviewAsync(userId, movieId, request);
            return Ok();
        }
        catch (UnauthorizedAccessException) { return Unauthorized(); }
    }

    [HttpGet("/api/movies/{movieId:guid}/reviews")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetReviews(Guid movieId, [FromQuery] PaginationParam param)
    {
        return Ok(await reviewService.GetReviewsAsync(movieId, param));
    }
}
