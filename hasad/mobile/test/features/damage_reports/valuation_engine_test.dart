import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/damage_reports/domain/services/valuation_engine.dart';

void main() {
  group('ValuationEngine', () {
    test('calculateEstimatedLoss returns correct value', () {
      final loss = ValuationEngine.calculateEstimatedLoss(
        quantity: 10,
        unitPrice: 100,
        damagePercentage: 50,
      );
      expect(loss, 500.0);
    });

    test('calculateEstimatedLoss rounds to 2 decimal places', () {
      final loss = ValuationEngine.calculateEstimatedLoss(
        quantity: 3,
        unitPrice: 33.33,
        damagePercentage: 33.33,
      );
      // 3 * 33.33 * 0.3333 = 33.326667
      expect(loss, 33.33);
    });

    test('returns 0 if any input is <= 0', () {
      expect(ValuationEngine.calculateEstimatedLoss(quantity: 0, unitPrice: 10, damagePercentage: 10), 0.0);
      expect(ValuationEngine.calculateEstimatedLoss(quantity: 10, unitPrice: -1, damagePercentage: 10), 0.0);
      expect(ValuationEngine.calculateEstimatedLoss(quantity: 10, unitPrice: 10, damagePercentage: -5), 0.0);
    });
  });
}
