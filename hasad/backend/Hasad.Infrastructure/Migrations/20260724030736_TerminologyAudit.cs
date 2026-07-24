using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class TerminologyAudit : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DamageCategories_DamageNatures_NatureId",
                table: "DamageCategories");

            migrationBuilder.DropForeignKey(
                name: "FK_DamageReports_DamageNatures_DamageNatureId",
                table: "DamageReports");

            migrationBuilder.DropTable(
                name: "CompensationAuditLogs");

            migrationBuilder.DropTable(
                name: "Compensations");

            migrationBuilder.DropTable(
                name: "CompensationRules");

            migrationBuilder.RenameColumn(
                name: "DamageNatureId",
                table: "DamageReports",
                newName: "AgriculturalSectorId");

            migrationBuilder.RenameIndex(
                name: "IX_DamageReports_DamageNatureId",
                table: "DamageReports",
                newName: "IX_DamageReports_AgriculturalSectorId");

            migrationBuilder.RenameColumn(
                name: "NatureId",
                table: "DamageCategories",
                newName: "AgriculturalSectorId");

            migrationBuilder.RenameIndex(
                name: "IX_DamageCategories_NatureId",
                table: "DamageCategories",
                newName: "IX_DamageCategories_AgriculturalSectorId");

            migrationBuilder.AddColumn<int>(
                name: "DamageActionId",
                table: "DamageItems",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "DamageNatureId",
                table: "DamageItems",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "AssistanceRules",
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
                    table.PrimaryKey("PK_AssistanceRules", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "DamageActions",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NameAr = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DamageActions", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Assistances",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ClientId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DamageReportId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    RuleId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    CalculatedAmount = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    ApprovedAmount = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Status = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Remarks = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Assistances", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Assistances_AssistanceRules_RuleId",
                        column: x => x.RuleId,
                        principalTable: "AssistanceRules",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Assistances_DamageReports_DamageReportId",
                        column: x => x.DamageReportId,
                        principalTable: "DamageReports",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AssistanceAuditLogs",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    AssistanceId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    PreviousStatus = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    NewStatus = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ChangedBy = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    ChangedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Reason = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AssistanceAuditLogs", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AssistanceAuditLogs_Assistances_AssistanceId",
                        column: x => x.AssistanceId,
                        principalTable: "Assistances",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.UpdateData(
                table: "AgriculturalSectors",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "NameAr", "NameEn" },
                values: new object[] { "الإنتاج النباتي", "Plant Production" });

            migrationBuilder.UpdateData(
                table: "AgriculturalSectors",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "NameAr", "NameEn" },
                values: new object[] { "الإنتاج الحيواني", "Animal Production" });

            migrationBuilder.UpdateData(
                table: "AgriculturalSectors",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "NameAr", "NameEn" },
                values: new object[] { "الإنتاج المختلط", "Mixed Production" });

            migrationBuilder.UpdateData(
                table: "MeasurementUnits",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "Category", "NameAr", "NameEn" },
                values: new object[] { "Count", "شجرة", "Tree" });

            migrationBuilder.InsertData(
                table: "MeasurementUnits",
                columns: new[] { "Id", "Category", "Code", "NameAr", "NameEn" },
                values: new object[,]
                {
                    { 5, "Weight", null, "كغم", "Kg" },
                    { 6, "Weight", null, "طن", "Ton" },
                    { 7, "Count", null, "رأس", "Head" },
                    { 8, "Count", null, "خلية", "Hive" },
                    { 9, "Count", null, "صندوق", "Box" },
                    { 10, "Volume", null, "لتر", "Liter" },
                    { 11, "General", null, "أخرى", "Other" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_DamageItems_DamageActionId",
                table: "DamageItems",
                column: "DamageActionId");

            migrationBuilder.CreateIndex(
                name: "IX_DamageItems_DamageNatureId",
                table: "DamageItems",
                column: "DamageNatureId");

            migrationBuilder.CreateIndex(
                name: "IX_AssistanceAuditLogs_AssistanceId",
                table: "AssistanceAuditLogs",
                column: "AssistanceId");

            migrationBuilder.CreateIndex(
                name: "IX_Assistances_ClientId",
                table: "Assistances",
                column: "ClientId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Assistances_DamageReportId",
                table: "Assistances",
                column: "DamageReportId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Assistances_RuleId",
                table: "Assistances",
                column: "RuleId");

            migrationBuilder.AddForeignKey(
                name: "FK_DamageCategories_AgriculturalSectors_AgriculturalSectorId",
                table: "DamageCategories",
                column: "AgriculturalSectorId",
                principalTable: "AgriculturalSectors",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_DamageItems_DamageActions_DamageActionId",
                table: "DamageItems",
                column: "DamageActionId",
                principalTable: "DamageActions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_DamageItems_DamageNatures_DamageNatureId",
                table: "DamageItems",
                column: "DamageNatureId",
                principalTable: "DamageNatures",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_DamageReports_AgriculturalSectors_AgriculturalSectorId",
                table: "DamageReports",
                column: "AgriculturalSectorId",
                principalTable: "AgriculturalSectors",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DamageCategories_AgriculturalSectors_AgriculturalSectorId",
                table: "DamageCategories");

            migrationBuilder.DropForeignKey(
                name: "FK_DamageItems_DamageActions_DamageActionId",
                table: "DamageItems");

            migrationBuilder.DropForeignKey(
                name: "FK_DamageItems_DamageNatures_DamageNatureId",
                table: "DamageItems");

            migrationBuilder.DropForeignKey(
                name: "FK_DamageReports_AgriculturalSectors_AgriculturalSectorId",
                table: "DamageReports");

            migrationBuilder.DropTable(
                name: "AssistanceAuditLogs");

            migrationBuilder.DropTable(
                name: "DamageActions");

            migrationBuilder.DropTable(
                name: "Assistances");

            migrationBuilder.DropTable(
                name: "AssistanceRules");

            migrationBuilder.DropIndex(
                name: "IX_DamageItems_DamageActionId",
                table: "DamageItems");

            migrationBuilder.DropIndex(
                name: "IX_DamageItems_DamageNatureId",
                table: "DamageItems");

            migrationBuilder.DeleteData(
                table: "MeasurementUnits",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "MeasurementUnits",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "MeasurementUnits",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "MeasurementUnits",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "MeasurementUnits",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "MeasurementUnits",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "MeasurementUnits",
                keyColumn: "Id",
                keyValue: 11);

            migrationBuilder.DropColumn(
                name: "DamageActionId",
                table: "DamageItems");

            migrationBuilder.DropColumn(
                name: "DamageNatureId",
                table: "DamageItems");

            migrationBuilder.RenameColumn(
                name: "AgriculturalSectorId",
                table: "DamageReports",
                newName: "DamageNatureId");

            migrationBuilder.RenameIndex(
                name: "IX_DamageReports_AgriculturalSectorId",
                table: "DamageReports",
                newName: "IX_DamageReports_DamageNatureId");

            migrationBuilder.RenameColumn(
                name: "AgriculturalSectorId",
                table: "DamageCategories",
                newName: "NatureId");

            migrationBuilder.RenameIndex(
                name: "IX_DamageCategories_AgriculturalSectorId",
                table: "DamageCategories",
                newName: "IX_DamageCategories_NatureId");

            migrationBuilder.CreateTable(
                name: "CompensationRules",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    Multiplier = table.Column<decimal>(type: "decimal(18,4)", precision: 18, scale: 4, nullable: false),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CompensationRules", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Compensations",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DamageReportId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    RuleId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    ApprovedAmount = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    CalculatedAmount = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    ClientId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Remarks = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: false),
                    Status = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Compensations", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Compensations_CompensationRules_RuleId",
                        column: x => x.RuleId,
                        principalTable: "CompensationRules",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Compensations_DamageReports_DamageReportId",
                        column: x => x.DamageReportId,
                        principalTable: "DamageReports",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "CompensationAuditLogs",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CompensationId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ChangedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ChangedBy = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    NewStatus = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    PreviousStatus = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
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

            migrationBuilder.UpdateData(
                table: "AgriculturalSectors",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "NameAr", "NameEn" },
                values: new object[] { "نباتي", "Plant" });

            migrationBuilder.UpdateData(
                table: "AgriculturalSectors",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "NameAr", "NameEn" },
                values: new object[] { "حيواني", "Animal" });

            migrationBuilder.UpdateData(
                table: "AgriculturalSectors",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "NameAr", "NameEn" },
                values: new object[] { "مختلط", "Mixed" });

            migrationBuilder.UpdateData(
                table: "MeasurementUnits",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "Category", "NameAr", "NameEn" },
                values: new object[] { "Area", "أخرى", "Other" });

            migrationBuilder.CreateIndex(
                name: "IX_CompensationAuditLogs_CompensationId",
                table: "CompensationAuditLogs",
                column: "CompensationId");

            migrationBuilder.CreateIndex(
                name: "IX_Compensations_ClientId",
                table: "Compensations",
                column: "ClientId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Compensations_DamageReportId",
                table: "Compensations",
                column: "DamageReportId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Compensations_RuleId",
                table: "Compensations",
                column: "RuleId");

            migrationBuilder.AddForeignKey(
                name: "FK_DamageCategories_DamageNatures_NatureId",
                table: "DamageCategories",
                column: "NatureId",
                principalTable: "DamageNatures",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_DamageReports_DamageNatures_DamageNatureId",
                table: "DamageReports",
                column: "DamageNatureId",
                principalTable: "DamageNatures",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
