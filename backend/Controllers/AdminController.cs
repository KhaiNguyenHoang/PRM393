using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Netmu.Services.Contracts;

namespace Netmu.Controllers;

[ApiController]
[Route("api/admin/[controller]")]
[Authorize(Roles = "admin")]
public class UsersController(IAdminUserService service) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll() => Ok(await service.GetAllAsync());

    [HttpPost("{id:guid}/ban")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Ban(Guid id)
    {
        await service.BanAsync(id);
        return Ok();
    }

    [HttpPost("{id:guid}/unban")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Unban(Guid id)
    {
        await service.UnbanAsync(id);
        return Ok();
    }
}

[ApiController]
[Route("api/admin/[controller]")]
[Authorize(Roles = "admin")]
public class AnalyticsController(IAdminUserService service) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> Get() => Ok(await service.GetAnalyticsAsync());
}
