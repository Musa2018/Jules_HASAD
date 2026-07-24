using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Sprint14_2_2_DamageReportRefinement : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DamageReports_Farmers_FarmerId",
                table: "DamageReports");

            migrationBuilder.DropIndex(
                name: "IX_DamageReports_FarmerId",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "DamageYear",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "DirectorateId",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "FarmerId",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "GovernorateId",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "Latitude",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "LocalityId",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "Longitude",
                table: "DamageReports");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "DamageYear",
                table: "DamageReports",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<Guid>(
                name: "DirectorateId",
                table: "DamageReports",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "FarmerId",
                table: "DamageReports",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "GovernorateId",
                table: "DamageReports",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<double>(
                name: "Latitude",
                table: "DamageReports",
                type: "float",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "LocalityId",
                table: "DamageReports",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<double>(
                name: "Longitude",
                table: "DamageReports",
                type: "float",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_DamageReports_FarmerId",
                table: "DamageReports",
                column: "FarmerId");

            migrationBuilder.AddForeignKey(
                name: "FK_DamageReports_Farmers_FarmerId",
                table: "DamageReports",
                column: "FarmerId",
                principalTable: "Farmers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
