using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class RedesignFarmModule : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Farms_Farmers_FarmerId",
                table: "Farms");

            migrationBuilder.DropIndex(
                name: "IX_Farmers_ClientId",
                table: "Farmers");

            migrationBuilder.DropIndex(
                name: "IX_Farmers_IdTypeId_IdNumber",
                table: "Farmers");

            migrationBuilder.DropColumn(
                name: "LandAreaUnit",
                table: "Farms");

            migrationBuilder.RenameColumn(
                name: "Name",
                table: "Farms",
                newName: "LocalFarmName");

            migrationBuilder.RenameColumn(
                name: "LandArea",
                table: "Farms",
                newName: "Area");

            migrationBuilder.AlterColumn<int>(
                name: "OwnershipTypeId",
                table: "Farms",
                type: "int",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<Guid>(
                name: "LocalityId",
                table: "Farms",
                type: "uniqueidentifier",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<Guid>(
                name: "GovernorateId",
                table: "Farms",
                type: "uniqueidentifier",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(50)",
                oldMaxLength: 50);

            migrationBuilder.AddColumn<int>(
                name: "AgriculturalSectorId",
                table: "Farms",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "AreaUnitId",
                table: "Farms",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "Basin",
                table: "Farms",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "Farms",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DeletedBy",
                table: "Farms",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "DirectorateId",
                table: "Farms",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Farms",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "Notes",
                table: "Farms",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "OwnerFarmerId",
                table: "Farms",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Parcel",
                table: "Farms",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "PoliticalClassificationId",
                table: "Farms",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "RelationshipToOwnerId",
                table: "Farms",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "AgriculturalSectors",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NameAr = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AgriculturalSectors", x => x.Id);
                });

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
                name: "OwnershipTypes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NameAr = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OwnershipTypes", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "PoliticalClassifications",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NameAr = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PoliticalClassifications", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "RelationshipToOwners",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NameAr = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RelationshipToOwners", x => x.Id);
                });

            migrationBuilder.InsertData(
                table: "AgriculturalSectors",
                columns: new[] { "Id", "NameAr", "NameEn" },
                values: new object[,]
                {
                    { 1, "نباتي", "Plant" },
                    { 2, "حيواني", "Animal" },
                    { 3, "مختلط", "Mixed" }
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

            migrationBuilder.InsertData(
                table: "OwnershipTypes",
                columns: new[] { "Id", "NameAr", "NameEn" },
                values: new object[,]
                {
                    { 1, "ملك", "Owned" },
                    { 2, "تأجير", "Leased" },
                    { 3, "مزارعة", "Sharecropping" },
                    { 4, "شراكة", "Partnership" },
                    { 5, "أخرى", "Other" }
                });

            migrationBuilder.InsertData(
                table: "PoliticalClassifications",
                columns: new[] { "Id", "NameAr", "NameEn" },
                values: new object[,]
                {
                    { 1, "A", "A" },
                    { 2, "B", "B" },
                    { 3, "C", "C" }
                });

            migrationBuilder.InsertData(
                table: "RelationshipToOwners",
                columns: new[] { "Id", "NameAr", "NameEn" },
                values: new object[,]
                {
                    { 1, "المالك نفسه", "Owner Himself" },
                    { 2, "مستأجر", "Tenant" },
                    { 3, "شريك", "Partner" },
                    { 4, "وكيل", "Agent" },
                    { 5, "وريث", "Heir" },
                    { 6, "منتفع", "Beneficiary" },
                    { 7, "أخرى", "Other" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Farms_AgriculturalSectorId",
                table: "Farms",
                column: "AgriculturalSectorId");

            migrationBuilder.CreateIndex(
                name: "IX_Farms_AreaUnitId",
                table: "Farms",
                column: "AreaUnitId");

            migrationBuilder.CreateIndex(
                name: "IX_Farms_DirectorateId",
                table: "Farms",
                column: "DirectorateId");

            migrationBuilder.CreateIndex(
                name: "IX_Farms_GovernorateId_DirectorateId_LocalityId",
                table: "Farms",
                columns: new[] { "GovernorateId", "DirectorateId", "LocalityId" });

            migrationBuilder.CreateIndex(
                name: "IX_Farms_LocalityId",
                table: "Farms",
                column: "LocalityId");

            migrationBuilder.CreateIndex(
                name: "IX_Farms_OwnerFarmerId",
                table: "Farms",
                column: "OwnerFarmerId");

            migrationBuilder.CreateIndex(
                name: "IX_Farms_OwnershipTypeId",
                table: "Farms",
                column: "OwnershipTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_Farms_PoliticalClassificationId",
                table: "Farms",
                column: "PoliticalClassificationId");

            migrationBuilder.CreateIndex(
                name: "IX_Farms_RelationshipToOwnerId",
                table: "Farms",
                column: "RelationshipToOwnerId");

            migrationBuilder.CreateIndex(
                name: "IX_Farmers_ClientId",
                table: "Farmers",
                column: "ClientId",
                unique: true,
                filter: "[IsDeleted] = 0");

            migrationBuilder.CreateIndex(
                name: "IX_Farmers_IdTypeId_IdNumber",
                table: "Farmers",
                columns: new[] { "IdTypeId", "IdNumber" },
                unique: true,
                filter: "[IsDeleted] = 0");

            migrationBuilder.AddForeignKey(
                name: "FK_Farms_AgriculturalSectors_AgriculturalSectorId",
                table: "Farms",
                column: "AgriculturalSectorId",
                principalTable: "AgriculturalSectors",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Farms_AreaUnits_AreaUnitId",
                table: "Farms",
                column: "AreaUnitId",
                principalTable: "AreaUnits",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Farms_Directorates_DirectorateId",
                table: "Farms",
                column: "DirectorateId",
                principalTable: "Directorates",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Farms_Farmers_FarmerId",
                table: "Farms",
                column: "FarmerId",
                principalTable: "Farmers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Farms_Farmers_OwnerFarmerId",
                table: "Farms",
                column: "OwnerFarmerId",
                principalTable: "Farmers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Farms_Governorates_GovernorateId",
                table: "Farms",
                column: "GovernorateId",
                principalTable: "Governorates",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Farms_Localities_LocalityId",
                table: "Farms",
                column: "LocalityId",
                principalTable: "Localities",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Farms_OwnershipTypes_OwnershipTypeId",
                table: "Farms",
                column: "OwnershipTypeId",
                principalTable: "OwnershipTypes",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Farms_PoliticalClassifications_PoliticalClassificationId",
                table: "Farms",
                column: "PoliticalClassificationId",
                principalTable: "PoliticalClassifications",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Farms_RelationshipToOwners_RelationshipToOwnerId",
                table: "Farms",
                column: "RelationshipToOwnerId",
                principalTable: "RelationshipToOwners",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Farms_AgriculturalSectors_AgriculturalSectorId",
                table: "Farms");

            migrationBuilder.DropForeignKey(
                name: "FK_Farms_AreaUnits_AreaUnitId",
                table: "Farms");

            migrationBuilder.DropForeignKey(
                name: "FK_Farms_Directorates_DirectorateId",
                table: "Farms");

            migrationBuilder.DropForeignKey(
                name: "FK_Farms_Farmers_FarmerId",
                table: "Farms");

            migrationBuilder.DropForeignKey(
                name: "FK_Farms_Farmers_OwnerFarmerId",
                table: "Farms");

            migrationBuilder.DropForeignKey(
                name: "FK_Farms_Governorates_GovernorateId",
                table: "Farms");

            migrationBuilder.DropForeignKey(
                name: "FK_Farms_Localities_LocalityId",
                table: "Farms");

            migrationBuilder.DropForeignKey(
                name: "FK_Farms_OwnershipTypes_OwnershipTypeId",
                table: "Farms");

            migrationBuilder.DropForeignKey(
                name: "FK_Farms_PoliticalClassifications_PoliticalClassificationId",
                table: "Farms");

            migrationBuilder.DropForeignKey(
                name: "FK_Farms_RelationshipToOwners_RelationshipToOwnerId",
                table: "Farms");

            migrationBuilder.DropTable(
                name: "AgriculturalSectors");

            migrationBuilder.DropTable(
                name: "AreaUnits");

            migrationBuilder.DropTable(
                name: "OwnershipTypes");

            migrationBuilder.DropTable(
                name: "PoliticalClassifications");

            migrationBuilder.DropTable(
                name: "RelationshipToOwners");

            migrationBuilder.DropIndex(
                name: "IX_Farms_AgriculturalSectorId",
                table: "Farms");

            migrationBuilder.DropIndex(
                name: "IX_Farms_AreaUnitId",
                table: "Farms");

            migrationBuilder.DropIndex(
                name: "IX_Farms_DirectorateId",
                table: "Farms");

            migrationBuilder.DropIndex(
                name: "IX_Farms_GovernorateId_DirectorateId_LocalityId",
                table: "Farms");

            migrationBuilder.DropIndex(
                name: "IX_Farms_LocalityId",
                table: "Farms");

            migrationBuilder.DropIndex(
                name: "IX_Farms_OwnerFarmerId",
                table: "Farms");

            migrationBuilder.DropIndex(
                name: "IX_Farms_OwnershipTypeId",
                table: "Farms");

            migrationBuilder.DropIndex(
                name: "IX_Farms_PoliticalClassificationId",
                table: "Farms");

            migrationBuilder.DropIndex(
                name: "IX_Farms_RelationshipToOwnerId",
                table: "Farms");

            migrationBuilder.DropIndex(
                name: "IX_Farmers_ClientId",
                table: "Farmers");

            migrationBuilder.DropIndex(
                name: "IX_Farmers_IdTypeId_IdNumber",
                table: "Farmers");

            migrationBuilder.DropColumn(
                name: "AgriculturalSectorId",
                table: "Farms");

            migrationBuilder.DropColumn(
                name: "AreaUnitId",
                table: "Farms");

            migrationBuilder.DropColumn(
                name: "Basin",
                table: "Farms");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "Farms");

            migrationBuilder.DropColumn(
                name: "DeletedBy",
                table: "Farms");

            migrationBuilder.DropColumn(
                name: "DirectorateId",
                table: "Farms");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Farms");

            migrationBuilder.DropColumn(
                name: "Notes",
                table: "Farms");

            migrationBuilder.DropColumn(
                name: "OwnerFarmerId",
                table: "Farms");

            migrationBuilder.DropColumn(
                name: "Parcel",
                table: "Farms");

            migrationBuilder.DropColumn(
                name: "PoliticalClassificationId",
                table: "Farms");

            migrationBuilder.DropColumn(
                name: "RelationshipToOwnerId",
                table: "Farms");

            migrationBuilder.RenameColumn(
                name: "LocalFarmName",
                table: "Farms",
                newName: "Name");

            migrationBuilder.RenameColumn(
                name: "Area",
                table: "Farms",
                newName: "LandArea");

            migrationBuilder.AlterColumn<string>(
                name: "OwnershipTypeId",
                table: "Farms",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<string>(
                name: "LocalityId",
                table: "Farms",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier");

            migrationBuilder.AlterColumn<string>(
                name: "GovernorateId",
                table: "Farms",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier");

            migrationBuilder.AddColumn<string>(
                name: "LandAreaUnit",
                table: "Farms",
                type: "nvarchar(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_Farmers_ClientId",
                table: "Farmers",
                column: "ClientId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Farmers_IdTypeId_IdNumber",
                table: "Farmers",
                columns: new[] { "IdTypeId", "IdNumber" },
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Farms_Farmers_FarmerId",
                table: "Farms",
                column: "FarmerId",
                principalTable: "Farmers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
