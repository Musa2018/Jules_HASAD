using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddCreatedAtToUser : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Guard against pre-existing/untracked schema state: only add the column
            // if it does not already exist, to avoid SQL error 2705 (duplicate column).
            migrationBuilder.Sql(
                @"IF NOT EXISTS (
                    SELECT 1 FROM sys.columns
                    WHERE Name = N'CreatedAt'
                      AND Object_ID = Object_ID(N'[AspNetUsers]'))
                BEGIN
                    ALTER TABLE [AspNetUsers] ADD [CreatedAt] datetime2 NOT NULL DEFAULT '0001-01-01T00:00:00.0000000';
                END");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(
                @"IF EXISTS (
                    SELECT 1 FROM sys.columns
                    WHERE Name = N'CreatedAt'
                      AND Object_ID = Object_ID(N'[AspNetUsers]'))
                BEGIN
                    ALTER TABLE [AspNetUsers] DROP COLUMN [CreatedAt];
                END");
        }
    }
}
