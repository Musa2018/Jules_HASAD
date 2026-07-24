using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Sprint14_2_1_FixDirectorateBusinessCodes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Governorate Codes (Standardized to 3 uppercase letters)
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'JEN' WHERE NameEn = 'Jenin'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'TUB' WHERE NameEn = 'Tubas'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'TUL' WHERE NameEn = 'Tulkarm'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'NBL' WHERE NameEn = 'Nablus'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'QAL' WHERE NameEn = 'Qalqilya'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'SLF' WHERE NameEn = 'Salfit'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'RAM' WHERE NameEn = 'Ramallah & Al-Bireh'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'JER' WHERE NameEn = 'Jericho'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'JRS' WHERE NameEn = 'Jerusalem'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'BTH' WHERE NameEn = 'Bethlehem'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'HBN' WHERE NameEn = 'Hebron'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'NGZ' WHERE NameEn = 'North Gaza'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'GZA' WHERE NameEn = 'Gaza'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'CEN' WHERE NameEn = 'Deir al-Balah'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'KYS' WHERE NameEn = 'Khan Yunis'");
            migrationBuilder.Sql("UPDATE Governorates SET Code = 'RFH' WHERE NameEn = 'Rafah'");

            // Directorate Codes (Official abbreviations)
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'JEN' WHERE NameEn = 'Jenin Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'TUB' WHERE NameEn = 'Tubas Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'TUL' WHERE NameEn = 'Tulkarm Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'NAB' WHERE NameEn = 'Nablus Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'QAL' WHERE NameEn = 'Qalqilya Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'SLF' WHERE NameEn = 'Salfit Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'RAM' WHERE NameEn = 'Ramallah Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'JER' WHERE NameEn = 'Jericho Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'JRS' WHERE NameEn = 'Jerusalem Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'BTH' WHERE NameEn = 'Bethlehem Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'NHB' WHERE NameEn = 'North Hebron'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'SHB' WHERE NameEn = 'South Hebron'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'HBN' WHERE NameEn = 'Hebron Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'NGZ' WHERE NameEn = 'North Gaza Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'GZA' WHERE NameEn = 'Gaza Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'CEN' WHERE NameEn = 'Central Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'KYS' WHERE NameEn = 'Khan Yunis Directorate'");
            migrationBuilder.Sql("UPDATE Directorates SET Code = 'RFH' WHERE NameEn = 'Rafah Directorate'");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
