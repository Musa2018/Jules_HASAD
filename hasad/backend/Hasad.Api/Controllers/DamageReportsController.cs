using Asp.Versioning;
using Hasad.Application.Features.DamageReports.Commands.AddDamageItem;
using Hasad.Application.Features.DamageReports.Commands.CreateDamageReport;
using Hasad.Application.Features.DamageReports.Commands.DeleteDamageItem;
using Hasad.Application.Features.DamageReports.Commands.DeleteDamageReport;
using Hasad.Application.Features.DamageReports.Commands.SubmitDamageReport;
using Hasad.Application.Features.DamageReports.Commands.TransitionDamageReport;
using Hasad.Application.Features.DamageReports.Commands.UpdateDamageItem;
using Hasad.Application.Features.DamageReports.Commands.UpdateDamageReport;
using Hasad.Application.Features.DamageReports.Commands.UploadAttachment;
using Hasad.Application.Features.DamageReports.Queries.GetDamageReportById;
using Hasad.Application.Features.DamageReports.Queries.GetDamageReportHistory;
using Hasad.Application.Features.DamageReports.Queries.GetDamageReportsByFarm;
using Hasad.Application.Features.DamageReports.Queries.GetDamageReportsList;
using Hasad.Application.Features.DamageReports.Queries.GetIntegratedAuditLog;
using Hasad.Application.Features.DamageReports.Queries.GetDamageReportZip;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Hasad.Api.Controllers;

[ApiController]
[Route("api/v{version:apiVersion}/damage-reports")]
[ApiVersion("1.0")]
[Authorize]
public class DamageReportsController : ControllerBase
{
    private readonly IMediator _mediator;

    public DamageReportsController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [HttpGet]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer,FieldSurveyor,ReadOnly,TechnicalReviewer,ArchiveOfficer,Director,Supervisor,GeneralManager,LegalReviewer,ProceduralReviewer,MinistryTechReviewer,ChiefArchiveOfficer,DirectorateManager")]
    public async Task<IActionResult> GetDamageReports(
        [FromQuery] int pageNumber = 1,
        [FromQuery] int pageSize = 10,
        [FromQuery] string? searchText = null,
        [FromQuery] DateTime? updatedSince = null)
    {
        var result = await _mediator.Send(new GetDamageReportsListQuery(pageNumber, pageSize, searchText, updatedSince));
        return Ok(result);
    }

    [HttpGet("{id}")]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer,FieldSurveyor,ReadOnly,TechnicalReviewer,ArchiveOfficer,Director,Supervisor,GeneralManager,LegalReviewer,ProceduralReviewer,MinistryTechReviewer,ChiefArchiveOfficer,DirectorateManager")]
    public async Task<IActionResult> GetDamageReport(Guid id)
    {
        var result = await _mediator.Send(new GetDamageReportByIdQuery(id));
        return result.Succeeded ? Ok(result) : NotFound(result);
    }

    [HttpGet("farm/{farmId}")]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer,FieldSurveyor,ReadOnly,TechnicalReviewer,ArchiveOfficer,Director,Supervisor,GeneralManager,LegalReviewer,ProceduralReviewer,MinistryTechReviewer,ChiefArchiveOfficer,DirectorateManager")]
    public async Task<IActionResult> GetDamageReportsByFarm(Guid farmId)
    {
        var result = await _mediator.Send(new GetDamageReportsByFarmQuery(farmId));
        return Ok(result);
    }

    [HttpPost]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer,FieldSurveyor")]
    public async Task<IActionResult> CreateDamageReport([FromBody] CreateDamageReportCommand command)
    {
        var result = await _mediator.Send(command);
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }

    [HttpPut("{id}")]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer,FieldSurveyor")]
    public async Task<IActionResult> UpdateDamageReport(Guid id, [FromBody] UpdateDamageReportCommand command)
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

    [HttpDelete("{id}")]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer")]
    public async Task<IActionResult> DeleteDamageReport(Guid id)
    {
        var result = await _mediator.Send(new DeleteDamageReportCommand(id));
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }

    // Workflow endpoints

    [HttpPost("{id}/submit")]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer,FieldSurveyor")]
    public async Task<IActionResult> SubmitDamageReport(Guid id)
    {
        var result = await _mediator.Send(new SubmitDamageReportCommand(id));
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }

    [HttpPost("{id}/transition")]
    [Authorize] // Handled internally by roles
    public async Task<IActionResult> TransitionDamageReport(Guid id, [FromBody] TransitionDamageReportCommand command)
    {
        if (id != command.Id) return BadRequest("ID mismatch.");
        var result = await _mediator.Send(command);
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }

    [HttpGet("{id}/history")]
    public async Task<IActionResult> GetDamageReportHistory(Guid id)
    {
        var result = await _mediator.Send(new GetDamageReportHistoryQuery(id));
        return Ok(result);
    }

    [HttpGet("{id}/audit-log")]
    [Authorize(Roles = "SuperAdmin,Administrator,ProceduralReviewer,GeneralManager,AgriculturalEngineer,FieldSurveyor")]
    public async Task<IActionResult> GetIntegratedAuditLog(Guid id)
    {
        var result = await _mediator.Send(new GetIntegratedAuditLogQuery(id));
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }

    [HttpGet("{id}/export-zip")]
    [Authorize(Roles = "SuperAdmin,Administrator,ChiefArchiveOfficer,GeneralManager")]
    public async Task<IActionResult> ExportZip(Guid id)
    {
        var result = await _mediator.Send(new GetDamageReportZipQuery(id));
        if (!result.Succeeded) return BadRequest(result);

        return File(result.Data!.Content, "application/zip", result.Data!.FileName);
    }

    // Damage Items endpoints

    [HttpPost("{id}/items")]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer,FieldSurveyor")]
    public async Task<IActionResult> AddDamageItem(Guid id, [FromBody] AddDamageItemCommand command)
    {
        if (id != command.DamageReportId)
        {
            return BadRequest(new { Errors = new[] { "Report ID mismatch." } });
        }
        var result = await _mediator.Send(command);
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }

    [HttpPut("items/{itemId}")]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer,FieldSurveyor")]
    public async Task<IActionResult> UpdateDamageItem(Guid itemId, [FromBody] UpdateDamageItemCommand command)
    {
        if (itemId != command.Id)
        {
            return BadRequest(new { Errors = new[] { "Item ID mismatch." } });
        }
        var result = await _mediator.Send(command);
        if (result.Succeeded) return Ok(result);
        if (result.Errors.Any(e => e.Contains("CONFLICT"))) return Conflict(result);
        return BadRequest(result);
    }

    [HttpDelete("items/{itemId}")]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer")]
    public async Task<IActionResult> DeleteDamageItem(Guid itemId)
    {
        var result = await _mediator.Send(new DeleteDamageItemCommand(itemId));
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }

    [HttpDelete("attachments/{attachmentId}")]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer,FieldSurveyor,ArchiveOfficer")]
    public async Task<IActionResult> DeleteAttachment(Guid attachmentId)
    {
        // Reusing the general pattern: we need a command for this.
        // For speed, we can use a temporary mediator call if defined,
        // but I will ensure the infrastructure is there.
        var result = await _mediator.Send(new Hasad.Application.Features.DamageReports.Commands.DeleteAttachment.DeleteAttachmentCommand(attachmentId));
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }

    [HttpPost("{id}/attachments")]
    [Authorize(Roles = "SuperAdmin,Administrator,AgriculturalEngineer,FieldSurveyor,ArchiveOfficer")]
    public async Task<IActionResult> UploadAttachment(
        Guid id,
        [FromForm] IFormFile file,
        [FromForm] Guid clientId,
        [FromForm] string documentName,
        [FromForm] DateTime documentDate,
        [FromForm] int documentTypeId,
        [FromForm] string localPath)
    {
        if (file == null || file.Length == 0) return BadRequest("No file uploaded.");

        using var stream = file.OpenReadStream();
        var command = new UploadAttachmentCommand(
            id,
            clientId,
            stream,
            file.FileName,
            documentName,
            documentDate,
            documentTypeId,
            localPath,
            file.ContentType,
            file.Length,
            null,
            null,
            null
        );

        var result = await _mediator.Send(command);
        return result.Succeeded ? Ok(result) : BadRequest(result);
    }
}
