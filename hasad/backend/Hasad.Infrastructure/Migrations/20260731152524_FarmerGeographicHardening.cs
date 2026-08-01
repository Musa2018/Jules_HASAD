using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class FarmerGeographicHardening : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // 1. Rename existing string columns to legacy
            migrationBuilder.RenameColumn(
                name: "GovernorateId",
                table: "Farmers",
                newName: "LegacyGovernorateId");

            migrationBuilder.RenameColumn(
                name: "LocalityId",
                table: "Farmers",
                newName: "LegacyLocalityId");

            // 2. Add new Guid columns
            migrationBuilder.AddColumn<Guid>(
                name: "GovernorateId",
                table: "Farmers",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "DirectorateId",
                table: "Farmers",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "LocalityId",
                table: "Farmers",
                type: "uniqueidentifier",
                nullable: true);

            // 3. Backfill Data
            migrationBuilder.Sql(@"
                -- Backfill GovernorateId
                UPDATE f
                SET f.GovernorateId = g.Id
                FROM Farmers f
                JOIN Governorates g ON f.LegacyGovernorateId = g.NameAr OR f.LegacyGovernorateId = g.NameEn OR f.LegacyGovernorateId = g.Code;

                -- Backfill LocalityId and DirectorateId
                UPDATE f
                SET f.LocalityId = l.Id,
                    f.DirectorateId = l.DirectorateId
                FROM Farmers f
                JOIN Localities l ON f.LegacyLocalityId = l.NameAr OR f.LegacyLocalityId = l.NameEn;

                -- Audit Statistics
                DECLARE @Total INT = (SELECT COUNT(*) FROM Farmers);
                DECLARE @Mapped INT = (SELECT COUNT(*) FROM Farmers WHERE GovernorateId IS NOT NULL AND LocalityId IS NOT NULL);
                DECLARE @Unmapped INT = @Total - @Mapped;

                PRINT 'Farmer Geographic Migration Audit:';
                PRINT 'Total Records: ' + CAST(@Total AS VARCHAR);
                PRINT 'Mapped Records: ' + CAST(@Mapped AS VARCHAR);
                PRINT 'Unmapped Records: ' + CAST(@Unmapped AS VARCHAR);
            ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "GovernorateId",
                table: "Farmers");

            migrationBuilder.DropColumn(
                name: "DirectorateId",
                table: "Farmers");

            migrationBuilder.DropColumn(
                name: "LocalityId",
                table: "Farmers");

            migrationBuilder.RenameColumn(
                name: "LegacyGovernorateId",
                table: "Farmers",
                newName: "GovernorateId");

            migrationBuilder.RenameColumn(
                name: "LegacyLocalityId",
                table: "Farmers",
                newName: "LocalityId");
        }
    }
}
