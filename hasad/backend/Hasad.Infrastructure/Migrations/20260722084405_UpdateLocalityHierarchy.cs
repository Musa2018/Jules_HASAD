using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class UpdateLocalityHierarchy : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "DirectorateId",
                table: "Localities",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            // Data Migration: Assign first available Directorate to existing Localities in the same Governorate
            migrationBuilder.Sql(@"
                UPDATE l
                SET l.DirectorateId = (
                    SELECT TOP 1 d.Id
                    FROM Directorates d
                    WHERE d.GovernorateId = l.GovernorateId
                )
                FROM Localities l
                WHERE l.DirectorateId = '00000000-0000-0000-0000-000000000000'
            ");

            migrationBuilder.CreateIndex(
                name: "IX_Localities_DirectorateId",
                table: "Localities",
                column: "DirectorateId");

            migrationBuilder.AddForeignKey(
                name: "FK_Localities_Directorates_DirectorateId",
                table: "Localities",
                column: "DirectorateId",
                principalTable: "Directorates",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Localities_Directorates_DirectorateId",
                table: "Localities");

            migrationBuilder.DropIndex(
                name: "IX_Localities_DirectorateId",
                table: "Localities");

            migrationBuilder.DropColumn(
                name: "DirectorateId",
                table: "Localities");
        }
    }
}
