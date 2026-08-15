import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_workflow_history.dart';

void main() {
  group('Damage Report JSON Parsing Tests', () {
    test('DamageItem should parse correctly from backend JSON even if damageReportId is missing', () {
      const jsonString = '''
      {
        "id": "c3781483-ea88-4ba8-a2eb-8adcb9b160b6",
        "clientId": "d3781483-ea88-4ba8-a2eb-8adcb9b160b7",
        "damageNatureId": 1,
        "damageActionId": 2,
        "classificationId": 7,
        "costingSheetId": "e3781483-ea88-4ba8-a2eb-8adcb9b160b8",
        "calculatedUnitPrice": 150.0,
        "measurementUnitSnapshot": "Tree",
        "affectedArea": 0.0,
        "damagePercentage": 50.0,
        "quantity": 10.0,
        "estimatedLoss": 750.0,
        "rowVersion": "AAAAAAAAB9c="
      }
      ''';

      final Map<String, dynamic> json = jsonDecode(jsonString);
      final item = DamageItem.fromJson(json);

      expect(item.serverId, "c3781483-ea88-4ba8-a2eb-8adcb9b160b6");
      expect(item.id, "d3781483-ea88-4ba8-a2eb-8adcb9b160b7");
      expect(item.damageReportId, isEmpty);
    });

    test('DamageItem should NOT fail if clientId is missing (uses empty default)', () {
      const jsonString = '''
      {
        "id": "c3781483-ea88-4ba8-a2eb-8adcb9b160b6",
        "damageReportId": "r1",
        "affectedArea": 0.0,
        "damagePercentage": 50.0,
        "quantity": 10.0,
        "estimatedLoss": 750.0
      }
      ''';

      final Map<String, dynamic> json = jsonDecode(jsonString);
      
      final item = DamageItem.fromJson(json);
      expect(item.id, isEmpty);
    });

    test('DamageWorkflowHistory should handle null fields from backend gracefully', () {
      const jsonString = '''
      {
        "id": "h1-guid",
        "fromStatus": null,
        "toStatus": "TechReview",
        "changedByUserId": null,
        "changedAt": "2024-03-20T10:00:00Z",
        "comment": null,
        "isOverride": false
      }
      ''';

      final Map<String, dynamic> json = jsonDecode(jsonString);
      final history = DamageWorkflowHistory.fromJson(json);

      expect(history.id, "h1-guid");
      expect(history.fromStatus, "");
      expect(history.toStatus, "TechReview");
      expect(history.changedByUserId, "");
      expect(history.comment, isNull);
      expect(history.changedAt, isNotNull);
    });
  });
}
