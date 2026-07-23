using Hasad.Domain.Enums;

namespace Hasad.Domain.Constants;

public static class AppRoles
{
    public const string SuperAdmin = "SuperAdmin";
    public const string Administrator = "Administrator";
    public const string AgriculturalEngineer = "AgriculturalEngineer";
    public const string FieldSurveyor = "FieldSurveyor";
    public const string Farmer = "Farmer";
    public const string ReadOnly = "ReadOnly";
    public const string Director = "Director";
    public const string Finance = "Finance";
    public const string Supervisor = "Supervisor";
    public const string TechnicalReviewer = "TechnicalReviewer";
    public const string ArchiveOfficer = "ArchiveOfficer";
    public const string MinistryReviewer = "MinistryReviewer";
    public const string GeneralManager = "GeneralManager";

    // Ministerial Workflow Roles (Sprint 13.1)
    public const string LegalReviewer = "LegalReviewer";
    public const string ProceduralReviewer = "ProceduralReviewer";
    public const string MinistryTechReviewer = "MinistryTechReviewer";
    public const string ChiefArchiveOfficer = "ChiefArchiveOfficer";
    public const string DirectorateManager = "DirectorateManager";

    public static RoleScopeType GetScopeType(string roleName) => roleName switch
    {
        Director or Supervisor or DirectorateManager => RoleScopeType.Governorate,
        AgriculturalEngineer or FieldSurveyor or TechnicalReviewer or ArchiveOfficer => RoleScopeType.Directorate,
        _ => RoleScopeType.Global
    };

    public static string[] All() => new[]
    {
        SuperAdmin, Administrator, AgriculturalEngineer,
        FieldSurveyor, Farmer, ReadOnly, Director, Finance,
        Supervisor, TechnicalReviewer, ArchiveOfficer,
        MinistryReviewer, GeneralManager,
        LegalReviewer, ProceduralReviewer, MinistryTechReviewer,
        ChiefArchiveOfficer, DirectorateManager
    };
}
