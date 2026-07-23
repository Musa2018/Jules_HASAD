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

    test('itemToUpdateJson maps fields correctly', () {
      const item = DamageItem(
        id: 'i1',
        serverId: 'si1',
        damageReportId: 'r1',
        classificationId: 10,
        costingSheetId: 'cs10',
        calculatedUnitPrice: 200,
        measurementUnitSnapshot: 'Ton',
        affectedArea: 5,
        damagePercentage: 30,
        quantity: 15,
        estimatedLoss: 600,
        rowVersion: 'rv2',
      );
      final json = DamageReportSyncDto.itemToUpdateJson(item);

      expect(json['id'], 'si1');
      expect(json['classificationId'], 10);
      expect(json['calculatedUnitPrice'], 200.0);
      expect(json['rowVersion'], 'rv2');
    });
  });
}
