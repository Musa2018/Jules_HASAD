class SyncException implements Exception {
  final List<String> errors;
  SyncException(this.errors);

  @override
  String toString() =>
      errors.isEmpty ? 'An error occurred during synchronization.' : errors.join('\n');
}

class SyncValidationException extends SyncException {
  SyncValidationException(super.errors);
}

class SyncConflictException extends SyncException {
  SyncConflictException(super.errors);
}

class SyncDependencyException extends SyncException {
  SyncDependencyException(super.errors);
}

// Entity-specific aliases for backward compatibility if needed, 
// or just use generic everywhere.
class FarmerException extends SyncException {
  FarmerException(super.errors);
}

class FarmException extends SyncException {
  FarmException(super.errors);
}

class DamageReportException extends SyncException {
  DamageReportException(super.errors);
}
