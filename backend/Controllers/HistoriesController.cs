using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Netmu.Dtos;
using Netmu.Services.Contracts;
using System.Security.Claims;

namespace Netmu.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class HistoriesController(IHistoryService service) : ControllerBase
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
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> CreateHistory([FromBody] CreateHistoryDto dto)
    {
        try
        {
            var userId = GetUserIdFromToken();
            await service.CreateAsync(userId, dto);
            return Ok();
        }
        catch (UnauthorizedAccessException) { return Unauthorized(); }
    }

    [HttpGet]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetHistories()
    {
        try
        {
            var userId = GetUserIdFromToken();
            return Ok(await service.GetByUserAsync(userId));
        }
        catch (UnauthorizedAccessException) { return Unauthorized(); }
    }
}
