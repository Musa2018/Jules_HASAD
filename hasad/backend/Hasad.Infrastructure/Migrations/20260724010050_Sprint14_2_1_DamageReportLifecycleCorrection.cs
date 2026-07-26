using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Sprint14_2_1_DamageReportLifecycleCorrection : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_DamageReports_FarmId_DamageDate_DamageCauseId",
                table: "DamageReports");

            migrationBuilder.AddColumn<string>(
                name: "Code",
                table: "Directorates",
                type: "nvarchar(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "DamageNatureId",
                table: "DamageReports",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "ReportNumber",
                table: "DamageReports",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");

            // Backfill unique values before creating unique indexes
            migrationBuilder.Sql("UPDATE Directorates SET Code = LEFT(CAST(Id AS NVARCHAR(36)), 20)");
            migrationBuilder.Sql("UPDATE DamageReports SET ReportNumber = PermanentFormNumber WHERE PermanentFormNumber <> ''");
            migrationBuilder.Sql("UPDATE DamageReports SET ReportNumber = CAST(Id AS NVARCHAR(36)) WHERE ReportNumber = ''");

            migrationBuilder.CreateTable(
                name: "DamageReportSequences",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DirectorateId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DamageYear = table.Column<int>(type: "int", nullable: false),
                    LastSequence = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DamageReportSequences", x => x.Id);
                    table.ForeignKey(
                        name: "FK_DamageReportSequences_Directorates_DirectorateId",
                        column: x => x.DirectorateId,
                        principalTable: "Directorates",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Directorates_Code",
                table: "Directorates",
                column: "Code",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_DamageReports_DamageNatureId",
                table: "DamageReports",
                column: "DamageNatureId");

            migrationBuilder.CreateIndex(
                name: "IX_DamageReports_FarmId_DamageDate",
                table: "DamageReports",
                columns: new[] { "FarmId", "DamageDate" },
                unique: true,
                filter: "[IsDeleted] = 0");

            migrationBuilder.CreateIndex(
                name: "IX_DamageReports_ReportNumber",
                table: "DamageReports",
                column: "ReportNumber",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_DamageReportSequences_DirectorateId_DamageYear",
                table: "DamageReportSequences",
                columns: new[] { "DirectorateId", "DamageYear" },
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_DamageReports_DamageNatures_DamageNatureId",
                table: "DamageReports",
                column: "DamageNatureId",
                principalTable: "DamageNatures",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DamageReports_DamageNatures_DamageNatureId",
                table: "DamageReports");

            migrationBuilder.DropTable(
                name: "DamageReportSequences");

            migrationBuilder.DropIndex(
                name: "IX_Directorates_Code",
                table: "Directorates");

            migrationBuilder.DropIndex(
                name: "IX_DamageReports_DamageNatureId",
                table: "DamageReports");

            migrationBuilder.DropIndex(
                name: "IX_DamageReports_FarmId_DamageDate",
                table: "DamageReports");

            migrationBuilder.DropIndex(
                name: "IX_DamageReports_ReportNumber",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "Code",
                table: "Directorates");

            migrationBuilder.DropColumn(
                name: "DamageNatureId",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "ReportNumber",
                table: "DamageReports");

            migrationBuilder.CreateIndex(
                name: "IX_DamageReports_FarmId_DamageDate_DamageCauseId",
                table: "DamageReports",
                columns: new[] { "FarmId", "DamageDate", "DamageCauseId" },
                unique: true,
                filter: "[IsDeleted] = 0");
        }
    }
}
