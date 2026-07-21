using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Netmu.Dtos;
using Netmu.Services.Contracts;
using System.Security.Claims;

namespace Netmu.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class PlaylistsController(IPlaylistService playlistService) : ControllerBase
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

    [HttpPost]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> CreatePlaylist([FromBody] PlaylistDtoRequest request)
    {
        try
        {
            var userId = GetUserIdFromToken();
            var id = await playlistService.CreatePlaylistAsync(userId, request);
            return Ok(new { Id = id });
        }
        catch (UnauthorizedAccessException) { return Unauthorized(); }
    }

    [HttpGet]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetPlaylists()
    {
        try
        {
            var userId = GetUserIdFromToken();
            var res = await playlistService.GetUserPlaylistsAsync(userId);
            return Ok(res);
        }
        catch (UnauthorizedAccessException) { return Unauthorized(); }
    }

    [HttpPut("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> UpdatePlaylist(Guid id, [FromBody] PlaylistDtoRequest request)
    {
        try
        {
            var userId = GetUserIdFromToken();
            await playlistService.UpdatePlaylistAsync(userId, id, request);
            return Ok();
        }
        catch (UnauthorizedAccessException) { return Unauthorized(); }
    }

    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> DeletePlaylist(Guid id)
    {
        try
        {
            var userId = GetUserIdFromToken();
            await playlistService.DeletePlaylistAsync(userId, id);
            return Ok();
        }
        catch (UnauthorizedAccessException) { return Unauthorized(); }
    }

    [HttpGet("{id:guid}/movies")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetPlaylistMovies(Guid id)
    {
        try
        {
            var userId = GetUserIdFromToken();
            var movies = await playlistService.GetPlaylistMoviesAsync(userId, id);
            return Ok(movies);
        }
        catch (UnauthorizedAccessException) { return Unauthorized(); }
    }

    [HttpPost("{id:guid}/movies/{movieId:guid}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> AddMovieToPlaylist(Guid id, Guid movieId)
    {
        try
        {
            var userId = GetUserIdFromToken();
            await playlistService.AddMovieToPlaylistAsync(userId, id, movieId);
            return Ok();
        }
        catch (UnauthorizedAccessException) { return Unauthorized(); }
    }

    [HttpDelete("{id:guid}/movies/{movieId:guid}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> RemoveMovieFromPlaylist(Guid id, Guid movieId)
    {
        try
        {
            var userId = GetUserIdFromToken();
            await playlistService.RemoveMovieFromPlaylistAsync(userId, id, movieId);
            return Ok();
        }
        catch (UnauthorizedAccessException) { return Unauthorized(); }
    }
}
