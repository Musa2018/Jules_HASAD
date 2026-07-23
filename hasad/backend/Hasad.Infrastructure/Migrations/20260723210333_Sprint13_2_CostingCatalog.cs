using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Sprint13_2_CostingCatalog : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DamageItems_CostingSheets_CostingSheetId",
                table: "DamageItems");

            migrationBuilder.DropForeignKey(
                name: "FK_Farms_AreaUnits_AreaUnitId",
                table: "Farms");

            // --- Phase 1: Create New Structure ---
            migrationBuilder.CreateTable(
                name: "CostingSheetCatalogs",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                    CreatedBy = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CostingSheetCatalogs", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "MeasurementUnits",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NameAr = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Code = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Category = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MeasurementUnits", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "CostingSheetVersions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CatalogId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    VersionNumber = table.Column<int>(type: "int", nullable: false),
                    Status = table.Column<int>(type: "int", nullable: false),
                    EffectiveFrom = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EffectiveTo = table.Column<DateTime>(type: "datetime2", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                    CreatedBy = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ApprovedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    ApprovedBy = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CostingSheetVersions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CostingSheetVersions_CostingSheetCatalogs_CatalogId",
                        column: x => x.CatalogId,
                        principalTable: "CostingSheetCatalogs",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "CostingSheetItems",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    VersionId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ClassificationId = table.Column<int>(type: "int", nullable: false),
                    MeasurementUnitId = table.Column<int>(type: "int", nullable: true),
                    UnitPrice = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CostingSheetItems", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CostingSheetItems_CostingSheetVersions_VersionId",
                        column: x => x.VersionId,
                        principalTable: "CostingSheetVersions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CostingSheetItems_DamageClassifications_ClassificationId",
                        column: x => x.ClassificationId,
                        principalTable: "DamageClassifications",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_CostingSheetItems_MeasurementUnits_MeasurementUnitId",
                        column: x => x.MeasurementUnitId,
                        principalTable: "MeasurementUnits",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            // --- Phase 2: Data Preservation & Legacy Migration ---

            // 2.1 Seed Measurement Units (to maintain FKs)
            migrationBuilder.Sql("SET IDENTITY_INSERT MeasurementUnits ON");
            migrationBuilder.Sql("INSERT INTO MeasurementUnits (Id, NameAr, NameEn, Category) SELECT Id, NameAr, NameEn, 'Area' FROM AreaUnits");
            migrationBuilder.Sql("SET IDENTITY_INSERT MeasurementUnits OFF");

            // 2.2 Create Legacy Catalog and Version
            var legacyCatalogId = Guid.NewGuid();
            var legacyVersionId = Guid.NewGuid();

            migrationBuilder.Sql($@"
                INSERT INTO CostingSheetCatalogs (Id, Name, Description, CreatedAt, CreatedBy)
                VALUES ('{legacyCatalogId}', 'Legacy Catalog', 'Historical pricing data imported from legacy system.', GETUTCDATE(), 'System');

                INSERT INTO CostingSheetVersions (Id, CatalogId, VersionNumber, Status, EffectiveFrom, CreatedAt, CreatedBy)
                VALUES ('{legacyVersionId}', '{legacyCatalogId}', 1, 2 /* Active */, '2000-01-01', GETUTCDATE(), 'System');
            ");

            // 2.3 Migrate Costing Sheets to Items
            migrationBuilder.Sql($@"
                INSERT INTO CostingSheetItems (Id, VersionId, ClassificationId, UnitPrice, CreatedAt)
                SELECT Id, '{legacyVersionId}', ClassificationId, UnitPrice, CreatedAt
                FROM CostingSheets;
            ");

            // --- Phase 3: Column Renames ---
            migrationBuilder.RenameColumn(
                name: "AreaUnitId",
                table: "Farms",
                newName: "MeasurementUnitId");

            migrationBuilder.RenameIndex(
                name: "IX_Farms_AreaUnitId",
                table: "Farms",
                newName: "IX_Farms_MeasurementUnitId");

            migrationBuilder.RenameColumn(
                name: "CostingSheetId",
                table: "DamageItems",
                newName: "CostingSheetItemId");

            migrationBuilder.RenameIndex(
                name: "IX_DamageItems_CostingSheetId",
                table: "DamageItems",
                newName: "IX_DamageItems_CostingSheetItemId");

            // --- Phase 4: Constraints & Cleanup ---
            migrationBuilder.DropTable(
                name: "AreaUnits");

            migrationBuilder.DropTable(
                name: "CostingSheets");

            migrationBuilder.CreateIndex(
                name: "IX_CostingSheetItems_ClassificationId",
                table: "CostingSheetItems",
                column: "ClassificationId");

            migrationBuilder.CreateIndex(
                name: "IX_CostingSheetItems_MeasurementUnitId",
                table: "CostingSheetItems",
                column: "MeasurementUnitId");

            migrationBuilder.CreateIndex(
                name: "IX_CostingSheetItems_VersionId",
                table: "CostingSheetItems",
                column: "VersionId");

            migrationBuilder.CreateIndex(
                name: "IX_CostingSheetVersions_CatalogId",
                table: "CostingSheetVersions",
                column: "CatalogId");

            migrationBuilder.AddForeignKey(
                name: "FK_DamageItems_CostingSheetItems_CostingSheetItemId",
                table: "DamageItems",
                column: "CostingSheetItemId",
                principalTable: "CostingSheetItems",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Farms_MeasurementUnits_MeasurementUnitId",
                table: "Farms",
                column: "MeasurementUnitId",
                principalTable: "MeasurementUnits",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DamageItems_CostingSheetItems_CostingSheetItemId",
                table: "DamageItems");

            migrationBuilder.DropForeignKey(
                name: "FK_Farms_MeasurementUnits_MeasurementUnitId",
                table: "Farms");

            migrationBuilder.DropTable(
                name: "CostingSheetItems");

            migrationBuilder.DropTable(
                name: "CostingSheetVersions");

            migrationBuilder.DropTable(
                name: "MeasurementUnits");

            migrationBuilder.DropTable(
                name: "CostingSheetCatalogs");

            migrationBuilder.RenameColumn(
                name: "MeasurementUnitId",
                table: "Farms",
                newName: "AreaUnitId");

            migrationBuilder.RenameIndex(
                name: "IX_Farms_MeasurementUnitId",
                table: "Farms",
                newName: "IX_Farms_AreaUnitId");

            migrationBuilder.RenameColumn(
                name: "CostingSheetItemId",
                table: "DamageItems",
                newName: "CostingSheetId");

            migrationBuilder.RenameIndex(
                name: "IX_DamageItems_CostingSheetItemId",
                table: "DamageItems",
                newName: "IX_DamageItems_CostingSheetId");

            migrationBuilder.CreateTable(
                name: "AreaUnits",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NameAr = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AreaUnits", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "CostingSheets",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ClassificationId = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                    EffectiveFrom = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EffectiveTo = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    UnitPrice = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    VersionNumber = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CostingSheets", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CostingSheets_DamageClassifications_ClassificationId",
                        column: x => x.ClassificationId,
                        principalTable: "DamageClassifications",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.InsertData(
                table: "AreaUnits",
                columns: new[] { "Id", "NameAr", "NameEn" },
                values: new object[,]
                {
                    { 1, "دونم", "Dunum" },
                    { 2, "متر مربع", "Square Meter" },
                    { 3, "هكتار", "Hectare" },
                    { 4, "أخرى", "Other" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_CostingSheets_ClassificationId",
                table: "CostingSheets",
                column: "ClassificationId");

            migrationBuilder.AddForeignKey(
                name: "FK_DamageItems_CostingSheets_CostingSheetId",
                table: "DamageItems",
                column: "CostingSheetId",
                principalTable: "CostingSheets",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Farms_AreaUnits_AreaUnitId",
                table: "Farms",
                column: "AreaUnitId",
                principalTable: "AreaUnits",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
