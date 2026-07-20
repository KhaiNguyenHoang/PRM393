using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Netmu.Dtos;
using Netmu.Services.Contracts;
using System.Security.Claims;

namespace Netmu.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class FavoritesController(IFavoriteService favoriteService) : ControllerBase
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

    [HttpPost("{movieId:guid}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> AddFavorite(Guid movieId)
    {
        try
        {
            var userId = GetUserIdFromToken();
            await favoriteService.AddFavoriteAsync(userId, movieId);
            return Ok();
        }
        catch (UnauthorizedAccessException) { return Unauthorized(); }
    }

    [HttpDelete("{movieId:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> RemoveFavorite(Guid movieId)
    {
        try
        {
            var userId = GetUserIdFromToken();
            await favoriteService.RemoveFavoriteAsync(userId, movieId);
            return NoContent();
        }
        catch (UnauthorizedAccessException) { return Unauthorized(); }
    }

    [HttpGet]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetFavorites([FromQuery] PaginationParam param)
    {
        try
        {
            var userId = GetUserIdFromToken();
            return Ok(await favoriteService.GetFavoritesAsync(userId, param));
        }
        catch (UnauthorizedAccessException) { return Unauthorized(); }
    }
}
