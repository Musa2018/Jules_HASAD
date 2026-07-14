using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class HardenCompensationModule : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "RuleId",
                table: "Compensations",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "CompensationAuditLogs",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CompensationId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    PreviousStatus = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    NewStatus = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ChangedBy = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    ChangedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Reason = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CompensationAuditLogs", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CompensationAuditLogs_Compensations_CompensationId",
                        column: x => x.CompensationId,
                        principalTable: "Compensations",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "CompensationRules",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Multiplier = table.Column<decimal>(type: "decimal(18,4)", precision: 18, scale: 4, nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CompensationRules", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Compensations_RuleId",
                table: "Compensations",
                column: "RuleId");

            migrationBuilder.CreateIndex(
                name: "IX_CompensationAuditLogs_CompensationId",
                table: "CompensationAuditLogs",
                column: "CompensationId");

            migrationBuilder.AddForeignKey(
                name: "FK_Compensations_CompensationRules_RuleId",
                table: "Compensations",
                column: "RuleId",
                principalTable: "CompensationRules",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Compensations_CompensationRules_RuleId",
                table: "Compensations");

            migrationBuilder.DropTable(
                name: "CompensationAuditLogs");

            migrationBuilder.DropTable(
                name: "CompensationRules");

            migrationBuilder.DropIndex(
                name: "IX_Compensations_RuleId",
                table: "Compensations");

            migrationBuilder.DropColumn(
                name: "RuleId",
                table: "Compensations");
        }
    }
}
