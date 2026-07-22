using Asp.Versioning;
using Hasad.Application.Features.ReferenceData.Queries.GetReferenceData;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Hasad.Api.Controllers;

[ApiController]
[Route("api/v{version:apiVersion}/[controller]")]
[ApiVersion("1.0")]
[Authorize]
public class ReferenceDataController : ControllerBase
{
    private readonly IMediator _mediator;

    public ReferenceDataController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [HttpGet]
    public async Task<IActionResult> GetReferenceData()
    {
        var result = await _mediator.Send(new GetReferenceDataQuery());
        return Ok(new { succeeded = true, data = result });
    }
}
