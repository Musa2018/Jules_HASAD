using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class RemoveDuplicateSeedData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Manual Override: Do NOT delete existing reference data.
            // This migration removes HasData from EF model metadata to transfer ownership to DbInitializer.
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Manual Override: Do NOT restore HasData in rollback.
            // Ownership remains with DbInitializer.
        }
    }
}
