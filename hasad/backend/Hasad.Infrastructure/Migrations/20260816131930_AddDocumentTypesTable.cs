using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddDocumentTypesTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "DocumentTypes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NameAr = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsRequired = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DocumentTypes", x => x.Id);
                });

            migrationBuilder.InsertData(
                table: "DocumentTypes",
                columns: new[] { "Id", "IsActive", "IsRequired", "NameAr", "NameEn" },
                values: new object[,]
                {
                    { 1, true, false, "صورة الموقع", "Site Photo" },
                    { 2, true, false, "صورة الهوية", "ID Photo" },
                    { 3, true, false, "وثيقة ملكية", "Ownership Document" },
                    { 4, true, false, "استمارة حصر الأضرار", "Damage Assessment Form" },
                    { 5, true, false, "قرار وزاري", "Ministerial Decision" },
                    { 6, true, false, "قرار مدير عام", "Director General Decision" },
                    { 7, true, false, "قرار داخلي", "Internal Decision" },
                    { 8, true, false, "شهادة ضرر", "Damage Certificate" },
                    { 9, true, false, "أخرى", "Other" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_DamageReportAttachments_DocumentTypeId",
                table: "DamageReportAttachments",
                column: "DocumentTypeId");

            migrationBuilder.AddForeignKey(
                name: "FK_DamageReportAttachments_DocumentTypes_DocumentTypeId",
                table: "DamageReportAttachments",
                column: "DocumentTypeId",
                principalTable: "DocumentTypes",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DamageReportAttachments_DocumentTypes_DocumentTypeId",
                table: "DamageReportAttachments");

            migrationBuilder.DropTable(
                name: "DocumentTypes");

            migrationBuilder.DropIndex(
                name: "IX_DamageReportAttachments_DocumentTypeId",
                table: "DamageReportAttachments");
        }
    }
}
