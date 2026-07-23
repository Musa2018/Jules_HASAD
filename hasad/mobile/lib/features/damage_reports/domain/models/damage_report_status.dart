class DamageReportStatus {
  static const String draft = 'Draft';
  static const String techReview = 'TechReview';
  static const String archiveDir = 'ArchiveDir';
  static const String dirManager = 'DirManager';
  static const String minTechReview = 'MinTechReview';
  static const String legalReview = 'LegalReview';
  static const String procReview = 'ProcReview';
  static const String minArchive = 'MinArchive';
  static const String genManager = 'GenManager';
  static const String completed = 'Completed';

  static const List<String> all = [
    draft, techReview, archiveDir, dirManager, minTechReview,
    legalReview, procReview, minArchive, genManager, completed
  ];
}
