using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Sprint14_UpdateIdentityUniqueness : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Farmers_IdTypeId_IdNumber",
                table: "Farmers");

            migrationBuilder.CreateIndex(
                name: "IX_Farmers_IdNumber",
                table: "Farmers",
                column: "IdNumber",
                unique: true,
                filter: "[IsDeleted] = 0");

            migrationBuilder.CreateIndex(
                name: "IX_Farmers_IdTypeId",
                table: "Farmers",
                column: "IdTypeId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Farmers_IdNumber",
                table: "Farmers");

            migrationBuilder.DropIndex(
                name: "IX_Farmers_IdTypeId",
                table: "Farmers");

            migrationBuilder.CreateIndex(
                name: "IX_Farmers_IdTypeId_IdNumber",
                table: "Farmers",
                columns: new[] { "IdTypeId", "IdNumber" },
                unique: true,
                filter: "[IsDeleted] = 0");
        }
    }
}
