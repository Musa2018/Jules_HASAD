using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class DropCoordinatesFromDamageReportFinal : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CompanyName",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "Latitude",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "Longitude",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "SettlementName",
                table: "DamageReports");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "CompanyName",
                table: "DamageReports",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<double>(
                name: "Latitude",
                table: "DamageReports",
                type: "float",
                nullable: true);

            migrationBuilder.AddColumn<double>(
                name: "Longitude",
                table: "DamageReports",
                type: "float",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "SettlementName",
                table: "DamageReports",
                type: "nvarchar(max)",
                nullable: true);
        }
    }
}
