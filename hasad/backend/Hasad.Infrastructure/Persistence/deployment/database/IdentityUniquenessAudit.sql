-- HASAD Identity Uniqueness Audit Script
-- Detects active farmers with duplicate Identity Numbers
--
-- Instructions:
-- 1. Run this script against the production database.
-- 2. If any rows are returned, you MUST resolve them before applying the
--    migration "Sprint14_UpdateIdentityUniqueness".
-- 3. To resolve: Coordinate with field survey teams to verify which record
--    is correct. Either merge the data into one record and soft-delete
--    the other (IsDeleted = 1), or correct the IdentityNumber if it was a typo.
--
-- Expected Output:
-- IdentityNumber | Farmer Id | Farmer Name | Identity Type | Governorate | Directorate

WITH ActiveDuplicates AS (
    SELECT IdNumber
    FROM Farmers
    WHERE IsDeleted = 0
    GROUP BY IdNumber
    HAVING COUNT(*) > 1
)
SELECT
    f.IdNumber AS [Identity Number],
    f.Id AS [Farmer Id],
    f.FirstNameAr + ' ' + f.FamilyNameAr AS [Farmer Name],
    it.NameAr AS [Identity Type],
    g.NameAr AS [Governorate],
    dir.NameAr AS [Directorate]
FROM Farmers f
JOIN ActiveDuplicates ad ON f.IdNumber = ad.IdNumber
JOIN IdTypes it ON f.IdTypeId = it.Id
LEFT JOIN Governorates g ON f.GovernorateId = CAST(g.Id AS NVARCHAR(50))
LEFT JOIN Localities l ON f.LocalityId = CAST(l.Id AS NVARCHAR(50))
LEFT JOIN Directorates dir ON l.DirectorateId = dir.Id
WHERE f.IsDeleted = 0
ORDER BY f.IdNumber;
