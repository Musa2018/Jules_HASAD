using Asp.Versioning;
using Hasad.Application.Features.Users.Queries.GetDirectorates;
using Hasad.Application.Features.Users.Queries.GetGovernorates;
using Hasad.Application.Features.Users.Queries.GetRoles;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Hasad.Api.Controllers;

[ApiController]
[Route("api/v{version:apiVersion}/[controller]")]
[ApiVersion("1.0")]
[Authorize(Roles = "SuperAdmin")]
public class UsersController : ControllerBase
{
    private readonly IMediator _mediator;

    public UsersController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [HttpGet("roles")]
    public async Task<IActionResult> GetRoles()
    {
        var result = await _mediator.Send(new GetRolesQuery());
        return Ok(result);
    }

    [HttpGet("governorates")]
    public async Task<IActionResult> GetGovernorates()
    {
        var result = await _mediator.Send(new GetGovernoratesQuery());
        return Ok(result);
    }

    [HttpGet("directorates")]
    public async Task<IActionResult> GetDirectorates([FromQuery] Guid? governorateId)
    {
        var result = await _mediator.Send(new GetDirectoratesQuery(governorateId));
        return Ok(result);
    }
}
