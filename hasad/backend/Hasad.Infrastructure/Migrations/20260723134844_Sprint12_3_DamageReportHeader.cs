using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Sprint12_3_DamageReportHeader : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DamageReports_DamageCauseCategories_DamageTypeId",
                table: "DamageReports");

            migrationBuilder.DropIndex(
                name: "IX_DamageReports_FarmId_DamageDate",
                table: "DamageReports");

            migrationBuilder.RenameColumn(
                name: "FormNumber",
                table: "DamageReports",
                newName: "PermanentFormNumber");

            migrationBuilder.RenameColumn(
                name: "DamageTypeId",
                table: "DamageReports",
                newName: "DamageCauseCategoryId");

            migrationBuilder.RenameIndex(
                name: "IX_DamageReports_FormNumber",
                table: "DamageReports",
                newName: "IX_DamageReports_PermanentFormNumber");

            migrationBuilder.RenameIndex(
                name: "IX_DamageReports_DamageTypeId",
                table: "DamageReports",
                newName: "IX_DamageReports_DamageCauseCategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_DamageReports_FarmId_DamageDate_DamageCauseId",
                table: "DamageReports",
                columns: new[] { "FarmId", "DamageDate", "DamageCauseId" },
                unique: true,
                filter: "[IsDeleted] = 0");

            migrationBuilder.AddForeignKey(
                name: "FK_DamageReports_DamageCauseCategories_DamageCauseCategoryId",
                table: "DamageReports",
                column: "DamageCauseCategoryId",
                principalTable: "DamageCauseCategories",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DamageReports_DamageCauseCategories_DamageCauseCategoryId",
                table: "DamageReports");

            migrationBuilder.DropIndex(
                name: "IX_DamageReports_FarmId_DamageDate_DamageCauseId",
                table: "DamageReports");

            migrationBuilder.RenameColumn(
                name: "PermanentFormNumber",
                table: "DamageReports",
                newName: "FormNumber");

            migrationBuilder.RenameColumn(
                name: "DamageCauseCategoryId",
                table: "DamageReports",
                newName: "DamageTypeId");

            migrationBuilder.RenameIndex(
                name: "IX_DamageReports_PermanentFormNumber",
                table: "DamageReports",
                newName: "IX_DamageReports_FormNumber");

            migrationBuilder.RenameIndex(
                name: "IX_DamageReports_DamageCauseCategoryId",
                table: "DamageReports",
                newName: "IX_DamageReports_DamageTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_DamageReports_FarmId_DamageDate",
                table: "DamageReports",
                columns: new[] { "FarmId", "DamageDate" },
                unique: true,
                filter: "[IsDeleted] = 0");

            migrationBuilder.AddForeignKey(
                name: "FK_DamageReports_DamageCauseCategories_DamageTypeId",
                table: "DamageReports",
                column: "DamageTypeId",
                principalTable: "DamageCauseCategories",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
