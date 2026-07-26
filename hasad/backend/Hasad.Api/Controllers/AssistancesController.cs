using Asp.Versioning;
using Hasad.Application.Features.Assistances.Commands.CreateAssistance;
using Hasad.Application.Features.Assistances.Commands.UpdateAssistance;
using Hasad.Application.Features.Assistances.Commands.ApproveAssistance;
using Hasad.Application.Features.Assistances.Commands.RejectAssistance;
using Hasad.Application.Features.Assistances.Commands.MarkAsPaidAssistance;
using Hasad.Application.Features.Assistances.Commands.RecalculateAssistance;
using Hasad.Application.Features.Assistances.Commands.SubmitAssistance;
using Hasad.Application.Features.Assistances.Queries.GetAssistanceByReportId;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Hasad.Api.Controllers;

[ApiController]
[Route("api/v{version:apiVersion}/[controller]")]
[ApiVersion("1.0")]
[Authorize]
public class AssistancesController : ControllerBase
{
    private readonly IMediator _mediator;

    public AssistancesController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [HttpGet("report/{reportId}")]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer,FieldSurveyor,ReadOnly")]
    public async Task<IActionResult> GetByReportId(Guid reportId)
    {
        var result = await _mediator.Send(new GetAssistanceByReportIdQuery(reportId));
        return Ok(result);
    }

    [HttpPost]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer")]
    public async Task<IActionResult> Create([FromBody] CreateAssistanceCommand command)
    {
        var result = await _mediator.Send(command);
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }

    [HttpPost("{id}/recalculate")]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer")]
    public async Task<IActionResult> Recalculate(Guid id, [FromBody] RecalculateAssistanceCommand command)
    {
        if (id != command.Id) return BadRequest(new { Errors = new[] { "ID mismatch." } });
        var result = await _mediator.Send(command);
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }

    [HttpPost("{id}/submit")]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer")]
    public async Task<IActionResult> Submit(Guid id, [FromBody] SubmitAssistanceCommand command)
    {
        if (id != command.Id) return BadRequest(new { Errors = new[] { "ID mismatch." } });
        var result = await _mediator.Send(command);
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }

    [HttpPost("{id}/approve")]
    [Authorize(Roles = "SuperAdmin,Administrator")]
    public async Task<IActionResult> Approve(Guid id, [FromBody] ApproveAssistanceCommand command)
    {
        if (id != command.Id) return BadRequest(new { Errors = new[] { "ID mismatch." } });
        var result = await _mediator.Send(command);
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }

    [HttpPost("{id}/reject")]
    [Authorize(Roles = "SuperAdmin,Administrator")]
    public async Task<IActionResult> Reject(Guid id, [FromBody] RejectAssistanceCommand command)
    {
        if (id != command.Id) return BadRequest(new { Errors = new[] { "ID mismatch." } });
        var result = await _mediator.Send(command);
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }

    [HttpPost("{id}/pay")]
    [Authorize(Roles = "SuperAdmin,Administrator")]
    public async Task<IActionResult> MarkAsPaid(Guid id, [FromBody] MarkAsPaidAssistanceCommand command)
    {
        if (id != command.Id) return BadRequest(new { Errors = new[] { "ID mismatch." } });
        var result = await _mediator.Send(command);
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }
}
