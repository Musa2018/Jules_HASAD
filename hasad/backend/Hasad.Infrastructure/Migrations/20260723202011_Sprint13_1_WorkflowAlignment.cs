using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Sprint13_1_WorkflowAlignment : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Migrate StatusId based on Sprint 13.1 Mapping Table
            migrationBuilder.Sql("UPDATE DamageReports SET StatusId = 'TechReview' WHERE StatusId = 'Submitted'");
            migrationBuilder.Sql("UPDATE DamageReports SET StatusId = 'ArchiveDir' WHERE StatusId = 'TechnicalReview'");
            migrationBuilder.Sql("UPDATE DamageReports SET StatusId = 'DirManager' WHERE StatusId = 'SupervisorReview'");
            migrationBuilder.Sql("UPDATE DamageReports SET StatusId = 'MinTechReview' WHERE StatusId = 'MinistryReview'");
            migrationBuilder.Sql("UPDATE DamageReports SET StatusId = 'MinArchive' WHERE StatusId = 'Archive'");
            migrationBuilder.Sql("UPDATE DamageReports SET StatusId = 'Completed' WHERE StatusId = 'Approved'");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Revert StatusId
            migrationBuilder.Sql("UPDATE DamageReports SET StatusId = 'Submitted' WHERE StatusId = 'TechReview'");
            migrationBuilder.Sql("UPDATE DamageReports SET StatusId = 'TechnicalReview' WHERE StatusId = 'ArchiveDir'");
            migrationBuilder.Sql("UPDATE DamageReports SET StatusId = 'SupervisorReview' WHERE StatusId = 'DirManager'");
            migrationBuilder.Sql("UPDATE DamageReports SET StatusId = 'MinistryReview' WHERE StatusId = 'MinTechReview'");
            migrationBuilder.Sql("UPDATE DamageReports SET StatusId = 'Archive' WHERE StatusId = 'MinArchive'");
            migrationBuilder.Sql("UPDATE DamageReports SET StatusId = 'Approved' WHERE StatusId = 'Completed'");
        }
    }
}
