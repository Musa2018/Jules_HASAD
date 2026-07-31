using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hasad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class CorrectDamageReportSequence : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
                IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_DamageReportSequences_DirectorateId_DamageYear' AND object_id = OBJECT_ID(N'[DamageReportSequences]'))
                BEGIN
                    DROP INDEX [IX_DamageReportSequences_DirectorateId_DamageYear] ON [DamageReportSequences];
                END
            ");

            // --- DATA MIGRATION: Preserve historical sequence continuity ---
            // 1. Create a temporary table to hold the max sequences found in DamageReports
            migrationBuilder.Sql(@"
                IF OBJECT_ID('tempdb..#MaxSequences') IS NOT NULL DROP TABLE #MaxSequences;
                CREATE TABLE #MaxSequences (DirectorateId UNIQUEIDENTIFIER, MaxSeq INT);

                INSERT INTO #MaxSequences (DirectorateId, MaxSeq)
                SELECT DirectorateId, MAX(TRY_CAST(RIGHT(ReportNumber, 6) AS INT))
                FROM DamageReports
                WHERE ReportNumber IS NOT NULL AND ReportNumber <> ''
                GROUP BY DirectorateId;

                -- 2. Update existing sequence records with the global max for that directorate
                UPDATE DRS
                SET DRS.LastSequence = MS.MaxSeq
                FROM DamageReportSequences DRS
                JOIN #MaxSequences MS ON DRS.DirectorateId = MS.DirectorateId;

                -- 3. Insert missing sequence records for directorates that have reports but no sequence record
                INSERT INTO DamageReportSequences (Id, DirectorateId, LastSequence)
                SELECT NEWID(), MS.DirectorateId, MS.MaxSeq
                FROM #MaxSequences MS
                WHERE MS.DirectorateId NOT IN (SELECT DirectorateId FROM DamageReportSequences);

                -- 4. Clean up
                DROP TABLE #MaxSequences;
            ");

            migrationBuilder.Sql(@"
                IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[DamageReportSequences]') AND name = N'DamageYear')
                BEGIN
                    DECLARE @var0 sysname;
                    SELECT @var0 = [d].[name]
                    FROM [sys].[default_constraints] [d]
                    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
                    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[DamageReportSequences]') AND [c].[name] = N'DamageYear');
                    IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [DamageReportSequences] DROP CONSTRAINT [' + @var0 + '];');
                    ALTER TABLE [DamageReportSequences] DROP COLUMN [DamageYear];
                END
            ");

            migrationBuilder.Sql(@"
                IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[CostingSheetItems]') AND name = N'Code')
                BEGIN
                    ALTER TABLE [CostingSheetItems] ADD [Code] nvarchar(20) NOT NULL DEFAULT N'';
                END
            ");

            migrationBuilder.Sql(@"
                IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_DamageReportSequences_DirectorateId' AND object_id = OBJECT_ID(N'[DamageReportSequences]'))
                BEGIN
                    CREATE UNIQUE INDEX [IX_DamageReportSequences_DirectorateId] ON [DamageReportSequences] ([DirectorateId]);
                END
            ");

            migrationBuilder.Sql(@"
                IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_CostingSheetItems_Code' AND object_id = OBJECT_ID(N'[CostingSheetItems]'))
                BEGIN
                    CREATE UNIQUE INDEX [IX_CostingSheetItems_Code] ON [CostingSheetItems] ([Code]);
                END
            ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
                IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_DamageReportSequences_DirectorateId' AND object_id = OBJECT_ID(N'[DamageReportSequences]'))
                BEGIN
                    DROP INDEX [IX_DamageReportSequences_DirectorateId] ON [DamageReportSequences];
                END
            ");

            migrationBuilder.Sql(@"
                IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_CostingSheetItems_Code' AND object_id = OBJECT_ID(N'[CostingSheetItems]'))
                BEGIN
                    DROP INDEX [IX_CostingSheetItems_Code] ON [CostingSheetItems];
                END
            ");

            migrationBuilder.Sql(@"
                IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[CostingSheetItems]') AND name = N'Code')
                BEGIN
                    ALTER TABLE [CostingSheetItems] DROP COLUMN [Code];
                END
            ");

            migrationBuilder.Sql(@"
                IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[DamageReportSequences]') AND name = N'DamageYear')
                BEGIN
                    ALTER TABLE [DamageReportSequences] ADD [DamageYear] int NOT NULL DEFAULT 0;
                END
            ");

            migrationBuilder.Sql(@"
                IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_DamageReportSequences_DirectorateId_DamageYear' AND object_id = OBJECT_ID(N'[DamageReportSequences]'))
                BEGIN
                    CREATE UNIQUE INDEX [IX_DamageReportSequences_DirectorateId_DamageYear] ON [DamageReportSequences] ([DirectorateId], [DamageYear]);
                END
            ");
        }
    }
}
