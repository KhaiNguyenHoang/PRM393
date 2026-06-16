using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Netmu.Dtos;
using Netmu.Services.Contracts;

namespace Netmu.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class MoviesController(IMovieService service) : ControllerBase
{
    [HttpPost]
    [Authorize(Roles = "admin")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> CreateMovie([FromBody] MovieDtoRequest request)
    {
        var id = await service.CreateMovieAsync(request);
        return CreatedAtAction(nameof(GetMovie), new { id }, id);
    }

    [HttpGet]
    [Route("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetMovie(Guid id)
    {
        return Ok(await service.GetMovieAsync(id));
    }

    [HttpGet]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetMovies([FromQuery] PaginationParam param)
    {
        return Ok(await service.GetMoviesAsync(param));
    }

    [HttpPut]
    [Route("{id:guid}")]
    [Authorize(Roles = "admin")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> UpdateMovie(Guid id, [FromBody] MovieDtoRequest request)
    {
        return Ok(await service.UpdateMovieAsync(id, request));
    }

    [HttpDelete]
    [Route("{id:guid}")]
    [Authorize(Roles = "admin")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> DeleteMovie(Guid id)
    {
        await service.DeleteMovieAsync(id);
        return NoContent();
    }
}