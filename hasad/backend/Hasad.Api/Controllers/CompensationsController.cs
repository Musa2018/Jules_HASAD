using Asp.Versioning;
using Hasad.Application.Features.Compensations.Commands.CreateCompensation;
using Hasad.Application.Features.Compensations.Commands.UpdateCompensation;
using Hasad.Application.Features.Compensations.Queries.GetCompensationByReportId;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Hasad.Api.Controllers;

[ApiController]
[Route("api/v{version:apiVersion}/[controller]")]
[ApiVersion("1.0")]
[Authorize]
public class CompensationsController : ControllerBase
{
    private readonly IMediator _mediator;

    public CompensationsController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [HttpGet("report/{reportId}")]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer,FieldSurveyor,ReadOnly")]
    public async Task<IActionResult> GetByReportId(Guid reportId)
    {
        var result = await _mediator.Send(new GetCompensationByReportIdQuery(reportId));
        return Ok(result);
    }

    [HttpPost]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer")]
    public async Task<IActionResult> Create([FromBody] CreateCompensationCommand command)
    {
        var result = await _mediator.Send(command);
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }

    [HttpPut("{id}")]
    [Authorize(Roles = "SuperAdmin,Administrator")]
    public async Task<IActionResult> Update(Guid id, [FromBody] UpdateCompensationCommand command)
    {
        if (id != command.Id)
        {
            return BadRequest(new { Errors = new[] { "ID in route does not match ID in body." } });
        }

        var result = await _mediator.Send(command);
        if (result.Succeeded) return Ok(result);

        if (result.Errors.Any(e => e.Contains("CONFLICT")))
        {
            return Conflict(result);
        }

        return BadRequest(result);
    }
}
