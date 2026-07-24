namespace Hasad.Domain.Constants;

public static class DamageReportStatus
{
    public const string Draft = "Draft";
    public const string PendingTechnicalVerification = "PendingTechnicalVerification";
    public const string TechReview = "TechReview";
    public const string ArchiveDir = "ArchiveDir";
    public const string DirManager = "DirManager";
    public const string MinTechReview = "MinTechReview";
    public const string LegalReview = "LegalReview";
    public const string ProcReview = "ProcReview";
    public const string MinArchive = "MinArchive";
    public const string GenManager = "GenManager";
    public const string Completed = "Completed";

    public static string[] All() => new[]
    {
        Draft, PendingTechnicalVerification, TechReview, ArchiveDir, DirManager, MinTechReview,
        LegalReview, ProcReview, MinArchive, GenManager, Completed
    };
}
