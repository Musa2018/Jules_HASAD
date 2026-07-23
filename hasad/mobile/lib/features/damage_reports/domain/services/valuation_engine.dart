class ValuationEngine {
  /// Calculates the estimated technical loss.
  /// Formula: Quantity * Unit Price * (Damage Percentage / 100)
  static double calculateEstimatedLoss({
    required double quantity,
    required double unitPrice,
    required double damagePercentage,
  }) {
    if (quantity <= 0 || unitPrice <= 0 || damagePercentage <= 0) {
      return 0.0;
    }
    
    final loss = quantity * unitPrice * (damagePercentage / 100.0);
    
    // Round to 2 decimal places for technical consistency
    return double.parse(loss.toStringAsFixed(2));
  }
}
