using System.Text;
using Dapper;
using Hasad.Application.Features.Reporting.Models;

namespace Hasad.Application.Features.Reporting.Services;

public class DynamicQueryEngine : IDynamicQueryEngine
{
    public (string sql, DynamicParameters parameters) BuildQuery(
        ReportRequest request,
        ReportDefinitionMetadata metadata,
        Guid? directorateId,
        Guid? governorateId)
    {
        var parameters = new DynamicParameters();
        int paramCounter = 0;

        // 1. Columns Selection with White-listing
        var validColumns = request.SelectedColumns
            .Where(c => metadata.AllowedFields.ContainsKey(c))
            .Select(c => $"[{c}]")
            .ToList();

        if (!validColumns.Any())
        {
            validColumns = metadata.AllowedFields.Keys.Select(k => $"[{k}]").ToList();
        }

        // 2. Aggregations
        if (request.Aggregates != null && request.Aggregates.Any())
        {
            foreach (var agg in request.Aggregates)
            {
                if (metadata.AllowedFields.ContainsKey(agg.Field) && IsValidAggregate(agg.Function))
                {
                    validColumns.Add($"{agg.Function}([{agg.Field}]) AS [{agg.Field}_{agg.Function}]");
                }
            }
        }

        var sb = new StringBuilder();
        sb.Append($"SELECT {string.Join(", ", validColumns)} FROM [{metadata.DataSourceViewName}] ");

        // 3. WHERE Clause (Common Logic)
        var whereClause = BuildWhereClause(request, directorateId, governorateId, metadata, ref parameters, ref paramCounter);
        sb.Append(whereClause);

        // 4. Group By
        if (request.GroupBy != null && request.GroupBy.Any())
        {
            var validGroups = request.GroupBy
                .Where(g => metadata.AllowedFields.ContainsKey(g))
                .Select(g => $"[{g}]");

            if (validGroups.Any())
            {
                sb.Append($"GROUP BY {string.Join(", ", validGroups)} ");
            }
        }

        // 5. Order By & Paging
        var sort = request.Sorts?.FirstOrDefault(s => metadata.AllowedFields.ContainsKey(s.Field));
        var sortColumn = sort?.Field ?? metadata.DefaultSortField;
        var sortDir = sort?.Direction?.ToUpper() == "DESC" ? "DESC" : "ASC";

        sb.Append($"ORDER BY [{sortColumn}] {sortDir} ");

        if (request.ExportFormat.Equals("JSON", StringComparison.OrdinalIgnoreCase))
        {
            int offset = (request.PageIndex - 1) * request.PageSize;
            sb.Append($"OFFSET {offset} ROWS FETCH NEXT {request.PageSize} ROWS ONLY;");
        }

        return (sb.ToString(), parameters);
    }

    public (string sql, DynamicParameters parameters) BuildCountQuery(
        ReportRequest request,
        ReportDefinitionMetadata metadata,
        Guid? directorateId,
        Guid? governorateId)
    {
        var parameters = new DynamicParameters();
        int paramCounter = 0;

        var sb = new StringBuilder();
        sb.Append($"SELECT COUNT(*) FROM [{metadata.DataSourceViewName}] ");

        var whereClause = BuildWhereClause(request, directorateId, governorateId, metadata, ref parameters, ref paramCounter);
        sb.Append(whereClause);

        return (sb.ToString(), parameters);
    }

    private string BuildWhereClause(
        ReportRequest request,
        Guid? directorateId,
        Guid? governorateId,
        ReportDefinitionMetadata metadata,
        ref DynamicParameters parameters,
        ref int paramCounter)
    {
        var sb = new StringBuilder();
        sb.Append("WHERE 1=1 ");

        // RLS
        if (directorateId.HasValue)
        {
            sb.Append($"AND [DirectorateId] = @p{paramCounter} ");
            parameters.Add($"@p{paramCounter++}", directorateId.Value);
        }
        else if (governorateId.HasValue)
        {
            sb.Append($"AND [GovernorateId] = @p{paramCounter} ");
            parameters.Add($"@p{paramCounter++}", governorateId.Value);
        }

        // Dynamic Filters
        if (request.Filters != null)
        {
            foreach (var filter in request.Filters)
            {
                if (!metadata.AllowedFields.ContainsKey(filter.Field)) continue;
                if (filter.Values == null || !filter.Values.Any()) continue;

                var fieldName = $"[{filter.Field}]";
                switch (filter.Operator.ToUpper())
                {
                    case "EQUALS":
                        sb.Append($"AND {fieldName} = @p{paramCounter} ");
                        parameters.Add($"@p{paramCounter++}", filter.Values[0]);
                        break;
                    case "NOTEQUALS":
                        sb.Append($"AND {fieldName} <> @p{paramCounter} ");
                        parameters.Add($"@p{paramCounter++}", filter.Values[0]);
                        break;
                    case "BETWEEN":
                        if (filter.Values.Count >= 2)
                        {
                            sb.Append($"AND {fieldName} BETWEEN @p{paramCounter} AND @p{paramCounter + 1} ");
                            parameters.Add($"@p{paramCounter++}", filter.Values[0]);
                            parameters.Add($"@p{paramCounter++}", filter.Values[1]);
                        }
                        break;
                    case "IN":
                        var inParams = new List<string>();
                        foreach (var val in filter.Values)
                        {
                            var pName = $"@p{paramCounter++}";
                            inParams.Add(pName);
                            parameters.Add(pName, val);
                        }
                        sb.Append($"AND {fieldName} IN ({string.Join(", ", inParams)}) ");
                        break;
                    case "GREATERTHANOREQUAL":
                        sb.Append($"AND {fieldName} >= @p{paramCounter} ");
                        parameters.Add($"@p{paramCounter++}", filter.Values[0]);
                        break;
                    case "LESSTHANOREQUAL":
                        sb.Append($"AND {fieldName} <= @p{paramCounter} ");
                        parameters.Add($"@p{paramCounter++}", filter.Values[0]);
                        break;
                    case "CONTAINS":
                        sb.Append($"AND {fieldName} LIKE @p{paramCounter} ");
                        parameters.Add($"@p{paramCounter++}", $"%{filter.Values[0]}%");
                        break;
                }
            }
        }

        return sb.ToString();
    }

    private bool IsValidAggregate(string func) =>
        new[] { "SUM", "AVG", "COUNT", "MIN", "MAX" }.Contains(func.ToUpper());
}
