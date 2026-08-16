using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class LinkWorkflowStatusForeignKeys : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Clean up existing data to avoid FK conflicts
            migrationBuilder.Sql("UPDATE DamageReports SET StatusId = 'Draft' WHERE StatusId NOT IN (SELECT Id FROM WorkflowStatuses)");
            migrationBuilder.Sql("UPDATE DamageWorkflowHistories SET FromStatus = 'Draft' WHERE FromStatus NOT IN (SELECT Id FROM WorkflowStatuses)");
            migrationBuilder.Sql("UPDATE DamageWorkflowHistories SET ToStatus = 'Draft' WHERE ToStatus NOT IN (SELECT Id FROM WorkflowStatuses)");

            migrationBuilder.CreateIndex(
                name: "IX_DamageWorkflowHistories_FromStatus",
                table: "DamageWorkflowHistories",
                column: "FromStatus");

            migrationBuilder.CreateIndex(
                name: "IX_DamageWorkflowHistories_ToStatus",
                table: "DamageWorkflowHistories",
                column: "ToStatus");

            migrationBuilder.AddForeignKey(
                name: "FK_DamageReports_WorkflowStatuses_StatusId",
                table: "DamageReports",
                column: "StatusId",
                principalTable: "WorkflowStatuses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_DamageWorkflowHistories_WorkflowStatuses_FromStatus",
                table: "DamageWorkflowHistories",
                column: "FromStatus",
                principalTable: "WorkflowStatuses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_DamageWorkflowHistories_WorkflowStatuses_ToStatus",
                table: "DamageWorkflowHistories",
                column: "ToStatus",
                principalTable: "WorkflowStatuses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DamageReports_WorkflowStatuses_StatusId",
                table: "DamageReports");

            migrationBuilder.DropForeignKey(
                name: "FK_DamageWorkflowHistories_WorkflowStatuses_FromStatus",
                table: "DamageWorkflowHistories");

            migrationBuilder.DropForeignKey(
                name: "FK_DamageWorkflowHistories_WorkflowStatuses_ToStatus",
                table: "DamageWorkflowHistories");

            migrationBuilder.DropIndex(
                name: "IX_DamageWorkflowHistories_FromStatus",
                table: "DamageWorkflowHistories");

            migrationBuilder.DropIndex(
                name: "IX_DamageWorkflowHistories_ToStatus",
                table: "DamageWorkflowHistories");
        }
    }
}
