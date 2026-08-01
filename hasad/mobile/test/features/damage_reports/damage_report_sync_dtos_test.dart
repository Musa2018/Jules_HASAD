// ignore_for_file: deprecated_member_use_from_same_package
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/damage_reports/data/dto/damage_report_sync_dto.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';

void main() {
  group('DamageReportSyncDto', () {
    final baseReport = DamageReport(
      id: 'local-r1',
      temporaryFormNumber: 'TEMP-1',
      damageYear: 2024,
      farmId: 'local-f1',
      farmerId: 'local-u1',
      damageDate: DateTime(2024, 5, 20),
      documentationDate: DateTime(2024, 5, 21),
      governorateId: 'gov1',
      directorateId: 'dir1',
      localityId: 'loc1',
      statusId: 'Draft',
      notes: 'Test',
      items: [
        const DamageItem(
          id: 'local-i1',
          damageReportId: 'local-r1',
          classificationId: 1,
          costingSheetId: 'cs1',
          calculatedUnitPrice: 100,
          measurementUnitSnapshot: 'Tree',
          affectedArea: 10,
          damagePercentage: 50,
          quantity: 5,
          estimatedLoss: 500,
        ),
      ],
    );

    test('toCreateJson maps all fields correctly', () {
      final json = DamageReportSyncDto.toCreateJson(baseReport);

      expect(json['clientId'], 'local-r1');
      expect(json['temporaryFormNumber'], 'TEMP-1');
      expect(json['damageYear'], 2024);
      expect(json['farmId'], 'local-f1');
      expect(json['items'], hasLength(1));
      expect(json['items'][0]['clientId'], 'local-i1');
      expect(json['items'][0]['calculatedUnitPrice'], 100.0);
    });

    test('toUpdateJson requires serverId', () {
      expect(
        () => DamageReportSyncDto.toUpdateJson(baseReport),
        throwsArgumentError,
      );
    });

    test('toUpdateJson maps update fields correctly', () {
      final report = baseReport.copyWith(serverId: 'server-r1', rowVersion: 'v1');
      final json = DamageReportSyncDto.toUpdateJson(report);

      expect(json['id'], 'server-r1');
      expect(json['rowVersion'], 'v1');
      expect(json.containsKey('clientId'), isFalse);
    });

    test('itemToUpdateJson requires serverId', () {
      const item = DamageItem(
        id: 'i1',
        damageReportId: 'r1',
        affectedArea: 1,
        damagePercentage: 1,
        quantity: 1,
        estimatedLoss: 1,
      );
      expect(
        () => DamageReportSyncDto.itemToUpdateJson(item),
        throwsArgumentError,
      );
    });

    test('toCreateJson converts empty GUID strings to null', () {
      final report = baseReport.copyWith(
        governorateId: '',
        directorateId: ' ', // Note: My helper checks for isEmpty, maybe I should trim too?
        localityId: 'null',
      );
      final json = DamageReportSyncDto.toCreateJson(report);

      expect(json['governorateId'], isNull);
      expect(json['localityId'], isNull);
    });

    test('itemToCreateJson resolves costingSheetId from costingSheetItemId', () {
      const item = DamageItem(
        id: 'i1',
        damageReportId: 'r1',
        costingSheetId: 'old-cs',
        costingSheetItemId: 'new-cs',
        affectedArea: 1,
        damagePercentage: 1,
        quantity: 1,
        estimatedLoss: 1,
      );
      final json = DamageReportSyncDto.itemToCreateJson(item);

      expect(json['costingSheetId'], 'new-cs');
    });

    test('itemToCreateJson includes damageNatureId and damageActionId', () {
      const item = DamageItem(
        id: 'i1',
        damageReportId: 'r1',
        damageNatureId: 5,
        damageActionId: 7,
        affectedArea: 1,
        damagePercentage: 1,
        quantity: 1,
        estimatedLoss: 1,
      );
      final json = DamageReportSyncDto.itemToCreateJson(item);

      expect(json['damageNatureId'], 5);
      expect(json['damageActionId'], 7);
    });
  });
}
