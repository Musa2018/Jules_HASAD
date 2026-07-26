using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class DamageClassificationFoundation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_DamageReports_FarmId",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "AgriculturalSectorId",
                table: "DamageItems");

            migrationBuilder.DropColumn(
                name: "CropId",
                table: "DamageItems");

            migrationBuilder.DropColumn(
                name: "DamageTypeId",
                table: "DamageItems");

            migrationBuilder.RenameColumn(
                name: "SubSectorId",
                table: "DamageItems",
                newName: "MeasurementUnitSnapshot");

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "Farmers",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DeletedBy",
                table: "Farmers",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "CompanyName",
                table: "DamageReports",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "DamageCauseId",
                table: "DamageReports",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "DamageTypeId",
                table: "DamageReports",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "DamageYear",
                table: "DamageReports",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "DamageReports",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DeletedBy",
                table: "DamageReports",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "FormNumber",
                table: "DamageReports",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "DamageReports",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "SettlementName",
                table: "DamageReports",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "TemporaryFormNumber",
                table: "DamageReports",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<decimal>(
                name: "CalculatedUnitPrice",
                table: "DamageItems",
                type: "decimal(18,2)",
                precision: 18,
                scale: 2,
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<int>(
                name: "ClassificationId",
                table: "DamageItems",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<Guid>(
                name: "CostingSheetId",
                table: "DamageItems",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "DamageItems",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DeletedBy",
                table: "DamageItems",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "DamageItems",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.CreateTable(
                name: "DamageCauseCategories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NameAr = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DamageCauseCategories", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "DamageNatures",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NameAr = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DamageNatures", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "DamageCauses",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CategoryId = table.Column<int>(type: "int", nullable: false),
                    NameAr = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DamageCauses", x => x.Id);
                    table.ForeignKey(
                        name: "FK_DamageCauses_DamageCauseCategories_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "DamageCauseCategories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "DamageCategories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NatureId = table.Column<int>(type: "int", nullable: false),
                    NameAr = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DamageCategories", x => x.Id);
                    table.ForeignKey(
                        name: "FK_DamageCategories_DamageNatures_NatureId",
                        column: x => x.NatureId,
                        principalTable: "DamageNatures",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "DamageSubCategories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CategoryId = table.Column<int>(type: "int", nullable: false),
                    NameAr = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DamageSubCategories", x => x.Id);
                    table.ForeignKey(
                        name: "FK_DamageSubCategories_DamageCategories_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "DamageCategories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "DamageClassifications",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SubCategoryId = table.Column<int>(type: "int", nullable: false),
                    NameAr = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DamageClassifications", x => x.Id);
                    table.ForeignKey(
                        name: "FK_DamageClassifications_DamageSubCategories_SubCategoryId",
                        column: x => x.SubCategoryId,
                        principalTable: "DamageSubCategories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "CostingSheets",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ClassificationId = table.Column<int>(type: "int", nullable: false),
                    UnitPrice = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    EffectiveFrom = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EffectiveTo = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    VersionNumber = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
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

            migrationBuilder.CreateIndex(
                name: "IX_DamageReports_DamageCauseId",
                table: "DamageReports",
                column: "DamageCauseId");

            migrationBuilder.CreateIndex(
                name: "IX_DamageReports_DamageTypeId",
                table: "DamageReports",
                column: "DamageTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_DamageReports_FarmId_DamageDate",
                table: "DamageReports",
                columns: new[] { "FarmId", "DamageDate" },
                unique: true,
                filter: "[IsDeleted] = 0");

            migrationBuilder.CreateIndex(
                name: "IX_DamageReports_FormNumber",
                table: "DamageReports",
                column: "FormNumber",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_DamageItems_ClassificationId",
                table: "DamageItems",
                column: "ClassificationId");

            migrationBuilder.CreateIndex(
                name: "IX_DamageItems_CostingSheetId",
                table: "DamageItems",
                column: "CostingSheetId");

            migrationBuilder.CreateIndex(
                name: "IX_CostingSheets_ClassificationId",
                table: "CostingSheets",
                column: "ClassificationId");

            migrationBuilder.CreateIndex(
                name: "IX_DamageCategories_NatureId",
                table: "DamageCategories",
                column: "NatureId");

            migrationBuilder.CreateIndex(
                name: "IX_DamageCauses_CategoryId",
                table: "DamageCauses",
                column: "CategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_DamageClassifications_SubCategoryId",
                table: "DamageClassifications",
                column: "SubCategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_DamageSubCategories_CategoryId",
                table: "DamageSubCategories",
                column: "CategoryId");

            migrationBuilder.AddForeignKey(
                name: "FK_DamageItems_CostingSheets_CostingSheetId",
                table: "DamageItems",
                column: "CostingSheetId",
                principalTable: "CostingSheets",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_DamageItems_DamageClassifications_ClassificationId",
                table: "DamageItems",
                column: "ClassificationId",
                principalTable: "DamageClassifications",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_DamageReports_DamageCauseCategories_DamageTypeId",
                table: "DamageReports",
                column: "DamageTypeId",
                principalTable: "DamageCauseCategories",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_DamageReports_DamageCauses_DamageCauseId",
                table: "DamageReports",
                column: "DamageCauseId",
                principalTable: "DamageCauses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DamageItems_CostingSheets_CostingSheetId",
                table: "DamageItems");

            migrationBuilder.DropForeignKey(
                name: "FK_DamageItems_DamageClassifications_ClassificationId",
                table: "DamageItems");

            migrationBuilder.DropForeignKey(
                name: "FK_DamageReports_DamageCauseCategories_DamageTypeId",
                table: "DamageReports");

            migrationBuilder.DropForeignKey(
                name: "FK_DamageReports_DamageCauses_DamageCauseId",
                table: "DamageReports");

            migrationBuilder.DropTable(
                name: "CostingSheets");

            migrationBuilder.DropTable(
                name: "DamageCauses");

            migrationBuilder.DropTable(
                name: "DamageClassifications");

            migrationBuilder.DropTable(
                name: "DamageCauseCategories");

            migrationBuilder.DropTable(
                name: "DamageSubCategories");

            migrationBuilder.DropTable(
                name: "DamageCategories");

            migrationBuilder.DropTable(
                name: "DamageNatures");

            migrationBuilder.DropIndex(
                name: "IX_DamageReports_DamageCauseId",
                table: "DamageReports");

            migrationBuilder.DropIndex(
                name: "IX_DamageReports_DamageTypeId",
                table: "DamageReports");

            migrationBuilder.DropIndex(
                name: "IX_DamageReports_FarmId_DamageDate",
                table: "DamageReports");

            migrationBuilder.DropIndex(
                name: "IX_DamageReports_FormNumber",
                table: "DamageReports");

            migrationBuilder.DropIndex(
                name: "IX_DamageItems_ClassificationId",
                table: "DamageItems");

            migrationBuilder.DropIndex(
                name: "IX_DamageItems_CostingSheetId",
                table: "DamageItems");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "Farmers");

            migrationBuilder.DropColumn(
                name: "DeletedBy",
                table: "Farmers");

            migrationBuilder.DropColumn(
                name: "CompanyName",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "DamageCauseId",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "DamageTypeId",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "DamageYear",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "DeletedBy",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "FormNumber",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "SettlementName",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "TemporaryFormNumber",
                table: "DamageReports");

            migrationBuilder.DropColumn(
                name: "CalculatedUnitPrice",
                table: "DamageItems");

            migrationBuilder.DropColumn(
                name: "ClassificationId",
                table: "DamageItems");

            migrationBuilder.DropColumn(
                name: "CostingSheetId",
                table: "DamageItems");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "DamageItems");

            migrationBuilder.DropColumn(
                name: "DeletedBy",
                table: "DamageItems");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "DamageItems");

            migrationBuilder.RenameColumn(
                name: "MeasurementUnitSnapshot",
                table: "DamageItems",
                newName: "SubSectorId");

            migrationBuilder.AddColumn<string>(
                name: "AgriculturalSectorId",
                table: "DamageItems",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "CropId",
                table: "DamageItems",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "DamageTypeId",
                table: "DamageItems",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_DamageReports_FarmId",
                table: "DamageReports",
                column: "FarmId");
        }
    }
}
