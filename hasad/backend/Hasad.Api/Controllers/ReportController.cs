using System.Diagnostics;
using Dapper;
using Hasad.Application.Common.Interfaces;
using Hasad.Application.Features.Reporting.Models;
using Hasad.Application.Features.Reporting.Services;
using Hasad.Domain.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Hasad.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class ReportController : ControllerBase
{
    private readonly IReportMetadataService _metadataService;
    private readonly IDynamicQueryEngine _queryEngine;
    private readonly IReportExportService _exportService;
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public ReportController(
        IReportMetadataService metadataService,
        IDynamicQueryEngine queryEngine,
        IReportExportService exportService,
        IApplicationDbContext context,
        ICurrentUserService currentUser)
    {
        _metadataService = metadataService;
        _queryEngine = queryEngine;
        _exportService = exportService;
        _context = context;
        _currentUser = currentUser;
    }

    [HttpGet("{id}/metadata")]
    public async Task<ActionResult<ReportDefinitionMetadata>> GetMetadata(string id)
    {
        var metadata = await _metadataService.GetMetadataAsync(id);
        if (metadata == null) return NotFound($"Report with ID '{id}' not found.");
        return Ok(metadata);
    }

    [HttpPost("execute")]
    public async Task<ActionResult<ReportResultDto>> Execute([FromBody] ReportRequest request)
    {
        var metadata = await _metadataService.GetMetadataAsync(request.ReportId);
        if (metadata == null) return BadRequest("Invalid Report ID.");

        var stopwatch = Stopwatch.StartNew();

        try
        {
            using var connection = _context.Database.GetDbConnection();

            // 1. Get Total Count
            var (countSql, countParams) = _queryEngine.BuildCountQuery(
                request,
                metadata,
                _currentUser.DirectorateId,
                _currentUser.GovernorateId);

            var totalCount = await connection.ExecuteScalarAsync<int>(countSql, countParams);

            // 2. Build and Execute Data Query
            var (sql, parameters) = _queryEngine.BuildQuery(
                request,
                metadata,
                _currentUser.DirectorateId,
                _currentUser.GovernorateId);

            var results = (await connection.QueryAsync<dynamic>(sql, parameters)).ToList();

            stopwatch.Stop();

            var rowDictionaries = results.Select(r => (IDictionary<string, object>)r).ToList();

            // 3. Record Execution Log
            await LogExecutionAsync(request.ReportId, (int)stopwatch.ElapsedMilliseconds, rowDictionaries.Count, request.ExportFormat);

            return Ok(new ReportResultDto
            {
                ReportId = request.ReportId,
                Columns = rowDictionaries.FirstOrDefault()?.Keys.ToList() ?? new List<string>(),
                Rows = rowDictionaries,
                PageIndex = request.PageIndex,
                PageSize = request.PageSize,
                TotalCount = totalCount
            });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Error executing report: {ex.Message}");
        }
    }

    [HttpPost("export/excel")]
    public async Task<IActionResult> ExportExcel([FromBody] ReportRequest request)
    {
        request.ExportFormat = "EXCEL";
        request.PageSize = 100000; // Large threshold for export
        request.PageIndex = 1;

        var data = await GetReportDataAsync(request);
        if (data == null) return BadRequest("Invalid Report ID or Query.");

        var fileBytes = await _exportService.ExportToExcelAsync(data);

        await LogExecutionAsync(request.ReportId, 0, data.Count, "EXCEL");

        return File(fileBytes, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", $"{request.ReportId}_{DateTime.Now:yyyyMMdd}.xlsx");
    }

    [HttpPost("export/pdf")]
    public async Task<IActionResult> ExportPdf([FromBody] ReportRequest request)
    {
        request.ExportFormat = "PDF";
        request.PageSize = 5000; // Reasonable threshold for PDF
        request.PageIndex = 1;

        var metadata = await _metadataService.GetMetadataAsync(request.ReportId);
        if (metadata == null) return BadRequest("Invalid Report ID.");

        var data = await GetReportDataAsync(request);
        if (data == null) return BadRequest("Invalid Query.");

        var fileBytes = await _exportService.ExportToPdfAsync(metadata.Title, data);

        await LogExecutionAsync(request.ReportId, 0, data.Count, "PDF");

        return File(fileBytes, "application/pdf", $"{request.ReportId}_{DateTime.Now:yyyyMMdd}.pdf");
    }

    private async Task<List<IDictionary<string, object>>?> GetReportDataAsync(ReportRequest request)
    {
        var metadata = await _metadataService.GetMetadataAsync(request.ReportId);
        if (metadata == null) return null;

        var (sql, parameters) = _queryEngine.BuildQuery(
            request,
            metadata,
            _currentUser.DirectorateId,
            _currentUser.GovernorateId);

        using var connection = _context.Database.GetDbConnection();
        var results = (await connection.QueryAsync<dynamic>(sql, parameters)).ToList();

        return results.Select(r => (IDictionary<string, object>)r).ToList();
    }

    private async Task LogExecutionAsync(string reportId, int durationMs, int rowsReturned, string format)
    {
        var log = new ReportExecutionLog
        {
            ReportId = reportId,
            UserId = _currentUser.UserId ?? "System",
            ExecutedAt = DateTime.UtcNow,
            ExecutionDurationMs = durationMs,
            RowsReturned = rowsReturned,
            ExportFormat = format
        };
        _context.ReportExecutionLogs.Add(log);
        await _context.SaveChangesAsync(CancellationToken.None);
    }
}
