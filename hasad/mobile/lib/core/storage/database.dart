import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DataClassName('FarmerLocal')
class Farmers extends Table {
  TextColumn get id => text()(); // local UUID (ClientId)
  TextColumn get serverId => text().nullable()(); // Authority ID from server
  IntColumn get idTypeId => integer().withDefault(const Constant(1))();
  TextColumn get idNumber => text().withLength(max: 20).withDefault(const Constant(''))();
  
  // Names
  TextColumn get firstNameAr => text().withLength(max: 50).withDefault(const Constant(''))();
  TextColumn get fatherNameAr => text().withLength(max: 50).withDefault(const Constant(''))();
  TextColumn get grandfatherNameAr => text().withLength(max: 50).withDefault(const Constant(''))();
  TextColumn get familyNameAr => text().withLength(max: 50).withDefault(const Constant(''))();
  
  TextColumn get firstNameEn => text().withLength(max: 50).withDefault(const Constant(''))();
  TextColumn get fatherNameEn => text().withLength(max: 50).withDefault(const Constant(''))();
  TextColumn get grandfatherNameEn => text().withLength(max: 50).withDefault(const Constant(''))();
  TextColumn get familyNameEn => text().withLength(max: 50).withDefault(const Constant(''))();

  DateTimeColumn get birthDate => dateTime().nullable()();
  IntColumn get gender => integer().withDefault(const Constant(0))();
  TextColumn get phoneNumber => text().withLength(max: 20).withDefault(const Constant(''))();
  IntColumn get familySize => integer().withDefault(const Constant(1))();

  TextColumn get governorateId => text().withLength(max: 50).withDefault(const Constant(''))();
  TextColumn get localityId => text().withLength(max: 50).withDefault(const Constant(''))();
  TextColumn get address => text().withLength(max: 500).withDefault(const Constant(''))();

  // Deprecated field - kept temporarily for migration safety if needed, or we can use onUpgrade to drop/ignore.
  // Actually, standard Drift migration adding columns is safer.
  TextColumn get name => text().withLength(max: 200).withDefault(const Constant(''))();
  TextColumn get nationalId => text().withLength(max: 20).withDefault(const Constant(''))();

  // Optimistic concurrency token
  TextColumn get rowVersion => text().withDefault(const Constant(''))();

  // Sync Status: pending, syncing, completed, failed, conflict
  TextColumn get syncStatus =>
      text().withDefault(const Constant('completed'))();
  TextColumn get lastSyncError => text().nullable()();
  BoolColumn get isPendingDelete => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  // Audit
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get deletedBy => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FarmLocal')
class Farms extends Table {
  TextColumn get id => text()(); // local UUID (ClientId)
  TextColumn get serverId => text().nullable()(); // Authority ID from server
  TextColumn get farmerId => text()(); // The operator farmer ClientId
  TextColumn get ownerFarmerId => text().nullable()(); // The owner farmer ClientId
  
  TextColumn get localFarmName => text().withLength(max: 200)();
  IntColumn get ownershipTypeId => integer().withDefault(const Constant(1))();
  IntColumn get relationshipToOwnerId => integer().nullable()();

  // Geography
  TextColumn get governorateId => text().withLength(max: 50)();
  TextColumn get directorateId => text().withLength(max: 50)();
  TextColumn get localityId => text().withLength(max: 50)();
  TextColumn get basin => text().withLength(max: 100)();
  TextColumn get parcel => text().withLength(max: 100)();

  // Area
  RealColumn get area => real()();
  IntColumn get areaUnitId => integer().withDefault(const Constant(1))();
  IntColumn get measurementUnitId => integer().nullable()();

  // Agriculture
  IntColumn get agriculturalSectorId => integer().withDefault(const Constant(1))();
  IntColumn get politicalClassificationId => integer().withDefault(const Constant(1))();

  // Location
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();

  TextColumn get notes => text().nullable()();

  // Sync & Metadata
  TextColumn get rowVersion => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('completed'))();
  TextColumn get lastSyncError => text().nullable()();
  BoolColumn get isPendingDelete => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class OwnershipTypes extends Table {
  IntColumn get id => integer()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class AgriculturalSectors extends Table {
  IntColumn get id => integer()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class PoliticalClassifications extends Table {
  IntColumn get id => integer()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class AreaUnits extends Table {
  IntColumn get id => integer()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class MeasurementUnits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameAr => text().withLength(max: 100)();
  TextColumn get nameEn => text().withLength(max: 100)();
  TextColumn get code => text().nullable()();
  TextColumn get category => text().withLength(max: 50)();
}

class RelationshipToOwners extends Table {
  IntColumn get id => integer()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GovernorateLocal')
class Governorates extends Table {
  TextColumn get id => text()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  TextColumn get code => text()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DirectorateLocal')
class Directorates extends Table {
  TextColumn get id => text()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  TextColumn get code => text().withDefault(const Constant(''))();
  TextColumn get governorateId => text()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalityLocal')
class Localities extends Table {
  TextColumn get id => text()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  TextColumn get governorateId => text()();
  TextColumn get directorateId => text()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DamageReportLocal')
class DamageReports extends Table {
  TextColumn get id => text()(); // ClientId
  TextColumn get serverId => text().nullable()();
  TextColumn get reportNumber => text().withDefault(const Constant(''))();
  TextColumn get permanentFormNumber => text().withDefault(const Constant(''))();
  TextColumn get temporaryFormNumber => text().withDefault(const Constant(''))();

  TextColumn get farmId => text()();

  DateTimeColumn get damageDate => dateTime()();
  DateTimeColumn get documentationDate => dateTime()();

  IntColumn get agriculturalSectorId => integer().withDefault(const Constant(0))();
  IntColumn get damageCauseCategoryId => integer().withDefault(const Constant(0))();
  IntColumn get damageCauseId => integer().withDefault(const Constant(0))();
  TextColumn get settlementName => text().nullable()();
  TextColumn get companyName => text().nullable()();

  TextColumn get statusId => text().withLength(max: 50)();
  TextColumn get notes => text()();

  TextColumn get rowVersion => text().withDefault(const Constant(''))();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('completed'))();
  TextColumn get lastSyncError => text().nullable()();
  BoolColumn get isPendingDelete => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DamageItemLocal')
class DamageItems extends Table {
  TextColumn get id => text()(); // ClientId
  TextColumn get serverId => text().nullable()();
  TextColumn get damageReportId => text()();

  IntColumn get damageNatureId => integer().withDefault(const Constant(0))();
  IntColumn get damageActionId => integer().withDefault(const Constant(0))();
  IntColumn get classificationId => integer().withDefault(const Constant(0))();
  TextColumn get costingSheetId => text().withDefault(const Constant(''))();
  TextColumn get costingSheetItemId => text().nullable()();
  RealColumn get calculatedUnitPrice => real().withDefault(const Constant(0.0))();
  TextColumn get measurementUnitSnapshot => text().withDefault(const Constant(''))();

  RealColumn get affectedArea => real()();
  RealColumn get damagePercentage => real()();
  RealColumn get quantity => real()();
  RealColumn get estimatedLoss => real()();

  TextColumn get rowVersion => text().withDefault(const Constant(''))();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('completed'))();
  TextColumn get lastSyncError => text().nullable()();
  BoolColumn get isPendingDelete => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DamageReportAttachmentLocal')
class DamageReportAttachments extends Table {
  TextColumn get id => text()(); // ClientId
  TextColumn get serverId => text().nullable()();
  TextColumn get damageReportId => text()();

  TextColumn get localPath => text()();
  TextColumn get remotePath => text().nullable()();

  TextColumn get uploadStatus => text().withDefault(
    const Constant('pending'),
  )(); // pending, uploading, completed, failed
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  TextColumn get lastSyncError => text().nullable()();
  BoolColumn get isPendingDelete => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DamageWorkflowHistoryLocal')
class DamageWorkflowHistories extends Table {
  TextColumn get id => text()(); // ClientId/UUID
  TextColumn get serverId => text().nullable()();
  TextColumn get damageReportId => text()(); // ClientId

  TextColumn get fromStatus => text().withLength(max: 50)();
  TextColumn get toStatus => text().withLength(max: 50)();

  TextColumn get changedByUserId => text().withLength(max: 100)();
  DateTimeColumn get changedAt => dateTime()();

  TextColumn get comment => text().nullable().withLength(max: 500)();
  BoolColumn get isOverride => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get localId => text()();
  TextColumn get entityType =>
      text()(); // 'farmer', 'farm', 'damage_report', 'damage_item', 'attachment', 'workflow_history'
  TextColumn get operation =>
      text()(); // 'create', 'update', 'delete', 'upload', 'workflow_action'
  TextColumn get data => text()(); // JSON payload
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class DamageNatures extends Table {
  IntColumn get id => integer()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class DamageActions extends Table {
  IntColumn get id => integer()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class DamageCategories extends Table {
  IntColumn get id => integer()();
  IntColumn get parentId => integer()(); // agriculturalSectorId
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class DamageSubCategories extends Table {
  IntColumn get id => integer()();
  IntColumn get parentId => integer()(); // categoryId
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class DamageClassifications extends Table {
  IntColumn get id => integer()();
  IntColumn get parentId => integer()(); // subCategoryId
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class DamageCauseCategories extends Table {
  IntColumn get id => integer()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class DamageCauses extends Table {
  IntColumn get id => integer()();
  IntColumn get parentId => integer()(); // categoryId
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class CostingSheets extends Table {
  TextColumn get id => text()(); // Guid
  IntColumn get classificationId => integer()();
  RealColumn get unitPrice => real()();
  DateTimeColumn get effectiveFrom => dateTime()();
  DateTimeColumn get effectiveTo => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get versionNumber => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class CostingSheetCatalogs extends Table {
  TextColumn get id => text()(); // Guid
  TextColumn get name => text().withLength(max: 200)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get createdBy => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class CostingSheetVersions extends Table {
  TextColumn get id => text()(); // Guid
  TextColumn get catalogId => text()(); // Guid
  IntColumn get versionNumber => integer()();
  IntColumn get status => integer()(); // 0: Draft, 1: PendingApproval, 2: Active, 3: Archived
  DateTimeColumn get effectiveFrom => dateTime()();
  DateTimeColumn get effectiveTo => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get createdBy => text()();
  DateTimeColumn get approvedAt => dateTime().nullable()();
  TextColumn get approvedBy => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class CostingSheetItems extends Table {
  TextColumn get id => text()(); // Guid
  TextColumn get versionId => text()(); // Guid
  IntColumn get classificationId => integer()();
  IntColumn get measurementUnitId => integer().nullable()();
  RealColumn get unitPrice => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Farmers,
    Farms,
    DamageReports,
    DamageItems,
    DamageReportAttachments,
    SyncQueue,
    OwnershipTypes,
    AgriculturalSectors,
    PoliticalClassifications,
    AreaUnits,
    RelationshipToOwners,
    Governorates,
    Directorates,
    Localities,
    DamageNatures,
    DamageActions,
    DamageCategories,
    DamageSubCategories,
    DamageClassifications,
    DamageCauseCategories,
    DamageCauses,
    MeasurementUnits,
    CostingSheetCatalogs,
    CostingSheetVersions,
    CostingSheetItems,
    CostingSheets,
    DamageWorkflowHistories,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.withExecutor(super.e);

  @override
  int get schemaVersion => 20;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      // ... previous migrations
      if (from < 12) {
        // Sprint 12.1: Damage Classification Foundation
        await m.createTable(damageNatures);
        await m.createTable(damageCategories);
        await m.createTable(damageSubCategories);
        await m.createTable(damageClassifications);
        await m.createTable(damageCauseCategories);
        await m.createTable(damageCauses);
        await m.createTable(costingSheets);

        await m.addColumn(damageReports, damageReports.permanentFormNumber);
        await m.addColumn(damageReports, damageReports.temporaryFormNumber);
        await m.addColumn(damageReports, damageReports.damageYear);
        await m.addColumn(damageReports, damageReports.damageCauseCategoryId);
        await m.addColumn(damageReports, damageReports.damageCauseId);
        await m.addColumn(damageReports, damageReports.settlementName);
        await m.addColumn(damageReports, damageReports.companyName);

        await m.addColumn(damageItems, damageItems.classificationId);
        await m.addColumn(damageItems, damageItems.costingSheetId);
        await m.addColumn(damageItems, damageItems.calculatedUnitPrice);
        await m.addColumn(damageItems, damageItems.measurementUnitSnapshot);
        
        // Audit fields for Farmers (already added to class, but need to add to table in migration if not there)
        await m.addColumn(farmers, farmers.deletedAt);
        await m.addColumn(farmers, farmers.deletedBy);
      }
      if (from < 13) {
        // Sprint 12.3: Duplicate Prevention Index
        await m.createIndex(Index('damage_report_duplicate_idx', 'damage_reports (farm_id, damage_date, damage_cause_id)'));
      }
      if (from < 14) {
        // Sprint 12.4: Workflow History
        await m.createTable(damageWorkflowHistories);
      }
      if (from < 15) {
        // Sprint 12.4: Directorate Denormalization for Security - SAFE MIGRATION
        // 1. Add column as nullable first to allow backfill
        await customStatement('ALTER TABLE damage_reports ADD COLUMN directorate_id TEXT;');
        
        // 2. Backfill from Farms table to preserve authorization scope
        await customStatement('''
          UPDATE damage_reports 
          SET directorate_id = (
            SELECT directorate_id FROM farms WHERE farms.id = damage_reports.farm_id
          )
          WHERE directorate_id IS NULL;
        ''');

        // 3. Enforce NOT NULL by recreating the table via Drift's alterTable
        // This handles the SQLite limitation of not being able to ADD NOT NULL columns to existing data
        // and ensures future integrity without fake defaults.
        await m.alterTable(TableMigration(damageReports));
      }
      if (from < 16) {
        // Sprint 13.2: Costing Catalog & Measurement Unit Consolidation
        await m.createTable(measurementUnits);
        await m.createTable(costingSheetCatalogs);
        await m.createTable(costingSheetVersions);
        await m.createTable(costingSheetItems);

        await m.addColumn(farms, farms.measurementUnitId);
        await m.addColumn(damageItems, damageItems.costingSheetItemId);

        // Data Migration
        await transaction(() async {
          // 1. Migrate AreaUnits to MeasurementUnits
          await customStatement('''
            INSERT INTO measurement_units (id, name_ar, name_en, category)
            SELECT id, name_ar, name_en, 'Area' FROM area_units
          ''');

          // 2. Create Local Legacy Catalog
          final legacyCatalogId = 'LEGACY-CATALOG-LOCAL';
          await customStatement('''
            INSERT INTO costing_sheet_catalogs (id, name, description, created_at, created_by)
            VALUES (?, 'Legacy Catalog (Local)', 'Auto-generated during migration from v15 to v16.', 
                   strftime('%s', 'now'), 'System')
          ''', [legacyCatalogId]);

          // 3. Create Local Legacy Version (Status: 3 - Archived)
          final legacyVersionId = 'LEGACY-VERSION-LOCAL';
          await customStatement('''
            INSERT INTO costing_sheet_versions (id, catalog_id, version_number, status, effective_from, created_at, created_by)
            VALUES (?, ?, 1, 3, strftime('%s', '2000-01-01'), strftime('%s', 'now'), 'System')
          ''', [legacyVersionId, legacyCatalogId]);

          // 4. Migrate CostingSheets to CostingSheetItems
          await customStatement('''
            INSERT INTO costing_sheet_items (id, version_id, classification_id, unit_price, created_at)
            SELECT id, ?, classification_id, unit_price, strftime('%s', 'now')
            FROM costing_sheets
          ''', [legacyVersionId]);

          // 5. Populate new reference columns
          await customStatement('UPDATE farms SET measurement_unit_id = area_unit_id');
          await customStatement('UPDATE damage_items SET costing_sheet_item_id = costing_sheet_id');
        });
      }
      if (from < 17) {
        // Sprint 14.2.1: Directorate Code and Official Numbering
        await m.addColumn(directorates, directorates.code);
        await m.addColumn(damageReports, damageReports.reportNumber);
        await m.addColumn(damageReports, damageReports.damageNatureId);

        // Data Migration: 
        // 1. Backfill NatureId from first item's classification hierarchy
        await customStatement('''
          UPDATE damage_reports 
          SET damage_nature_id = (
            SELECT dc.parent_id FROM damage_items di
            JOIN damage_classifications dcl ON di.classification_id = dcl.id
            JOIN damage_sub_categories dsc ON dcl.parent_id = dsc.id
            JOIN damage_categories dc ON dsc.parent_id = dc.id
            WHERE di.damage_report_id = damage_reports.id
            LIMIT 1
          )
          WHERE EXISTS (SELECT 1 FROM damage_items WHERE damage_report_id = damage_reports.id);
        ''');

        // 2. Backfill ReportNumber from PermanentFormNumber
        await customStatement('UPDATE damage_reports SET report_number = permanent_form_number WHERE permanent_form_number != "";');

        // 3. Hardened Duplicate Prevention: Unique index on FarmId + DamageDate (ADR-0015)
        await customStatement('DROP INDEX IF EXISTS damage_report_duplicate_idx;');
        await customStatement('CREATE UNIQUE INDEX damage_report_unique_incident_idx ON damage_reports (farm_id, damage_date);');
      }
      if (from < 18) {
        // Sprint 14.2.2: DamageReport Entity Principle - Removing redundant fields
        await m.alterTable(TableMigration(damageReports));
      }
      if (from < 19) {
        // Sprint 14.2.3: Damage Assessment Reference Data Foundation
        // Refactor DamageCategories to be sector-based
        await m.alterTable(TableMigration(damageCategories));
      }
      if (from < 20) {
        // Sprint 14.2.3 Correction: Add Damage Action
        await m.createTable(damageActions);
        await m.alterTable(TableMigration(damageItems));
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
