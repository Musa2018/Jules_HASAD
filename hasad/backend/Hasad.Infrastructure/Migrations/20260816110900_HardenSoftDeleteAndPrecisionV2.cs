using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class HardenSoftDeleteAndPrecisionV2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "DamageWorkflowHistories",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DeletedBy",
                table: "DamageWorkflowHistories",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "DamageWorkflowHistories",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "DamageReportAttachments",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DeletedBy",
                table: "DamageReportAttachments",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "DamageReportAttachments",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "AssistanceAuditLogs",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DeletedBy",
                table: "AssistanceAuditLogs",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "AssistanceAuditLogs",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "DamageWorkflowHistories");

            migrationBuilder.DropColumn(
                name: "DeletedBy",
                table: "DamageWorkflowHistories");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "DamageWorkflowHistories");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "DamageReportAttachments");

            migrationBuilder.DropColumn(
                name: "DeletedBy",
                table: "DamageReportAttachments");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "DamageReportAttachments");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "AssistanceAuditLogs");

            migrationBuilder.DropColumn(
                name: "DeletedBy",
                table: "AssistanceAuditLogs");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "AssistanceAuditLogs");
        }
    }
}
