// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FarmersTable extends Farmers with TableInfo<$FarmersTable, FarmerLocal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FarmersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idTypeIdMeta = const VerificationMeta(
    'idTypeId',
  );
  @override
  late final GeneratedColumn<int> idTypeId = GeneratedColumn<int>(
    'id_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _idNumberMeta = const VerificationMeta(
    'idNumber',
  );
  @override
  late final GeneratedColumn<String> idNumber = GeneratedColumn<String>(
    'id_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _firstNameArMeta = const VerificationMeta(
    'firstNameAr',
  );
  @override
  late final GeneratedColumn<String> firstNameAr = GeneratedColumn<String>(
    'first_name_ar',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fatherNameArMeta = const VerificationMeta(
    'fatherNameAr',
  );
  @override
  late final GeneratedColumn<String> fatherNameAr = GeneratedColumn<String>(
    'father_name_ar',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _grandfatherNameArMeta = const VerificationMeta(
    'grandfatherNameAr',
  );
  @override
  late final GeneratedColumn<String> grandfatherNameAr =
      GeneratedColumn<String>(
        'grandfather_name_ar',
        aliasedName,
        false,
        additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _familyNameArMeta = const VerificationMeta(
    'familyNameAr',
  );
  @override
  late final GeneratedColumn<String> familyNameAr = GeneratedColumn<String>(
    'family_name_ar',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _firstNameEnMeta = const VerificationMeta(
    'firstNameEn',
  );
  @override
  late final GeneratedColumn<String> firstNameEn = GeneratedColumn<String>(
    'first_name_en',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fatherNameEnMeta = const VerificationMeta(
    'fatherNameEn',
  );
  @override
  late final GeneratedColumn<String> fatherNameEn = GeneratedColumn<String>(
    'father_name_en',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _grandfatherNameEnMeta = const VerificationMeta(
    'grandfatherNameEn',
  );
  @override
  late final GeneratedColumn<String> grandfatherNameEn =
      GeneratedColumn<String>(
        'grandfather_name_en',
        aliasedName,
        false,
        additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _familyNameEnMeta = const VerificationMeta(
    'familyNameEn',
  );
  @override
  late final GeneratedColumn<String> familyNameEn = GeneratedColumn<String>(
    'family_name_en',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<int> gender = GeneratedColumn<int>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _familySizeMeta = const VerificationMeta(
    'familySize',
  );
  @override
  late final GeneratedColumn<int> familySize = GeneratedColumn<int>(
    'family_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _governorateIdMeta = const VerificationMeta(
    'governorateId',
  );
  @override
  late final GeneratedColumn<String> governorateId = GeneratedColumn<String>(
    'governorate_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _localityIdMeta = const VerificationMeta(
    'localityId',
  );
  @override
  late final GeneratedColumn<String> localityId = GeneratedColumn<String>(
    'locality_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 500),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nationalIdMeta = const VerificationMeta(
    'nationalId',
  );
  @override
  late final GeneratedColumn<String> nationalId = GeneratedColumn<String>(
    'national_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _rowVersionMeta = const VerificationMeta(
    'rowVersion',
  );
  @override
  late final GeneratedColumn<String> rowVersion = GeneratedColumn<String>(
    'row_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('completed'),
  );
  static const VerificationMeta _lastSyncErrorMeta = const VerificationMeta(
    'lastSyncError',
  );
  @override
  late final GeneratedColumn<String> lastSyncError = GeneratedColumn<String>(
    'last_sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPendingDeleteMeta = const VerificationMeta(
    'isPendingDelete',
  );
  @override
  late final GeneratedColumn<bool> isPendingDelete = GeneratedColumn<bool>(
    'is_pending_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pending_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedByMeta = const VerificationMeta(
    'deletedBy',
  );
  @override
  late final GeneratedColumn<String> deletedBy = GeneratedColumn<String>(
    'deleted_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    idTypeId,
    idNumber,
    firstNameAr,
    fatherNameAr,
    grandfatherNameAr,
    familyNameAr,
    firstNameEn,
    fatherNameEn,
    grandfatherNameEn,
    familyNameEn,
    birthDate,
    gender,
    phoneNumber,
    familySize,
    governorateId,
    localityId,
    address,
    name,
    nationalId,
    rowVersion,
    syncStatus,
    lastSyncError,
    isPendingDelete,
    createdAt,
    updatedAt,
    deletedAt,
    deletedBy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'farmers';
  @override
  VerificationContext validateIntegrity(
    Insertable<FarmerLocal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('id_type_id')) {
      context.handle(
        _idTypeIdMeta,
        idTypeId.isAcceptableOrUnknown(data['id_type_id']!, _idTypeIdMeta),
      );
    }
    if (data.containsKey('id_number')) {
      context.handle(
        _idNumberMeta,
        idNumber.isAcceptableOrUnknown(data['id_number']!, _idNumberMeta),
      );
    }
    if (data.containsKey('first_name_ar')) {
      context.handle(
        _firstNameArMeta,
        firstNameAr.isAcceptableOrUnknown(
          data['first_name_ar']!,
          _firstNameArMeta,
        ),
      );
    }
    if (data.containsKey('father_name_ar')) {
      context.handle(
        _fatherNameArMeta,
        fatherNameAr.isAcceptableOrUnknown(
          data['father_name_ar']!,
          _fatherNameArMeta,
        ),
      );
    }
    if (data.containsKey('grandfather_name_ar')) {
      context.handle(
        _grandfatherNameArMeta,
        grandfatherNameAr.isAcceptableOrUnknown(
          data['grandfather_name_ar']!,
          _grandfatherNameArMeta,
        ),
      );
    }
    if (data.containsKey('family_name_ar')) {
      context.handle(
        _familyNameArMeta,
        familyNameAr.isAcceptableOrUnknown(
          data['family_name_ar']!,
          _familyNameArMeta,
        ),
      );
    }
    if (data.containsKey('first_name_en')) {
      context.handle(
        _firstNameEnMeta,
        firstNameEn.isAcceptableOrUnknown(
          data['first_name_en']!,
          _firstNameEnMeta,
        ),
      );
    }
    if (data.containsKey('father_name_en')) {
      context.handle(
        _fatherNameEnMeta,
        fatherNameEn.isAcceptableOrUnknown(
          data['father_name_en']!,
          _fatherNameEnMeta,
        ),
      );
    }
    if (data.containsKey('grandfather_name_en')) {
      context.handle(
        _grandfatherNameEnMeta,
        grandfatherNameEn.isAcceptableOrUnknown(
          data['grandfather_name_en']!,
          _grandfatherNameEnMeta,
        ),
      );
    }
    if (data.containsKey('family_name_en')) {
      context.handle(
        _familyNameEnMeta,
        familyNameEn.isAcceptableOrUnknown(
          data['family_name_en']!,
          _familyNameEnMeta,
        ),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('family_size')) {
      context.handle(
        _familySizeMeta,
        familySize.isAcceptableOrUnknown(data['family_size']!, _familySizeMeta),
      );
    }
    if (data.containsKey('governorate_id')) {
      context.handle(
        _governorateIdMeta,
        governorateId.isAcceptableOrUnknown(
          data['governorate_id']!,
          _governorateIdMeta,
        ),
      );
    }
    if (data.containsKey('locality_id')) {
      context.handle(
        _localityIdMeta,
        localityId.isAcceptableOrUnknown(data['locality_id']!, _localityIdMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('national_id')) {
      context.handle(
        _nationalIdMeta,
        nationalId.isAcceptableOrUnknown(data['national_id']!, _nationalIdMeta),
      );
    }
    if (data.containsKey('row_version')) {
      context.handle(
        _rowVersionMeta,
        rowVersion.isAcceptableOrUnknown(data['row_version']!, _rowVersionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_sync_error')) {
      context.handle(
        _lastSyncErrorMeta,
        lastSyncError.isAcceptableOrUnknown(
          data['last_sync_error']!,
          _lastSyncErrorMeta,
        ),
      );
    }
    if (data.containsKey('is_pending_delete')) {
      context.handle(
        _isPendingDeleteMeta,
        isPendingDelete.isAcceptableOrUnknown(
          data['is_pending_delete']!,
          _isPendingDeleteMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('deleted_by')) {
      context.handle(
        _deletedByMeta,
        deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FarmerLocal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FarmerLocal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      idTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_type_id'],
      )!,
      idNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_number'],
      )!,
      firstNameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name_ar'],
      )!,
      fatherNameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}father_name_ar'],
      )!,
      grandfatherNameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grandfather_name_ar'],
      )!,
      familyNameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_name_ar'],
      )!,
      firstNameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name_en'],
      )!,
      fatherNameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}father_name_en'],
      )!,
      grandfatherNameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grandfather_name_en'],
      )!,
      familyNameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_name_en'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gender'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      familySize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}family_size'],
      )!,
      governorateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}governorate_id'],
      )!,
      localityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locality_id'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nationalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}national_id'],
      )!,
      rowVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_version'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastSyncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sync_error'],
      ),
      isPendingDelete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pending_delete'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deletedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_by'],
      ),
    );
  }

  @override
  $FarmersTable createAlias(String alias) {
    return $FarmersTable(attachedDatabase, alias);
  }
}

class FarmerLocal extends DataClass implements Insertable<FarmerLocal> {
  final String id;
  final String? serverId;
  final int idTypeId;
  final String idNumber;
  final String firstNameAr;
  final String fatherNameAr;
  final String grandfatherNameAr;
  final String familyNameAr;
  final String firstNameEn;
  final String fatherNameEn;
  final String grandfatherNameEn;
  final String familyNameEn;
  final DateTime? birthDate;
  final int gender;
  final String phoneNumber;
  final int familySize;
  final String governorateId;
  final String localityId;
  final String address;
  final String name;
  final String nationalId;
  final String rowVersion;
  final String syncStatus;
  final String? lastSyncError;
  final bool isPendingDelete;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? deletedBy;
  const FarmerLocal({
    required this.id,
    this.serverId,
    required this.idTypeId,
    required this.idNumber,
    required this.firstNameAr,
    required this.fatherNameAr,
    required this.grandfatherNameAr,
    required this.familyNameAr,
    required this.firstNameEn,
    required this.fatherNameEn,
    required this.grandfatherNameEn,
    required this.familyNameEn,
    this.birthDate,
    required this.gender,
    required this.phoneNumber,
    required this.familySize,
    required this.governorateId,
    required this.localityId,
    required this.address,
    required this.name,
    required this.nationalId,
    required this.rowVersion,
    required this.syncStatus,
    this.lastSyncError,
    required this.isPendingDelete,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.deletedBy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['id_type_id'] = Variable<int>(idTypeId);
    map['id_number'] = Variable<String>(idNumber);
    map['first_name_ar'] = Variable<String>(firstNameAr);
    map['father_name_ar'] = Variable<String>(fatherNameAr);
    map['grandfather_name_ar'] = Variable<String>(grandfatherNameAr);
    map['family_name_ar'] = Variable<String>(familyNameAr);
    map['first_name_en'] = Variable<String>(firstNameEn);
    map['father_name_en'] = Variable<String>(fatherNameEn);
    map['grandfather_name_en'] = Variable<String>(grandfatherNameEn);
    map['family_name_en'] = Variable<String>(familyNameEn);
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    map['gender'] = Variable<int>(gender);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['family_size'] = Variable<int>(familySize);
    map['governorate_id'] = Variable<String>(governorateId);
    map['locality_id'] = Variable<String>(localityId);
    map['address'] = Variable<String>(address);
    map['name'] = Variable<String>(name);
    map['national_id'] = Variable<String>(nationalId);
    map['row_version'] = Variable<String>(rowVersion);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncError != null) {
      map['last_sync_error'] = Variable<String>(lastSyncError);
    }
    map['is_pending_delete'] = Variable<bool>(isPendingDelete);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<String>(deletedBy);
    }
    return map;
  }

  FarmersCompanion toCompanion(bool nullToAbsent) {
    return FarmersCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      idTypeId: Value(idTypeId),
      idNumber: Value(idNumber),
      firstNameAr: Value(firstNameAr),
      fatherNameAr: Value(fatherNameAr),
      grandfatherNameAr: Value(grandfatherNameAr),
      familyNameAr: Value(familyNameAr),
      firstNameEn: Value(firstNameEn),
      fatherNameEn: Value(fatherNameEn),
      grandfatherNameEn: Value(grandfatherNameEn),
      familyNameEn: Value(familyNameEn),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      gender: Value(gender),
      phoneNumber: Value(phoneNumber),
      familySize: Value(familySize),
      governorateId: Value(governorateId),
      localityId: Value(localityId),
      address: Value(address),
      name: Value(name),
      nationalId: Value(nationalId),
      rowVersion: Value(rowVersion),
      syncStatus: Value(syncStatus),
      lastSyncError: lastSyncError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncError),
      isPendingDelete: Value(isPendingDelete),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory FarmerLocal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarmerLocal(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      idTypeId: serializer.fromJson<int>(json['idTypeId']),
      idNumber: serializer.fromJson<String>(json['idNumber']),
      firstNameAr: serializer.fromJson<String>(json['firstNameAr']),
      fatherNameAr: serializer.fromJson<String>(json['fatherNameAr']),
      grandfatherNameAr: serializer.fromJson<String>(json['grandfatherNameAr']),
      familyNameAr: serializer.fromJson<String>(json['familyNameAr']),
      firstNameEn: serializer.fromJson<String>(json['firstNameEn']),
      fatherNameEn: serializer.fromJson<String>(json['fatherNameEn']),
      grandfatherNameEn: serializer.fromJson<String>(json['grandfatherNameEn']),
      familyNameEn: serializer.fromJson<String>(json['familyNameEn']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      gender: serializer.fromJson<int>(json['gender']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      familySize: serializer.fromJson<int>(json['familySize']),
      governorateId: serializer.fromJson<String>(json['governorateId']),
      localityId: serializer.fromJson<String>(json['localityId']),
      address: serializer.fromJson<String>(json['address']),
      name: serializer.fromJson<String>(json['name']),
      nationalId: serializer.fromJson<String>(json['nationalId']),
      rowVersion: serializer.fromJson<String>(json['rowVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncError: serializer.fromJson<String?>(json['lastSyncError']),
      isPendingDelete: serializer.fromJson<bool>(json['isPendingDelete']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deletedBy: serializer.fromJson<String?>(json['deletedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'idTypeId': serializer.toJson<int>(idTypeId),
      'idNumber': serializer.toJson<String>(idNumber),
      'firstNameAr': serializer.toJson<String>(firstNameAr),
      'fatherNameAr': serializer.toJson<String>(fatherNameAr),
      'grandfatherNameAr': serializer.toJson<String>(grandfatherNameAr),
      'familyNameAr': serializer.toJson<String>(familyNameAr),
      'firstNameEn': serializer.toJson<String>(firstNameEn),
      'fatherNameEn': serializer.toJson<String>(fatherNameEn),
      'grandfatherNameEn': serializer.toJson<String>(grandfatherNameEn),
      'familyNameEn': serializer.toJson<String>(familyNameEn),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'gender': serializer.toJson<int>(gender),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'familySize': serializer.toJson<int>(familySize),
      'governorateId': serializer.toJson<String>(governorateId),
      'localityId': serializer.toJson<String>(localityId),
      'address': serializer.toJson<String>(address),
      'name': serializer.toJson<String>(name),
      'nationalId': serializer.toJson<String>(nationalId),
      'rowVersion': serializer.toJson<String>(rowVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncError': serializer.toJson<String?>(lastSyncError),
      'isPendingDelete': serializer.toJson<bool>(isPendingDelete),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deletedBy': serializer.toJson<String?>(deletedBy),
    };
  }

  FarmerLocal copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    int? idTypeId,
    String? idNumber,
    String? firstNameAr,
    String? fatherNameAr,
    String? grandfatherNameAr,
    String? familyNameAr,
    String? firstNameEn,
    String? fatherNameEn,
    String? grandfatherNameEn,
    String? familyNameEn,
    Value<DateTime?> birthDate = const Value.absent(),
    int? gender,
    String? phoneNumber,
    int? familySize,
    String? governorateId,
    String? localityId,
    String? address,
    String? name,
    String? nationalId,
    String? rowVersion,
    String? syncStatus,
    Value<String?> lastSyncError = const Value.absent(),
    bool? isPendingDelete,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deletedBy = const Value.absent(),
  }) => FarmerLocal(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    idTypeId: idTypeId ?? this.idTypeId,
    idNumber: idNumber ?? this.idNumber,
    firstNameAr: firstNameAr ?? this.firstNameAr,
    fatherNameAr: fatherNameAr ?? this.fatherNameAr,
    grandfatherNameAr: grandfatherNameAr ?? this.grandfatherNameAr,
    familyNameAr: familyNameAr ?? this.familyNameAr,
    firstNameEn: firstNameEn ?? this.firstNameEn,
    fatherNameEn: fatherNameEn ?? this.fatherNameEn,
    grandfatherNameEn: grandfatherNameEn ?? this.grandfatherNameEn,
    familyNameEn: familyNameEn ?? this.familyNameEn,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    gender: gender ?? this.gender,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    familySize: familySize ?? this.familySize,
    governorateId: governorateId ?? this.governorateId,
    localityId: localityId ?? this.localityId,
    address: address ?? this.address,
    name: name ?? this.name,
    nationalId: nationalId ?? this.nationalId,
    rowVersion: rowVersion ?? this.rowVersion,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncError: lastSyncError.present
        ? lastSyncError.value
        : this.lastSyncError,
    isPendingDelete: isPendingDelete ?? this.isPendingDelete,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
  );
  FarmerLocal copyWithCompanion(FarmersCompanion data) {
    return FarmerLocal(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      idTypeId: data.idTypeId.present ? data.idTypeId.value : this.idTypeId,
      idNumber: data.idNumber.present ? data.idNumber.value : this.idNumber,
      firstNameAr: data.firstNameAr.present
          ? data.firstNameAr.value
          : this.firstNameAr,
      fatherNameAr: data.fatherNameAr.present
          ? data.fatherNameAr.value
          : this.fatherNameAr,
      grandfatherNameAr: data.grandfatherNameAr.present
          ? data.grandfatherNameAr.value
          : this.grandfatherNameAr,
      familyNameAr: data.familyNameAr.present
          ? data.familyNameAr.value
          : this.familyNameAr,
      firstNameEn: data.firstNameEn.present
          ? data.firstNameEn.value
          : this.firstNameEn,
      fatherNameEn: data.fatherNameEn.present
          ? data.fatherNameEn.value
          : this.fatherNameEn,
      grandfatherNameEn: data.grandfatherNameEn.present
          ? data.grandfatherNameEn.value
          : this.grandfatherNameEn,
      familyNameEn: data.familyNameEn.present
          ? data.familyNameEn.value
          : this.familyNameEn,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      gender: data.gender.present ? data.gender.value : this.gender,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      familySize: data.familySize.present
          ? data.familySize.value
          : this.familySize,
      governorateId: data.governorateId.present
          ? data.governorateId.value
          : this.governorateId,
      localityId: data.localityId.present
          ? data.localityId.value
          : this.localityId,
      address: data.address.present ? data.address.value : this.address,
      name: data.name.present ? data.name.value : this.name,
      nationalId: data.nationalId.present
          ? data.nationalId.value
          : this.nationalId,
      rowVersion: data.rowVersion.present
          ? data.rowVersion.value
          : this.rowVersion,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastSyncError: data.lastSyncError.present
          ? data.lastSyncError.value
          : this.lastSyncError,
      isPendingDelete: data.isPendingDelete.present
          ? data.isPendingDelete.value
          : this.isPendingDelete,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FarmerLocal(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('idTypeId: $idTypeId, ')
          ..write('idNumber: $idNumber, ')
          ..write('firstNameAr: $firstNameAr, ')
          ..write('fatherNameAr: $fatherNameAr, ')
          ..write('grandfatherNameAr: $grandfatherNameAr, ')
          ..write('familyNameAr: $familyNameAr, ')
          ..write('firstNameEn: $firstNameEn, ')
          ..write('fatherNameEn: $fatherNameEn, ')
          ..write('grandfatherNameEn: $grandfatherNameEn, ')
          ..write('familyNameEn: $familyNameEn, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('familySize: $familySize, ')
          ..write('governorateId: $governorateId, ')
          ..write('localityId: $localityId, ')
          ..write('address: $address, ')
          ..write('name: $name, ')
          ..write('nationalId: $nationalId, ')
          ..write('rowVersion: $rowVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncError: $lastSyncError, ')
          ..write('isPendingDelete: $isPendingDelete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    serverId,
    idTypeId,
    idNumber,
    firstNameAr,
    fatherNameAr,
    grandfatherNameAr,
    familyNameAr,
    firstNameEn,
    fatherNameEn,
    grandfatherNameEn,
    familyNameEn,
    birthDate,
    gender,
    phoneNumber,
    familySize,
    governorateId,
    localityId,
    address,
    name,
    nationalId,
    rowVersion,
    syncStatus,
    lastSyncError,
    isPendingDelete,
    createdAt,
    updatedAt,
    deletedAt,
    deletedBy,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarmerLocal &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.idTypeId == this.idTypeId &&
          other.idNumber == this.idNumber &&
          other.firstNameAr == this.firstNameAr &&
          other.fatherNameAr == this.fatherNameAr &&
          other.grandfatherNameAr == this.grandfatherNameAr &&
          other.familyNameAr == this.familyNameAr &&
          other.firstNameEn == this.firstNameEn &&
          other.fatherNameEn == this.fatherNameEn &&
          other.grandfatherNameEn == this.grandfatherNameEn &&
          other.familyNameEn == this.familyNameEn &&
          other.birthDate == this.birthDate &&
          other.gender == this.gender &&
          other.phoneNumber == this.phoneNumber &&
          other.familySize == this.familySize &&
          other.governorateId == this.governorateId &&
          other.localityId == this.localityId &&
          other.address == this.address &&
          other.name == this.name &&
          other.nationalId == this.nationalId &&
          other.rowVersion == this.rowVersion &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncError == this.lastSyncError &&
          other.isPendingDelete == this.isPendingDelete &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class FarmersCompanion extends UpdateCompanion<FarmerLocal> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<int> idTypeId;
  final Value<String> idNumber;
  final Value<String> firstNameAr;
  final Value<String> fatherNameAr;
  final Value<String> grandfatherNameAr;
  final Value<String> familyNameAr;
  final Value<String> firstNameEn;
  final Value<String> fatherNameEn;
  final Value<String> grandfatherNameEn;
  final Value<String> familyNameEn;
  final Value<DateTime?> birthDate;
  final Value<int> gender;
  final Value<String> phoneNumber;
  final Value<int> familySize;
  final Value<String> governorateId;
  final Value<String> localityId;
  final Value<String> address;
  final Value<String> name;
  final Value<String> nationalId;
  final Value<String> rowVersion;
  final Value<String> syncStatus;
  final Value<String?> lastSyncError;
  final Value<bool> isPendingDelete;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deletedBy;
  final Value<int> rowid;
  const FarmersCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.idTypeId = const Value.absent(),
    this.idNumber = const Value.absent(),
    this.firstNameAr = const Value.absent(),
    this.fatherNameAr = const Value.absent(),
    this.grandfatherNameAr = const Value.absent(),
    this.familyNameAr = const Value.absent(),
    this.firstNameEn = const Value.absent(),
    this.fatherNameEn = const Value.absent(),
    this.grandfatherNameEn = const Value.absent(),
    this.familyNameEn = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.familySize = const Value.absent(),
    this.governorateId = const Value.absent(),
    this.localityId = const Value.absent(),
    this.address = const Value.absent(),
    this.name = const Value.absent(),
    this.nationalId = const Value.absent(),
    this.rowVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncError = const Value.absent(),
    this.isPendingDelete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FarmersCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    this.idTypeId = const Value.absent(),
    this.idNumber = const Value.absent(),
    this.firstNameAr = const Value.absent(),
    this.fatherNameAr = const Value.absent(),
    this.grandfatherNameAr = const Value.absent(),
    this.familyNameAr = const Value.absent(),
    this.firstNameEn = const Value.absent(),
    this.fatherNameEn = const Value.absent(),
    this.grandfatherNameEn = const Value.absent(),
    this.familyNameEn = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.familySize = const Value.absent(),
    this.governorateId = const Value.absent(),
    this.localityId = const Value.absent(),
    this.address = const Value.absent(),
    this.name = const Value.absent(),
    this.nationalId = const Value.absent(),
    this.rowVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncError = const Value.absent(),
    this.isPendingDelete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<FarmerLocal> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<int>? idTypeId,
    Expression<String>? idNumber,
    Expression<String>? firstNameAr,
    Expression<String>? fatherNameAr,
    Expression<String>? grandfatherNameAr,
    Expression<String>? familyNameAr,
    Expression<String>? firstNameEn,
    Expression<String>? fatherNameEn,
    Expression<String>? grandfatherNameEn,
    Expression<String>? familyNameEn,
    Expression<DateTime>? birthDate,
    Expression<int>? gender,
    Expression<String>? phoneNumber,
    Expression<int>? familySize,
    Expression<String>? governorateId,
    Expression<String>? localityId,
    Expression<String>? address,
    Expression<String>? name,
    Expression<String>? nationalId,
    Expression<String>? rowVersion,
    Expression<String>? syncStatus,
    Expression<String>? lastSyncError,
    Expression<bool>? isPendingDelete,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deletedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (idTypeId != null) 'id_type_id': idTypeId,
      if (idNumber != null) 'id_number': idNumber,
      if (firstNameAr != null) 'first_name_ar': firstNameAr,
      if (fatherNameAr != null) 'father_name_ar': fatherNameAr,
      if (grandfatherNameAr != null) 'grandfather_name_ar': grandfatherNameAr,
      if (familyNameAr != null) 'family_name_ar': familyNameAr,
      if (firstNameEn != null) 'first_name_en': firstNameEn,
      if (fatherNameEn != null) 'father_name_en': fatherNameEn,
      if (grandfatherNameEn != null) 'grandfather_name_en': grandfatherNameEn,
      if (familyNameEn != null) 'family_name_en': familyNameEn,
      if (birthDate != null) 'birth_date': birthDate,
      if (gender != null) 'gender': gender,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (familySize != null) 'family_size': familySize,
      if (governorateId != null) 'governorate_id': governorateId,
      if (localityId != null) 'locality_id': localityId,
      if (address != null) 'address': address,
      if (name != null) 'name': name,
      if (nationalId != null) 'national_id': nationalId,
      if (rowVersion != null) 'row_version': rowVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncError != null) 'last_sync_error': lastSyncError,
      if (isPendingDelete != null) 'is_pending_delete': isPendingDelete,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FarmersCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<int>? idTypeId,
    Value<String>? idNumber,
    Value<String>? firstNameAr,
    Value<String>? fatherNameAr,
    Value<String>? grandfatherNameAr,
    Value<String>? familyNameAr,
    Value<String>? firstNameEn,
    Value<String>? fatherNameEn,
    Value<String>? grandfatherNameEn,
    Value<String>? familyNameEn,
    Value<DateTime?>? birthDate,
    Value<int>? gender,
    Value<String>? phoneNumber,
    Value<int>? familySize,
    Value<String>? governorateId,
    Value<String>? localityId,
    Value<String>? address,
    Value<String>? name,
    Value<String>? nationalId,
    Value<String>? rowVersion,
    Value<String>? syncStatus,
    Value<String?>? lastSyncError,
    Value<bool>? isPendingDelete,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deletedBy,
    Value<int>? rowid,
  }) {
    return FarmersCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      idTypeId: idTypeId ?? this.idTypeId,
      idNumber: idNumber ?? this.idNumber,
      firstNameAr: firstNameAr ?? this.firstNameAr,
      fatherNameAr: fatherNameAr ?? this.fatherNameAr,
      grandfatherNameAr: grandfatherNameAr ?? this.grandfatherNameAr,
      familyNameAr: familyNameAr ?? this.familyNameAr,
      firstNameEn: firstNameEn ?? this.firstNameEn,
      fatherNameEn: fatherNameEn ?? this.fatherNameEn,
      grandfatherNameEn: grandfatherNameEn ?? this.grandfatherNameEn,
      familyNameEn: familyNameEn ?? this.familyNameEn,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      familySize: familySize ?? this.familySize,
      governorateId: governorateId ?? this.governorateId,
      localityId: localityId ?? this.localityId,
      address: address ?? this.address,
      name: name ?? this.name,
      nationalId: nationalId ?? this.nationalId,
      rowVersion: rowVersion ?? this.rowVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncError: lastSyncError ?? this.lastSyncError,
      isPendingDelete: isPendingDelete ?? this.isPendingDelete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (idTypeId.present) {
      map['id_type_id'] = Variable<int>(idTypeId.value);
    }
    if (idNumber.present) {
      map['id_number'] = Variable<String>(idNumber.value);
    }
    if (firstNameAr.present) {
      map['first_name_ar'] = Variable<String>(firstNameAr.value);
    }
    if (fatherNameAr.present) {
      map['father_name_ar'] = Variable<String>(fatherNameAr.value);
    }
    if (grandfatherNameAr.present) {
      map['grandfather_name_ar'] = Variable<String>(grandfatherNameAr.value);
    }
    if (familyNameAr.present) {
      map['family_name_ar'] = Variable<String>(familyNameAr.value);
    }
    if (firstNameEn.present) {
      map['first_name_en'] = Variable<String>(firstNameEn.value);
    }
    if (fatherNameEn.present) {
      map['father_name_en'] = Variable<String>(fatherNameEn.value);
    }
    if (grandfatherNameEn.present) {
      map['grandfather_name_en'] = Variable<String>(grandfatherNameEn.value);
    }
    if (familyNameEn.present) {
      map['family_name_en'] = Variable<String>(familyNameEn.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int>(gender.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (familySize.present) {
      map['family_size'] = Variable<int>(familySize.value);
    }
    if (governorateId.present) {
      map['governorate_id'] = Variable<String>(governorateId.value);
    }
    if (localityId.present) {
      map['locality_id'] = Variable<String>(localityId.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nationalId.present) {
      map['national_id'] = Variable<String>(nationalId.value);
    }
    if (rowVersion.present) {
      map['row_version'] = Variable<String>(rowVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncError.present) {
      map['last_sync_error'] = Variable<String>(lastSyncError.value);
    }
    if (isPendingDelete.present) {
      map['is_pending_delete'] = Variable<bool>(isPendingDelete.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<String>(deletedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FarmersCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('idTypeId: $idTypeId, ')
          ..write('idNumber: $idNumber, ')
          ..write('firstNameAr: $firstNameAr, ')
          ..write('fatherNameAr: $fatherNameAr, ')
          ..write('grandfatherNameAr: $grandfatherNameAr, ')
          ..write('familyNameAr: $familyNameAr, ')
          ..write('firstNameEn: $firstNameEn, ')
          ..write('fatherNameEn: $fatherNameEn, ')
          ..write('grandfatherNameEn: $grandfatherNameEn, ')
          ..write('familyNameEn: $familyNameEn, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('familySize: $familySize, ')
          ..write('governorateId: $governorateId, ')
          ..write('localityId: $localityId, ')
          ..write('address: $address, ')
          ..write('name: $name, ')
          ..write('nationalId: $nationalId, ')
          ..write('rowVersion: $rowVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncError: $lastSyncError, ')
          ..write('isPendingDelete: $isPendingDelete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FarmsTable extends Farms with TableInfo<$FarmsTable, FarmLocal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FarmsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _farmerIdMeta = const VerificationMeta(
    'farmerId',
  );
  @override
  late final GeneratedColumn<String> farmerId = GeneratedColumn<String>(
    'farmer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerFarmerIdMeta = const VerificationMeta(
    'ownerFarmerId',
  );
  @override
  late final GeneratedColumn<String> ownerFarmerId = GeneratedColumn<String>(
    'owner_farmer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localFarmNameMeta = const VerificationMeta(
    'localFarmName',
  );
  @override
  late final GeneratedColumn<String> localFarmName = GeneratedColumn<String>(
    'local_farm_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownershipTypeIdMeta = const VerificationMeta(
    'ownershipTypeId',
  );
  @override
  late final GeneratedColumn<int> ownershipTypeId = GeneratedColumn<int>(
    'ownership_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _relationshipToOwnerIdMeta =
      const VerificationMeta('relationshipToOwnerId');
  @override
  late final GeneratedColumn<int> relationshipToOwnerId = GeneratedColumn<int>(
    'relationship_to_owner_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _governorateIdMeta = const VerificationMeta(
    'governorateId',
  );
  @override
  late final GeneratedColumn<String> governorateId = GeneratedColumn<String>(
    'governorate_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directorateIdMeta = const VerificationMeta(
    'directorateId',
  );
  @override
  late final GeneratedColumn<String> directorateId = GeneratedColumn<String>(
    'directorate_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localityIdMeta = const VerificationMeta(
    'localityId',
  );
  @override
  late final GeneratedColumn<String> localityId = GeneratedColumn<String>(
    'locality_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _basinMeta = const VerificationMeta('basin');
  @override
  late final GeneratedColumn<String> basin = GeneratedColumn<String>(
    'basin',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parcelMeta = const VerificationMeta('parcel');
  @override
  late final GeneratedColumn<String> parcel = GeneratedColumn<String>(
    'parcel',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<double> area = GeneratedColumn<double>(
    'area',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _areaUnitIdMeta = const VerificationMeta(
    'areaUnitId',
  );
  @override
  late final GeneratedColumn<int> areaUnitId = GeneratedColumn<int>(
    'area_unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _agriculturalSectorIdMeta =
      const VerificationMeta('agriculturalSectorId');
  @override
  late final GeneratedColumn<int> agriculturalSectorId = GeneratedColumn<int>(
    'agricultural_sector_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _politicalClassificationIdMeta =
      const VerificationMeta('politicalClassificationId');
  @override
  late final GeneratedColumn<int> politicalClassificationId =
      GeneratedColumn<int>(
        'political_classification_id',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(1),
      );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rowVersionMeta = const VerificationMeta(
    'rowVersion',
  );
  @override
  late final GeneratedColumn<String> rowVersion = GeneratedColumn<String>(
    'row_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('completed'),
  );
  static const VerificationMeta _lastSyncErrorMeta = const VerificationMeta(
    'lastSyncError',
  );
  @override
  late final GeneratedColumn<String> lastSyncError = GeneratedColumn<String>(
    'last_sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPendingDeleteMeta = const VerificationMeta(
    'isPendingDelete',
  );
  @override
  late final GeneratedColumn<bool> isPendingDelete = GeneratedColumn<bool>(
    'is_pending_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pending_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    farmerId,
    ownerFarmerId,
    localFarmName,
    ownershipTypeId,
    relationshipToOwnerId,
    governorateId,
    directorateId,
    localityId,
    basin,
    parcel,
    area,
    areaUnitId,
    agriculturalSectorId,
    politicalClassificationId,
    latitude,
    longitude,
    notes,
    rowVersion,
    syncStatus,
    lastSyncError,
    isPendingDelete,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'farms';
  @override
  VerificationContext validateIntegrity(
    Insertable<FarmLocal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('farmer_id')) {
      context.handle(
        _farmerIdMeta,
        farmerId.isAcceptableOrUnknown(data['farmer_id']!, _farmerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_farmerIdMeta);
    }
    if (data.containsKey('owner_farmer_id')) {
      context.handle(
        _ownerFarmerIdMeta,
        ownerFarmerId.isAcceptableOrUnknown(
          data['owner_farmer_id']!,
          _ownerFarmerIdMeta,
        ),
      );
    }
    if (data.containsKey('local_farm_name')) {
      context.handle(
        _localFarmNameMeta,
        localFarmName.isAcceptableOrUnknown(
          data['local_farm_name']!,
          _localFarmNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localFarmNameMeta);
    }
    if (data.containsKey('ownership_type_id')) {
      context.handle(
        _ownershipTypeIdMeta,
        ownershipTypeId.isAcceptableOrUnknown(
          data['ownership_type_id']!,
          _ownershipTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('relationship_to_owner_id')) {
      context.handle(
        _relationshipToOwnerIdMeta,
        relationshipToOwnerId.isAcceptableOrUnknown(
          data['relationship_to_owner_id']!,
          _relationshipToOwnerIdMeta,
        ),
      );
    }
    if (data.containsKey('governorate_id')) {
      context.handle(
        _governorateIdMeta,
        governorateId.isAcceptableOrUnknown(
          data['governorate_id']!,
          _governorateIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_governorateIdMeta);
    }
    if (data.containsKey('directorate_id')) {
      context.handle(
        _directorateIdMeta,
        directorateId.isAcceptableOrUnknown(
          data['directorate_id']!,
          _directorateIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_directorateIdMeta);
    }
    if (data.containsKey('locality_id')) {
      context.handle(
        _localityIdMeta,
        localityId.isAcceptableOrUnknown(data['locality_id']!, _localityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localityIdMeta);
    }
    if (data.containsKey('basin')) {
      context.handle(
        _basinMeta,
        basin.isAcceptableOrUnknown(data['basin']!, _basinMeta),
      );
    } else if (isInserting) {
      context.missing(_basinMeta);
    }
    if (data.containsKey('parcel')) {
      context.handle(
        _parcelMeta,
        parcel.isAcceptableOrUnknown(data['parcel']!, _parcelMeta),
      );
    } else if (isInserting) {
      context.missing(_parcelMeta);
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    } else if (isInserting) {
      context.missing(_areaMeta);
    }
    if (data.containsKey('area_unit_id')) {
      context.handle(
        _areaUnitIdMeta,
        areaUnitId.isAcceptableOrUnknown(
          data['area_unit_id']!,
          _areaUnitIdMeta,
        ),
      );
    }
    if (data.containsKey('agricultural_sector_id')) {
      context.handle(
        _agriculturalSectorIdMeta,
        agriculturalSectorId.isAcceptableOrUnknown(
          data['agricultural_sector_id']!,
          _agriculturalSectorIdMeta,
        ),
      );
    }
    if (data.containsKey('political_classification_id')) {
      context.handle(
        _politicalClassificationIdMeta,
        politicalClassificationId.isAcceptableOrUnknown(
          data['political_classification_id']!,
          _politicalClassificationIdMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('row_version')) {
      context.handle(
        _rowVersionMeta,
        rowVersion.isAcceptableOrUnknown(data['row_version']!, _rowVersionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_sync_error')) {
      context.handle(
        _lastSyncErrorMeta,
        lastSyncError.isAcceptableOrUnknown(
          data['last_sync_error']!,
          _lastSyncErrorMeta,
        ),
      );
    }
    if (data.containsKey('is_pending_delete')) {
      context.handle(
        _isPendingDeleteMeta,
        isPendingDelete.isAcceptableOrUnknown(
          data['is_pending_delete']!,
          _isPendingDeleteMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FarmLocal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FarmLocal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      farmerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}farmer_id'],
      )!,
      ownerFarmerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_farmer_id'],
      ),
      localFarmName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_farm_name'],
      )!,
      ownershipTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ownership_type_id'],
      )!,
      relationshipToOwnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}relationship_to_owner_id'],
      ),
      governorateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}governorate_id'],
      )!,
      directorateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}directorate_id'],
      )!,
      localityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locality_id'],
      )!,
      basin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}basin'],
      )!,
      parcel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parcel'],
      )!,
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area'],
      )!,
      areaUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}area_unit_id'],
      )!,
      agriculturalSectorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}agricultural_sector_id'],
      )!,
      politicalClassificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}political_classification_id'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      rowVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_version'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastSyncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sync_error'],
      ),
      isPendingDelete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pending_delete'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $FarmsTable createAlias(String alias) {
    return $FarmsTable(attachedDatabase, alias);
  }
}

class FarmLocal extends DataClass implements Insertable<FarmLocal> {
  final String id;
  final String? serverId;
  final String farmerId;
  final String? ownerFarmerId;
  final String localFarmName;
  final int ownershipTypeId;
  final int? relationshipToOwnerId;
  final String governorateId;
  final String directorateId;
  final String localityId;
  final String basin;
  final String parcel;
  final double area;
  final int areaUnitId;
  final int agriculturalSectorId;
  final int politicalClassificationId;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final String rowVersion;
  final String syncStatus;
  final String? lastSyncError;
  final bool isPendingDelete;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const FarmLocal({
    required this.id,
    this.serverId,
    required this.farmerId,
    this.ownerFarmerId,
    required this.localFarmName,
    required this.ownershipTypeId,
    this.relationshipToOwnerId,
    required this.governorateId,
    required this.directorateId,
    required this.localityId,
    required this.basin,
    required this.parcel,
    required this.area,
    required this.areaUnitId,
    required this.agriculturalSectorId,
    required this.politicalClassificationId,
    this.latitude,
    this.longitude,
    this.notes,
    required this.rowVersion,
    required this.syncStatus,
    this.lastSyncError,
    required this.isPendingDelete,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['farmer_id'] = Variable<String>(farmerId);
    if (!nullToAbsent || ownerFarmerId != null) {
      map['owner_farmer_id'] = Variable<String>(ownerFarmerId);
    }
    map['local_farm_name'] = Variable<String>(localFarmName);
    map['ownership_type_id'] = Variable<int>(ownershipTypeId);
    if (!nullToAbsent || relationshipToOwnerId != null) {
      map['relationship_to_owner_id'] = Variable<int>(relationshipToOwnerId);
    }
    map['governorate_id'] = Variable<String>(governorateId);
    map['directorate_id'] = Variable<String>(directorateId);
    map['locality_id'] = Variable<String>(localityId);
    map['basin'] = Variable<String>(basin);
    map['parcel'] = Variable<String>(parcel);
    map['area'] = Variable<double>(area);
    map['area_unit_id'] = Variable<int>(areaUnitId);
    map['agricultural_sector_id'] = Variable<int>(agriculturalSectorId);
    map['political_classification_id'] = Variable<int>(
      politicalClassificationId,
    );
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['row_version'] = Variable<String>(rowVersion);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncError != null) {
      map['last_sync_error'] = Variable<String>(lastSyncError);
    }
    map['is_pending_delete'] = Variable<bool>(isPendingDelete);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  FarmsCompanion toCompanion(bool nullToAbsent) {
    return FarmsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      farmerId: Value(farmerId),
      ownerFarmerId: ownerFarmerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerFarmerId),
      localFarmName: Value(localFarmName),
      ownershipTypeId: Value(ownershipTypeId),
      relationshipToOwnerId: relationshipToOwnerId == null && nullToAbsent
          ? const Value.absent()
          : Value(relationshipToOwnerId),
      governorateId: Value(governorateId),
      directorateId: Value(directorateId),
      localityId: Value(localityId),
      basin: Value(basin),
      parcel: Value(parcel),
      area: Value(area),
      areaUnitId: Value(areaUnitId),
      agriculturalSectorId: Value(agriculturalSectorId),
      politicalClassificationId: Value(politicalClassificationId),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      rowVersion: Value(rowVersion),
      syncStatus: Value(syncStatus),
      lastSyncError: lastSyncError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncError),
      isPendingDelete: Value(isPendingDelete),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory FarmLocal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarmLocal(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      farmerId: serializer.fromJson<String>(json['farmerId']),
      ownerFarmerId: serializer.fromJson<String?>(json['ownerFarmerId']),
      localFarmName: serializer.fromJson<String>(json['localFarmName']),
      ownershipTypeId: serializer.fromJson<int>(json['ownershipTypeId']),
      relationshipToOwnerId: serializer.fromJson<int?>(
        json['relationshipToOwnerId'],
      ),
      governorateId: serializer.fromJson<String>(json['governorateId']),
      directorateId: serializer.fromJson<String>(json['directorateId']),
      localityId: serializer.fromJson<String>(json['localityId']),
      basin: serializer.fromJson<String>(json['basin']),
      parcel: serializer.fromJson<String>(json['parcel']),
      area: serializer.fromJson<double>(json['area']),
      areaUnitId: serializer.fromJson<int>(json['areaUnitId']),
      agriculturalSectorId: serializer.fromJson<int>(
        json['agriculturalSectorId'],
      ),
      politicalClassificationId: serializer.fromJson<int>(
        json['politicalClassificationId'],
      ),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      notes: serializer.fromJson<String?>(json['notes']),
      rowVersion: serializer.fromJson<String>(json['rowVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncError: serializer.fromJson<String?>(json['lastSyncError']),
      isPendingDelete: serializer.fromJson<bool>(json['isPendingDelete']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'farmerId': serializer.toJson<String>(farmerId),
      'ownerFarmerId': serializer.toJson<String?>(ownerFarmerId),
      'localFarmName': serializer.toJson<String>(localFarmName),
      'ownershipTypeId': serializer.toJson<int>(ownershipTypeId),
      'relationshipToOwnerId': serializer.toJson<int?>(relationshipToOwnerId),
      'governorateId': serializer.toJson<String>(governorateId),
      'directorateId': serializer.toJson<String>(directorateId),
      'localityId': serializer.toJson<String>(localityId),
      'basin': serializer.toJson<String>(basin),
      'parcel': serializer.toJson<String>(parcel),
      'area': serializer.toJson<double>(area),
      'areaUnitId': serializer.toJson<int>(areaUnitId),
      'agriculturalSectorId': serializer.toJson<int>(agriculturalSectorId),
      'politicalClassificationId': serializer.toJson<int>(
        politicalClassificationId,
      ),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'notes': serializer.toJson<String?>(notes),
      'rowVersion': serializer.toJson<String>(rowVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncError': serializer.toJson<String?>(lastSyncError),
      'isPendingDelete': serializer.toJson<bool>(isPendingDelete),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  FarmLocal copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? farmerId,
    Value<String?> ownerFarmerId = const Value.absent(),
    String? localFarmName,
    int? ownershipTypeId,
    Value<int?> relationshipToOwnerId = const Value.absent(),
    String? governorateId,
    String? directorateId,
    String? localityId,
    String? basin,
    String? parcel,
    double? area,
    int? areaUnitId,
    int? agriculturalSectorId,
    int? politicalClassificationId,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? rowVersion,
    String? syncStatus,
    Value<String?> lastSyncError = const Value.absent(),
    bool? isPendingDelete,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => FarmLocal(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    farmerId: farmerId ?? this.farmerId,
    ownerFarmerId: ownerFarmerId.present
        ? ownerFarmerId.value
        : this.ownerFarmerId,
    localFarmName: localFarmName ?? this.localFarmName,
    ownershipTypeId: ownershipTypeId ?? this.ownershipTypeId,
    relationshipToOwnerId: relationshipToOwnerId.present
        ? relationshipToOwnerId.value
        : this.relationshipToOwnerId,
    governorateId: governorateId ?? this.governorateId,
    directorateId: directorateId ?? this.directorateId,
    localityId: localityId ?? this.localityId,
    basin: basin ?? this.basin,
    parcel: parcel ?? this.parcel,
    area: area ?? this.area,
    areaUnitId: areaUnitId ?? this.areaUnitId,
    agriculturalSectorId: agriculturalSectorId ?? this.agriculturalSectorId,
    politicalClassificationId:
        politicalClassificationId ?? this.politicalClassificationId,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    notes: notes.present ? notes.value : this.notes,
    rowVersion: rowVersion ?? this.rowVersion,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncError: lastSyncError.present
        ? lastSyncError.value
        : this.lastSyncError,
    isPendingDelete: isPendingDelete ?? this.isPendingDelete,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  FarmLocal copyWithCompanion(FarmsCompanion data) {
    return FarmLocal(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      farmerId: data.farmerId.present ? data.farmerId.value : this.farmerId,
      ownerFarmerId: data.ownerFarmerId.present
          ? data.ownerFarmerId.value
          : this.ownerFarmerId,
      localFarmName: data.localFarmName.present
          ? data.localFarmName.value
          : this.localFarmName,
      ownershipTypeId: data.ownershipTypeId.present
          ? data.ownershipTypeId.value
          : this.ownershipTypeId,
      relationshipToOwnerId: data.relationshipToOwnerId.present
          ? data.relationshipToOwnerId.value
          : this.relationshipToOwnerId,
      governorateId: data.governorateId.present
          ? data.governorateId.value
          : this.governorateId,
      directorateId: data.directorateId.present
          ? data.directorateId.value
          : this.directorateId,
      localityId: data.localityId.present
          ? data.localityId.value
          : this.localityId,
      basin: data.basin.present ? data.basin.value : this.basin,
      parcel: data.parcel.present ? data.parcel.value : this.parcel,
      area: data.area.present ? data.area.value : this.area,
      areaUnitId: data.areaUnitId.present
          ? data.areaUnitId.value
          : this.areaUnitId,
      agriculturalSectorId: data.agriculturalSectorId.present
          ? data.agriculturalSectorId.value
          : this.agriculturalSectorId,
      politicalClassificationId: data.politicalClassificationId.present
          ? data.politicalClassificationId.value
          : this.politicalClassificationId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      notes: data.notes.present ? data.notes.value : this.notes,
      rowVersion: data.rowVersion.present
          ? data.rowVersion.value
          : this.rowVersion,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastSyncError: data.lastSyncError.present
          ? data.lastSyncError.value
          : this.lastSyncError,
      isPendingDelete: data.isPendingDelete.present
          ? data.isPendingDelete.value
          : this.isPendingDelete,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FarmLocal(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('farmerId: $farmerId, ')
          ..write('ownerFarmerId: $ownerFarmerId, ')
          ..write('localFarmName: $localFarmName, ')
          ..write('ownershipTypeId: $ownershipTypeId, ')
          ..write('relationshipToOwnerId: $relationshipToOwnerId, ')
          ..write('governorateId: $governorateId, ')
          ..write('directorateId: $directorateId, ')
          ..write('localityId: $localityId, ')
          ..write('basin: $basin, ')
          ..write('parcel: $parcel, ')
          ..write('area: $area, ')
          ..write('areaUnitId: $areaUnitId, ')
          ..write('agriculturalSectorId: $agriculturalSectorId, ')
          ..write('politicalClassificationId: $politicalClassificationId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('notes: $notes, ')
          ..write('rowVersion: $rowVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncError: $lastSyncError, ')
          ..write('isPendingDelete: $isPendingDelete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    serverId,
    farmerId,
    ownerFarmerId,
    localFarmName,
    ownershipTypeId,
    relationshipToOwnerId,
    governorateId,
    directorateId,
    localityId,
    basin,
    parcel,
    area,
    areaUnitId,
    agriculturalSectorId,
    politicalClassificationId,
    latitude,
    longitude,
    notes,
    rowVersion,
    syncStatus,
    lastSyncError,
    isPendingDelete,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarmLocal &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.farmerId == this.farmerId &&
          other.ownerFarmerId == this.ownerFarmerId &&
          other.localFarmName == this.localFarmName &&
          other.ownershipTypeId == this.ownershipTypeId &&
          other.relationshipToOwnerId == this.relationshipToOwnerId &&
          other.governorateId == this.governorateId &&
          other.directorateId == this.directorateId &&
          other.localityId == this.localityId &&
          other.basin == this.basin &&
          other.parcel == this.parcel &&
          other.area == this.area &&
          other.areaUnitId == this.areaUnitId &&
          other.agriculturalSectorId == this.agriculturalSectorId &&
          other.politicalClassificationId == this.politicalClassificationId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.notes == this.notes &&
          other.rowVersion == this.rowVersion &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncError == this.lastSyncError &&
          other.isPendingDelete == this.isPendingDelete &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FarmsCompanion extends UpdateCompanion<FarmLocal> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> farmerId;
  final Value<String?> ownerFarmerId;
  final Value<String> localFarmName;
  final Value<int> ownershipTypeId;
  final Value<int?> relationshipToOwnerId;
  final Value<String> governorateId;
  final Value<String> directorateId;
  final Value<String> localityId;
  final Value<String> basin;
  final Value<String> parcel;
  final Value<double> area;
  final Value<int> areaUnitId;
  final Value<int> agriculturalSectorId;
  final Value<int> politicalClassificationId;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> notes;
  final Value<String> rowVersion;
  final Value<String> syncStatus;
  final Value<String?> lastSyncError;
  final Value<bool> isPendingDelete;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const FarmsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.farmerId = const Value.absent(),
    this.ownerFarmerId = const Value.absent(),
    this.localFarmName = const Value.absent(),
    this.ownershipTypeId = const Value.absent(),
    this.relationshipToOwnerId = const Value.absent(),
    this.governorateId = const Value.absent(),
    this.directorateId = const Value.absent(),
    this.localityId = const Value.absent(),
    this.basin = const Value.absent(),
    this.parcel = const Value.absent(),
    this.area = const Value.absent(),
    this.areaUnitId = const Value.absent(),
    this.agriculturalSectorId = const Value.absent(),
    this.politicalClassificationId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncError = const Value.absent(),
    this.isPendingDelete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FarmsCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String farmerId,
    this.ownerFarmerId = const Value.absent(),
    required String localFarmName,
    this.ownershipTypeId = const Value.absent(),
    this.relationshipToOwnerId = const Value.absent(),
    required String governorateId,
    required String directorateId,
    required String localityId,
    required String basin,
    required String parcel,
    required double area,
    this.areaUnitId = const Value.absent(),
    this.agriculturalSectorId = const Value.absent(),
    this.politicalClassificationId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncError = const Value.absent(),
    this.isPendingDelete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       farmerId = Value(farmerId),
       localFarmName = Value(localFarmName),
       governorateId = Value(governorateId),
       directorateId = Value(directorateId),
       localityId = Value(localityId),
       basin = Value(basin),
       parcel = Value(parcel),
       area = Value(area);
  static Insertable<FarmLocal> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? farmerId,
    Expression<String>? ownerFarmerId,
    Expression<String>? localFarmName,
    Expression<int>? ownershipTypeId,
    Expression<int>? relationshipToOwnerId,
    Expression<String>? governorateId,
    Expression<String>? directorateId,
    Expression<String>? localityId,
    Expression<String>? basin,
    Expression<String>? parcel,
    Expression<double>? area,
    Expression<int>? areaUnitId,
    Expression<int>? agriculturalSectorId,
    Expression<int>? politicalClassificationId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? notes,
    Expression<String>? rowVersion,
    Expression<String>? syncStatus,
    Expression<String>? lastSyncError,
    Expression<bool>? isPendingDelete,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (farmerId != null) 'farmer_id': farmerId,
      if (ownerFarmerId != null) 'owner_farmer_id': ownerFarmerId,
      if (localFarmName != null) 'local_farm_name': localFarmName,
      if (ownershipTypeId != null) 'ownership_type_id': ownershipTypeId,
      if (relationshipToOwnerId != null)
        'relationship_to_owner_id': relationshipToOwnerId,
      if (governorateId != null) 'governorate_id': governorateId,
      if (directorateId != null) 'directorate_id': directorateId,
      if (localityId != null) 'locality_id': localityId,
      if (basin != null) 'basin': basin,
      if (parcel != null) 'parcel': parcel,
      if (area != null) 'area': area,
      if (areaUnitId != null) 'area_unit_id': areaUnitId,
      if (agriculturalSectorId != null)
        'agricultural_sector_id': agriculturalSectorId,
      if (politicalClassificationId != null)
        'political_classification_id': politicalClassificationId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (notes != null) 'notes': notes,
      if (rowVersion != null) 'row_version': rowVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncError != null) 'last_sync_error': lastSyncError,
      if (isPendingDelete != null) 'is_pending_delete': isPendingDelete,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FarmsCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? farmerId,
    Value<String?>? ownerFarmerId,
    Value<String>? localFarmName,
    Value<int>? ownershipTypeId,
    Value<int?>? relationshipToOwnerId,
    Value<String>? governorateId,
    Value<String>? directorateId,
    Value<String>? localityId,
    Value<String>? basin,
    Value<String>? parcel,
    Value<double>? area,
    Value<int>? areaUnitId,
    Value<int>? agriculturalSectorId,
    Value<int>? politicalClassificationId,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? notes,
    Value<String>? rowVersion,
    Value<String>? syncStatus,
    Value<String?>? lastSyncError,
    Value<bool>? isPendingDelete,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return FarmsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      farmerId: farmerId ?? this.farmerId,
      ownerFarmerId: ownerFarmerId ?? this.ownerFarmerId,
      localFarmName: localFarmName ?? this.localFarmName,
      ownershipTypeId: ownershipTypeId ?? this.ownershipTypeId,
      relationshipToOwnerId:
          relationshipToOwnerId ?? this.relationshipToOwnerId,
      governorateId: governorateId ?? this.governorateId,
      directorateId: directorateId ?? this.directorateId,
      localityId: localityId ?? this.localityId,
      basin: basin ?? this.basin,
      parcel: parcel ?? this.parcel,
      area: area ?? this.area,
      areaUnitId: areaUnitId ?? this.areaUnitId,
      agriculturalSectorId: agriculturalSectorId ?? this.agriculturalSectorId,
      politicalClassificationId:
          politicalClassificationId ?? this.politicalClassificationId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      notes: notes ?? this.notes,
      rowVersion: rowVersion ?? this.rowVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncError: lastSyncError ?? this.lastSyncError,
      isPendingDelete: isPendingDelete ?? this.isPendingDelete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (farmerId.present) {
      map['farmer_id'] = Variable<String>(farmerId.value);
    }
    if (ownerFarmerId.present) {
      map['owner_farmer_id'] = Variable<String>(ownerFarmerId.value);
    }
    if (localFarmName.present) {
      map['local_farm_name'] = Variable<String>(localFarmName.value);
    }
    if (ownershipTypeId.present) {
      map['ownership_type_id'] = Variable<int>(ownershipTypeId.value);
    }
    if (relationshipToOwnerId.present) {
      map['relationship_to_owner_id'] = Variable<int>(
        relationshipToOwnerId.value,
      );
    }
    if (governorateId.present) {
      map['governorate_id'] = Variable<String>(governorateId.value);
    }
    if (directorateId.present) {
      map['directorate_id'] = Variable<String>(directorateId.value);
    }
    if (localityId.present) {
      map['locality_id'] = Variable<String>(localityId.value);
    }
    if (basin.present) {
      map['basin'] = Variable<String>(basin.value);
    }
    if (parcel.present) {
      map['parcel'] = Variable<String>(parcel.value);
    }
    if (area.present) {
      map['area'] = Variable<double>(area.value);
    }
    if (areaUnitId.present) {
      map['area_unit_id'] = Variable<int>(areaUnitId.value);
    }
    if (agriculturalSectorId.present) {
      map['agricultural_sector_id'] = Variable<int>(agriculturalSectorId.value);
    }
    if (politicalClassificationId.present) {
      map['political_classification_id'] = Variable<int>(
        politicalClassificationId.value,
      );
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowVersion.present) {
      map['row_version'] = Variable<String>(rowVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncError.present) {
      map['last_sync_error'] = Variable<String>(lastSyncError.value);
    }
    if (isPendingDelete.present) {
      map['is_pending_delete'] = Variable<bool>(isPendingDelete.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FarmsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('farmerId: $farmerId, ')
          ..write('ownerFarmerId: $ownerFarmerId, ')
          ..write('localFarmName: $localFarmName, ')
          ..write('ownershipTypeId: $ownershipTypeId, ')
          ..write('relationshipToOwnerId: $relationshipToOwnerId, ')
          ..write('governorateId: $governorateId, ')
          ..write('directorateId: $directorateId, ')
          ..write('localityId: $localityId, ')
          ..write('basin: $basin, ')
          ..write('parcel: $parcel, ')
          ..write('area: $area, ')
          ..write('areaUnitId: $areaUnitId, ')
          ..write('agriculturalSectorId: $agriculturalSectorId, ')
          ..write('politicalClassificationId: $politicalClassificationId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('notes: $notes, ')
          ..write('rowVersion: $rowVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncError: $lastSyncError, ')
          ..write('isPendingDelete: $isPendingDelete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DamageReportsTable extends DamageReports
    with TableInfo<$DamageReportsTable, DamageReportLocal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DamageReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _permanentFormNumberMeta =
      const VerificationMeta('permanentFormNumber');
  @override
  late final GeneratedColumn<String> permanentFormNumber =
      GeneratedColumn<String>(
        'permanent_form_number',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _temporaryFormNumberMeta =
      const VerificationMeta('temporaryFormNumber');
  @override
  late final GeneratedColumn<String> temporaryFormNumber =
      GeneratedColumn<String>(
        'temporary_form_number',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _damageYearMeta = const VerificationMeta(
    'damageYear',
  );
  @override
  late final GeneratedColumn<int> damageYear = GeneratedColumn<int>(
    'damage_year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
    'farm_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _farmerIdMeta = const VerificationMeta(
    'farmerId',
  );
  @override
  late final GeneratedColumn<String> farmerId = GeneratedColumn<String>(
    'farmer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _damageDateMeta = const VerificationMeta(
    'damageDate',
  );
  @override
  late final GeneratedColumn<DateTime> damageDate = GeneratedColumn<DateTime>(
    'damage_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentationDateMeta = const VerificationMeta(
    'documentationDate',
  );
  @override
  late final GeneratedColumn<DateTime> documentationDate =
      GeneratedColumn<DateTime>(
        'documentation_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _damageCauseCategoryIdMeta =
      const VerificationMeta('damageCauseCategoryId');
  @override
  late final GeneratedColumn<int> damageCauseCategoryId = GeneratedColumn<int>(
    'damage_cause_category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _damageCauseIdMeta = const VerificationMeta(
    'damageCauseId',
  );
  @override
  late final GeneratedColumn<int> damageCauseId = GeneratedColumn<int>(
    'damage_cause_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _settlementNameMeta = const VerificationMeta(
    'settlementName',
  );
  @override
  late final GeneratedColumn<String> settlementName = GeneratedColumn<String>(
    'settlement_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _governorateIdMeta = const VerificationMeta(
    'governorateId',
  );
  @override
  late final GeneratedColumn<String> governorateId = GeneratedColumn<String>(
    'governorate_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localityIdMeta = const VerificationMeta(
    'localityId',
  );
  @override
  late final GeneratedColumn<String> localityId = GeneratedColumn<String>(
    'locality_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusIdMeta = const VerificationMeta(
    'statusId',
  );
  @override
  late final GeneratedColumn<String> statusId = GeneratedColumn<String>(
    'status_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowVersionMeta = const VerificationMeta(
    'rowVersion',
  );
  @override
  late final GeneratedColumn<String> rowVersion = GeneratedColumn<String>(
    'row_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('completed'),
  );
  static const VerificationMeta _lastSyncErrorMeta = const VerificationMeta(
    'lastSyncError',
  );
  @override
  late final GeneratedColumn<String> lastSyncError = GeneratedColumn<String>(
    'last_sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPendingDeleteMeta = const VerificationMeta(
    'isPendingDelete',
  );
  @override
  late final GeneratedColumn<bool> isPendingDelete = GeneratedColumn<bool>(
    'is_pending_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pending_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    permanentFormNumber,
    temporaryFormNumber,
    damageYear,
    farmId,
    farmerId,
    damageDate,
    documentationDate,
    damageCauseCategoryId,
    damageCauseId,
    settlementName,
    companyName,
    governorateId,
    localityId,
    latitude,
    longitude,
    statusId,
    notes,
    rowVersion,
    syncStatus,
    lastSyncError,
    isPendingDelete,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'damage_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<DamageReportLocal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('permanent_form_number')) {
      context.handle(
        _permanentFormNumberMeta,
        permanentFormNumber.isAcceptableOrUnknown(
          data['permanent_form_number']!,
          _permanentFormNumberMeta,
        ),
      );
    }
    if (data.containsKey('temporary_form_number')) {
      context.handle(
        _temporaryFormNumberMeta,
        temporaryFormNumber.isAcceptableOrUnknown(
          data['temporary_form_number']!,
          _temporaryFormNumberMeta,
        ),
      );
    }
    if (data.containsKey('damage_year')) {
      context.handle(
        _damageYearMeta,
        damageYear.isAcceptableOrUnknown(data['damage_year']!, _damageYearMeta),
      );
    }
    if (data.containsKey('farm_id')) {
      context.handle(
        _farmIdMeta,
        farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta),
      );
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('farmer_id')) {
      context.handle(
        _farmerIdMeta,
        farmerId.isAcceptableOrUnknown(data['farmer_id']!, _farmerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_farmerIdMeta);
    }
    if (data.containsKey('damage_date')) {
      context.handle(
        _damageDateMeta,
        damageDate.isAcceptableOrUnknown(data['damage_date']!, _damageDateMeta),
      );
    } else if (isInserting) {
      context.missing(_damageDateMeta);
    }
    if (data.containsKey('documentation_date')) {
      context.handle(
        _documentationDateMeta,
        documentationDate.isAcceptableOrUnknown(
          data['documentation_date']!,
          _documentationDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_documentationDateMeta);
    }
    if (data.containsKey('damage_cause_category_id')) {
      context.handle(
        _damageCauseCategoryIdMeta,
        damageCauseCategoryId.isAcceptableOrUnknown(
          data['damage_cause_category_id']!,
          _damageCauseCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('damage_cause_id')) {
      context.handle(
        _damageCauseIdMeta,
        damageCauseId.isAcceptableOrUnknown(
          data['damage_cause_id']!,
          _damageCauseIdMeta,
        ),
      );
    }
    if (data.containsKey('settlement_name')) {
      context.handle(
        _settlementNameMeta,
        settlementName.isAcceptableOrUnknown(
          data['settlement_name']!,
          _settlementNameMeta,
        ),
      );
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    }
    if (data.containsKey('governorate_id')) {
      context.handle(
        _governorateIdMeta,
        governorateId.isAcceptableOrUnknown(
          data['governorate_id']!,
          _governorateIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_governorateIdMeta);
    }
    if (data.containsKey('locality_id')) {
      context.handle(
        _localityIdMeta,
        localityId.isAcceptableOrUnknown(data['locality_id']!, _localityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localityIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('status_id')) {
      context.handle(
        _statusIdMeta,
        statusId.isAcceptableOrUnknown(data['status_id']!, _statusIdMeta),
      );
    } else if (isInserting) {
      context.missing(_statusIdMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('row_version')) {
      context.handle(
        _rowVersionMeta,
        rowVersion.isAcceptableOrUnknown(data['row_version']!, _rowVersionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_sync_error')) {
      context.handle(
        _lastSyncErrorMeta,
        lastSyncError.isAcceptableOrUnknown(
          data['last_sync_error']!,
          _lastSyncErrorMeta,
        ),
      );
    }
    if (data.containsKey('is_pending_delete')) {
      context.handle(
        _isPendingDeleteMeta,
        isPendingDelete.isAcceptableOrUnknown(
          data['is_pending_delete']!,
          _isPendingDeleteMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DamageReportLocal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DamageReportLocal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      permanentFormNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permanent_form_number'],
      )!,
      temporaryFormNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temporary_form_number'],
      )!,
      damageYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}damage_year'],
      )!,
      farmId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}farm_id'],
      )!,
      farmerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}farmer_id'],
      )!,
      damageDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}damage_date'],
      )!,
      documentationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}documentation_date'],
      )!,
      damageCauseCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}damage_cause_category_id'],
      )!,
      damageCauseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}damage_cause_id'],
      )!,
      settlementName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}settlement_name'],
      ),
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      ),
      governorateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}governorate_id'],
      )!,
      localityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locality_id'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      statusId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_id'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      rowVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_version'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastSyncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sync_error'],
      ),
      isPendingDelete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pending_delete'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $DamageReportsTable createAlias(String alias) {
    return $DamageReportsTable(attachedDatabase, alias);
  }
}

class DamageReportLocal extends DataClass
    implements Insertable<DamageReportLocal> {
  final String id;
  final String? serverId;
  final String permanentFormNumber;
  final String temporaryFormNumber;
  final int damageYear;
  final String farmId;
  final String farmerId;
  final DateTime damageDate;
  final DateTime documentationDate;
  final int damageCauseCategoryId;
  final int damageCauseId;
  final String? settlementName;
  final String? companyName;
  final String governorateId;
  final String localityId;
  final double? latitude;
  final double? longitude;
  final String statusId;
  final String notes;
  final String rowVersion;
  final String syncStatus;
  final String? lastSyncError;
  final bool isPendingDelete;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const DamageReportLocal({
    required this.id,
    this.serverId,
    required this.permanentFormNumber,
    required this.temporaryFormNumber,
    required this.damageYear,
    required this.farmId,
    required this.farmerId,
    required this.damageDate,
    required this.documentationDate,
    required this.damageCauseCategoryId,
    required this.damageCauseId,
    this.settlementName,
    this.companyName,
    required this.governorateId,
    required this.localityId,
    this.latitude,
    this.longitude,
    required this.statusId,
    required this.notes,
    required this.rowVersion,
    required this.syncStatus,
    this.lastSyncError,
    required this.isPendingDelete,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['permanent_form_number'] = Variable<String>(permanentFormNumber);
    map['temporary_form_number'] = Variable<String>(temporaryFormNumber);
    map['damage_year'] = Variable<int>(damageYear);
    map['farm_id'] = Variable<String>(farmId);
    map['farmer_id'] = Variable<String>(farmerId);
    map['damage_date'] = Variable<DateTime>(damageDate);
    map['documentation_date'] = Variable<DateTime>(documentationDate);
    map['damage_cause_category_id'] = Variable<int>(damageCauseCategoryId);
    map['damage_cause_id'] = Variable<int>(damageCauseId);
    if (!nullToAbsent || settlementName != null) {
      map['settlement_name'] = Variable<String>(settlementName);
    }
    if (!nullToAbsent || companyName != null) {
      map['company_name'] = Variable<String>(companyName);
    }
    map['governorate_id'] = Variable<String>(governorateId);
    map['locality_id'] = Variable<String>(localityId);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['status_id'] = Variable<String>(statusId);
    map['notes'] = Variable<String>(notes);
    map['row_version'] = Variable<String>(rowVersion);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncError != null) {
      map['last_sync_error'] = Variable<String>(lastSyncError);
    }
    map['is_pending_delete'] = Variable<bool>(isPendingDelete);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  DamageReportsCompanion toCompanion(bool nullToAbsent) {
    return DamageReportsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      permanentFormNumber: Value(permanentFormNumber),
      temporaryFormNumber: Value(temporaryFormNumber),
      damageYear: Value(damageYear),
      farmId: Value(farmId),
      farmerId: Value(farmerId),
      damageDate: Value(damageDate),
      documentationDate: Value(documentationDate),
      damageCauseCategoryId: Value(damageCauseCategoryId),
      damageCauseId: Value(damageCauseId),
      settlementName: settlementName == null && nullToAbsent
          ? const Value.absent()
          : Value(settlementName),
      companyName: companyName == null && nullToAbsent
          ? const Value.absent()
          : Value(companyName),
      governorateId: Value(governorateId),
      localityId: Value(localityId),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      statusId: Value(statusId),
      notes: Value(notes),
      rowVersion: Value(rowVersion),
      syncStatus: Value(syncStatus),
      lastSyncError: lastSyncError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncError),
      isPendingDelete: Value(isPendingDelete),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory DamageReportLocal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DamageReportLocal(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      permanentFormNumber: serializer.fromJson<String>(
        json['permanentFormNumber'],
      ),
      temporaryFormNumber: serializer.fromJson<String>(
        json['temporaryFormNumber'],
      ),
      damageYear: serializer.fromJson<int>(json['damageYear']),
      farmId: serializer.fromJson<String>(json['farmId']),
      farmerId: serializer.fromJson<String>(json['farmerId']),
      damageDate: serializer.fromJson<DateTime>(json['damageDate']),
      documentationDate: serializer.fromJson<DateTime>(
        json['documentationDate'],
      ),
      damageCauseCategoryId: serializer.fromJson<int>(
        json['damageCauseCategoryId'],
      ),
      damageCauseId: serializer.fromJson<int>(json['damageCauseId']),
      settlementName: serializer.fromJson<String?>(json['settlementName']),
      companyName: serializer.fromJson<String?>(json['companyName']),
      governorateId: serializer.fromJson<String>(json['governorateId']),
      localityId: serializer.fromJson<String>(json['localityId']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      statusId: serializer.fromJson<String>(json['statusId']),
      notes: serializer.fromJson<String>(json['notes']),
      rowVersion: serializer.fromJson<String>(json['rowVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncError: serializer.fromJson<String?>(json['lastSyncError']),
      isPendingDelete: serializer.fromJson<bool>(json['isPendingDelete']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'permanentFormNumber': serializer.toJson<String>(permanentFormNumber),
      'temporaryFormNumber': serializer.toJson<String>(temporaryFormNumber),
      'damageYear': serializer.toJson<int>(damageYear),
      'farmId': serializer.toJson<String>(farmId),
      'farmerId': serializer.toJson<String>(farmerId),
      'damageDate': serializer.toJson<DateTime>(damageDate),
      'documentationDate': serializer.toJson<DateTime>(documentationDate),
      'damageCauseCategoryId': serializer.toJson<int>(damageCauseCategoryId),
      'damageCauseId': serializer.toJson<int>(damageCauseId),
      'settlementName': serializer.toJson<String?>(settlementName),
      'companyName': serializer.toJson<String?>(companyName),
      'governorateId': serializer.toJson<String>(governorateId),
      'localityId': serializer.toJson<String>(localityId),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'statusId': serializer.toJson<String>(statusId),
      'notes': serializer.toJson<String>(notes),
      'rowVersion': serializer.toJson<String>(rowVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncError': serializer.toJson<String?>(lastSyncError),
      'isPendingDelete': serializer.toJson<bool>(isPendingDelete),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  DamageReportLocal copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? permanentFormNumber,
    String? temporaryFormNumber,
    int? damageYear,
    String? farmId,
    String? farmerId,
    DateTime? damageDate,
    DateTime? documentationDate,
    int? damageCauseCategoryId,
    int? damageCauseId,
    Value<String?> settlementName = const Value.absent(),
    Value<String?> companyName = const Value.absent(),
    String? governorateId,
    String? localityId,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    String? statusId,
    String? notes,
    String? rowVersion,
    String? syncStatus,
    Value<String?> lastSyncError = const Value.absent(),
    bool? isPendingDelete,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => DamageReportLocal(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    permanentFormNumber: permanentFormNumber ?? this.permanentFormNumber,
    temporaryFormNumber: temporaryFormNumber ?? this.temporaryFormNumber,
    damageYear: damageYear ?? this.damageYear,
    farmId: farmId ?? this.farmId,
    farmerId: farmerId ?? this.farmerId,
    damageDate: damageDate ?? this.damageDate,
    documentationDate: documentationDate ?? this.documentationDate,
    damageCauseCategoryId: damageCauseCategoryId ?? this.damageCauseCategoryId,
    damageCauseId: damageCauseId ?? this.damageCauseId,
    settlementName: settlementName.present
        ? settlementName.value
        : this.settlementName,
    companyName: companyName.present ? companyName.value : this.companyName,
    governorateId: governorateId ?? this.governorateId,
    localityId: localityId ?? this.localityId,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    statusId: statusId ?? this.statusId,
    notes: notes ?? this.notes,
    rowVersion: rowVersion ?? this.rowVersion,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncError: lastSyncError.present
        ? lastSyncError.value
        : this.lastSyncError,
    isPendingDelete: isPendingDelete ?? this.isPendingDelete,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  DamageReportLocal copyWithCompanion(DamageReportsCompanion data) {
    return DamageReportLocal(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      permanentFormNumber: data.permanentFormNumber.present
          ? data.permanentFormNumber.value
          : this.permanentFormNumber,
      temporaryFormNumber: data.temporaryFormNumber.present
          ? data.temporaryFormNumber.value
          : this.temporaryFormNumber,
      damageYear: data.damageYear.present
          ? data.damageYear.value
          : this.damageYear,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      farmerId: data.farmerId.present ? data.farmerId.value : this.farmerId,
      damageDate: data.damageDate.present
          ? data.damageDate.value
          : this.damageDate,
      documentationDate: data.documentationDate.present
          ? data.documentationDate.value
          : this.documentationDate,
      damageCauseCategoryId: data.damageCauseCategoryId.present
          ? data.damageCauseCategoryId.value
          : this.damageCauseCategoryId,
      damageCauseId: data.damageCauseId.present
          ? data.damageCauseId.value
          : this.damageCauseId,
      settlementName: data.settlementName.present
          ? data.settlementName.value
          : this.settlementName,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      governorateId: data.governorateId.present
          ? data.governorateId.value
          : this.governorateId,
      localityId: data.localityId.present
          ? data.localityId.value
          : this.localityId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      statusId: data.statusId.present ? data.statusId.value : this.statusId,
      notes: data.notes.present ? data.notes.value : this.notes,
      rowVersion: data.rowVersion.present
          ? data.rowVersion.value
          : this.rowVersion,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastSyncError: data.lastSyncError.present
          ? data.lastSyncError.value
          : this.lastSyncError,
      isPendingDelete: data.isPendingDelete.present
          ? data.isPendingDelete.value
          : this.isPendingDelete,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DamageReportLocal(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('permanentFormNumber: $permanentFormNumber, ')
          ..write('temporaryFormNumber: $temporaryFormNumber, ')
          ..write('damageYear: $damageYear, ')
          ..write('farmId: $farmId, ')
          ..write('farmerId: $farmerId, ')
          ..write('damageDate: $damageDate, ')
          ..write('documentationDate: $documentationDate, ')
          ..write('damageCauseCategoryId: $damageCauseCategoryId, ')
          ..write('damageCauseId: $damageCauseId, ')
          ..write('settlementName: $settlementName, ')
          ..write('companyName: $companyName, ')
          ..write('governorateId: $governorateId, ')
          ..write('localityId: $localityId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('statusId: $statusId, ')
          ..write('notes: $notes, ')
          ..write('rowVersion: $rowVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncError: $lastSyncError, ')
          ..write('isPendingDelete: $isPendingDelete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    serverId,
    permanentFormNumber,
    temporaryFormNumber,
    damageYear,
    farmId,
    farmerId,
    damageDate,
    documentationDate,
    damageCauseCategoryId,
    damageCauseId,
    settlementName,
    companyName,
    governorateId,
    localityId,
    latitude,
    longitude,
    statusId,
    notes,
    rowVersion,
    syncStatus,
    lastSyncError,
    isPendingDelete,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DamageReportLocal &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.permanentFormNumber == this.permanentFormNumber &&
          other.temporaryFormNumber == this.temporaryFormNumber &&
          other.damageYear == this.damageYear &&
          other.farmId == this.farmId &&
          other.farmerId == this.farmerId &&
          other.damageDate == this.damageDate &&
          other.documentationDate == this.documentationDate &&
          other.damageCauseCategoryId == this.damageCauseCategoryId &&
          other.damageCauseId == this.damageCauseId &&
          other.settlementName == this.settlementName &&
          other.companyName == this.companyName &&
          other.governorateId == this.governorateId &&
          other.localityId == this.localityId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.statusId == this.statusId &&
          other.notes == this.notes &&
          other.rowVersion == this.rowVersion &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncError == this.lastSyncError &&
          other.isPendingDelete == this.isPendingDelete &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DamageReportsCompanion extends UpdateCompanion<DamageReportLocal> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> permanentFormNumber;
  final Value<String> temporaryFormNumber;
  final Value<int> damageYear;
  final Value<String> farmId;
  final Value<String> farmerId;
  final Value<DateTime> damageDate;
  final Value<DateTime> documentationDate;
  final Value<int> damageCauseCategoryId;
  final Value<int> damageCauseId;
  final Value<String?> settlementName;
  final Value<String?> companyName;
  final Value<String> governorateId;
  final Value<String> localityId;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String> statusId;
  final Value<String> notes;
  final Value<String> rowVersion;
  final Value<String> syncStatus;
  final Value<String?> lastSyncError;
  final Value<bool> isPendingDelete;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const DamageReportsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.permanentFormNumber = const Value.absent(),
    this.temporaryFormNumber = const Value.absent(),
    this.damageYear = const Value.absent(),
    this.farmId = const Value.absent(),
    this.farmerId = const Value.absent(),
    this.damageDate = const Value.absent(),
    this.documentationDate = const Value.absent(),
    this.damageCauseCategoryId = const Value.absent(),
    this.damageCauseId = const Value.absent(),
    this.settlementName = const Value.absent(),
    this.companyName = const Value.absent(),
    this.governorateId = const Value.absent(),
    this.localityId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.statusId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncError = const Value.absent(),
    this.isPendingDelete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DamageReportsCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    this.permanentFormNumber = const Value.absent(),
    this.temporaryFormNumber = const Value.absent(),
    this.damageYear = const Value.absent(),
    required String farmId,
    required String farmerId,
    required DateTime damageDate,
    required DateTime documentationDate,
    this.damageCauseCategoryId = const Value.absent(),
    this.damageCauseId = const Value.absent(),
    this.settlementName = const Value.absent(),
    this.companyName = const Value.absent(),
    required String governorateId,
    required String localityId,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    required String statusId,
    required String notes,
    this.rowVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncError = const Value.absent(),
    this.isPendingDelete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       farmId = Value(farmId),
       farmerId = Value(farmerId),
       damageDate = Value(damageDate),
       documentationDate = Value(documentationDate),
       governorateId = Value(governorateId),
       localityId = Value(localityId),
       statusId = Value(statusId),
       notes = Value(notes);
  static Insertable<DamageReportLocal> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? permanentFormNumber,
    Expression<String>? temporaryFormNumber,
    Expression<int>? damageYear,
    Expression<String>? farmId,
    Expression<String>? farmerId,
    Expression<DateTime>? damageDate,
    Expression<DateTime>? documentationDate,
    Expression<int>? damageCauseCategoryId,
    Expression<int>? damageCauseId,
    Expression<String>? settlementName,
    Expression<String>? companyName,
    Expression<String>? governorateId,
    Expression<String>? localityId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? statusId,
    Expression<String>? notes,
    Expression<String>? rowVersion,
    Expression<String>? syncStatus,
    Expression<String>? lastSyncError,
    Expression<bool>? isPendingDelete,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (permanentFormNumber != null)
        'permanent_form_number': permanentFormNumber,
      if (temporaryFormNumber != null)
        'temporary_form_number': temporaryFormNumber,
      if (damageYear != null) 'damage_year': damageYear,
      if (farmId != null) 'farm_id': farmId,
      if (farmerId != null) 'farmer_id': farmerId,
      if (damageDate != null) 'damage_date': damageDate,
      if (documentationDate != null) 'documentation_date': documentationDate,
      if (damageCauseCategoryId != null)
        'damage_cause_category_id': damageCauseCategoryId,
      if (damageCauseId != null) 'damage_cause_id': damageCauseId,
      if (settlementName != null) 'settlement_name': settlementName,
      if (companyName != null) 'company_name': companyName,
      if (governorateId != null) 'governorate_id': governorateId,
      if (localityId != null) 'locality_id': localityId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (statusId != null) 'status_id': statusId,
      if (notes != null) 'notes': notes,
      if (rowVersion != null) 'row_version': rowVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncError != null) 'last_sync_error': lastSyncError,
      if (isPendingDelete != null) 'is_pending_delete': isPendingDelete,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DamageReportsCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? permanentFormNumber,
    Value<String>? temporaryFormNumber,
    Value<int>? damageYear,
    Value<String>? farmId,
    Value<String>? farmerId,
    Value<DateTime>? damageDate,
    Value<DateTime>? documentationDate,
    Value<int>? damageCauseCategoryId,
    Value<int>? damageCauseId,
    Value<String?>? settlementName,
    Value<String?>? companyName,
    Value<String>? governorateId,
    Value<String>? localityId,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String>? statusId,
    Value<String>? notes,
    Value<String>? rowVersion,
    Value<String>? syncStatus,
    Value<String?>? lastSyncError,
    Value<bool>? isPendingDelete,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return DamageReportsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      permanentFormNumber: permanentFormNumber ?? this.permanentFormNumber,
      temporaryFormNumber: temporaryFormNumber ?? this.temporaryFormNumber,
      damageYear: damageYear ?? this.damageYear,
      farmId: farmId ?? this.farmId,
      farmerId: farmerId ?? this.farmerId,
      damageDate: damageDate ?? this.damageDate,
      documentationDate: documentationDate ?? this.documentationDate,
      damageCauseCategoryId:
          damageCauseCategoryId ?? this.damageCauseCategoryId,
      damageCauseId: damageCauseId ?? this.damageCauseId,
      settlementName: settlementName ?? this.settlementName,
      companyName: companyName ?? this.companyName,
      governorateId: governorateId ?? this.governorateId,
      localityId: localityId ?? this.localityId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      statusId: statusId ?? this.statusId,
      notes: notes ?? this.notes,
      rowVersion: rowVersion ?? this.rowVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncError: lastSyncError ?? this.lastSyncError,
      isPendingDelete: isPendingDelete ?? this.isPendingDelete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (permanentFormNumber.present) {
      map['permanent_form_number'] = Variable<String>(
        permanentFormNumber.value,
      );
    }
    if (temporaryFormNumber.present) {
      map['temporary_form_number'] = Variable<String>(
        temporaryFormNumber.value,
      );
    }
    if (damageYear.present) {
      map['damage_year'] = Variable<int>(damageYear.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (farmerId.present) {
      map['farmer_id'] = Variable<String>(farmerId.value);
    }
    if (damageDate.present) {
      map['damage_date'] = Variable<DateTime>(damageDate.value);
    }
    if (documentationDate.present) {
      map['documentation_date'] = Variable<DateTime>(documentationDate.value);
    }
    if (damageCauseCategoryId.present) {
      map['damage_cause_category_id'] = Variable<int>(
        damageCauseCategoryId.value,
      );
    }
    if (damageCauseId.present) {
      map['damage_cause_id'] = Variable<int>(damageCauseId.value);
    }
    if (settlementName.present) {
      map['settlement_name'] = Variable<String>(settlementName.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (governorateId.present) {
      map['governorate_id'] = Variable<String>(governorateId.value);
    }
    if (localityId.present) {
      map['locality_id'] = Variable<String>(localityId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (statusId.present) {
      map['status_id'] = Variable<String>(statusId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowVersion.present) {
      map['row_version'] = Variable<String>(rowVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncError.present) {
      map['last_sync_error'] = Variable<String>(lastSyncError.value);
    }
    if (isPendingDelete.present) {
      map['is_pending_delete'] = Variable<bool>(isPendingDelete.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DamageReportsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('permanentFormNumber: $permanentFormNumber, ')
          ..write('temporaryFormNumber: $temporaryFormNumber, ')
          ..write('damageYear: $damageYear, ')
          ..write('farmId: $farmId, ')
          ..write('farmerId: $farmerId, ')
          ..write('damageDate: $damageDate, ')
          ..write('documentationDate: $documentationDate, ')
          ..write('damageCauseCategoryId: $damageCauseCategoryId, ')
          ..write('damageCauseId: $damageCauseId, ')
          ..write('settlementName: $settlementName, ')
          ..write('companyName: $companyName, ')
          ..write('governorateId: $governorateId, ')
          ..write('localityId: $localityId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('statusId: $statusId, ')
          ..write('notes: $notes, ')
          ..write('rowVersion: $rowVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncError: $lastSyncError, ')
          ..write('isPendingDelete: $isPendingDelete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DamageItemsTable extends DamageItems
    with TableInfo<$DamageItemsTable, DamageItemLocal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DamageItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _damageReportIdMeta = const VerificationMeta(
    'damageReportId',
  );
  @override
  late final GeneratedColumn<String> damageReportId = GeneratedColumn<String>(
    'damage_report_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classificationIdMeta = const VerificationMeta(
    'classificationId',
  );
  @override
  late final GeneratedColumn<int> classificationId = GeneratedColumn<int>(
    'classification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _costingSheetIdMeta = const VerificationMeta(
    'costingSheetId',
  );
  @override
  late final GeneratedColumn<String> costingSheetId = GeneratedColumn<String>(
    'costing_sheet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _calculatedUnitPriceMeta =
      const VerificationMeta('calculatedUnitPrice');
  @override
  late final GeneratedColumn<double> calculatedUnitPrice =
      GeneratedColumn<double>(
        'calculated_unit_price',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _measurementUnitSnapshotMeta =
      const VerificationMeta('measurementUnitSnapshot');
  @override
  late final GeneratedColumn<String> measurementUnitSnapshot =
      GeneratedColumn<String>(
        'measurement_unit_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _affectedAreaMeta = const VerificationMeta(
    'affectedArea',
  );
  @override
  late final GeneratedColumn<double> affectedArea = GeneratedColumn<double>(
    'affected_area',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _damagePercentageMeta = const VerificationMeta(
    'damagePercentage',
  );
  @override
  late final GeneratedColumn<double> damagePercentage = GeneratedColumn<double>(
    'damage_percentage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedLossMeta = const VerificationMeta(
    'estimatedLoss',
  );
  @override
  late final GeneratedColumn<double> estimatedLoss = GeneratedColumn<double>(
    'estimated_loss',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowVersionMeta = const VerificationMeta(
    'rowVersion',
  );
  @override
  late final GeneratedColumn<String> rowVersion = GeneratedColumn<String>(
    'row_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('completed'),
  );
  static const VerificationMeta _lastSyncErrorMeta = const VerificationMeta(
    'lastSyncError',
  );
  @override
  late final GeneratedColumn<String> lastSyncError = GeneratedColumn<String>(
    'last_sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPendingDeleteMeta = const VerificationMeta(
    'isPendingDelete',
  );
  @override
  late final GeneratedColumn<bool> isPendingDelete = GeneratedColumn<bool>(
    'is_pending_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pending_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    damageReportId,
    classificationId,
    costingSheetId,
    calculatedUnitPrice,
    measurementUnitSnapshot,
    affectedArea,
    damagePercentage,
    quantity,
    estimatedLoss,
    rowVersion,
    syncStatus,
    lastSyncError,
    isPendingDelete,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'damage_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DamageItemLocal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('damage_report_id')) {
      context.handle(
        _damageReportIdMeta,
        damageReportId.isAcceptableOrUnknown(
          data['damage_report_id']!,
          _damageReportIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_damageReportIdMeta);
    }
    if (data.containsKey('classification_id')) {
      context.handle(
        _classificationIdMeta,
        classificationId.isAcceptableOrUnknown(
          data['classification_id']!,
          _classificationIdMeta,
        ),
      );
    }
    if (data.containsKey('costing_sheet_id')) {
      context.handle(
        _costingSheetIdMeta,
        costingSheetId.isAcceptableOrUnknown(
          data['costing_sheet_id']!,
          _costingSheetIdMeta,
        ),
      );
    }
    if (data.containsKey('calculated_unit_price')) {
      context.handle(
        _calculatedUnitPriceMeta,
        calculatedUnitPrice.isAcceptableOrUnknown(
          data['calculated_unit_price']!,
          _calculatedUnitPriceMeta,
        ),
      );
    }
    if (data.containsKey('measurement_unit_snapshot')) {
      context.handle(
        _measurementUnitSnapshotMeta,
        measurementUnitSnapshot.isAcceptableOrUnknown(
          data['measurement_unit_snapshot']!,
          _measurementUnitSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('affected_area')) {
      context.handle(
        _affectedAreaMeta,
        affectedArea.isAcceptableOrUnknown(
          data['affected_area']!,
          _affectedAreaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_affectedAreaMeta);
    }
    if (data.containsKey('damage_percentage')) {
      context.handle(
        _damagePercentageMeta,
        damagePercentage.isAcceptableOrUnknown(
          data['damage_percentage']!,
          _damagePercentageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_damagePercentageMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('estimated_loss')) {
      context.handle(
        _estimatedLossMeta,
        estimatedLoss.isAcceptableOrUnknown(
          data['estimated_loss']!,
          _estimatedLossMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedLossMeta);
    }
    if (data.containsKey('row_version')) {
      context.handle(
        _rowVersionMeta,
        rowVersion.isAcceptableOrUnknown(data['row_version']!, _rowVersionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_sync_error')) {
      context.handle(
        _lastSyncErrorMeta,
        lastSyncError.isAcceptableOrUnknown(
          data['last_sync_error']!,
          _lastSyncErrorMeta,
        ),
      );
    }
    if (data.containsKey('is_pending_delete')) {
      context.handle(
        _isPendingDeleteMeta,
        isPendingDelete.isAcceptableOrUnknown(
          data['is_pending_delete']!,
          _isPendingDeleteMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DamageItemLocal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DamageItemLocal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      damageReportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}damage_report_id'],
      )!,
      classificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}classification_id'],
      )!,
      costingSheetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}costing_sheet_id'],
      )!,
      calculatedUnitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calculated_unit_price'],
      )!,
      measurementUnitSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_unit_snapshot'],
      )!,
      affectedArea: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}affected_area'],
      )!,
      damagePercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}damage_percentage'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      estimatedLoss: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated_loss'],
      )!,
      rowVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_version'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastSyncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sync_error'],
      ),
      isPendingDelete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pending_delete'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $DamageItemsTable createAlias(String alias) {
    return $DamageItemsTable(attachedDatabase, alias);
  }
}

class DamageItemLocal extends DataClass implements Insertable<DamageItemLocal> {
  final String id;
  final String? serverId;
  final String damageReportId;
  final int classificationId;
  final String costingSheetId;
  final double calculatedUnitPrice;
  final String measurementUnitSnapshot;
  final double affectedArea;
  final double damagePercentage;
  final double quantity;
  final double estimatedLoss;
  final String rowVersion;
  final String syncStatus;
  final String? lastSyncError;
  final bool isPendingDelete;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const DamageItemLocal({
    required this.id,
    this.serverId,
    required this.damageReportId,
    required this.classificationId,
    required this.costingSheetId,
    required this.calculatedUnitPrice,
    required this.measurementUnitSnapshot,
    required this.affectedArea,
    required this.damagePercentage,
    required this.quantity,
    required this.estimatedLoss,
    required this.rowVersion,
    required this.syncStatus,
    this.lastSyncError,
    required this.isPendingDelete,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['damage_report_id'] = Variable<String>(damageReportId);
    map['classification_id'] = Variable<int>(classificationId);
    map['costing_sheet_id'] = Variable<String>(costingSheetId);
    map['calculated_unit_price'] = Variable<double>(calculatedUnitPrice);
    map['measurement_unit_snapshot'] = Variable<String>(
      measurementUnitSnapshot,
    );
    map['affected_area'] = Variable<double>(affectedArea);
    map['damage_percentage'] = Variable<double>(damagePercentage);
    map['quantity'] = Variable<double>(quantity);
    map['estimated_loss'] = Variable<double>(estimatedLoss);
    map['row_version'] = Variable<String>(rowVersion);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncError != null) {
      map['last_sync_error'] = Variable<String>(lastSyncError);
    }
    map['is_pending_delete'] = Variable<bool>(isPendingDelete);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  DamageItemsCompanion toCompanion(bool nullToAbsent) {
    return DamageItemsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      damageReportId: Value(damageReportId),
      classificationId: Value(classificationId),
      costingSheetId: Value(costingSheetId),
      calculatedUnitPrice: Value(calculatedUnitPrice),
      measurementUnitSnapshot: Value(measurementUnitSnapshot),
      affectedArea: Value(affectedArea),
      damagePercentage: Value(damagePercentage),
      quantity: Value(quantity),
      estimatedLoss: Value(estimatedLoss),
      rowVersion: Value(rowVersion),
      syncStatus: Value(syncStatus),
      lastSyncError: lastSyncError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncError),
      isPendingDelete: Value(isPendingDelete),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory DamageItemLocal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DamageItemLocal(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      damageReportId: serializer.fromJson<String>(json['damageReportId']),
      classificationId: serializer.fromJson<int>(json['classificationId']),
      costingSheetId: serializer.fromJson<String>(json['costingSheetId']),
      calculatedUnitPrice: serializer.fromJson<double>(
        json['calculatedUnitPrice'],
      ),
      measurementUnitSnapshot: serializer.fromJson<String>(
        json['measurementUnitSnapshot'],
      ),
      affectedArea: serializer.fromJson<double>(json['affectedArea']),
      damagePercentage: serializer.fromJson<double>(json['damagePercentage']),
      quantity: serializer.fromJson<double>(json['quantity']),
      estimatedLoss: serializer.fromJson<double>(json['estimatedLoss']),
      rowVersion: serializer.fromJson<String>(json['rowVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncError: serializer.fromJson<String?>(json['lastSyncError']),
      isPendingDelete: serializer.fromJson<bool>(json['isPendingDelete']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'damageReportId': serializer.toJson<String>(damageReportId),
      'classificationId': serializer.toJson<int>(classificationId),
      'costingSheetId': serializer.toJson<String>(costingSheetId),
      'calculatedUnitPrice': serializer.toJson<double>(calculatedUnitPrice),
      'measurementUnitSnapshot': serializer.toJson<String>(
        measurementUnitSnapshot,
      ),
      'affectedArea': serializer.toJson<double>(affectedArea),
      'damagePercentage': serializer.toJson<double>(damagePercentage),
      'quantity': serializer.toJson<double>(quantity),
      'estimatedLoss': serializer.toJson<double>(estimatedLoss),
      'rowVersion': serializer.toJson<String>(rowVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncError': serializer.toJson<String?>(lastSyncError),
      'isPendingDelete': serializer.toJson<bool>(isPendingDelete),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  DamageItemLocal copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? damageReportId,
    int? classificationId,
    String? costingSheetId,
    double? calculatedUnitPrice,
    String? measurementUnitSnapshot,
    double? affectedArea,
    double? damagePercentage,
    double? quantity,
    double? estimatedLoss,
    String? rowVersion,
    String? syncStatus,
    Value<String?> lastSyncError = const Value.absent(),
    bool? isPendingDelete,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => DamageItemLocal(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    damageReportId: damageReportId ?? this.damageReportId,
    classificationId: classificationId ?? this.classificationId,
    costingSheetId: costingSheetId ?? this.costingSheetId,
    calculatedUnitPrice: calculatedUnitPrice ?? this.calculatedUnitPrice,
    measurementUnitSnapshot:
        measurementUnitSnapshot ?? this.measurementUnitSnapshot,
    affectedArea: affectedArea ?? this.affectedArea,
    damagePercentage: damagePercentage ?? this.damagePercentage,
    quantity: quantity ?? this.quantity,
    estimatedLoss: estimatedLoss ?? this.estimatedLoss,
    rowVersion: rowVersion ?? this.rowVersion,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncError: lastSyncError.present
        ? lastSyncError.value
        : this.lastSyncError,
    isPendingDelete: isPendingDelete ?? this.isPendingDelete,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  DamageItemLocal copyWithCompanion(DamageItemsCompanion data) {
    return DamageItemLocal(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      damageReportId: data.damageReportId.present
          ? data.damageReportId.value
          : this.damageReportId,
      classificationId: data.classificationId.present
          ? data.classificationId.value
          : this.classificationId,
      costingSheetId: data.costingSheetId.present
          ? data.costingSheetId.value
          : this.costingSheetId,
      calculatedUnitPrice: data.calculatedUnitPrice.present
          ? data.calculatedUnitPrice.value
          : this.calculatedUnitPrice,
      measurementUnitSnapshot: data.measurementUnitSnapshot.present
          ? data.measurementUnitSnapshot.value
          : this.measurementUnitSnapshot,
      affectedArea: data.affectedArea.present
          ? data.affectedArea.value
          : this.affectedArea,
      damagePercentage: data.damagePercentage.present
          ? data.damagePercentage.value
          : this.damagePercentage,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      estimatedLoss: data.estimatedLoss.present
          ? data.estimatedLoss.value
          : this.estimatedLoss,
      rowVersion: data.rowVersion.present
          ? data.rowVersion.value
          : this.rowVersion,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastSyncError: data.lastSyncError.present
          ? data.lastSyncError.value
          : this.lastSyncError,
      isPendingDelete: data.isPendingDelete.present
          ? data.isPendingDelete.value
          : this.isPendingDelete,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DamageItemLocal(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('damageReportId: $damageReportId, ')
          ..write('classificationId: $classificationId, ')
          ..write('costingSheetId: $costingSheetId, ')
          ..write('calculatedUnitPrice: $calculatedUnitPrice, ')
          ..write('measurementUnitSnapshot: $measurementUnitSnapshot, ')
          ..write('affectedArea: $affectedArea, ')
          ..write('damagePercentage: $damagePercentage, ')
          ..write('quantity: $quantity, ')
          ..write('estimatedLoss: $estimatedLoss, ')
          ..write('rowVersion: $rowVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncError: $lastSyncError, ')
          ..write('isPendingDelete: $isPendingDelete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    damageReportId,
    classificationId,
    costingSheetId,
    calculatedUnitPrice,
    measurementUnitSnapshot,
    affectedArea,
    damagePercentage,
    quantity,
    estimatedLoss,
    rowVersion,
    syncStatus,
    lastSyncError,
    isPendingDelete,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DamageItemLocal &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.damageReportId == this.damageReportId &&
          other.classificationId == this.classificationId &&
          other.costingSheetId == this.costingSheetId &&
          other.calculatedUnitPrice == this.calculatedUnitPrice &&
          other.measurementUnitSnapshot == this.measurementUnitSnapshot &&
          other.affectedArea == this.affectedArea &&
          other.damagePercentage == this.damagePercentage &&
          other.quantity == this.quantity &&
          other.estimatedLoss == this.estimatedLoss &&
          other.rowVersion == this.rowVersion &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncError == this.lastSyncError &&
          other.isPendingDelete == this.isPendingDelete &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DamageItemsCompanion extends UpdateCompanion<DamageItemLocal> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> damageReportId;
  final Value<int> classificationId;
  final Value<String> costingSheetId;
  final Value<double> calculatedUnitPrice;
  final Value<String> measurementUnitSnapshot;
  final Value<double> affectedArea;
  final Value<double> damagePercentage;
  final Value<double> quantity;
  final Value<double> estimatedLoss;
  final Value<String> rowVersion;
  final Value<String> syncStatus;
  final Value<String?> lastSyncError;
  final Value<bool> isPendingDelete;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const DamageItemsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.damageReportId = const Value.absent(),
    this.classificationId = const Value.absent(),
    this.costingSheetId = const Value.absent(),
    this.calculatedUnitPrice = const Value.absent(),
    this.measurementUnitSnapshot = const Value.absent(),
    this.affectedArea = const Value.absent(),
    this.damagePercentage = const Value.absent(),
    this.quantity = const Value.absent(),
    this.estimatedLoss = const Value.absent(),
    this.rowVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncError = const Value.absent(),
    this.isPendingDelete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DamageItemsCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String damageReportId,
    this.classificationId = const Value.absent(),
    this.costingSheetId = const Value.absent(),
    this.calculatedUnitPrice = const Value.absent(),
    this.measurementUnitSnapshot = const Value.absent(),
    required double affectedArea,
    required double damagePercentage,
    required double quantity,
    required double estimatedLoss,
    this.rowVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncError = const Value.absent(),
    this.isPendingDelete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       damageReportId = Value(damageReportId),
       affectedArea = Value(affectedArea),
       damagePercentage = Value(damagePercentage),
       quantity = Value(quantity),
       estimatedLoss = Value(estimatedLoss);
  static Insertable<DamageItemLocal> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? damageReportId,
    Expression<int>? classificationId,
    Expression<String>? costingSheetId,
    Expression<double>? calculatedUnitPrice,
    Expression<String>? measurementUnitSnapshot,
    Expression<double>? affectedArea,
    Expression<double>? damagePercentage,
    Expression<double>? quantity,
    Expression<double>? estimatedLoss,
    Expression<String>? rowVersion,
    Expression<String>? syncStatus,
    Expression<String>? lastSyncError,
    Expression<bool>? isPendingDelete,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (damageReportId != null) 'damage_report_id': damageReportId,
      if (classificationId != null) 'classification_id': classificationId,
      if (costingSheetId != null) 'costing_sheet_id': costingSheetId,
      if (calculatedUnitPrice != null)
        'calculated_unit_price': calculatedUnitPrice,
      if (measurementUnitSnapshot != null)
        'measurement_unit_snapshot': measurementUnitSnapshot,
      if (affectedArea != null) 'affected_area': affectedArea,
      if (damagePercentage != null) 'damage_percentage': damagePercentage,
      if (quantity != null) 'quantity': quantity,
      if (estimatedLoss != null) 'estimated_loss': estimatedLoss,
      if (rowVersion != null) 'row_version': rowVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncError != null) 'last_sync_error': lastSyncError,
      if (isPendingDelete != null) 'is_pending_delete': isPendingDelete,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DamageItemsCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? damageReportId,
    Value<int>? classificationId,
    Value<String>? costingSheetId,
    Value<double>? calculatedUnitPrice,
    Value<String>? measurementUnitSnapshot,
    Value<double>? affectedArea,
    Value<double>? damagePercentage,
    Value<double>? quantity,
    Value<double>? estimatedLoss,
    Value<String>? rowVersion,
    Value<String>? syncStatus,
    Value<String?>? lastSyncError,
    Value<bool>? isPendingDelete,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return DamageItemsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      damageReportId: damageReportId ?? this.damageReportId,
      classificationId: classificationId ?? this.classificationId,
      costingSheetId: costingSheetId ?? this.costingSheetId,
      calculatedUnitPrice: calculatedUnitPrice ?? this.calculatedUnitPrice,
      measurementUnitSnapshot:
          measurementUnitSnapshot ?? this.measurementUnitSnapshot,
      affectedArea: affectedArea ?? this.affectedArea,
      damagePercentage: damagePercentage ?? this.damagePercentage,
      quantity: quantity ?? this.quantity,
      estimatedLoss: estimatedLoss ?? this.estimatedLoss,
      rowVersion: rowVersion ?? this.rowVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncError: lastSyncError ?? this.lastSyncError,
      isPendingDelete: isPendingDelete ?? this.isPendingDelete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (damageReportId.present) {
      map['damage_report_id'] = Variable<String>(damageReportId.value);
    }
    if (classificationId.present) {
      map['classification_id'] = Variable<int>(classificationId.value);
    }
    if (costingSheetId.present) {
      map['costing_sheet_id'] = Variable<String>(costingSheetId.value);
    }
    if (calculatedUnitPrice.present) {
      map['calculated_unit_price'] = Variable<double>(
        calculatedUnitPrice.value,
      );
    }
    if (measurementUnitSnapshot.present) {
      map['measurement_unit_snapshot'] = Variable<String>(
        measurementUnitSnapshot.value,
      );
    }
    if (affectedArea.present) {
      map['affected_area'] = Variable<double>(affectedArea.value);
    }
    if (damagePercentage.present) {
      map['damage_percentage'] = Variable<double>(damagePercentage.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (estimatedLoss.present) {
      map['estimated_loss'] = Variable<double>(estimatedLoss.value);
    }
    if (rowVersion.present) {
      map['row_version'] = Variable<String>(rowVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncError.present) {
      map['last_sync_error'] = Variable<String>(lastSyncError.value);
    }
    if (isPendingDelete.present) {
      map['is_pending_delete'] = Variable<bool>(isPendingDelete.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DamageItemsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('damageReportId: $damageReportId, ')
          ..write('classificationId: $classificationId, ')
          ..write('costingSheetId: $costingSheetId, ')
          ..write('calculatedUnitPrice: $calculatedUnitPrice, ')
          ..write('measurementUnitSnapshot: $measurementUnitSnapshot, ')
          ..write('affectedArea: $affectedArea, ')
          ..write('damagePercentage: $damagePercentage, ')
          ..write('quantity: $quantity, ')
          ..write('estimatedLoss: $estimatedLoss, ')
          ..write('rowVersion: $rowVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncError: $lastSyncError, ')
          ..write('isPendingDelete: $isPendingDelete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DamageReportAttachmentsTable extends DamageReportAttachments
    with TableInfo<$DamageReportAttachmentsTable, DamageReportAttachmentLocal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DamageReportAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _damageReportIdMeta = const VerificationMeta(
    'damageReportId',
  );
  @override
  late final GeneratedColumn<String> damageReportId = GeneratedColumn<String>(
    'damage_report_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remotePathMeta = const VerificationMeta(
    'remotePath',
  );
  @override
  late final GeneratedColumn<String> remotePath = GeneratedColumn<String>(
    'remote_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uploadStatusMeta = const VerificationMeta(
    'uploadStatus',
  );
  @override
  late final GeneratedColumn<String> uploadStatus = GeneratedColumn<String>(
    'upload_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _lastSyncErrorMeta = const VerificationMeta(
    'lastSyncError',
  );
  @override
  late final GeneratedColumn<String> lastSyncError = GeneratedColumn<String>(
    'last_sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPendingDeleteMeta = const VerificationMeta(
    'isPendingDelete',
  );
  @override
  late final GeneratedColumn<bool> isPendingDelete = GeneratedColumn<bool>(
    'is_pending_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pending_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    damageReportId,
    localPath,
    remotePath,
    uploadStatus,
    syncStatus,
    lastSyncError,
    isPendingDelete,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'damage_report_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<DamageReportAttachmentLocal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('damage_report_id')) {
      context.handle(
        _damageReportIdMeta,
        damageReportId.isAcceptableOrUnknown(
          data['damage_report_id']!,
          _damageReportIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_damageReportIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('remote_path')) {
      context.handle(
        _remotePathMeta,
        remotePath.isAcceptableOrUnknown(data['remote_path']!, _remotePathMeta),
      );
    }
    if (data.containsKey('upload_status')) {
      context.handle(
        _uploadStatusMeta,
        uploadStatus.isAcceptableOrUnknown(
          data['upload_status']!,
          _uploadStatusMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_sync_error')) {
      context.handle(
        _lastSyncErrorMeta,
        lastSyncError.isAcceptableOrUnknown(
          data['last_sync_error']!,
          _lastSyncErrorMeta,
        ),
      );
    }
    if (data.containsKey('is_pending_delete')) {
      context.handle(
        _isPendingDeleteMeta,
        isPendingDelete.isAcceptableOrUnknown(
          data['is_pending_delete']!,
          _isPendingDeleteMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DamageReportAttachmentLocal map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DamageReportAttachmentLocal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      damageReportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}damage_report_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      remotePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_path'],
      ),
      uploadStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upload_status'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastSyncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sync_error'],
      ),
      isPendingDelete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pending_delete'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $DamageReportAttachmentsTable createAlias(String alias) {
    return $DamageReportAttachmentsTable(attachedDatabase, alias);
  }
}

class DamageReportAttachmentLocal extends DataClass
    implements Insertable<DamageReportAttachmentLocal> {
  final String id;
  final String? serverId;
  final String damageReportId;
  final String localPath;
  final String? remotePath;
  final String uploadStatus;
  final String syncStatus;
  final String? lastSyncError;
  final bool isPendingDelete;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const DamageReportAttachmentLocal({
    required this.id,
    this.serverId,
    required this.damageReportId,
    required this.localPath,
    this.remotePath,
    required this.uploadStatus,
    required this.syncStatus,
    this.lastSyncError,
    required this.isPendingDelete,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['damage_report_id'] = Variable<String>(damageReportId);
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || remotePath != null) {
      map['remote_path'] = Variable<String>(remotePath);
    }
    map['upload_status'] = Variable<String>(uploadStatus);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncError != null) {
      map['last_sync_error'] = Variable<String>(lastSyncError);
    }
    map['is_pending_delete'] = Variable<bool>(isPendingDelete);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  DamageReportAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return DamageReportAttachmentsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      damageReportId: Value(damageReportId),
      localPath: Value(localPath),
      remotePath: remotePath == null && nullToAbsent
          ? const Value.absent()
          : Value(remotePath),
      uploadStatus: Value(uploadStatus),
      syncStatus: Value(syncStatus),
      lastSyncError: lastSyncError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncError),
      isPendingDelete: Value(isPendingDelete),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory DamageReportAttachmentLocal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DamageReportAttachmentLocal(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      damageReportId: serializer.fromJson<String>(json['damageReportId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      remotePath: serializer.fromJson<String?>(json['remotePath']),
      uploadStatus: serializer.fromJson<String>(json['uploadStatus']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncError: serializer.fromJson<String?>(json['lastSyncError']),
      isPendingDelete: serializer.fromJson<bool>(json['isPendingDelete']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'damageReportId': serializer.toJson<String>(damageReportId),
      'localPath': serializer.toJson<String>(localPath),
      'remotePath': serializer.toJson<String?>(remotePath),
      'uploadStatus': serializer.toJson<String>(uploadStatus),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncError': serializer.toJson<String?>(lastSyncError),
      'isPendingDelete': serializer.toJson<bool>(isPendingDelete),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  DamageReportAttachmentLocal copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? damageReportId,
    String? localPath,
    Value<String?> remotePath = const Value.absent(),
    String? uploadStatus,
    String? syncStatus,
    Value<String?> lastSyncError = const Value.absent(),
    bool? isPendingDelete,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => DamageReportAttachmentLocal(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    damageReportId: damageReportId ?? this.damageReportId,
    localPath: localPath ?? this.localPath,
    remotePath: remotePath.present ? remotePath.value : this.remotePath,
    uploadStatus: uploadStatus ?? this.uploadStatus,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncError: lastSyncError.present
        ? lastSyncError.value
        : this.lastSyncError,
    isPendingDelete: isPendingDelete ?? this.isPendingDelete,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  DamageReportAttachmentLocal copyWithCompanion(
    DamageReportAttachmentsCompanion data,
  ) {
    return DamageReportAttachmentLocal(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      damageReportId: data.damageReportId.present
          ? data.damageReportId.value
          : this.damageReportId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      remotePath: data.remotePath.present
          ? data.remotePath.value
          : this.remotePath,
      uploadStatus: data.uploadStatus.present
          ? data.uploadStatus.value
          : this.uploadStatus,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastSyncError: data.lastSyncError.present
          ? data.lastSyncError.value
          : this.lastSyncError,
      isPendingDelete: data.isPendingDelete.present
          ? data.isPendingDelete.value
          : this.isPendingDelete,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DamageReportAttachmentLocal(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('damageReportId: $damageReportId, ')
          ..write('localPath: $localPath, ')
          ..write('remotePath: $remotePath, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncError: $lastSyncError, ')
          ..write('isPendingDelete: $isPendingDelete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    damageReportId,
    localPath,
    remotePath,
    uploadStatus,
    syncStatus,
    lastSyncError,
    isPendingDelete,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DamageReportAttachmentLocal &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.damageReportId == this.damageReportId &&
          other.localPath == this.localPath &&
          other.remotePath == this.remotePath &&
          other.uploadStatus == this.uploadStatus &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncError == this.lastSyncError &&
          other.isPendingDelete == this.isPendingDelete &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DamageReportAttachmentsCompanion
    extends UpdateCompanion<DamageReportAttachmentLocal> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> damageReportId;
  final Value<String> localPath;
  final Value<String?> remotePath;
  final Value<String> uploadStatus;
  final Value<String> syncStatus;
  final Value<String?> lastSyncError;
  final Value<bool> isPendingDelete;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const DamageReportAttachmentsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.damageReportId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.remotePath = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncError = const Value.absent(),
    this.isPendingDelete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DamageReportAttachmentsCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String damageReportId,
    required String localPath,
    this.remotePath = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncError = const Value.absent(),
    this.isPendingDelete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       damageReportId = Value(damageReportId),
       localPath = Value(localPath);
  static Insertable<DamageReportAttachmentLocal> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? damageReportId,
    Expression<String>? localPath,
    Expression<String>? remotePath,
    Expression<String>? uploadStatus,
    Expression<String>? syncStatus,
    Expression<String>? lastSyncError,
    Expression<bool>? isPendingDelete,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (damageReportId != null) 'damage_report_id': damageReportId,
      if (localPath != null) 'local_path': localPath,
      if (remotePath != null) 'remote_path': remotePath,
      if (uploadStatus != null) 'upload_status': uploadStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncError != null) 'last_sync_error': lastSyncError,
      if (isPendingDelete != null) 'is_pending_delete': isPendingDelete,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DamageReportAttachmentsCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? damageReportId,
    Value<String>? localPath,
    Value<String?>? remotePath,
    Value<String>? uploadStatus,
    Value<String>? syncStatus,
    Value<String?>? lastSyncError,
    Value<bool>? isPendingDelete,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return DamageReportAttachmentsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      damageReportId: damageReportId ?? this.damageReportId,
      localPath: localPath ?? this.localPath,
      remotePath: remotePath ?? this.remotePath,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncError: lastSyncError ?? this.lastSyncError,
      isPendingDelete: isPendingDelete ?? this.isPendingDelete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (damageReportId.present) {
      map['damage_report_id'] = Variable<String>(damageReportId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (remotePath.present) {
      map['remote_path'] = Variable<String>(remotePath.value);
    }
    if (uploadStatus.present) {
      map['upload_status'] = Variable<String>(uploadStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncError.present) {
      map['last_sync_error'] = Variable<String>(lastSyncError.value);
    }
    if (isPendingDelete.present) {
      map['is_pending_delete'] = Variable<bool>(isPendingDelete.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DamageReportAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('damageReportId: $damageReportId, ')
          ..write('localPath: $localPath, ')
          ..write('remotePath: $remotePath, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncError: $lastSyncError, ')
          ..write('isPendingDelete: $isPendingDelete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localId,
    entityType,
    operation,
    data,
    status,
    retryCount,
    lastError,
    lastAttemptAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final String localId;
  final String entityType;
  final String operation;
  final String data;
  final String status;
  final int retryCount;
  final String? lastError;
  final DateTime? lastAttemptAt;
  final DateTime createdAt;
  const SyncQueueData({
    required this.id,
    required this.localId,
    required this.entityType,
    required this.operation,
    required this.data,
    required this.status,
    required this.retryCount,
    this.lastError,
    this.lastAttemptAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['local_id'] = Variable<String>(localId);
    map['entity_type'] = Variable<String>(entityType);
    map['operation'] = Variable<String>(operation);
    map['data'] = Variable<String>(data);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      localId: Value(localId),
      entityType: Value(entityType),
      operation: Value(operation),
      data: Value(data),
      status: Value(status),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      localId: serializer.fromJson<String>(json['localId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      operation: serializer.fromJson<String>(json['operation']),
      data: serializer.fromJson<String>(json['data']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'localId': serializer.toJson<String>(localId),
      'entityType': serializer.toJson<String>(entityType),
      'operation': serializer.toJson<String>(operation),
      'data': serializer.toJson<String>(data),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueData copyWith({
    String? id,
    String? localId,
    String? entityType,
    String? operation,
    String? data,
    String? status,
    int? retryCount,
    Value<String?> lastError = const Value.absent(),
    Value<DateTime?> lastAttemptAt = const Value.absent(),
    DateTime? createdAt,
  }) => SyncQueueData(
    id: id ?? this.id,
    localId: localId ?? this.localId,
    entityType: entityType ?? this.entityType,
    operation: operation ?? this.operation,
    data: data ?? this.data,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      operation: data.operation.present ? data.operation.value : this.operation,
      data: data.data.present ? data.data.value : this.data,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('entityType: $entityType, ')
          ..write('operation: $operation, ')
          ..write('data: $data, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localId,
    entityType,
    operation,
    data,
    status,
    retryCount,
    lastError,
    lastAttemptAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.entityType == this.entityType &&
          other.operation == this.operation &&
          other.data == this.data &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.createdAt == this.createdAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<String> localId;
  final Value<String> entityType;
  final Value<String> operation;
  final Value<String> data;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<DateTime?> lastAttemptAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.operation = const Value.absent(),
    this.data = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String localId,
    required String entityType,
    required String operation,
    required String data,
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       localId = Value(localId),
       entityType = Value(entityType),
       operation = Value(operation),
       data = Value(data);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? localId,
    Expression<String>? entityType,
    Expression<String>? operation,
    Expression<String>? data,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<DateTime>? lastAttemptAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (entityType != null) 'entity_type': entityType,
      if (operation != null) 'operation': operation,
      if (data != null) 'data': data,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? localId,
    Value<String>? entityType,
    Value<String>? operation,
    Value<String>? data,
    Value<String>? status,
    Value<int>? retryCount,
    Value<String?>? lastError,
    Value<DateTime?>? lastAttemptAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      entityType: entityType ?? this.entityType,
      operation: operation ?? this.operation,
      data: data ?? this.data,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('entityType: $entityType, ')
          ..write('operation: $operation, ')
          ..write('data: $data, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OwnershipTypesTable extends OwnershipTypes
    with TableInfo<$OwnershipTypesTable, OwnershipType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OwnershipTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nameAr, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ownership_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<OwnershipType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OwnershipType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OwnershipType(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
    );
  }

  @override
  $OwnershipTypesTable createAlias(String alias) {
    return $OwnershipTypesTable(attachedDatabase, alias);
  }
}

class OwnershipType extends DataClass implements Insertable<OwnershipType> {
  final int id;
  final String nameAr;
  final String nameEn;
  const OwnershipType({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    return map;
  }

  OwnershipTypesCompanion toCompanion(bool nullToAbsent) {
    return OwnershipTypesCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
    );
  }

  factory OwnershipType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OwnershipType(
      id: serializer.fromJson<int>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
    };
  }

  OwnershipType copyWith({int? id, String? nameAr, String? nameEn}) =>
      OwnershipType(
        id: id ?? this.id,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
      );
  OwnershipType copyWithCompanion(OwnershipTypesCompanion data) {
    return OwnershipType(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OwnershipType(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameAr, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OwnershipType &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn);
}

class OwnershipTypesCompanion extends UpdateCompanion<OwnershipType> {
  final Value<int> id;
  final Value<String> nameAr;
  final Value<String> nameEn;
  const OwnershipTypesCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  OwnershipTypesCompanion.insert({
    this.id = const Value.absent(),
    required String nameAr,
    required String nameEn,
  }) : nameAr = Value(nameAr),
       nameEn = Value(nameEn);
  static Insertable<OwnershipType> custom({
    Expression<int>? id,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
    });
  }

  OwnershipTypesCompanion copyWith({
    Value<int>? id,
    Value<String>? nameAr,
    Value<String>? nameEn,
  }) {
    return OwnershipTypesCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OwnershipTypesCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }
}

class $AgriculturalSectorsTable extends AgriculturalSectors
    with TableInfo<$AgriculturalSectorsTable, AgriculturalSector> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AgriculturalSectorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nameAr, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'agricultural_sectors';
  @override
  VerificationContext validateIntegrity(
    Insertable<AgriculturalSector> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AgriculturalSector map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AgriculturalSector(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
    );
  }

  @override
  $AgriculturalSectorsTable createAlias(String alias) {
    return $AgriculturalSectorsTable(attachedDatabase, alias);
  }
}

class AgriculturalSector extends DataClass
    implements Insertable<AgriculturalSector> {
  final int id;
  final String nameAr;
  final String nameEn;
  const AgriculturalSector({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    return map;
  }

  AgriculturalSectorsCompanion toCompanion(bool nullToAbsent) {
    return AgriculturalSectorsCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
    );
  }

  factory AgriculturalSector.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AgriculturalSector(
      id: serializer.fromJson<int>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
    };
  }

  AgriculturalSector copyWith({int? id, String? nameAr, String? nameEn}) =>
      AgriculturalSector(
        id: id ?? this.id,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
      );
  AgriculturalSector copyWithCompanion(AgriculturalSectorsCompanion data) {
    return AgriculturalSector(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AgriculturalSector(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameAr, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AgriculturalSector &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn);
}

class AgriculturalSectorsCompanion extends UpdateCompanion<AgriculturalSector> {
  final Value<int> id;
  final Value<String> nameAr;
  final Value<String> nameEn;
  const AgriculturalSectorsCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  AgriculturalSectorsCompanion.insert({
    this.id = const Value.absent(),
    required String nameAr,
    required String nameEn,
  }) : nameAr = Value(nameAr),
       nameEn = Value(nameEn);
  static Insertable<AgriculturalSector> custom({
    Expression<int>? id,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
    });
  }

  AgriculturalSectorsCompanion copyWith({
    Value<int>? id,
    Value<String>? nameAr,
    Value<String>? nameEn,
  }) {
    return AgriculturalSectorsCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AgriculturalSectorsCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }
}

class $PoliticalClassificationsTable extends PoliticalClassifications
    with TableInfo<$PoliticalClassificationsTable, PoliticalClassification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PoliticalClassificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nameAr, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'political_classifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<PoliticalClassification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PoliticalClassification map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PoliticalClassification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
    );
  }

  @override
  $PoliticalClassificationsTable createAlias(String alias) {
    return $PoliticalClassificationsTable(attachedDatabase, alias);
  }
}

class PoliticalClassification extends DataClass
    implements Insertable<PoliticalClassification> {
  final int id;
  final String nameAr;
  final String nameEn;
  const PoliticalClassification({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    return map;
  }

  PoliticalClassificationsCompanion toCompanion(bool nullToAbsent) {
    return PoliticalClassificationsCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
    );
  }

  factory PoliticalClassification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PoliticalClassification(
      id: serializer.fromJson<int>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
    };
  }

  PoliticalClassification copyWith({int? id, String? nameAr, String? nameEn}) =>
      PoliticalClassification(
        id: id ?? this.id,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
      );
  PoliticalClassification copyWithCompanion(
    PoliticalClassificationsCompanion data,
  ) {
    return PoliticalClassification(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PoliticalClassification(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameAr, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PoliticalClassification &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn);
}

class PoliticalClassificationsCompanion
    extends UpdateCompanion<PoliticalClassification> {
  final Value<int> id;
  final Value<String> nameAr;
  final Value<String> nameEn;
  const PoliticalClassificationsCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  PoliticalClassificationsCompanion.insert({
    this.id = const Value.absent(),
    required String nameAr,
    required String nameEn,
  }) : nameAr = Value(nameAr),
       nameEn = Value(nameEn);
  static Insertable<PoliticalClassification> custom({
    Expression<int>? id,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
    });
  }

  PoliticalClassificationsCompanion copyWith({
    Value<int>? id,
    Value<String>? nameAr,
    Value<String>? nameEn,
  }) {
    return PoliticalClassificationsCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PoliticalClassificationsCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }
}

class $AreaUnitsTable extends AreaUnits
    with TableInfo<$AreaUnitsTable, AreaUnit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AreaUnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nameAr, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'area_units';
  @override
  VerificationContext validateIntegrity(
    Insertable<AreaUnit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AreaUnit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AreaUnit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
    );
  }

  @override
  $AreaUnitsTable createAlias(String alias) {
    return $AreaUnitsTable(attachedDatabase, alias);
  }
}

class AreaUnit extends DataClass implements Insertable<AreaUnit> {
  final int id;
  final String nameAr;
  final String nameEn;
  const AreaUnit({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    return map;
  }

  AreaUnitsCompanion toCompanion(bool nullToAbsent) {
    return AreaUnitsCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
    );
  }

  factory AreaUnit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AreaUnit(
      id: serializer.fromJson<int>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
    };
  }

  AreaUnit copyWith({int? id, String? nameAr, String? nameEn}) => AreaUnit(
    id: id ?? this.id,
    nameAr: nameAr ?? this.nameAr,
    nameEn: nameEn ?? this.nameEn,
  );
  AreaUnit copyWithCompanion(AreaUnitsCompanion data) {
    return AreaUnit(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AreaUnit(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameAr, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AreaUnit &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn);
}

class AreaUnitsCompanion extends UpdateCompanion<AreaUnit> {
  final Value<int> id;
  final Value<String> nameAr;
  final Value<String> nameEn;
  const AreaUnitsCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  AreaUnitsCompanion.insert({
    this.id = const Value.absent(),
    required String nameAr,
    required String nameEn,
  }) : nameAr = Value(nameAr),
       nameEn = Value(nameEn);
  static Insertable<AreaUnit> custom({
    Expression<int>? id,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
    });
  }

  AreaUnitsCompanion copyWith({
    Value<int>? id,
    Value<String>? nameAr,
    Value<String>? nameEn,
  }) {
    return AreaUnitsCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AreaUnitsCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }
}

class $RelationshipToOwnersTable extends RelationshipToOwners
    with TableInfo<$RelationshipToOwnersTable, RelationshipToOwner> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelationshipToOwnersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nameAr, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'relationship_to_owners';
  @override
  VerificationContext validateIntegrity(
    Insertable<RelationshipToOwner> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RelationshipToOwner map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RelationshipToOwner(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
    );
  }

  @override
  $RelationshipToOwnersTable createAlias(String alias) {
    return $RelationshipToOwnersTable(attachedDatabase, alias);
  }
}

class RelationshipToOwner extends DataClass
    implements Insertable<RelationshipToOwner> {
  final int id;
  final String nameAr;
  final String nameEn;
  const RelationshipToOwner({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    return map;
  }

  RelationshipToOwnersCompanion toCompanion(bool nullToAbsent) {
    return RelationshipToOwnersCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
    );
  }

  factory RelationshipToOwner.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RelationshipToOwner(
      id: serializer.fromJson<int>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
    };
  }

  RelationshipToOwner copyWith({int? id, String? nameAr, String? nameEn}) =>
      RelationshipToOwner(
        id: id ?? this.id,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
      );
  RelationshipToOwner copyWithCompanion(RelationshipToOwnersCompanion data) {
    return RelationshipToOwner(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RelationshipToOwner(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameAr, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RelationshipToOwner &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn);
}

class RelationshipToOwnersCompanion
    extends UpdateCompanion<RelationshipToOwner> {
  final Value<int> id;
  final Value<String> nameAr;
  final Value<String> nameEn;
  const RelationshipToOwnersCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  RelationshipToOwnersCompanion.insert({
    this.id = const Value.absent(),
    required String nameAr,
    required String nameEn,
  }) : nameAr = Value(nameAr),
       nameEn = Value(nameEn);
  static Insertable<RelationshipToOwner> custom({
    Expression<int>? id,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
    });
  }

  RelationshipToOwnersCompanion copyWith({
    Value<int>? id,
    Value<String>? nameAr,
    Value<String>? nameEn,
  }) {
    return RelationshipToOwnersCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelationshipToOwnersCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }
}

class $GovernoratesTable extends Governorates
    with TableInfo<$GovernoratesTable, GovernorateLocal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GovernoratesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nameAr, nameEn, code];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'governorates';
  @override
  VerificationContext validateIntegrity(
    Insertable<GovernorateLocal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GovernorateLocal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GovernorateLocal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
    );
  }

  @override
  $GovernoratesTable createAlias(String alias) {
    return $GovernoratesTable(attachedDatabase, alias);
  }
}

class GovernorateLocal extends DataClass
    implements Insertable<GovernorateLocal> {
  final String id;
  final String nameAr;
  final String nameEn;
  final String code;
  const GovernorateLocal({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.code,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    map['code'] = Variable<String>(code);
    return map;
  }

  GovernoratesCompanion toCompanion(bool nullToAbsent) {
    return GovernoratesCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
      code: Value(code),
    );
  }

  factory GovernorateLocal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GovernorateLocal(
      id: serializer.fromJson<String>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      code: serializer.fromJson<String>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
      'code': serializer.toJson<String>(code),
    };
  }

  GovernorateLocal copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? code,
  }) => GovernorateLocal(
    id: id ?? this.id,
    nameAr: nameAr ?? this.nameAr,
    nameEn: nameEn ?? this.nameEn,
    code: code ?? this.code,
  );
  GovernorateLocal copyWithCompanion(GovernoratesCompanion data) {
    return GovernorateLocal(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      code: data.code.present ? data.code.value : this.code,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GovernorateLocal(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameAr, nameEn, code);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GovernorateLocal &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn &&
          other.code == this.code);
}

class GovernoratesCompanion extends UpdateCompanion<GovernorateLocal> {
  final Value<String> id;
  final Value<String> nameAr;
  final Value<String> nameEn;
  final Value<String> code;
  final Value<int> rowid;
  const GovernoratesCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.code = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GovernoratesCompanion.insert({
    required String id,
    required String nameAr,
    required String nameEn,
    required String code,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nameAr = Value(nameAr),
       nameEn = Value(nameEn),
       code = Value(code);
  static Insertable<GovernorateLocal> custom({
    Expression<String>? id,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
    Expression<String>? code,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (code != null) 'code': code,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GovernoratesCompanion copyWith({
    Value<String>? id,
    Value<String>? nameAr,
    Value<String>? nameEn,
    Value<String>? code,
    Value<int>? rowid,
  }) {
    return GovernoratesCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      code: code ?? this.code,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GovernoratesCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('code: $code, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DirectoratesTable extends Directorates
    with TableInfo<$DirectoratesTable, DirectorateLocal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DirectoratesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _governorateIdMeta = const VerificationMeta(
    'governorateId',
  );
  @override
  late final GeneratedColumn<String> governorateId = GeneratedColumn<String>(
    'governorate_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nameAr, nameEn, governorateId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'directorates';
  @override
  VerificationContext validateIntegrity(
    Insertable<DirectorateLocal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('governorate_id')) {
      context.handle(
        _governorateIdMeta,
        governorateId.isAcceptableOrUnknown(
          data['governorate_id']!,
          _governorateIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_governorateIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DirectorateLocal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DirectorateLocal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      governorateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}governorate_id'],
      )!,
    );
  }

  @override
  $DirectoratesTable createAlias(String alias) {
    return $DirectoratesTable(attachedDatabase, alias);
  }
}

class DirectorateLocal extends DataClass
    implements Insertable<DirectorateLocal> {
  final String id;
  final String nameAr;
  final String nameEn;
  final String governorateId;
  const DirectorateLocal({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.governorateId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    map['governorate_id'] = Variable<String>(governorateId);
    return map;
  }

  DirectoratesCompanion toCompanion(bool nullToAbsent) {
    return DirectoratesCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
      governorateId: Value(governorateId),
    );
  }

  factory DirectorateLocal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DirectorateLocal(
      id: serializer.fromJson<String>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      governorateId: serializer.fromJson<String>(json['governorateId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
      'governorateId': serializer.toJson<String>(governorateId),
    };
  }

  DirectorateLocal copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? governorateId,
  }) => DirectorateLocal(
    id: id ?? this.id,
    nameAr: nameAr ?? this.nameAr,
    nameEn: nameEn ?? this.nameEn,
    governorateId: governorateId ?? this.governorateId,
  );
  DirectorateLocal copyWithCompanion(DirectoratesCompanion data) {
    return DirectorateLocal(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      governorateId: data.governorateId.present
          ? data.governorateId.value
          : this.governorateId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DirectorateLocal(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('governorateId: $governorateId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameAr, nameEn, governorateId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DirectorateLocal &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn &&
          other.governorateId == this.governorateId);
}

class DirectoratesCompanion extends UpdateCompanion<DirectorateLocal> {
  final Value<String> id;
  final Value<String> nameAr;
  final Value<String> nameEn;
  final Value<String> governorateId;
  final Value<int> rowid;
  const DirectoratesCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.governorateId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DirectoratesCompanion.insert({
    required String id,
    required String nameAr,
    required String nameEn,
    required String governorateId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nameAr = Value(nameAr),
       nameEn = Value(nameEn),
       governorateId = Value(governorateId);
  static Insertable<DirectorateLocal> custom({
    Expression<String>? id,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
    Expression<String>? governorateId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (governorateId != null) 'governorate_id': governorateId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DirectoratesCompanion copyWith({
    Value<String>? id,
    Value<String>? nameAr,
    Value<String>? nameEn,
    Value<String>? governorateId,
    Value<int>? rowid,
  }) {
    return DirectoratesCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      governorateId: governorateId ?? this.governorateId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (governorateId.present) {
      map['governorate_id'] = Variable<String>(governorateId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DirectoratesCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('governorateId: $governorateId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalitiesTable extends Localities
    with TableInfo<$LocalitiesTable, LocalityLocal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _governorateIdMeta = const VerificationMeta(
    'governorateId',
  );
  @override
  late final GeneratedColumn<String> governorateId = GeneratedColumn<String>(
    'governorate_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directorateIdMeta = const VerificationMeta(
    'directorateId',
  );
  @override
  late final GeneratedColumn<String> directorateId = GeneratedColumn<String>(
    'directorate_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameAr,
    nameEn,
    governorateId,
    directorateId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'localities';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalityLocal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('governorate_id')) {
      context.handle(
        _governorateIdMeta,
        governorateId.isAcceptableOrUnknown(
          data['governorate_id']!,
          _governorateIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_governorateIdMeta);
    }
    if (data.containsKey('directorate_id')) {
      context.handle(
        _directorateIdMeta,
        directorateId.isAcceptableOrUnknown(
          data['directorate_id']!,
          _directorateIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_directorateIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalityLocal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalityLocal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      governorateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}governorate_id'],
      )!,
      directorateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}directorate_id'],
      )!,
    );
  }

  @override
  $LocalitiesTable createAlias(String alias) {
    return $LocalitiesTable(attachedDatabase, alias);
  }
}

class LocalityLocal extends DataClass implements Insertable<LocalityLocal> {
  final String id;
  final String nameAr;
  final String nameEn;
  final String governorateId;
  final String directorateId;
  const LocalityLocal({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.governorateId,
    required this.directorateId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    map['governorate_id'] = Variable<String>(governorateId);
    map['directorate_id'] = Variable<String>(directorateId);
    return map;
  }

  LocalitiesCompanion toCompanion(bool nullToAbsent) {
    return LocalitiesCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
      governorateId: Value(governorateId),
      directorateId: Value(directorateId),
    );
  }

  factory LocalityLocal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalityLocal(
      id: serializer.fromJson<String>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      governorateId: serializer.fromJson<String>(json['governorateId']),
      directorateId: serializer.fromJson<String>(json['directorateId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
      'governorateId': serializer.toJson<String>(governorateId),
      'directorateId': serializer.toJson<String>(directorateId),
    };
  }

  LocalityLocal copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? governorateId,
    String? directorateId,
  }) => LocalityLocal(
    id: id ?? this.id,
    nameAr: nameAr ?? this.nameAr,
    nameEn: nameEn ?? this.nameEn,
    governorateId: governorateId ?? this.governorateId,
    directorateId: directorateId ?? this.directorateId,
  );
  LocalityLocal copyWithCompanion(LocalitiesCompanion data) {
    return LocalityLocal(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      governorateId: data.governorateId.present
          ? data.governorateId.value
          : this.governorateId,
      directorateId: data.directorateId.present
          ? data.directorateId.value
          : this.directorateId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalityLocal(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('governorateId: $governorateId, ')
          ..write('directorateId: $directorateId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nameAr, nameEn, governorateId, directorateId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalityLocal &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn &&
          other.governorateId == this.governorateId &&
          other.directorateId == this.directorateId);
}

class LocalitiesCompanion extends UpdateCompanion<LocalityLocal> {
  final Value<String> id;
  final Value<String> nameAr;
  final Value<String> nameEn;
  final Value<String> governorateId;
  final Value<String> directorateId;
  final Value<int> rowid;
  const LocalitiesCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.governorateId = const Value.absent(),
    this.directorateId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalitiesCompanion.insert({
    required String id,
    required String nameAr,
    required String nameEn,
    required String governorateId,
    required String directorateId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nameAr = Value(nameAr),
       nameEn = Value(nameEn),
       governorateId = Value(governorateId),
       directorateId = Value(directorateId);
  static Insertable<LocalityLocal> custom({
    Expression<String>? id,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
    Expression<String>? governorateId,
    Expression<String>? directorateId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (governorateId != null) 'governorate_id': governorateId,
      if (directorateId != null) 'directorate_id': directorateId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? nameAr,
    Value<String>? nameEn,
    Value<String>? governorateId,
    Value<String>? directorateId,
    Value<int>? rowid,
  }) {
    return LocalitiesCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      governorateId: governorateId ?? this.governorateId,
      directorateId: directorateId ?? this.directorateId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (governorateId.present) {
      map['governorate_id'] = Variable<String>(governorateId.value);
    }
    if (directorateId.present) {
      map['directorate_id'] = Variable<String>(directorateId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalitiesCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('governorateId: $governorateId, ')
          ..write('directorateId: $directorateId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DamageNaturesTable extends DamageNatures
    with TableInfo<$DamageNaturesTable, DamageNature> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DamageNaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nameAr, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'damage_natures';
  @override
  VerificationContext validateIntegrity(
    Insertable<DamageNature> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DamageNature map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DamageNature(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
    );
  }

  @override
  $DamageNaturesTable createAlias(String alias) {
    return $DamageNaturesTable(attachedDatabase, alias);
  }
}

class DamageNature extends DataClass implements Insertable<DamageNature> {
  final int id;
  final String nameAr;
  final String nameEn;
  const DamageNature({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    return map;
  }

  DamageNaturesCompanion toCompanion(bool nullToAbsent) {
    return DamageNaturesCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
    );
  }

  factory DamageNature.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DamageNature(
      id: serializer.fromJson<int>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
    };
  }

  DamageNature copyWith({int? id, String? nameAr, String? nameEn}) =>
      DamageNature(
        id: id ?? this.id,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
      );
  DamageNature copyWithCompanion(DamageNaturesCompanion data) {
    return DamageNature(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DamageNature(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameAr, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DamageNature &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn);
}

class DamageNaturesCompanion extends UpdateCompanion<DamageNature> {
  final Value<int> id;
  final Value<String> nameAr;
  final Value<String> nameEn;
  const DamageNaturesCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  DamageNaturesCompanion.insert({
    this.id = const Value.absent(),
    required String nameAr,
    required String nameEn,
  }) : nameAr = Value(nameAr),
       nameEn = Value(nameEn);
  static Insertable<DamageNature> custom({
    Expression<int>? id,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
    });
  }

  DamageNaturesCompanion copyWith({
    Value<int>? id,
    Value<String>? nameAr,
    Value<String>? nameEn,
  }) {
    return DamageNaturesCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DamageNaturesCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }
}

class $DamageCategoriesTable extends DamageCategories
    with TableInfo<$DamageCategoriesTable, DamageCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DamageCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, parentId, nameAr, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'damage_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<DamageCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DamageCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DamageCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
    );
  }

  @override
  $DamageCategoriesTable createAlias(String alias) {
    return $DamageCategoriesTable(attachedDatabase, alias);
  }
}

class DamageCategory extends DataClass implements Insertable<DamageCategory> {
  final int id;
  final int parentId;
  final String nameAr;
  final String nameEn;
  const DamageCategory({
    required this.id,
    required this.parentId,
    required this.nameAr,
    required this.nameEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['parent_id'] = Variable<int>(parentId);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    return map;
  }

  DamageCategoriesCompanion toCompanion(bool nullToAbsent) {
    return DamageCategoriesCompanion(
      id: Value(id),
      parentId: Value(parentId),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
    );
  }

  factory DamageCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DamageCategory(
      id: serializer.fromJson<int>(json['id']),
      parentId: serializer.fromJson<int>(json['parentId']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'parentId': serializer.toJson<int>(parentId),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
    };
  }

  DamageCategory copyWith({
    int? id,
    int? parentId,
    String? nameAr,
    String? nameEn,
  }) => DamageCategory(
    id: id ?? this.id,
    parentId: parentId ?? this.parentId,
    nameAr: nameAr ?? this.nameAr,
    nameEn: nameEn ?? this.nameEn,
  );
  DamageCategory copyWithCompanion(DamageCategoriesCompanion data) {
    return DamageCategory(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DamageCategory(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, parentId, nameAr, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DamageCategory &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn);
}

class DamageCategoriesCompanion extends UpdateCompanion<DamageCategory> {
  final Value<int> id;
  final Value<int> parentId;
  final Value<String> nameAr;
  final Value<String> nameEn;
  const DamageCategoriesCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  DamageCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int parentId,
    required String nameAr,
    required String nameEn,
  }) : parentId = Value(parentId),
       nameAr = Value(nameAr),
       nameEn = Value(nameEn);
  static Insertable<DamageCategory> custom({
    Expression<int>? id,
    Expression<int>? parentId,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
    });
  }

  DamageCategoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? parentId,
    Value<String>? nameAr,
    Value<String>? nameEn,
  }) {
    return DamageCategoriesCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DamageCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }
}

class $DamageSubCategoriesTable extends DamageSubCategories
    with TableInfo<$DamageSubCategoriesTable, DamageSubCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DamageSubCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, parentId, nameAr, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'damage_sub_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<DamageSubCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DamageSubCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DamageSubCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
    );
  }

  @override
  $DamageSubCategoriesTable createAlias(String alias) {
    return $DamageSubCategoriesTable(attachedDatabase, alias);
  }
}

class DamageSubCategory extends DataClass
    implements Insertable<DamageSubCategory> {
  final int id;
  final int parentId;
  final String nameAr;
  final String nameEn;
  const DamageSubCategory({
    required this.id,
    required this.parentId,
    required this.nameAr,
    required this.nameEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['parent_id'] = Variable<int>(parentId);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    return map;
  }

  DamageSubCategoriesCompanion toCompanion(bool nullToAbsent) {
    return DamageSubCategoriesCompanion(
      id: Value(id),
      parentId: Value(parentId),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
    );
  }

  factory DamageSubCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DamageSubCategory(
      id: serializer.fromJson<int>(json['id']),
      parentId: serializer.fromJson<int>(json['parentId']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'parentId': serializer.toJson<int>(parentId),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
    };
  }

  DamageSubCategory copyWith({
    int? id,
    int? parentId,
    String? nameAr,
    String? nameEn,
  }) => DamageSubCategory(
    id: id ?? this.id,
    parentId: parentId ?? this.parentId,
    nameAr: nameAr ?? this.nameAr,
    nameEn: nameEn ?? this.nameEn,
  );
  DamageSubCategory copyWithCompanion(DamageSubCategoriesCompanion data) {
    return DamageSubCategory(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DamageSubCategory(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, parentId, nameAr, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DamageSubCategory &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn);
}

class DamageSubCategoriesCompanion extends UpdateCompanion<DamageSubCategory> {
  final Value<int> id;
  final Value<int> parentId;
  final Value<String> nameAr;
  final Value<String> nameEn;
  const DamageSubCategoriesCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  DamageSubCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int parentId,
    required String nameAr,
    required String nameEn,
  }) : parentId = Value(parentId),
       nameAr = Value(nameAr),
       nameEn = Value(nameEn);
  static Insertable<DamageSubCategory> custom({
    Expression<int>? id,
    Expression<int>? parentId,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
    });
  }

  DamageSubCategoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? parentId,
    Value<String>? nameAr,
    Value<String>? nameEn,
  }) {
    return DamageSubCategoriesCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DamageSubCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }
}

class $DamageClassificationsTable extends DamageClassifications
    with TableInfo<$DamageClassificationsTable, DamageClassification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DamageClassificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, parentId, nameAr, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'damage_classifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<DamageClassification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DamageClassification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DamageClassification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
    );
  }

  @override
  $DamageClassificationsTable createAlias(String alias) {
    return $DamageClassificationsTable(attachedDatabase, alias);
  }
}

class DamageClassification extends DataClass
    implements Insertable<DamageClassification> {
  final int id;
  final int parentId;
  final String nameAr;
  final String nameEn;
  const DamageClassification({
    required this.id,
    required this.parentId,
    required this.nameAr,
    required this.nameEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['parent_id'] = Variable<int>(parentId);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    return map;
  }

  DamageClassificationsCompanion toCompanion(bool nullToAbsent) {
    return DamageClassificationsCompanion(
      id: Value(id),
      parentId: Value(parentId),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
    );
  }

  factory DamageClassification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DamageClassification(
      id: serializer.fromJson<int>(json['id']),
      parentId: serializer.fromJson<int>(json['parentId']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'parentId': serializer.toJson<int>(parentId),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
    };
  }

  DamageClassification copyWith({
    int? id,
    int? parentId,
    String? nameAr,
    String? nameEn,
  }) => DamageClassification(
    id: id ?? this.id,
    parentId: parentId ?? this.parentId,
    nameAr: nameAr ?? this.nameAr,
    nameEn: nameEn ?? this.nameEn,
  );
  DamageClassification copyWithCompanion(DamageClassificationsCompanion data) {
    return DamageClassification(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DamageClassification(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, parentId, nameAr, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DamageClassification &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn);
}

class DamageClassificationsCompanion
    extends UpdateCompanion<DamageClassification> {
  final Value<int> id;
  final Value<int> parentId;
  final Value<String> nameAr;
  final Value<String> nameEn;
  const DamageClassificationsCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  DamageClassificationsCompanion.insert({
    this.id = const Value.absent(),
    required int parentId,
    required String nameAr,
    required String nameEn,
  }) : parentId = Value(parentId),
       nameAr = Value(nameAr),
       nameEn = Value(nameEn);
  static Insertable<DamageClassification> custom({
    Expression<int>? id,
    Expression<int>? parentId,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
    });
  }

  DamageClassificationsCompanion copyWith({
    Value<int>? id,
    Value<int>? parentId,
    Value<String>? nameAr,
    Value<String>? nameEn,
  }) {
    return DamageClassificationsCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DamageClassificationsCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }
}

class $DamageCauseCategoriesTable extends DamageCauseCategories
    with TableInfo<$DamageCauseCategoriesTable, DamageCauseCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DamageCauseCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nameAr, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'damage_cause_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<DamageCauseCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DamageCauseCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DamageCauseCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
    );
  }

  @override
  $DamageCauseCategoriesTable createAlias(String alias) {
    return $DamageCauseCategoriesTable(attachedDatabase, alias);
  }
}

class DamageCauseCategory extends DataClass
    implements Insertable<DamageCauseCategory> {
  final int id;
  final String nameAr;
  final String nameEn;
  const DamageCauseCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    return map;
  }

  DamageCauseCategoriesCompanion toCompanion(bool nullToAbsent) {
    return DamageCauseCategoriesCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
    );
  }

  factory DamageCauseCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DamageCauseCategory(
      id: serializer.fromJson<int>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
    };
  }

  DamageCauseCategory copyWith({int? id, String? nameAr, String? nameEn}) =>
      DamageCauseCategory(
        id: id ?? this.id,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
      );
  DamageCauseCategory copyWithCompanion(DamageCauseCategoriesCompanion data) {
    return DamageCauseCategory(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DamageCauseCategory(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameAr, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DamageCauseCategory &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn);
}

class DamageCauseCategoriesCompanion
    extends UpdateCompanion<DamageCauseCategory> {
  final Value<int> id;
  final Value<String> nameAr;
  final Value<String> nameEn;
  const DamageCauseCategoriesCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  DamageCauseCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String nameAr,
    required String nameEn,
  }) : nameAr = Value(nameAr),
       nameEn = Value(nameEn);
  static Insertable<DamageCauseCategory> custom({
    Expression<int>? id,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
    });
  }

  DamageCauseCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? nameAr,
    Value<String>? nameEn,
  }) {
    return DamageCauseCategoriesCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DamageCauseCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }
}

class $DamageCausesTable extends DamageCauses
    with TableInfo<$DamageCausesTable, DamageCause> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DamageCausesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, parentId, nameAr, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'damage_causes';
  @override
  VerificationContext validateIntegrity(
    Insertable<DamageCause> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DamageCause map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DamageCause(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
    );
  }

  @override
  $DamageCausesTable createAlias(String alias) {
    return $DamageCausesTable(attachedDatabase, alias);
  }
}

class DamageCause extends DataClass implements Insertable<DamageCause> {
  final int id;
  final int parentId;
  final String nameAr;
  final String nameEn;
  const DamageCause({
    required this.id,
    required this.parentId,
    required this.nameAr,
    required this.nameEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['parent_id'] = Variable<int>(parentId);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    return map;
  }

  DamageCausesCompanion toCompanion(bool nullToAbsent) {
    return DamageCausesCompanion(
      id: Value(id),
      parentId: Value(parentId),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
    );
  }

  factory DamageCause.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DamageCause(
      id: serializer.fromJson<int>(json['id']),
      parentId: serializer.fromJson<int>(json['parentId']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'parentId': serializer.toJson<int>(parentId),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
    };
  }

  DamageCause copyWith({
    int? id,
    int? parentId,
    String? nameAr,
    String? nameEn,
  }) => DamageCause(
    id: id ?? this.id,
    parentId: parentId ?? this.parentId,
    nameAr: nameAr ?? this.nameAr,
    nameEn: nameEn ?? this.nameEn,
  );
  DamageCause copyWithCompanion(DamageCausesCompanion data) {
    return DamageCause(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DamageCause(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, parentId, nameAr, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DamageCause &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn);
}

class DamageCausesCompanion extends UpdateCompanion<DamageCause> {
  final Value<int> id;
  final Value<int> parentId;
  final Value<String> nameAr;
  final Value<String> nameEn;
  const DamageCausesCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  DamageCausesCompanion.insert({
    this.id = const Value.absent(),
    required int parentId,
    required String nameAr,
    required String nameEn,
  }) : parentId = Value(parentId),
       nameAr = Value(nameAr),
       nameEn = Value(nameEn);
  static Insertable<DamageCause> custom({
    Expression<int>? id,
    Expression<int>? parentId,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
    });
  }

  DamageCausesCompanion copyWith({
    Value<int>? id,
    Value<int>? parentId,
    Value<String>? nameAr,
    Value<String>? nameEn,
  }) {
    return DamageCausesCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DamageCausesCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }
}

class $CostingSheetsTable extends CostingSheets
    with TableInfo<$CostingSheetsTable, CostingSheet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CostingSheetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classificationIdMeta = const VerificationMeta(
    'classificationId',
  );
  @override
  late final GeneratedColumn<int> classificationId = GeneratedColumn<int>(
    'classification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectiveFromMeta = const VerificationMeta(
    'effectiveFrom',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveFrom =
      GeneratedColumn<DateTime>(
        'effective_from',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _effectiveToMeta = const VerificationMeta(
    'effectiveTo',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveTo = GeneratedColumn<DateTime>(
    'effective_to',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _versionNumberMeta = const VerificationMeta(
    'versionNumber',
  );
  @override
  late final GeneratedColumn<int> versionNumber = GeneratedColumn<int>(
    'version_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    classificationId,
    unitPrice,
    effectiveFrom,
    effectiveTo,
    isActive,
    versionNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'costing_sheets';
  @override
  VerificationContext validateIntegrity(
    Insertable<CostingSheet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('classification_id')) {
      context.handle(
        _classificationIdMeta,
        classificationId.isAcceptableOrUnknown(
          data['classification_id']!,
          _classificationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_classificationIdMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('effective_from')) {
      context.handle(
        _effectiveFromMeta,
        effectiveFrom.isAcceptableOrUnknown(
          data['effective_from']!,
          _effectiveFromMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveFromMeta);
    }
    if (data.containsKey('effective_to')) {
      context.handle(
        _effectiveToMeta,
        effectiveTo.isAcceptableOrUnknown(
          data['effective_to']!,
          _effectiveToMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('version_number')) {
      context.handle(
        _versionNumberMeta,
        versionNumber.isAcceptableOrUnknown(
          data['version_number']!,
          _versionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_versionNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CostingSheet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CostingSheet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      classificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}classification_id'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      effectiveFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}effective_from'],
      )!,
      effectiveTo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}effective_to'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      versionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version_number'],
      )!,
    );
  }

  @override
  $CostingSheetsTable createAlias(String alias) {
    return $CostingSheetsTable(attachedDatabase, alias);
  }
}

class CostingSheet extends DataClass implements Insertable<CostingSheet> {
  final String id;
  final int classificationId;
  final double unitPrice;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;
  final bool isActive;
  final int versionNumber;
  const CostingSheet({
    required this.id,
    required this.classificationId,
    required this.unitPrice,
    required this.effectiveFrom,
    this.effectiveTo,
    required this.isActive,
    required this.versionNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['classification_id'] = Variable<int>(classificationId);
    map['unit_price'] = Variable<double>(unitPrice);
    map['effective_from'] = Variable<DateTime>(effectiveFrom);
    if (!nullToAbsent || effectiveTo != null) {
      map['effective_to'] = Variable<DateTime>(effectiveTo);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['version_number'] = Variable<int>(versionNumber);
    return map;
  }

  CostingSheetsCompanion toCompanion(bool nullToAbsent) {
    return CostingSheetsCompanion(
      id: Value(id),
      classificationId: Value(classificationId),
      unitPrice: Value(unitPrice),
      effectiveFrom: Value(effectiveFrom),
      effectiveTo: effectiveTo == null && nullToAbsent
          ? const Value.absent()
          : Value(effectiveTo),
      isActive: Value(isActive),
      versionNumber: Value(versionNumber),
    );
  }

  factory CostingSheet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CostingSheet(
      id: serializer.fromJson<String>(json['id']),
      classificationId: serializer.fromJson<int>(json['classificationId']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      effectiveFrom: serializer.fromJson<DateTime>(json['effectiveFrom']),
      effectiveTo: serializer.fromJson<DateTime?>(json['effectiveTo']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      versionNumber: serializer.fromJson<int>(json['versionNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'classificationId': serializer.toJson<int>(classificationId),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'effectiveFrom': serializer.toJson<DateTime>(effectiveFrom),
      'effectiveTo': serializer.toJson<DateTime?>(effectiveTo),
      'isActive': serializer.toJson<bool>(isActive),
      'versionNumber': serializer.toJson<int>(versionNumber),
    };
  }

  CostingSheet copyWith({
    String? id,
    int? classificationId,
    double? unitPrice,
    DateTime? effectiveFrom,
    Value<DateTime?> effectiveTo = const Value.absent(),
    bool? isActive,
    int? versionNumber,
  }) => CostingSheet(
    id: id ?? this.id,
    classificationId: classificationId ?? this.classificationId,
    unitPrice: unitPrice ?? this.unitPrice,
    effectiveFrom: effectiveFrom ?? this.effectiveFrom,
    effectiveTo: effectiveTo.present ? effectiveTo.value : this.effectiveTo,
    isActive: isActive ?? this.isActive,
    versionNumber: versionNumber ?? this.versionNumber,
  );
  CostingSheet copyWithCompanion(CostingSheetsCompanion data) {
    return CostingSheet(
      id: data.id.present ? data.id.value : this.id,
      classificationId: data.classificationId.present
          ? data.classificationId.value
          : this.classificationId,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      effectiveFrom: data.effectiveFrom.present
          ? data.effectiveFrom.value
          : this.effectiveFrom,
      effectiveTo: data.effectiveTo.present
          ? data.effectiveTo.value
          : this.effectiveTo,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      versionNumber: data.versionNumber.present
          ? data.versionNumber.value
          : this.versionNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CostingSheet(')
          ..write('id: $id, ')
          ..write('classificationId: $classificationId, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('effectiveTo: $effectiveTo, ')
          ..write('isActive: $isActive, ')
          ..write('versionNumber: $versionNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    classificationId,
    unitPrice,
    effectiveFrom,
    effectiveTo,
    isActive,
    versionNumber,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CostingSheet &&
          other.id == this.id &&
          other.classificationId == this.classificationId &&
          other.unitPrice == this.unitPrice &&
          other.effectiveFrom == this.effectiveFrom &&
          other.effectiveTo == this.effectiveTo &&
          other.isActive == this.isActive &&
          other.versionNumber == this.versionNumber);
}

class CostingSheetsCompanion extends UpdateCompanion<CostingSheet> {
  final Value<String> id;
  final Value<int> classificationId;
  final Value<double> unitPrice;
  final Value<DateTime> effectiveFrom;
  final Value<DateTime?> effectiveTo;
  final Value<bool> isActive;
  final Value<int> versionNumber;
  final Value<int> rowid;
  const CostingSheetsCompanion({
    this.id = const Value.absent(),
    this.classificationId = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
    this.effectiveTo = const Value.absent(),
    this.isActive = const Value.absent(),
    this.versionNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CostingSheetsCompanion.insert({
    required String id,
    required int classificationId,
    required double unitPrice,
    required DateTime effectiveFrom,
    this.effectiveTo = const Value.absent(),
    this.isActive = const Value.absent(),
    required int versionNumber,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       classificationId = Value(classificationId),
       unitPrice = Value(unitPrice),
       effectiveFrom = Value(effectiveFrom),
       versionNumber = Value(versionNumber);
  static Insertable<CostingSheet> custom({
    Expression<String>? id,
    Expression<int>? classificationId,
    Expression<double>? unitPrice,
    Expression<DateTime>? effectiveFrom,
    Expression<DateTime>? effectiveTo,
    Expression<bool>? isActive,
    Expression<int>? versionNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (classificationId != null) 'classification_id': classificationId,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (effectiveFrom != null) 'effective_from': effectiveFrom,
      if (effectiveTo != null) 'effective_to': effectiveTo,
      if (isActive != null) 'is_active': isActive,
      if (versionNumber != null) 'version_number': versionNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CostingSheetsCompanion copyWith({
    Value<String>? id,
    Value<int>? classificationId,
    Value<double>? unitPrice,
    Value<DateTime>? effectiveFrom,
    Value<DateTime?>? effectiveTo,
    Value<bool>? isActive,
    Value<int>? versionNumber,
    Value<int>? rowid,
  }) {
    return CostingSheetsCompanion(
      id: id ?? this.id,
      classificationId: classificationId ?? this.classificationId,
      unitPrice: unitPrice ?? this.unitPrice,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo ?? this.effectiveTo,
      isActive: isActive ?? this.isActive,
      versionNumber: versionNumber ?? this.versionNumber,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (classificationId.present) {
      map['classification_id'] = Variable<int>(classificationId.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (effectiveFrom.present) {
      map['effective_from'] = Variable<DateTime>(effectiveFrom.value);
    }
    if (effectiveTo.present) {
      map['effective_to'] = Variable<DateTime>(effectiveTo.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (versionNumber.present) {
      map['version_number'] = Variable<int>(versionNumber.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CostingSheetsCompanion(')
          ..write('id: $id, ')
          ..write('classificationId: $classificationId, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('effectiveTo: $effectiveTo, ')
          ..write('isActive: $isActive, ')
          ..write('versionNumber: $versionNumber, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DamageWorkflowHistoriesTable extends DamageWorkflowHistories
    with TableInfo<$DamageWorkflowHistoriesTable, DamageWorkflowHistoryLocal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DamageWorkflowHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _damageReportIdMeta = const VerificationMeta(
    'damageReportId',
  );
  @override
  late final GeneratedColumn<String> damageReportId = GeneratedColumn<String>(
    'damage_report_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromStatusMeta = const VerificationMeta(
    'fromStatus',
  );
  @override
  late final GeneratedColumn<String> fromStatus = GeneratedColumn<String>(
    'from_status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toStatusMeta = const VerificationMeta(
    'toStatus',
  );
  @override
  late final GeneratedColumn<String> toStatus = GeneratedColumn<String>(
    'to_status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changedByUserIdMeta = const VerificationMeta(
    'changedByUserId',
  );
  @override
  late final GeneratedColumn<String> changedByUserId = GeneratedColumn<String>(
    'changed_by_user_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 500),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOverrideMeta = const VerificationMeta(
    'isOverride',
  );
  @override
  late final GeneratedColumn<bool> isOverride = GeneratedColumn<bool>(
    'is_override',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_override" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    damageReportId,
    fromStatus,
    toStatus,
    changedByUserId,
    changedAt,
    comment,
    isOverride,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'damage_workflow_histories';
  @override
  VerificationContext validateIntegrity(
    Insertable<DamageWorkflowHistoryLocal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('damage_report_id')) {
      context.handle(
        _damageReportIdMeta,
        damageReportId.isAcceptableOrUnknown(
          data['damage_report_id']!,
          _damageReportIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_damageReportIdMeta);
    }
    if (data.containsKey('from_status')) {
      context.handle(
        _fromStatusMeta,
        fromStatus.isAcceptableOrUnknown(data['from_status']!, _fromStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_fromStatusMeta);
    }
    if (data.containsKey('to_status')) {
      context.handle(
        _toStatusMeta,
        toStatus.isAcceptableOrUnknown(data['to_status']!, _toStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_toStatusMeta);
    }
    if (data.containsKey('changed_by_user_id')) {
      context.handle(
        _changedByUserIdMeta,
        changedByUserId.isAcceptableOrUnknown(
          data['changed_by_user_id']!,
          _changedByUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_changedByUserIdMeta);
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('is_override')) {
      context.handle(
        _isOverrideMeta,
        isOverride.isAcceptableOrUnknown(data['is_override']!, _isOverrideMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DamageWorkflowHistoryLocal map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DamageWorkflowHistoryLocal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      damageReportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}damage_report_id'],
      )!,
      fromStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_status'],
      )!,
      toStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_status'],
      )!,
      changedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}changed_by_user_id'],
      )!,
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}changed_at'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      isOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_override'],
      )!,
    );
  }

  @override
  $DamageWorkflowHistoriesTable createAlias(String alias) {
    return $DamageWorkflowHistoriesTable(attachedDatabase, alias);
  }
}

class DamageWorkflowHistoryLocal extends DataClass
    implements Insertable<DamageWorkflowHistoryLocal> {
  final String id;
  final String? serverId;
  final String damageReportId;
  final String fromStatus;
  final String toStatus;
  final String changedByUserId;
  final DateTime changedAt;
  final String? comment;
  final bool isOverride;
  const DamageWorkflowHistoryLocal({
    required this.id,
    this.serverId,
    required this.damageReportId,
    required this.fromStatus,
    required this.toStatus,
    required this.changedByUserId,
    required this.changedAt,
    this.comment,
    required this.isOverride,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['damage_report_id'] = Variable<String>(damageReportId);
    map['from_status'] = Variable<String>(fromStatus);
    map['to_status'] = Variable<String>(toStatus);
    map['changed_by_user_id'] = Variable<String>(changedByUserId);
    map['changed_at'] = Variable<DateTime>(changedAt);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['is_override'] = Variable<bool>(isOverride);
    return map;
  }

  DamageWorkflowHistoriesCompanion toCompanion(bool nullToAbsent) {
    return DamageWorkflowHistoriesCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      damageReportId: Value(damageReportId),
      fromStatus: Value(fromStatus),
      toStatus: Value(toStatus),
      changedByUserId: Value(changedByUserId),
      changedAt: Value(changedAt),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      isOverride: Value(isOverride),
    );
  }

  factory DamageWorkflowHistoryLocal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DamageWorkflowHistoryLocal(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      damageReportId: serializer.fromJson<String>(json['damageReportId']),
      fromStatus: serializer.fromJson<String>(json['fromStatus']),
      toStatus: serializer.fromJson<String>(json['toStatus']),
      changedByUserId: serializer.fromJson<String>(json['changedByUserId']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
      comment: serializer.fromJson<String?>(json['comment']),
      isOverride: serializer.fromJson<bool>(json['isOverride']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'damageReportId': serializer.toJson<String>(damageReportId),
      'fromStatus': serializer.toJson<String>(fromStatus),
      'toStatus': serializer.toJson<String>(toStatus),
      'changedByUserId': serializer.toJson<String>(changedByUserId),
      'changedAt': serializer.toJson<DateTime>(changedAt),
      'comment': serializer.toJson<String?>(comment),
      'isOverride': serializer.toJson<bool>(isOverride),
    };
  }

  DamageWorkflowHistoryLocal copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? damageReportId,
    String? fromStatus,
    String? toStatus,
    String? changedByUserId,
    DateTime? changedAt,
    Value<String?> comment = const Value.absent(),
    bool? isOverride,
  }) => DamageWorkflowHistoryLocal(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    damageReportId: damageReportId ?? this.damageReportId,
    fromStatus: fromStatus ?? this.fromStatus,
    toStatus: toStatus ?? this.toStatus,
    changedByUserId: changedByUserId ?? this.changedByUserId,
    changedAt: changedAt ?? this.changedAt,
    comment: comment.present ? comment.value : this.comment,
    isOverride: isOverride ?? this.isOverride,
  );
  DamageWorkflowHistoryLocal copyWithCompanion(
    DamageWorkflowHistoriesCompanion data,
  ) {
    return DamageWorkflowHistoryLocal(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      damageReportId: data.damageReportId.present
          ? data.damageReportId.value
          : this.damageReportId,
      fromStatus: data.fromStatus.present
          ? data.fromStatus.value
          : this.fromStatus,
      toStatus: data.toStatus.present ? data.toStatus.value : this.toStatus,
      changedByUserId: data.changedByUserId.present
          ? data.changedByUserId.value
          : this.changedByUserId,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
      comment: data.comment.present ? data.comment.value : this.comment,
      isOverride: data.isOverride.present
          ? data.isOverride.value
          : this.isOverride,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DamageWorkflowHistoryLocal(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('damageReportId: $damageReportId, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('changedByUserId: $changedByUserId, ')
          ..write('changedAt: $changedAt, ')
          ..write('comment: $comment, ')
          ..write('isOverride: $isOverride')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    damageReportId,
    fromStatus,
    toStatus,
    changedByUserId,
    changedAt,
    comment,
    isOverride,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DamageWorkflowHistoryLocal &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.damageReportId == this.damageReportId &&
          other.fromStatus == this.fromStatus &&
          other.toStatus == this.toStatus &&
          other.changedByUserId == this.changedByUserId &&
          other.changedAt == this.changedAt &&
          other.comment == this.comment &&
          other.isOverride == this.isOverride);
}

class DamageWorkflowHistoriesCompanion
    extends UpdateCompanion<DamageWorkflowHistoryLocal> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> damageReportId;
  final Value<String> fromStatus;
  final Value<String> toStatus;
  final Value<String> changedByUserId;
  final Value<DateTime> changedAt;
  final Value<String?> comment;
  final Value<bool> isOverride;
  final Value<int> rowid;
  const DamageWorkflowHistoriesCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.damageReportId = const Value.absent(),
    this.fromStatus = const Value.absent(),
    this.toStatus = const Value.absent(),
    this.changedByUserId = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.comment = const Value.absent(),
    this.isOverride = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DamageWorkflowHistoriesCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String damageReportId,
    required String fromStatus,
    required String toStatus,
    required String changedByUserId,
    required DateTime changedAt,
    this.comment = const Value.absent(),
    this.isOverride = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       damageReportId = Value(damageReportId),
       fromStatus = Value(fromStatus),
       toStatus = Value(toStatus),
       changedByUserId = Value(changedByUserId),
       changedAt = Value(changedAt);
  static Insertable<DamageWorkflowHistoryLocal> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? damageReportId,
    Expression<String>? fromStatus,
    Expression<String>? toStatus,
    Expression<String>? changedByUserId,
    Expression<DateTime>? changedAt,
    Expression<String>? comment,
    Expression<bool>? isOverride,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (damageReportId != null) 'damage_report_id': damageReportId,
      if (fromStatus != null) 'from_status': fromStatus,
      if (toStatus != null) 'to_status': toStatus,
      if (changedByUserId != null) 'changed_by_user_id': changedByUserId,
      if (changedAt != null) 'changed_at': changedAt,
      if (comment != null) 'comment': comment,
      if (isOverride != null) 'is_override': isOverride,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DamageWorkflowHistoriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? damageReportId,
    Value<String>? fromStatus,
    Value<String>? toStatus,
    Value<String>? changedByUserId,
    Value<DateTime>? changedAt,
    Value<String?>? comment,
    Value<bool>? isOverride,
    Value<int>? rowid,
  }) {
    return DamageWorkflowHistoriesCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      damageReportId: damageReportId ?? this.damageReportId,
      fromStatus: fromStatus ?? this.fromStatus,
      toStatus: toStatus ?? this.toStatus,
      changedByUserId: changedByUserId ?? this.changedByUserId,
      changedAt: changedAt ?? this.changedAt,
      comment: comment ?? this.comment,
      isOverride: isOverride ?? this.isOverride,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (damageReportId.present) {
      map['damage_report_id'] = Variable<String>(damageReportId.value);
    }
    if (fromStatus.present) {
      map['from_status'] = Variable<String>(fromStatus.value);
    }
    if (toStatus.present) {
      map['to_status'] = Variable<String>(toStatus.value);
    }
    if (changedByUserId.present) {
      map['changed_by_user_id'] = Variable<String>(changedByUserId.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (isOverride.present) {
      map['is_override'] = Variable<bool>(isOverride.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DamageWorkflowHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('damageReportId: $damageReportId, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('changedByUserId: $changedByUserId, ')
          ..write('changedAt: $changedAt, ')
          ..write('comment: $comment, ')
          ..write('isOverride: $isOverride, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FarmersTable farmers = $FarmersTable(this);
  late final $FarmsTable farms = $FarmsTable(this);
  late final $DamageReportsTable damageReports = $DamageReportsTable(this);
  late final $DamageItemsTable damageItems = $DamageItemsTable(this);
  late final $DamageReportAttachmentsTable damageReportAttachments =
      $DamageReportAttachmentsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $OwnershipTypesTable ownershipTypes = $OwnershipTypesTable(this);
  late final $AgriculturalSectorsTable agriculturalSectors =
      $AgriculturalSectorsTable(this);
  late final $PoliticalClassificationsTable politicalClassifications =
      $PoliticalClassificationsTable(this);
  late final $AreaUnitsTable areaUnits = $AreaUnitsTable(this);
  late final $RelationshipToOwnersTable relationshipToOwners =
      $RelationshipToOwnersTable(this);
  late final $GovernoratesTable governorates = $GovernoratesTable(this);
  late final $DirectoratesTable directorates = $DirectoratesTable(this);
  late final $LocalitiesTable localities = $LocalitiesTable(this);
  late final $DamageNaturesTable damageNatures = $DamageNaturesTable(this);
  late final $DamageCategoriesTable damageCategories = $DamageCategoriesTable(
    this,
  );
  late final $DamageSubCategoriesTable damageSubCategories =
      $DamageSubCategoriesTable(this);
  late final $DamageClassificationsTable damageClassifications =
      $DamageClassificationsTable(this);
  late final $DamageCauseCategoriesTable damageCauseCategories =
      $DamageCauseCategoriesTable(this);
  late final $DamageCausesTable damageCauses = $DamageCausesTable(this);
  late final $CostingSheetsTable costingSheets = $CostingSheetsTable(this);
  late final $DamageWorkflowHistoriesTable damageWorkflowHistories =
      $DamageWorkflowHistoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    farmers,
    farms,
    damageReports,
    damageItems,
    damageReportAttachments,
    syncQueue,
    ownershipTypes,
    agriculturalSectors,
    politicalClassifications,
    areaUnits,
    relationshipToOwners,
    governorates,
    directorates,
    localities,
    damageNatures,
    damageCategories,
    damageSubCategories,
    damageClassifications,
    damageCauseCategories,
    damageCauses,
    costingSheets,
    damageWorkflowHistories,
  ];
}

typedef $$FarmersTableCreateCompanionBuilder =
    FarmersCompanion Function({
      required String id,
      Value<String?> serverId,
      Value<int> idTypeId,
      Value<String> idNumber,
      Value<String> firstNameAr,
      Value<String> fatherNameAr,
      Value<String> grandfatherNameAr,
      Value<String> familyNameAr,
      Value<String> firstNameEn,
      Value<String> fatherNameEn,
      Value<String> grandfatherNameEn,
      Value<String> familyNameEn,
      Value<DateTime?> birthDate,
      Value<int> gender,
      Value<String> phoneNumber,
      Value<int> familySize,
      Value<String> governorateId,
      Value<String> localityId,
      Value<String> address,
      Value<String> name,
      Value<String> nationalId,
      Value<String> rowVersion,
      Value<String> syncStatus,
      Value<String?> lastSyncError,
      Value<bool> isPendingDelete,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> deletedBy,
      Value<int> rowid,
    });
typedef $$FarmersTableUpdateCompanionBuilder =
    FarmersCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<int> idTypeId,
      Value<String> idNumber,
      Value<String> firstNameAr,
      Value<String> fatherNameAr,
      Value<String> grandfatherNameAr,
      Value<String> familyNameAr,
      Value<String> firstNameEn,
      Value<String> fatherNameEn,
      Value<String> grandfatherNameEn,
      Value<String> familyNameEn,
      Value<DateTime?> birthDate,
      Value<int> gender,
      Value<String> phoneNumber,
      Value<int> familySize,
      Value<String> governorateId,
      Value<String> localityId,
      Value<String> address,
      Value<String> name,
      Value<String> nationalId,
      Value<String> rowVersion,
      Value<String> syncStatus,
      Value<String?> lastSyncError,
      Value<bool> isPendingDelete,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> deletedBy,
      Value<int> rowid,
    });

class $$FarmersTableFilterComposer
    extends Composer<_$AppDatabase, $FarmersTable> {
  $$FarmersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idTypeId => $composableBuilder(
    column: $table.idTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstNameAr => $composableBuilder(
    column: $table.firstNameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fatherNameAr => $composableBuilder(
    column: $table.fatherNameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grandfatherNameAr => $composableBuilder(
    column: $table.grandfatherNameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyNameAr => $composableBuilder(
    column: $table.familyNameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstNameEn => $composableBuilder(
    column: $table.firstNameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fatherNameEn => $composableBuilder(
    column: $table.fatherNameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grandfatherNameEn => $composableBuilder(
    column: $table.grandfatherNameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyNameEn => $composableBuilder(
    column: $table.familyNameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get familySize => $composableBuilder(
    column: $table.familySize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nationalId => $composableBuilder(
    column: $table.nationalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowVersion => $composableBuilder(
    column: $table.rowVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedBy => $composableBuilder(
    column: $table.deletedBy,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FarmersTableOrderingComposer
    extends Composer<_$AppDatabase, $FarmersTable> {
  $$FarmersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idTypeId => $composableBuilder(
    column: $table.idTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstNameAr => $composableBuilder(
    column: $table.firstNameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fatherNameAr => $composableBuilder(
    column: $table.fatherNameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grandfatherNameAr => $composableBuilder(
    column: $table.grandfatherNameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyNameAr => $composableBuilder(
    column: $table.familyNameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstNameEn => $composableBuilder(
    column: $table.firstNameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fatherNameEn => $composableBuilder(
    column: $table.fatherNameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grandfatherNameEn => $composableBuilder(
    column: $table.grandfatherNameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyNameEn => $composableBuilder(
    column: $table.familyNameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get familySize => $composableBuilder(
    column: $table.familySize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nationalId => $composableBuilder(
    column: $table.nationalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowVersion => $composableBuilder(
    column: $table.rowVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedBy => $composableBuilder(
    column: $table.deletedBy,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FarmersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FarmersTable> {
  $$FarmersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get idTypeId =>
      $composableBuilder(column: $table.idTypeId, builder: (column) => column);

  GeneratedColumn<String> get idNumber =>
      $composableBuilder(column: $table.idNumber, builder: (column) => column);

  GeneratedColumn<String> get firstNameAr => $composableBuilder(
    column: $table.firstNameAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fatherNameAr => $composableBuilder(
    column: $table.fatherNameAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get grandfatherNameAr => $composableBuilder(
    column: $table.grandfatherNameAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get familyNameAr => $composableBuilder(
    column: $table.familyNameAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstNameEn => $composableBuilder(
    column: $table.firstNameEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fatherNameEn => $composableBuilder(
    column: $table.fatherNameEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get grandfatherNameEn => $composableBuilder(
    column: $table.grandfatherNameEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get familyNameEn => $composableBuilder(
    column: $table.familyNameEn,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<int> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get familySize => $composableBuilder(
    column: $table.familySize,
    builder: (column) => column,
  );

  GeneratedColumn<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nationalId => $composableBuilder(
    column: $table.nationalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rowVersion => $composableBuilder(
    column: $table.rowVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $$FarmersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FarmersTable,
          FarmerLocal,
          $$FarmersTableFilterComposer,
          $$FarmersTableOrderingComposer,
          $$FarmersTableAnnotationComposer,
          $$FarmersTableCreateCompanionBuilder,
          $$FarmersTableUpdateCompanionBuilder,
          (
            FarmerLocal,
            BaseReferences<_$AppDatabase, $FarmersTable, FarmerLocal>,
          ),
          FarmerLocal,
          PrefetchHooks Function()
        > {
  $$FarmersTableTableManager(_$AppDatabase db, $FarmersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FarmersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FarmersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FarmersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<int> idTypeId = const Value.absent(),
                Value<String> idNumber = const Value.absent(),
                Value<String> firstNameAr = const Value.absent(),
                Value<String> fatherNameAr = const Value.absent(),
                Value<String> grandfatherNameAr = const Value.absent(),
                Value<String> familyNameAr = const Value.absent(),
                Value<String> firstNameEn = const Value.absent(),
                Value<String> fatherNameEn = const Value.absent(),
                Value<String> grandfatherNameEn = const Value.absent(),
                Value<String> familyNameEn = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<int> gender = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<int> familySize = const Value.absent(),
                Value<String> governorateId = const Value.absent(),
                Value<String> localityId = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nationalId = const Value.absent(),
                Value<String> rowVersion = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastSyncError = const Value.absent(),
                Value<bool> isPendingDelete = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deletedBy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FarmersCompanion(
                id: id,
                serverId: serverId,
                idTypeId: idTypeId,
                idNumber: idNumber,
                firstNameAr: firstNameAr,
                fatherNameAr: fatherNameAr,
                grandfatherNameAr: grandfatherNameAr,
                familyNameAr: familyNameAr,
                firstNameEn: firstNameEn,
                fatherNameEn: fatherNameEn,
                grandfatherNameEn: grandfatherNameEn,
                familyNameEn: familyNameEn,
                birthDate: birthDate,
                gender: gender,
                phoneNumber: phoneNumber,
                familySize: familySize,
                governorateId: governorateId,
                localityId: localityId,
                address: address,
                name: name,
                nationalId: nationalId,
                rowVersion: rowVersion,
                syncStatus: syncStatus,
                lastSyncError: lastSyncError,
                isPendingDelete: isPendingDelete,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deletedBy: deletedBy,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                Value<int> idTypeId = const Value.absent(),
                Value<String> idNumber = const Value.absent(),
                Value<String> firstNameAr = const Value.absent(),
                Value<String> fatherNameAr = const Value.absent(),
                Value<String> grandfatherNameAr = const Value.absent(),
                Value<String> familyNameAr = const Value.absent(),
                Value<String> firstNameEn = const Value.absent(),
                Value<String> fatherNameEn = const Value.absent(),
                Value<String> grandfatherNameEn = const Value.absent(),
                Value<String> familyNameEn = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<int> gender = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<int> familySize = const Value.absent(),
                Value<String> governorateId = const Value.absent(),
                Value<String> localityId = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nationalId = const Value.absent(),
                Value<String> rowVersion = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastSyncError = const Value.absent(),
                Value<bool> isPendingDelete = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deletedBy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FarmersCompanion.insert(
                id: id,
                serverId: serverId,
                idTypeId: idTypeId,
                idNumber: idNumber,
                firstNameAr: firstNameAr,
                fatherNameAr: fatherNameAr,
                grandfatherNameAr: grandfatherNameAr,
                familyNameAr: familyNameAr,
                firstNameEn: firstNameEn,
                fatherNameEn: fatherNameEn,
                grandfatherNameEn: grandfatherNameEn,
                familyNameEn: familyNameEn,
                birthDate: birthDate,
                gender: gender,
                phoneNumber: phoneNumber,
                familySize: familySize,
                governorateId: governorateId,
                localityId: localityId,
                address: address,
                name: name,
                nationalId: nationalId,
                rowVersion: rowVersion,
                syncStatus: syncStatus,
                lastSyncError: lastSyncError,
                isPendingDelete: isPendingDelete,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deletedBy: deletedBy,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FarmersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FarmersTable,
      FarmerLocal,
      $$FarmersTableFilterComposer,
      $$FarmersTableOrderingComposer,
      $$FarmersTableAnnotationComposer,
      $$FarmersTableCreateCompanionBuilder,
      $$FarmersTableUpdateCompanionBuilder,
      (FarmerLocal, BaseReferences<_$AppDatabase, $FarmersTable, FarmerLocal>),
      FarmerLocal,
      PrefetchHooks Function()
    >;
typedef $$FarmsTableCreateCompanionBuilder =
    FarmsCompanion Function({
      required String id,
      Value<String?> serverId,
      required String farmerId,
      Value<String?> ownerFarmerId,
      required String localFarmName,
      Value<int> ownershipTypeId,
      Value<int?> relationshipToOwnerId,
      required String governorateId,
      required String directorateId,
      required String localityId,
      required String basin,
      required String parcel,
      required double area,
      Value<int> areaUnitId,
      Value<int> agriculturalSectorId,
      Value<int> politicalClassificationId,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> notes,
      Value<String> rowVersion,
      Value<String> syncStatus,
      Value<String?> lastSyncError,
      Value<bool> isPendingDelete,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$FarmsTableUpdateCompanionBuilder =
    FarmsCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> farmerId,
      Value<String?> ownerFarmerId,
      Value<String> localFarmName,
      Value<int> ownershipTypeId,
      Value<int?> relationshipToOwnerId,
      Value<String> governorateId,
      Value<String> directorateId,
      Value<String> localityId,
      Value<String> basin,
      Value<String> parcel,
      Value<double> area,
      Value<int> areaUnitId,
      Value<int> agriculturalSectorId,
      Value<int> politicalClassificationId,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> notes,
      Value<String> rowVersion,
      Value<String> syncStatus,
      Value<String?> lastSyncError,
      Value<bool> isPendingDelete,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$FarmsTableFilterComposer extends Composer<_$AppDatabase, $FarmsTable> {
  $$FarmsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get farmerId => $composableBuilder(
    column: $table.farmerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerFarmerId => $composableBuilder(
    column: $table.ownerFarmerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localFarmName => $composableBuilder(
    column: $table.localFarmName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ownershipTypeId => $composableBuilder(
    column: $table.ownershipTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get relationshipToOwnerId => $composableBuilder(
    column: $table.relationshipToOwnerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get directorateId => $composableBuilder(
    column: $table.directorateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get basin => $composableBuilder(
    column: $table.basin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parcel => $composableBuilder(
    column: $table.parcel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get areaUnitId => $composableBuilder(
    column: $table.areaUnitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get agriculturalSectorId => $composableBuilder(
    column: $table.agriculturalSectorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get politicalClassificationId => $composableBuilder(
    column: $table.politicalClassificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowVersion => $composableBuilder(
    column: $table.rowVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FarmsTableOrderingComposer
    extends Composer<_$AppDatabase, $FarmsTable> {
  $$FarmsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get farmerId => $composableBuilder(
    column: $table.farmerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerFarmerId => $composableBuilder(
    column: $table.ownerFarmerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localFarmName => $composableBuilder(
    column: $table.localFarmName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ownershipTypeId => $composableBuilder(
    column: $table.ownershipTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get relationshipToOwnerId => $composableBuilder(
    column: $table.relationshipToOwnerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get directorateId => $composableBuilder(
    column: $table.directorateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get basin => $composableBuilder(
    column: $table.basin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parcel => $composableBuilder(
    column: $table.parcel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get areaUnitId => $composableBuilder(
    column: $table.areaUnitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get agriculturalSectorId => $composableBuilder(
    column: $table.agriculturalSectorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get politicalClassificationId => $composableBuilder(
    column: $table.politicalClassificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowVersion => $composableBuilder(
    column: $table.rowVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FarmsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FarmsTable> {
  $$FarmsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get farmerId =>
      $composableBuilder(column: $table.farmerId, builder: (column) => column);

  GeneratedColumn<String> get ownerFarmerId => $composableBuilder(
    column: $table.ownerFarmerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localFarmName => $composableBuilder(
    column: $table.localFarmName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ownershipTypeId => $composableBuilder(
    column: $table.ownershipTypeId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get relationshipToOwnerId => $composableBuilder(
    column: $table.relationshipToOwnerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get directorateId => $composableBuilder(
    column: $table.directorateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get basin =>
      $composableBuilder(column: $table.basin, builder: (column) => column);

  GeneratedColumn<String> get parcel =>
      $composableBuilder(column: $table.parcel, builder: (column) => column);

  GeneratedColumn<double> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<int> get areaUnitId => $composableBuilder(
    column: $table.areaUnitId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get agriculturalSectorId => $composableBuilder(
    column: $table.agriculturalSectorId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get politicalClassificationId => $composableBuilder(
    column: $table.politicalClassificationId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get rowVersion => $composableBuilder(
    column: $table.rowVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FarmsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FarmsTable,
          FarmLocal,
          $$FarmsTableFilterComposer,
          $$FarmsTableOrderingComposer,
          $$FarmsTableAnnotationComposer,
          $$FarmsTableCreateCompanionBuilder,
          $$FarmsTableUpdateCompanionBuilder,
          (FarmLocal, BaseReferences<_$AppDatabase, $FarmsTable, FarmLocal>),
          FarmLocal,
          PrefetchHooks Function()
        > {
  $$FarmsTableTableManager(_$AppDatabase db, $FarmsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FarmsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FarmsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FarmsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> farmerId = const Value.absent(),
                Value<String?> ownerFarmerId = const Value.absent(),
                Value<String> localFarmName = const Value.absent(),
                Value<int> ownershipTypeId = const Value.absent(),
                Value<int?> relationshipToOwnerId = const Value.absent(),
                Value<String> governorateId = const Value.absent(),
                Value<String> directorateId = const Value.absent(),
                Value<String> localityId = const Value.absent(),
                Value<String> basin = const Value.absent(),
                Value<String> parcel = const Value.absent(),
                Value<double> area = const Value.absent(),
                Value<int> areaUnitId = const Value.absent(),
                Value<int> agriculturalSectorId = const Value.absent(),
                Value<int> politicalClassificationId = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> rowVersion = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastSyncError = const Value.absent(),
                Value<bool> isPendingDelete = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FarmsCompanion(
                id: id,
                serverId: serverId,
                farmerId: farmerId,
                ownerFarmerId: ownerFarmerId,
                localFarmName: localFarmName,
                ownershipTypeId: ownershipTypeId,
                relationshipToOwnerId: relationshipToOwnerId,
                governorateId: governorateId,
                directorateId: directorateId,
                localityId: localityId,
                basin: basin,
                parcel: parcel,
                area: area,
                areaUnitId: areaUnitId,
                agriculturalSectorId: agriculturalSectorId,
                politicalClassificationId: politicalClassificationId,
                latitude: latitude,
                longitude: longitude,
                notes: notes,
                rowVersion: rowVersion,
                syncStatus: syncStatus,
                lastSyncError: lastSyncError,
                isPendingDelete: isPendingDelete,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String farmerId,
                Value<String?> ownerFarmerId = const Value.absent(),
                required String localFarmName,
                Value<int> ownershipTypeId = const Value.absent(),
                Value<int?> relationshipToOwnerId = const Value.absent(),
                required String governorateId,
                required String directorateId,
                required String localityId,
                required String basin,
                required String parcel,
                required double area,
                Value<int> areaUnitId = const Value.absent(),
                Value<int> agriculturalSectorId = const Value.absent(),
                Value<int> politicalClassificationId = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> rowVersion = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastSyncError = const Value.absent(),
                Value<bool> isPendingDelete = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FarmsCompanion.insert(
                id: id,
                serverId: serverId,
                farmerId: farmerId,
                ownerFarmerId: ownerFarmerId,
                localFarmName: localFarmName,
                ownershipTypeId: ownershipTypeId,
                relationshipToOwnerId: relationshipToOwnerId,
                governorateId: governorateId,
                directorateId: directorateId,
                localityId: localityId,
                basin: basin,
                parcel: parcel,
                area: area,
                areaUnitId: areaUnitId,
                agriculturalSectorId: agriculturalSectorId,
                politicalClassificationId: politicalClassificationId,
                latitude: latitude,
                longitude: longitude,
                notes: notes,
                rowVersion: rowVersion,
                syncStatus: syncStatus,
                lastSyncError: lastSyncError,
                isPendingDelete: isPendingDelete,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FarmsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FarmsTable,
      FarmLocal,
      $$FarmsTableFilterComposer,
      $$FarmsTableOrderingComposer,
      $$FarmsTableAnnotationComposer,
      $$FarmsTableCreateCompanionBuilder,
      $$FarmsTableUpdateCompanionBuilder,
      (FarmLocal, BaseReferences<_$AppDatabase, $FarmsTable, FarmLocal>),
      FarmLocal,
      PrefetchHooks Function()
    >;
typedef $$DamageReportsTableCreateCompanionBuilder =
    DamageReportsCompanion Function({
      required String id,
      Value<String?> serverId,
      Value<String> permanentFormNumber,
      Value<String> temporaryFormNumber,
      Value<int> damageYear,
      required String farmId,
      required String farmerId,
      required DateTime damageDate,
      required DateTime documentationDate,
      Value<int> damageCauseCategoryId,
      Value<int> damageCauseId,
      Value<String?> settlementName,
      Value<String?> companyName,
      required String governorateId,
      required String localityId,
      Value<double?> latitude,
      Value<double?> longitude,
      required String statusId,
      required String notes,
      Value<String> rowVersion,
      Value<String> syncStatus,
      Value<String?> lastSyncError,
      Value<bool> isPendingDelete,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$DamageReportsTableUpdateCompanionBuilder =
    DamageReportsCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> permanentFormNumber,
      Value<String> temporaryFormNumber,
      Value<int> damageYear,
      Value<String> farmId,
      Value<String> farmerId,
      Value<DateTime> damageDate,
      Value<DateTime> documentationDate,
      Value<int> damageCauseCategoryId,
      Value<int> damageCauseId,
      Value<String?> settlementName,
      Value<String?> companyName,
      Value<String> governorateId,
      Value<String> localityId,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String> statusId,
      Value<String> notes,
      Value<String> rowVersion,
      Value<String> syncStatus,
      Value<String?> lastSyncError,
      Value<bool> isPendingDelete,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$DamageReportsTableFilterComposer
    extends Composer<_$AppDatabase, $DamageReportsTable> {
  $$DamageReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permanentFormNumber => $composableBuilder(
    column: $table.permanentFormNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get temporaryFormNumber => $composableBuilder(
    column: $table.temporaryFormNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get damageYear => $composableBuilder(
    column: $table.damageYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get farmId => $composableBuilder(
    column: $table.farmId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get farmerId => $composableBuilder(
    column: $table.farmerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get damageDate => $composableBuilder(
    column: $table.damageDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get documentationDate => $composableBuilder(
    column: $table.documentationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get damageCauseCategoryId => $composableBuilder(
    column: $table.damageCauseCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get damageCauseId => $composableBuilder(
    column: $table.damageCauseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settlementName => $composableBuilder(
    column: $table.settlementName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statusId => $composableBuilder(
    column: $table.statusId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowVersion => $composableBuilder(
    column: $table.rowVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DamageReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $DamageReportsTable> {
  $$DamageReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permanentFormNumber => $composableBuilder(
    column: $table.permanentFormNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get temporaryFormNumber => $composableBuilder(
    column: $table.temporaryFormNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get damageYear => $composableBuilder(
    column: $table.damageYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get farmId => $composableBuilder(
    column: $table.farmId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get farmerId => $composableBuilder(
    column: $table.farmerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get damageDate => $composableBuilder(
    column: $table.damageDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get documentationDate => $composableBuilder(
    column: $table.documentationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get damageCauseCategoryId => $composableBuilder(
    column: $table.damageCauseCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get damageCauseId => $composableBuilder(
    column: $table.damageCauseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settlementName => $composableBuilder(
    column: $table.settlementName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statusId => $composableBuilder(
    column: $table.statusId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowVersion => $composableBuilder(
    column: $table.rowVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DamageReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DamageReportsTable> {
  $$DamageReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get permanentFormNumber => $composableBuilder(
    column: $table.permanentFormNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get temporaryFormNumber => $composableBuilder(
    column: $table.temporaryFormNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get damageYear => $composableBuilder(
    column: $table.damageYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get farmerId =>
      $composableBuilder(column: $table.farmerId, builder: (column) => column);

  GeneratedColumn<DateTime> get damageDate => $composableBuilder(
    column: $table.damageDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get documentationDate => $composableBuilder(
    column: $table.documentationDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get damageCauseCategoryId => $composableBuilder(
    column: $table.damageCauseCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get damageCauseId => $composableBuilder(
    column: $table.damageCauseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settlementName => $composableBuilder(
    column: $table.settlementName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get statusId =>
      $composableBuilder(column: $table.statusId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get rowVersion => $composableBuilder(
    column: $table.rowVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DamageReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DamageReportsTable,
          DamageReportLocal,
          $$DamageReportsTableFilterComposer,
          $$DamageReportsTableOrderingComposer,
          $$DamageReportsTableAnnotationComposer,
          $$DamageReportsTableCreateCompanionBuilder,
          $$DamageReportsTableUpdateCompanionBuilder,
          (
            DamageReportLocal,
            BaseReferences<
              _$AppDatabase,
              $DamageReportsTable,
              DamageReportLocal
            >,
          ),
          DamageReportLocal,
          PrefetchHooks Function()
        > {
  $$DamageReportsTableTableManager(_$AppDatabase db, $DamageReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DamageReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DamageReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DamageReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> permanentFormNumber = const Value.absent(),
                Value<String> temporaryFormNumber = const Value.absent(),
                Value<int> damageYear = const Value.absent(),
                Value<String> farmId = const Value.absent(),
                Value<String> farmerId = const Value.absent(),
                Value<DateTime> damageDate = const Value.absent(),
                Value<DateTime> documentationDate = const Value.absent(),
                Value<int> damageCauseCategoryId = const Value.absent(),
                Value<int> damageCauseId = const Value.absent(),
                Value<String?> settlementName = const Value.absent(),
                Value<String?> companyName = const Value.absent(),
                Value<String> governorateId = const Value.absent(),
                Value<String> localityId = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String> statusId = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> rowVersion = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastSyncError = const Value.absent(),
                Value<bool> isPendingDelete = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DamageReportsCompanion(
                id: id,
                serverId: serverId,
                permanentFormNumber: permanentFormNumber,
                temporaryFormNumber: temporaryFormNumber,
                damageYear: damageYear,
                farmId: farmId,
                farmerId: farmerId,
                damageDate: damageDate,
                documentationDate: documentationDate,
                damageCauseCategoryId: damageCauseCategoryId,
                damageCauseId: damageCauseId,
                settlementName: settlementName,
                companyName: companyName,
                governorateId: governorateId,
                localityId: localityId,
                latitude: latitude,
                longitude: longitude,
                statusId: statusId,
                notes: notes,
                rowVersion: rowVersion,
                syncStatus: syncStatus,
                lastSyncError: lastSyncError,
                isPendingDelete: isPendingDelete,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                Value<String> permanentFormNumber = const Value.absent(),
                Value<String> temporaryFormNumber = const Value.absent(),
                Value<int> damageYear = const Value.absent(),
                required String farmId,
                required String farmerId,
                required DateTime damageDate,
                required DateTime documentationDate,
                Value<int> damageCauseCategoryId = const Value.absent(),
                Value<int> damageCauseId = const Value.absent(),
                Value<String?> settlementName = const Value.absent(),
                Value<String?> companyName = const Value.absent(),
                required String governorateId,
                required String localityId,
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                required String statusId,
                required String notes,
                Value<String> rowVersion = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastSyncError = const Value.absent(),
                Value<bool> isPendingDelete = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DamageReportsCompanion.insert(
                id: id,
                serverId: serverId,
                permanentFormNumber: permanentFormNumber,
                temporaryFormNumber: temporaryFormNumber,
                damageYear: damageYear,
                farmId: farmId,
                farmerId: farmerId,
                damageDate: damageDate,
                documentationDate: documentationDate,
                damageCauseCategoryId: damageCauseCategoryId,
                damageCauseId: damageCauseId,
                settlementName: settlementName,
                companyName: companyName,
                governorateId: governorateId,
                localityId: localityId,
                latitude: latitude,
                longitude: longitude,
                statusId: statusId,
                notes: notes,
                rowVersion: rowVersion,
                syncStatus: syncStatus,
                lastSyncError: lastSyncError,
                isPendingDelete: isPendingDelete,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DamageReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DamageReportsTable,
      DamageReportLocal,
      $$DamageReportsTableFilterComposer,
      $$DamageReportsTableOrderingComposer,
      $$DamageReportsTableAnnotationComposer,
      $$DamageReportsTableCreateCompanionBuilder,
      $$DamageReportsTableUpdateCompanionBuilder,
      (
        DamageReportLocal,
        BaseReferences<_$AppDatabase, $DamageReportsTable, DamageReportLocal>,
      ),
      DamageReportLocal,
      PrefetchHooks Function()
    >;
typedef $$DamageItemsTableCreateCompanionBuilder =
    DamageItemsCompanion Function({
      required String id,
      Value<String?> serverId,
      required String damageReportId,
      Value<int> classificationId,
      Value<String> costingSheetId,
      Value<double> calculatedUnitPrice,
      Value<String> measurementUnitSnapshot,
      required double affectedArea,
      required double damagePercentage,
      required double quantity,
      required double estimatedLoss,
      Value<String> rowVersion,
      Value<String> syncStatus,
      Value<String?> lastSyncError,
      Value<bool> isPendingDelete,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$DamageItemsTableUpdateCompanionBuilder =
    DamageItemsCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> damageReportId,
      Value<int> classificationId,
      Value<String> costingSheetId,
      Value<double> calculatedUnitPrice,
      Value<String> measurementUnitSnapshot,
      Value<double> affectedArea,
      Value<double> damagePercentage,
      Value<double> quantity,
      Value<double> estimatedLoss,
      Value<String> rowVersion,
      Value<String> syncStatus,
      Value<String?> lastSyncError,
      Value<bool> isPendingDelete,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$DamageItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DamageItemsTable> {
  $$DamageItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get damageReportId => $composableBuilder(
    column: $table.damageReportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get classificationId => $composableBuilder(
    column: $table.classificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get costingSheetId => $composableBuilder(
    column: $table.costingSheetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calculatedUnitPrice => $composableBuilder(
    column: $table.calculatedUnitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementUnitSnapshot => $composableBuilder(
    column: $table.measurementUnitSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get affectedArea => $composableBuilder(
    column: $table.affectedArea,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get damagePercentage => $composableBuilder(
    column: $table.damagePercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedLoss => $composableBuilder(
    column: $table.estimatedLoss,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowVersion => $composableBuilder(
    column: $table.rowVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DamageItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DamageItemsTable> {
  $$DamageItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get damageReportId => $composableBuilder(
    column: $table.damageReportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get classificationId => $composableBuilder(
    column: $table.classificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get costingSheetId => $composableBuilder(
    column: $table.costingSheetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calculatedUnitPrice => $composableBuilder(
    column: $table.calculatedUnitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementUnitSnapshot => $composableBuilder(
    column: $table.measurementUnitSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get affectedArea => $composableBuilder(
    column: $table.affectedArea,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get damagePercentage => $composableBuilder(
    column: $table.damagePercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedLoss => $composableBuilder(
    column: $table.estimatedLoss,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowVersion => $composableBuilder(
    column: $table.rowVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DamageItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DamageItemsTable> {
  $$DamageItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get damageReportId => $composableBuilder(
    column: $table.damageReportId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get classificationId => $composableBuilder(
    column: $table.classificationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get costingSheetId => $composableBuilder(
    column: $table.costingSheetId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get calculatedUnitPrice => $composableBuilder(
    column: $table.calculatedUnitPrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementUnitSnapshot => $composableBuilder(
    column: $table.measurementUnitSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<double> get affectedArea => $composableBuilder(
    column: $table.affectedArea,
    builder: (column) => column,
  );

  GeneratedColumn<double> get damagePercentage => $composableBuilder(
    column: $table.damagePercentage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get estimatedLoss => $composableBuilder(
    column: $table.estimatedLoss,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rowVersion => $composableBuilder(
    column: $table.rowVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DamageItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DamageItemsTable,
          DamageItemLocal,
          $$DamageItemsTableFilterComposer,
          $$DamageItemsTableOrderingComposer,
          $$DamageItemsTableAnnotationComposer,
          $$DamageItemsTableCreateCompanionBuilder,
          $$DamageItemsTableUpdateCompanionBuilder,
          (
            DamageItemLocal,
            BaseReferences<_$AppDatabase, $DamageItemsTable, DamageItemLocal>,
          ),
          DamageItemLocal,
          PrefetchHooks Function()
        > {
  $$DamageItemsTableTableManager(_$AppDatabase db, $DamageItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DamageItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DamageItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DamageItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> damageReportId = const Value.absent(),
                Value<int> classificationId = const Value.absent(),
                Value<String> costingSheetId = const Value.absent(),
                Value<double> calculatedUnitPrice = const Value.absent(),
                Value<String> measurementUnitSnapshot = const Value.absent(),
                Value<double> affectedArea = const Value.absent(),
                Value<double> damagePercentage = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> estimatedLoss = const Value.absent(),
                Value<String> rowVersion = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastSyncError = const Value.absent(),
                Value<bool> isPendingDelete = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DamageItemsCompanion(
                id: id,
                serverId: serverId,
                damageReportId: damageReportId,
                classificationId: classificationId,
                costingSheetId: costingSheetId,
                calculatedUnitPrice: calculatedUnitPrice,
                measurementUnitSnapshot: measurementUnitSnapshot,
                affectedArea: affectedArea,
                damagePercentage: damagePercentage,
                quantity: quantity,
                estimatedLoss: estimatedLoss,
                rowVersion: rowVersion,
                syncStatus: syncStatus,
                lastSyncError: lastSyncError,
                isPendingDelete: isPendingDelete,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String damageReportId,
                Value<int> classificationId = const Value.absent(),
                Value<String> costingSheetId = const Value.absent(),
                Value<double> calculatedUnitPrice = const Value.absent(),
                Value<String> measurementUnitSnapshot = const Value.absent(),
                required double affectedArea,
                required double damagePercentage,
                required double quantity,
                required double estimatedLoss,
                Value<String> rowVersion = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastSyncError = const Value.absent(),
                Value<bool> isPendingDelete = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DamageItemsCompanion.insert(
                id: id,
                serverId: serverId,
                damageReportId: damageReportId,
                classificationId: classificationId,
                costingSheetId: costingSheetId,
                calculatedUnitPrice: calculatedUnitPrice,
                measurementUnitSnapshot: measurementUnitSnapshot,
                affectedArea: affectedArea,
                damagePercentage: damagePercentage,
                quantity: quantity,
                estimatedLoss: estimatedLoss,
                rowVersion: rowVersion,
                syncStatus: syncStatus,
                lastSyncError: lastSyncError,
                isPendingDelete: isPendingDelete,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DamageItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DamageItemsTable,
      DamageItemLocal,
      $$DamageItemsTableFilterComposer,
      $$DamageItemsTableOrderingComposer,
      $$DamageItemsTableAnnotationComposer,
      $$DamageItemsTableCreateCompanionBuilder,
      $$DamageItemsTableUpdateCompanionBuilder,
      (
        DamageItemLocal,
        BaseReferences<_$AppDatabase, $DamageItemsTable, DamageItemLocal>,
      ),
      DamageItemLocal,
      PrefetchHooks Function()
    >;
typedef $$DamageReportAttachmentsTableCreateCompanionBuilder =
    DamageReportAttachmentsCompanion Function({
      required String id,
      Value<String?> serverId,
      required String damageReportId,
      required String localPath,
      Value<String?> remotePath,
      Value<String> uploadStatus,
      Value<String> syncStatus,
      Value<String?> lastSyncError,
      Value<bool> isPendingDelete,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$DamageReportAttachmentsTableUpdateCompanionBuilder =
    DamageReportAttachmentsCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> damageReportId,
      Value<String> localPath,
      Value<String?> remotePath,
      Value<String> uploadStatus,
      Value<String> syncStatus,
      Value<String?> lastSyncError,
      Value<bool> isPendingDelete,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$DamageReportAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $DamageReportAttachmentsTable> {
  $$DamageReportAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get damageReportId => $composableBuilder(
    column: $table.damageReportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DamageReportAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DamageReportAttachmentsTable> {
  $$DamageReportAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get damageReportId => $composableBuilder(
    column: $table.damageReportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DamageReportAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DamageReportAttachmentsTable> {
  $$DamageReportAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get damageReportId => $composableBuilder(
    column: $table.damageReportId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPendingDelete => $composableBuilder(
    column: $table.isPendingDelete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DamageReportAttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DamageReportAttachmentsTable,
          DamageReportAttachmentLocal,
          $$DamageReportAttachmentsTableFilterComposer,
          $$DamageReportAttachmentsTableOrderingComposer,
          $$DamageReportAttachmentsTableAnnotationComposer,
          $$DamageReportAttachmentsTableCreateCompanionBuilder,
          $$DamageReportAttachmentsTableUpdateCompanionBuilder,
          (
            DamageReportAttachmentLocal,
            BaseReferences<
              _$AppDatabase,
              $DamageReportAttachmentsTable,
              DamageReportAttachmentLocal
            >,
          ),
          DamageReportAttachmentLocal,
          PrefetchHooks Function()
        > {
  $$DamageReportAttachmentsTableTableManager(
    _$AppDatabase db,
    $DamageReportAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DamageReportAttachmentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DamageReportAttachmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DamageReportAttachmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> damageReportId = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String?> remotePath = const Value.absent(),
                Value<String> uploadStatus = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastSyncError = const Value.absent(),
                Value<bool> isPendingDelete = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DamageReportAttachmentsCompanion(
                id: id,
                serverId: serverId,
                damageReportId: damageReportId,
                localPath: localPath,
                remotePath: remotePath,
                uploadStatus: uploadStatus,
                syncStatus: syncStatus,
                lastSyncError: lastSyncError,
                isPendingDelete: isPendingDelete,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String damageReportId,
                required String localPath,
                Value<String?> remotePath = const Value.absent(),
                Value<String> uploadStatus = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastSyncError = const Value.absent(),
                Value<bool> isPendingDelete = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DamageReportAttachmentsCompanion.insert(
                id: id,
                serverId: serverId,
                damageReportId: damageReportId,
                localPath: localPath,
                remotePath: remotePath,
                uploadStatus: uploadStatus,
                syncStatus: syncStatus,
                lastSyncError: lastSyncError,
                isPendingDelete: isPendingDelete,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DamageReportAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DamageReportAttachmentsTable,
      DamageReportAttachmentLocal,
      $$DamageReportAttachmentsTableFilterComposer,
      $$DamageReportAttachmentsTableOrderingComposer,
      $$DamageReportAttachmentsTableAnnotationComposer,
      $$DamageReportAttachmentsTableCreateCompanionBuilder,
      $$DamageReportAttachmentsTableUpdateCompanionBuilder,
      (
        DamageReportAttachmentLocal,
        BaseReferences<
          _$AppDatabase,
          $DamageReportAttachmentsTable,
          DamageReportAttachmentLocal
        >,
      ),
      DamageReportAttachmentLocal,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      required String id,
      required String localId,
      required String entityType,
      required String operation,
      required String data,
      Value<String> status,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<DateTime?> lastAttemptAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<String> id,
      Value<String> localId,
      Value<String> entityType,
      Value<String> operation,
      Value<String> data,
      Value<String> status,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<DateTime?> lastAttemptAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> localId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                localId: localId,
                entityType: entityType,
                operation: operation,
                data: data,
                status: status,
                retryCount: retryCount,
                lastError: lastError,
                lastAttemptAt: lastAttemptAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String localId,
                required String entityType,
                required String operation,
                required String data,
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                localId: localId,
                entityType: entityType,
                operation: operation,
                data: data,
                status: status,
                retryCount: retryCount,
                lastError: lastError,
                lastAttemptAt: lastAttemptAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$OwnershipTypesTableCreateCompanionBuilder =
    OwnershipTypesCompanion Function({
      Value<int> id,
      required String nameAr,
      required String nameEn,
    });
typedef $$OwnershipTypesTableUpdateCompanionBuilder =
    OwnershipTypesCompanion Function({
      Value<int> id,
      Value<String> nameAr,
      Value<String> nameEn,
    });

class $$OwnershipTypesTableFilterComposer
    extends Composer<_$AppDatabase, $OwnershipTypesTable> {
  $$OwnershipTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OwnershipTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $OwnershipTypesTable> {
  $$OwnershipTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OwnershipTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OwnershipTypesTable> {
  $$OwnershipTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);
}

class $$OwnershipTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OwnershipTypesTable,
          OwnershipType,
          $$OwnershipTypesTableFilterComposer,
          $$OwnershipTypesTableOrderingComposer,
          $$OwnershipTypesTableAnnotationComposer,
          $$OwnershipTypesTableCreateCompanionBuilder,
          $$OwnershipTypesTableUpdateCompanionBuilder,
          (
            OwnershipType,
            BaseReferences<_$AppDatabase, $OwnershipTypesTable, OwnershipType>,
          ),
          OwnershipType,
          PrefetchHooks Function()
        > {
  $$OwnershipTypesTableTableManager(
    _$AppDatabase db,
    $OwnershipTypesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OwnershipTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OwnershipTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OwnershipTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
              }) => OwnershipTypesCompanion(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameAr,
                required String nameEn,
              }) => OwnershipTypesCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OwnershipTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OwnershipTypesTable,
      OwnershipType,
      $$OwnershipTypesTableFilterComposer,
      $$OwnershipTypesTableOrderingComposer,
      $$OwnershipTypesTableAnnotationComposer,
      $$OwnershipTypesTableCreateCompanionBuilder,
      $$OwnershipTypesTableUpdateCompanionBuilder,
      (
        OwnershipType,
        BaseReferences<_$AppDatabase, $OwnershipTypesTable, OwnershipType>,
      ),
      OwnershipType,
      PrefetchHooks Function()
    >;
typedef $$AgriculturalSectorsTableCreateCompanionBuilder =
    AgriculturalSectorsCompanion Function({
      Value<int> id,
      required String nameAr,
      required String nameEn,
    });
typedef $$AgriculturalSectorsTableUpdateCompanionBuilder =
    AgriculturalSectorsCompanion Function({
      Value<int> id,
      Value<String> nameAr,
      Value<String> nameEn,
    });

class $$AgriculturalSectorsTableFilterComposer
    extends Composer<_$AppDatabase, $AgriculturalSectorsTable> {
  $$AgriculturalSectorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AgriculturalSectorsTableOrderingComposer
    extends Composer<_$AppDatabase, $AgriculturalSectorsTable> {
  $$AgriculturalSectorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AgriculturalSectorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AgriculturalSectorsTable> {
  $$AgriculturalSectorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);
}

class $$AgriculturalSectorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AgriculturalSectorsTable,
          AgriculturalSector,
          $$AgriculturalSectorsTableFilterComposer,
          $$AgriculturalSectorsTableOrderingComposer,
          $$AgriculturalSectorsTableAnnotationComposer,
          $$AgriculturalSectorsTableCreateCompanionBuilder,
          $$AgriculturalSectorsTableUpdateCompanionBuilder,
          (
            AgriculturalSector,
            BaseReferences<
              _$AppDatabase,
              $AgriculturalSectorsTable,
              AgriculturalSector
            >,
          ),
          AgriculturalSector,
          PrefetchHooks Function()
        > {
  $$AgriculturalSectorsTableTableManager(
    _$AppDatabase db,
    $AgriculturalSectorsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AgriculturalSectorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AgriculturalSectorsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AgriculturalSectorsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
              }) => AgriculturalSectorsCompanion(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameAr,
                required String nameEn,
              }) => AgriculturalSectorsCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AgriculturalSectorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AgriculturalSectorsTable,
      AgriculturalSector,
      $$AgriculturalSectorsTableFilterComposer,
      $$AgriculturalSectorsTableOrderingComposer,
      $$AgriculturalSectorsTableAnnotationComposer,
      $$AgriculturalSectorsTableCreateCompanionBuilder,
      $$AgriculturalSectorsTableUpdateCompanionBuilder,
      (
        AgriculturalSector,
        BaseReferences<
          _$AppDatabase,
          $AgriculturalSectorsTable,
          AgriculturalSector
        >,
      ),
      AgriculturalSector,
      PrefetchHooks Function()
    >;
typedef $$PoliticalClassificationsTableCreateCompanionBuilder =
    PoliticalClassificationsCompanion Function({
      Value<int> id,
      required String nameAr,
      required String nameEn,
    });
typedef $$PoliticalClassificationsTableUpdateCompanionBuilder =
    PoliticalClassificationsCompanion Function({
      Value<int> id,
      Value<String> nameAr,
      Value<String> nameEn,
    });

class $$PoliticalClassificationsTableFilterComposer
    extends Composer<_$AppDatabase, $PoliticalClassificationsTable> {
  $$PoliticalClassificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PoliticalClassificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PoliticalClassificationsTable> {
  $$PoliticalClassificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PoliticalClassificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PoliticalClassificationsTable> {
  $$PoliticalClassificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);
}

class $$PoliticalClassificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PoliticalClassificationsTable,
          PoliticalClassification,
          $$PoliticalClassificationsTableFilterComposer,
          $$PoliticalClassificationsTableOrderingComposer,
          $$PoliticalClassificationsTableAnnotationComposer,
          $$PoliticalClassificationsTableCreateCompanionBuilder,
          $$PoliticalClassificationsTableUpdateCompanionBuilder,
          (
            PoliticalClassification,
            BaseReferences<
              _$AppDatabase,
              $PoliticalClassificationsTable,
              PoliticalClassification
            >,
          ),
          PoliticalClassification,
          PrefetchHooks Function()
        > {
  $$PoliticalClassificationsTableTableManager(
    _$AppDatabase db,
    $PoliticalClassificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PoliticalClassificationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PoliticalClassificationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PoliticalClassificationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
              }) => PoliticalClassificationsCompanion(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameAr,
                required String nameEn,
              }) => PoliticalClassificationsCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PoliticalClassificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PoliticalClassificationsTable,
      PoliticalClassification,
      $$PoliticalClassificationsTableFilterComposer,
      $$PoliticalClassificationsTableOrderingComposer,
      $$PoliticalClassificationsTableAnnotationComposer,
      $$PoliticalClassificationsTableCreateCompanionBuilder,
      $$PoliticalClassificationsTableUpdateCompanionBuilder,
      (
        PoliticalClassification,
        BaseReferences<
          _$AppDatabase,
          $PoliticalClassificationsTable,
          PoliticalClassification
        >,
      ),
      PoliticalClassification,
      PrefetchHooks Function()
    >;
typedef $$AreaUnitsTableCreateCompanionBuilder =
    AreaUnitsCompanion Function({
      Value<int> id,
      required String nameAr,
      required String nameEn,
    });
typedef $$AreaUnitsTableUpdateCompanionBuilder =
    AreaUnitsCompanion Function({
      Value<int> id,
      Value<String> nameAr,
      Value<String> nameEn,
    });

class $$AreaUnitsTableFilterComposer
    extends Composer<_$AppDatabase, $AreaUnitsTable> {
  $$AreaUnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AreaUnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $AreaUnitsTable> {
  $$AreaUnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AreaUnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AreaUnitsTable> {
  $$AreaUnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);
}

class $$AreaUnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AreaUnitsTable,
          AreaUnit,
          $$AreaUnitsTableFilterComposer,
          $$AreaUnitsTableOrderingComposer,
          $$AreaUnitsTableAnnotationComposer,
          $$AreaUnitsTableCreateCompanionBuilder,
          $$AreaUnitsTableUpdateCompanionBuilder,
          (AreaUnit, BaseReferences<_$AppDatabase, $AreaUnitsTable, AreaUnit>),
          AreaUnit,
          PrefetchHooks Function()
        > {
  $$AreaUnitsTableTableManager(_$AppDatabase db, $AreaUnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AreaUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AreaUnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AreaUnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
              }) => AreaUnitsCompanion(id: id, nameAr: nameAr, nameEn: nameEn),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameAr,
                required String nameEn,
              }) => AreaUnitsCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AreaUnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AreaUnitsTable,
      AreaUnit,
      $$AreaUnitsTableFilterComposer,
      $$AreaUnitsTableOrderingComposer,
      $$AreaUnitsTableAnnotationComposer,
      $$AreaUnitsTableCreateCompanionBuilder,
      $$AreaUnitsTableUpdateCompanionBuilder,
      (AreaUnit, BaseReferences<_$AppDatabase, $AreaUnitsTable, AreaUnit>),
      AreaUnit,
      PrefetchHooks Function()
    >;
typedef $$RelationshipToOwnersTableCreateCompanionBuilder =
    RelationshipToOwnersCompanion Function({
      Value<int> id,
      required String nameAr,
      required String nameEn,
    });
typedef $$RelationshipToOwnersTableUpdateCompanionBuilder =
    RelationshipToOwnersCompanion Function({
      Value<int> id,
      Value<String> nameAr,
      Value<String> nameEn,
    });

class $$RelationshipToOwnersTableFilterComposer
    extends Composer<_$AppDatabase, $RelationshipToOwnersTable> {
  $$RelationshipToOwnersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RelationshipToOwnersTableOrderingComposer
    extends Composer<_$AppDatabase, $RelationshipToOwnersTable> {
  $$RelationshipToOwnersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RelationshipToOwnersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RelationshipToOwnersTable> {
  $$RelationshipToOwnersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);
}

class $$RelationshipToOwnersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RelationshipToOwnersTable,
          RelationshipToOwner,
          $$RelationshipToOwnersTableFilterComposer,
          $$RelationshipToOwnersTableOrderingComposer,
          $$RelationshipToOwnersTableAnnotationComposer,
          $$RelationshipToOwnersTableCreateCompanionBuilder,
          $$RelationshipToOwnersTableUpdateCompanionBuilder,
          (
            RelationshipToOwner,
            BaseReferences<
              _$AppDatabase,
              $RelationshipToOwnersTable,
              RelationshipToOwner
            >,
          ),
          RelationshipToOwner,
          PrefetchHooks Function()
        > {
  $$RelationshipToOwnersTableTableManager(
    _$AppDatabase db,
    $RelationshipToOwnersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RelationshipToOwnersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RelationshipToOwnersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RelationshipToOwnersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
              }) => RelationshipToOwnersCompanion(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameAr,
                required String nameEn,
              }) => RelationshipToOwnersCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RelationshipToOwnersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RelationshipToOwnersTable,
      RelationshipToOwner,
      $$RelationshipToOwnersTableFilterComposer,
      $$RelationshipToOwnersTableOrderingComposer,
      $$RelationshipToOwnersTableAnnotationComposer,
      $$RelationshipToOwnersTableCreateCompanionBuilder,
      $$RelationshipToOwnersTableUpdateCompanionBuilder,
      (
        RelationshipToOwner,
        BaseReferences<
          _$AppDatabase,
          $RelationshipToOwnersTable,
          RelationshipToOwner
        >,
      ),
      RelationshipToOwner,
      PrefetchHooks Function()
    >;
typedef $$GovernoratesTableCreateCompanionBuilder =
    GovernoratesCompanion Function({
      required String id,
      required String nameAr,
      required String nameEn,
      required String code,
      Value<int> rowid,
    });
typedef $$GovernoratesTableUpdateCompanionBuilder =
    GovernoratesCompanion Function({
      Value<String> id,
      Value<String> nameAr,
      Value<String> nameEn,
      Value<String> code,
      Value<int> rowid,
    });

class $$GovernoratesTableFilterComposer
    extends Composer<_$AppDatabase, $GovernoratesTable> {
  $$GovernoratesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GovernoratesTableOrderingComposer
    extends Composer<_$AppDatabase, $GovernoratesTable> {
  $$GovernoratesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GovernoratesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GovernoratesTable> {
  $$GovernoratesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);
}

class $$GovernoratesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GovernoratesTable,
          GovernorateLocal,
          $$GovernoratesTableFilterComposer,
          $$GovernoratesTableOrderingComposer,
          $$GovernoratesTableAnnotationComposer,
          $$GovernoratesTableCreateCompanionBuilder,
          $$GovernoratesTableUpdateCompanionBuilder,
          (
            GovernorateLocal,
            BaseReferences<_$AppDatabase, $GovernoratesTable, GovernorateLocal>,
          ),
          GovernorateLocal,
          PrefetchHooks Function()
        > {
  $$GovernoratesTableTableManager(_$AppDatabase db, $GovernoratesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GovernoratesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GovernoratesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GovernoratesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GovernoratesCompanion(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
                code: code,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nameAr,
                required String nameEn,
                required String code,
                Value<int> rowid = const Value.absent(),
              }) => GovernoratesCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
                code: code,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GovernoratesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GovernoratesTable,
      GovernorateLocal,
      $$GovernoratesTableFilterComposer,
      $$GovernoratesTableOrderingComposer,
      $$GovernoratesTableAnnotationComposer,
      $$GovernoratesTableCreateCompanionBuilder,
      $$GovernoratesTableUpdateCompanionBuilder,
      (
        GovernorateLocal,
        BaseReferences<_$AppDatabase, $GovernoratesTable, GovernorateLocal>,
      ),
      GovernorateLocal,
      PrefetchHooks Function()
    >;
typedef $$DirectoratesTableCreateCompanionBuilder =
    DirectoratesCompanion Function({
      required String id,
      required String nameAr,
      required String nameEn,
      required String governorateId,
      Value<int> rowid,
    });
typedef $$DirectoratesTableUpdateCompanionBuilder =
    DirectoratesCompanion Function({
      Value<String> id,
      Value<String> nameAr,
      Value<String> nameEn,
      Value<String> governorateId,
      Value<int> rowid,
    });

class $$DirectoratesTableFilterComposer
    extends Composer<_$AppDatabase, $DirectoratesTable> {
  $$DirectoratesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DirectoratesTableOrderingComposer
    extends Composer<_$AppDatabase, $DirectoratesTable> {
  $$DirectoratesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DirectoratesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DirectoratesTable> {
  $$DirectoratesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => column,
  );
}

class $$DirectoratesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DirectoratesTable,
          DirectorateLocal,
          $$DirectoratesTableFilterComposer,
          $$DirectoratesTableOrderingComposer,
          $$DirectoratesTableAnnotationComposer,
          $$DirectoratesTableCreateCompanionBuilder,
          $$DirectoratesTableUpdateCompanionBuilder,
          (
            DirectorateLocal,
            BaseReferences<_$AppDatabase, $DirectoratesTable, DirectorateLocal>,
          ),
          DirectorateLocal,
          PrefetchHooks Function()
        > {
  $$DirectoratesTableTableManager(_$AppDatabase db, $DirectoratesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DirectoratesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DirectoratesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DirectoratesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> governorateId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DirectoratesCompanion(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
                governorateId: governorateId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nameAr,
                required String nameEn,
                required String governorateId,
                Value<int> rowid = const Value.absent(),
              }) => DirectoratesCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
                governorateId: governorateId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DirectoratesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DirectoratesTable,
      DirectorateLocal,
      $$DirectoratesTableFilterComposer,
      $$DirectoratesTableOrderingComposer,
      $$DirectoratesTableAnnotationComposer,
      $$DirectoratesTableCreateCompanionBuilder,
      $$DirectoratesTableUpdateCompanionBuilder,
      (
        DirectorateLocal,
        BaseReferences<_$AppDatabase, $DirectoratesTable, DirectorateLocal>,
      ),
      DirectorateLocal,
      PrefetchHooks Function()
    >;
typedef $$LocalitiesTableCreateCompanionBuilder =
    LocalitiesCompanion Function({
      required String id,
      required String nameAr,
      required String nameEn,
      required String governorateId,
      required String directorateId,
      Value<int> rowid,
    });
typedef $$LocalitiesTableUpdateCompanionBuilder =
    LocalitiesCompanion Function({
      Value<String> id,
      Value<String> nameAr,
      Value<String> nameEn,
      Value<String> governorateId,
      Value<String> directorateId,
      Value<int> rowid,
    });

class $$LocalitiesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalitiesTable> {
  $$LocalitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get directorateId => $composableBuilder(
    column: $table.directorateId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalitiesTable> {
  $$LocalitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get directorateId => $composableBuilder(
    column: $table.directorateId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalitiesTable> {
  $$LocalitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get governorateId => $composableBuilder(
    column: $table.governorateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get directorateId => $composableBuilder(
    column: $table.directorateId,
    builder: (column) => column,
  );
}

class $$LocalitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalitiesTable,
          LocalityLocal,
          $$LocalitiesTableFilterComposer,
          $$LocalitiesTableOrderingComposer,
          $$LocalitiesTableAnnotationComposer,
          $$LocalitiesTableCreateCompanionBuilder,
          $$LocalitiesTableUpdateCompanionBuilder,
          (
            LocalityLocal,
            BaseReferences<_$AppDatabase, $LocalitiesTable, LocalityLocal>,
          ),
          LocalityLocal,
          PrefetchHooks Function()
        > {
  $$LocalitiesTableTableManager(_$AppDatabase db, $LocalitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> governorateId = const Value.absent(),
                Value<String> directorateId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalitiesCompanion(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
                governorateId: governorateId,
                directorateId: directorateId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nameAr,
                required String nameEn,
                required String governorateId,
                required String directorateId,
                Value<int> rowid = const Value.absent(),
              }) => LocalitiesCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
                governorateId: governorateId,
                directorateId: directorateId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalitiesTable,
      LocalityLocal,
      $$LocalitiesTableFilterComposer,
      $$LocalitiesTableOrderingComposer,
      $$LocalitiesTableAnnotationComposer,
      $$LocalitiesTableCreateCompanionBuilder,
      $$LocalitiesTableUpdateCompanionBuilder,
      (
        LocalityLocal,
        BaseReferences<_$AppDatabase, $LocalitiesTable, LocalityLocal>,
      ),
      LocalityLocal,
      PrefetchHooks Function()
    >;
typedef $$DamageNaturesTableCreateCompanionBuilder =
    DamageNaturesCompanion Function({
      Value<int> id,
      required String nameAr,
      required String nameEn,
    });
typedef $$DamageNaturesTableUpdateCompanionBuilder =
    DamageNaturesCompanion Function({
      Value<int> id,
      Value<String> nameAr,
      Value<String> nameEn,
    });

class $$DamageNaturesTableFilterComposer
    extends Composer<_$AppDatabase, $DamageNaturesTable> {
  $$DamageNaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DamageNaturesTableOrderingComposer
    extends Composer<_$AppDatabase, $DamageNaturesTable> {
  $$DamageNaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DamageNaturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DamageNaturesTable> {
  $$DamageNaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);
}

class $$DamageNaturesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DamageNaturesTable,
          DamageNature,
          $$DamageNaturesTableFilterComposer,
          $$DamageNaturesTableOrderingComposer,
          $$DamageNaturesTableAnnotationComposer,
          $$DamageNaturesTableCreateCompanionBuilder,
          $$DamageNaturesTableUpdateCompanionBuilder,
          (
            DamageNature,
            BaseReferences<_$AppDatabase, $DamageNaturesTable, DamageNature>,
          ),
          DamageNature,
          PrefetchHooks Function()
        > {
  $$DamageNaturesTableTableManager(_$AppDatabase db, $DamageNaturesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DamageNaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DamageNaturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DamageNaturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
              }) => DamageNaturesCompanion(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameAr,
                required String nameEn,
              }) => DamageNaturesCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DamageNaturesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DamageNaturesTable,
      DamageNature,
      $$DamageNaturesTableFilterComposer,
      $$DamageNaturesTableOrderingComposer,
      $$DamageNaturesTableAnnotationComposer,
      $$DamageNaturesTableCreateCompanionBuilder,
      $$DamageNaturesTableUpdateCompanionBuilder,
      (
        DamageNature,
        BaseReferences<_$AppDatabase, $DamageNaturesTable, DamageNature>,
      ),
      DamageNature,
      PrefetchHooks Function()
    >;
typedef $$DamageCategoriesTableCreateCompanionBuilder =
    DamageCategoriesCompanion Function({
      Value<int> id,
      required int parentId,
      required String nameAr,
      required String nameEn,
    });
typedef $$DamageCategoriesTableUpdateCompanionBuilder =
    DamageCategoriesCompanion Function({
      Value<int> id,
      Value<int> parentId,
      Value<String> nameAr,
      Value<String> nameEn,
    });

class $$DamageCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $DamageCategoriesTable> {
  $$DamageCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DamageCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DamageCategoriesTable> {
  $$DamageCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DamageCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DamageCategoriesTable> {
  $$DamageCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);
}

class $$DamageCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DamageCategoriesTable,
          DamageCategory,
          $$DamageCategoriesTableFilterComposer,
          $$DamageCategoriesTableOrderingComposer,
          $$DamageCategoriesTableAnnotationComposer,
          $$DamageCategoriesTableCreateCompanionBuilder,
          $$DamageCategoriesTableUpdateCompanionBuilder,
          (
            DamageCategory,
            BaseReferences<
              _$AppDatabase,
              $DamageCategoriesTable,
              DamageCategory
            >,
          ),
          DamageCategory,
          PrefetchHooks Function()
        > {
  $$DamageCategoriesTableTableManager(
    _$AppDatabase db,
    $DamageCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DamageCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DamageCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DamageCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> parentId = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
              }) => DamageCategoriesCompanion(
                id: id,
                parentId: parentId,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int parentId,
                required String nameAr,
                required String nameEn,
              }) => DamageCategoriesCompanion.insert(
                id: id,
                parentId: parentId,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DamageCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DamageCategoriesTable,
      DamageCategory,
      $$DamageCategoriesTableFilterComposer,
      $$DamageCategoriesTableOrderingComposer,
      $$DamageCategoriesTableAnnotationComposer,
      $$DamageCategoriesTableCreateCompanionBuilder,
      $$DamageCategoriesTableUpdateCompanionBuilder,
      (
        DamageCategory,
        BaseReferences<_$AppDatabase, $DamageCategoriesTable, DamageCategory>,
      ),
      DamageCategory,
      PrefetchHooks Function()
    >;
typedef $$DamageSubCategoriesTableCreateCompanionBuilder =
    DamageSubCategoriesCompanion Function({
      Value<int> id,
      required int parentId,
      required String nameAr,
      required String nameEn,
    });
typedef $$DamageSubCategoriesTableUpdateCompanionBuilder =
    DamageSubCategoriesCompanion Function({
      Value<int> id,
      Value<int> parentId,
      Value<String> nameAr,
      Value<String> nameEn,
    });

class $$DamageSubCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $DamageSubCategoriesTable> {
  $$DamageSubCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DamageSubCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DamageSubCategoriesTable> {
  $$DamageSubCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DamageSubCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DamageSubCategoriesTable> {
  $$DamageSubCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);
}

class $$DamageSubCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DamageSubCategoriesTable,
          DamageSubCategory,
          $$DamageSubCategoriesTableFilterComposer,
          $$DamageSubCategoriesTableOrderingComposer,
          $$DamageSubCategoriesTableAnnotationComposer,
          $$DamageSubCategoriesTableCreateCompanionBuilder,
          $$DamageSubCategoriesTableUpdateCompanionBuilder,
          (
            DamageSubCategory,
            BaseReferences<
              _$AppDatabase,
              $DamageSubCategoriesTable,
              DamageSubCategory
            >,
          ),
          DamageSubCategory,
          PrefetchHooks Function()
        > {
  $$DamageSubCategoriesTableTableManager(
    _$AppDatabase db,
    $DamageSubCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DamageSubCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DamageSubCategoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DamageSubCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> parentId = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
              }) => DamageSubCategoriesCompanion(
                id: id,
                parentId: parentId,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int parentId,
                required String nameAr,
                required String nameEn,
              }) => DamageSubCategoriesCompanion.insert(
                id: id,
                parentId: parentId,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DamageSubCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DamageSubCategoriesTable,
      DamageSubCategory,
      $$DamageSubCategoriesTableFilterComposer,
      $$DamageSubCategoriesTableOrderingComposer,
      $$DamageSubCategoriesTableAnnotationComposer,
      $$DamageSubCategoriesTableCreateCompanionBuilder,
      $$DamageSubCategoriesTableUpdateCompanionBuilder,
      (
        DamageSubCategory,
        BaseReferences<
          _$AppDatabase,
          $DamageSubCategoriesTable,
          DamageSubCategory
        >,
      ),
      DamageSubCategory,
      PrefetchHooks Function()
    >;
typedef $$DamageClassificationsTableCreateCompanionBuilder =
    DamageClassificationsCompanion Function({
      Value<int> id,
      required int parentId,
      required String nameAr,
      required String nameEn,
    });
typedef $$DamageClassificationsTableUpdateCompanionBuilder =
    DamageClassificationsCompanion Function({
      Value<int> id,
      Value<int> parentId,
      Value<String> nameAr,
      Value<String> nameEn,
    });

class $$DamageClassificationsTableFilterComposer
    extends Composer<_$AppDatabase, $DamageClassificationsTable> {
  $$DamageClassificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DamageClassificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $DamageClassificationsTable> {
  $$DamageClassificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DamageClassificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DamageClassificationsTable> {
  $$DamageClassificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);
}

class $$DamageClassificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DamageClassificationsTable,
          DamageClassification,
          $$DamageClassificationsTableFilterComposer,
          $$DamageClassificationsTableOrderingComposer,
          $$DamageClassificationsTableAnnotationComposer,
          $$DamageClassificationsTableCreateCompanionBuilder,
          $$DamageClassificationsTableUpdateCompanionBuilder,
          (
            DamageClassification,
            BaseReferences<
              _$AppDatabase,
              $DamageClassificationsTable,
              DamageClassification
            >,
          ),
          DamageClassification,
          PrefetchHooks Function()
        > {
  $$DamageClassificationsTableTableManager(
    _$AppDatabase db,
    $DamageClassificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DamageClassificationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DamageClassificationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DamageClassificationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> parentId = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
              }) => DamageClassificationsCompanion(
                id: id,
                parentId: parentId,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int parentId,
                required String nameAr,
                required String nameEn,
              }) => DamageClassificationsCompanion.insert(
                id: id,
                parentId: parentId,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DamageClassificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DamageClassificationsTable,
      DamageClassification,
      $$DamageClassificationsTableFilterComposer,
      $$DamageClassificationsTableOrderingComposer,
      $$DamageClassificationsTableAnnotationComposer,
      $$DamageClassificationsTableCreateCompanionBuilder,
      $$DamageClassificationsTableUpdateCompanionBuilder,
      (
        DamageClassification,
        BaseReferences<
          _$AppDatabase,
          $DamageClassificationsTable,
          DamageClassification
        >,
      ),
      DamageClassification,
      PrefetchHooks Function()
    >;
typedef $$DamageCauseCategoriesTableCreateCompanionBuilder =
    DamageCauseCategoriesCompanion Function({
      Value<int> id,
      required String nameAr,
      required String nameEn,
    });
typedef $$DamageCauseCategoriesTableUpdateCompanionBuilder =
    DamageCauseCategoriesCompanion Function({
      Value<int> id,
      Value<String> nameAr,
      Value<String> nameEn,
    });

class $$DamageCauseCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $DamageCauseCategoriesTable> {
  $$DamageCauseCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DamageCauseCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DamageCauseCategoriesTable> {
  $$DamageCauseCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DamageCauseCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DamageCauseCategoriesTable> {
  $$DamageCauseCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);
}

class $$DamageCauseCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DamageCauseCategoriesTable,
          DamageCauseCategory,
          $$DamageCauseCategoriesTableFilterComposer,
          $$DamageCauseCategoriesTableOrderingComposer,
          $$DamageCauseCategoriesTableAnnotationComposer,
          $$DamageCauseCategoriesTableCreateCompanionBuilder,
          $$DamageCauseCategoriesTableUpdateCompanionBuilder,
          (
            DamageCauseCategory,
            BaseReferences<
              _$AppDatabase,
              $DamageCauseCategoriesTable,
              DamageCauseCategory
            >,
          ),
          DamageCauseCategory,
          PrefetchHooks Function()
        > {
  $$DamageCauseCategoriesTableTableManager(
    _$AppDatabase db,
    $DamageCauseCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DamageCauseCategoriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DamageCauseCategoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DamageCauseCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
              }) => DamageCauseCategoriesCompanion(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameAr,
                required String nameEn,
              }) => DamageCauseCategoriesCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DamageCauseCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DamageCauseCategoriesTable,
      DamageCauseCategory,
      $$DamageCauseCategoriesTableFilterComposer,
      $$DamageCauseCategoriesTableOrderingComposer,
      $$DamageCauseCategoriesTableAnnotationComposer,
      $$DamageCauseCategoriesTableCreateCompanionBuilder,
      $$DamageCauseCategoriesTableUpdateCompanionBuilder,
      (
        DamageCauseCategory,
        BaseReferences<
          _$AppDatabase,
          $DamageCauseCategoriesTable,
          DamageCauseCategory
        >,
      ),
      DamageCauseCategory,
      PrefetchHooks Function()
    >;
typedef $$DamageCausesTableCreateCompanionBuilder =
    DamageCausesCompanion Function({
      Value<int> id,
      required int parentId,
      required String nameAr,
      required String nameEn,
    });
typedef $$DamageCausesTableUpdateCompanionBuilder =
    DamageCausesCompanion Function({
      Value<int> id,
      Value<int> parentId,
      Value<String> nameAr,
      Value<String> nameEn,
    });

class $$DamageCausesTableFilterComposer
    extends Composer<_$AppDatabase, $DamageCausesTable> {
  $$DamageCausesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DamageCausesTableOrderingComposer
    extends Composer<_$AppDatabase, $DamageCausesTable> {
  $$DamageCausesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DamageCausesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DamageCausesTable> {
  $$DamageCausesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);
}

class $$DamageCausesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DamageCausesTable,
          DamageCause,
          $$DamageCausesTableFilterComposer,
          $$DamageCausesTableOrderingComposer,
          $$DamageCausesTableAnnotationComposer,
          $$DamageCausesTableCreateCompanionBuilder,
          $$DamageCausesTableUpdateCompanionBuilder,
          (
            DamageCause,
            BaseReferences<_$AppDatabase, $DamageCausesTable, DamageCause>,
          ),
          DamageCause,
          PrefetchHooks Function()
        > {
  $$DamageCausesTableTableManager(_$AppDatabase db, $DamageCausesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DamageCausesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DamageCausesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DamageCausesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> parentId = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
              }) => DamageCausesCompanion(
                id: id,
                parentId: parentId,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int parentId,
                required String nameAr,
                required String nameEn,
              }) => DamageCausesCompanion.insert(
                id: id,
                parentId: parentId,
                nameAr: nameAr,
                nameEn: nameEn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DamageCausesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DamageCausesTable,
      DamageCause,
      $$DamageCausesTableFilterComposer,
      $$DamageCausesTableOrderingComposer,
      $$DamageCausesTableAnnotationComposer,
      $$DamageCausesTableCreateCompanionBuilder,
      $$DamageCausesTableUpdateCompanionBuilder,
      (
        DamageCause,
        BaseReferences<_$AppDatabase, $DamageCausesTable, DamageCause>,
      ),
      DamageCause,
      PrefetchHooks Function()
    >;
typedef $$CostingSheetsTableCreateCompanionBuilder =
    CostingSheetsCompanion Function({
      required String id,
      required int classificationId,
      required double unitPrice,
      required DateTime effectiveFrom,
      Value<DateTime?> effectiveTo,
      Value<bool> isActive,
      required int versionNumber,
      Value<int> rowid,
    });
typedef $$CostingSheetsTableUpdateCompanionBuilder =
    CostingSheetsCompanion Function({
      Value<String> id,
      Value<int> classificationId,
      Value<double> unitPrice,
      Value<DateTime> effectiveFrom,
      Value<DateTime?> effectiveTo,
      Value<bool> isActive,
      Value<int> versionNumber,
      Value<int> rowid,
    });

class $$CostingSheetsTableFilterComposer
    extends Composer<_$AppDatabase, $CostingSheetsTable> {
  $$CostingSheetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get classificationId => $composableBuilder(
    column: $table.classificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveTo => $composableBuilder(
    column: $table.effectiveTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CostingSheetsTableOrderingComposer
    extends Composer<_$AppDatabase, $CostingSheetsTable> {
  $$CostingSheetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get classificationId => $composableBuilder(
    column: $table.classificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveTo => $composableBuilder(
    column: $table.effectiveTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CostingSheetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CostingSheetsTable> {
  $$CostingSheetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get classificationId => $composableBuilder(
    column: $table.classificationId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get effectiveTo => $composableBuilder(
    column: $table.effectiveTo,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => column,
  );
}

class $$CostingSheetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CostingSheetsTable,
          CostingSheet,
          $$CostingSheetsTableFilterComposer,
          $$CostingSheetsTableOrderingComposer,
          $$CostingSheetsTableAnnotationComposer,
          $$CostingSheetsTableCreateCompanionBuilder,
          $$CostingSheetsTableUpdateCompanionBuilder,
          (
            CostingSheet,
            BaseReferences<_$AppDatabase, $CostingSheetsTable, CostingSheet>,
          ),
          CostingSheet,
          PrefetchHooks Function()
        > {
  $$CostingSheetsTableTableManager(_$AppDatabase db, $CostingSheetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CostingSheetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CostingSheetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CostingSheetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> classificationId = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<DateTime> effectiveFrom = const Value.absent(),
                Value<DateTime?> effectiveTo = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> versionNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CostingSheetsCompanion(
                id: id,
                classificationId: classificationId,
                unitPrice: unitPrice,
                effectiveFrom: effectiveFrom,
                effectiveTo: effectiveTo,
                isActive: isActive,
                versionNumber: versionNumber,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int classificationId,
                required double unitPrice,
                required DateTime effectiveFrom,
                Value<DateTime?> effectiveTo = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required int versionNumber,
                Value<int> rowid = const Value.absent(),
              }) => CostingSheetsCompanion.insert(
                id: id,
                classificationId: classificationId,
                unitPrice: unitPrice,
                effectiveFrom: effectiveFrom,
                effectiveTo: effectiveTo,
                isActive: isActive,
                versionNumber: versionNumber,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CostingSheetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CostingSheetsTable,
      CostingSheet,
      $$CostingSheetsTableFilterComposer,
      $$CostingSheetsTableOrderingComposer,
      $$CostingSheetsTableAnnotationComposer,
      $$CostingSheetsTableCreateCompanionBuilder,
      $$CostingSheetsTableUpdateCompanionBuilder,
      (
        CostingSheet,
        BaseReferences<_$AppDatabase, $CostingSheetsTable, CostingSheet>,
      ),
      CostingSheet,
      PrefetchHooks Function()
    >;
typedef $$DamageWorkflowHistoriesTableCreateCompanionBuilder =
    DamageWorkflowHistoriesCompanion Function({
      required String id,
      Value<String?> serverId,
      required String damageReportId,
      required String fromStatus,
      required String toStatus,
      required String changedByUserId,
      required DateTime changedAt,
      Value<String?> comment,
      Value<bool> isOverride,
      Value<int> rowid,
    });
typedef $$DamageWorkflowHistoriesTableUpdateCompanionBuilder =
    DamageWorkflowHistoriesCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> damageReportId,
      Value<String> fromStatus,
      Value<String> toStatus,
      Value<String> changedByUserId,
      Value<DateTime> changedAt,
      Value<String?> comment,
      Value<bool> isOverride,
      Value<int> rowid,
    });

class $$DamageWorkflowHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $DamageWorkflowHistoriesTable> {
  $$DamageWorkflowHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get damageReportId => $composableBuilder(
    column: $table.damageReportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toStatus => $composableBuilder(
    column: $table.toStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changedByUserId => $composableBuilder(
    column: $table.changedByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOverride => $composableBuilder(
    column: $table.isOverride,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DamageWorkflowHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DamageWorkflowHistoriesTable> {
  $$DamageWorkflowHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get damageReportId => $composableBuilder(
    column: $table.damageReportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toStatus => $composableBuilder(
    column: $table.toStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changedByUserId => $composableBuilder(
    column: $table.changedByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOverride => $composableBuilder(
    column: $table.isOverride,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DamageWorkflowHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DamageWorkflowHistoriesTable> {
  $$DamageWorkflowHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get damageReportId => $composableBuilder(
    column: $table.damageReportId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toStatus =>
      $composableBuilder(column: $table.toStatus, builder: (column) => column);

  GeneratedColumn<String> get changedByUserId => $composableBuilder(
    column: $table.changedByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<bool> get isOverride => $composableBuilder(
    column: $table.isOverride,
    builder: (column) => column,
  );
}

class $$DamageWorkflowHistoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DamageWorkflowHistoriesTable,
          DamageWorkflowHistoryLocal,
          $$DamageWorkflowHistoriesTableFilterComposer,
          $$DamageWorkflowHistoriesTableOrderingComposer,
          $$DamageWorkflowHistoriesTableAnnotationComposer,
          $$DamageWorkflowHistoriesTableCreateCompanionBuilder,
          $$DamageWorkflowHistoriesTableUpdateCompanionBuilder,
          (
            DamageWorkflowHistoryLocal,
            BaseReferences<
              _$AppDatabase,
              $DamageWorkflowHistoriesTable,
              DamageWorkflowHistoryLocal
            >,
          ),
          DamageWorkflowHistoryLocal,
          PrefetchHooks Function()
        > {
  $$DamageWorkflowHistoriesTableTableManager(
    _$AppDatabase db,
    $DamageWorkflowHistoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DamageWorkflowHistoriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DamageWorkflowHistoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DamageWorkflowHistoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> damageReportId = const Value.absent(),
                Value<String> fromStatus = const Value.absent(),
                Value<String> toStatus = const Value.absent(),
                Value<String> changedByUserId = const Value.absent(),
                Value<DateTime> changedAt = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<bool> isOverride = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DamageWorkflowHistoriesCompanion(
                id: id,
                serverId: serverId,
                damageReportId: damageReportId,
                fromStatus: fromStatus,
                toStatus: toStatus,
                changedByUserId: changedByUserId,
                changedAt: changedAt,
                comment: comment,
                isOverride: isOverride,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String damageReportId,
                required String fromStatus,
                required String toStatus,
                required String changedByUserId,
                required DateTime changedAt,
                Value<String?> comment = const Value.absent(),
                Value<bool> isOverride = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DamageWorkflowHistoriesCompanion.insert(
                id: id,
                serverId: serverId,
                damageReportId: damageReportId,
                fromStatus: fromStatus,
                toStatus: toStatus,
                changedByUserId: changedByUserId,
                changedAt: changedAt,
                comment: comment,
                isOverride: isOverride,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DamageWorkflowHistoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DamageWorkflowHistoriesTable,
      DamageWorkflowHistoryLocal,
      $$DamageWorkflowHistoriesTableFilterComposer,
      $$DamageWorkflowHistoriesTableOrderingComposer,
      $$DamageWorkflowHistoriesTableAnnotationComposer,
      $$DamageWorkflowHistoriesTableCreateCompanionBuilder,
      $$DamageWorkflowHistoriesTableUpdateCompanionBuilder,
      (
        DamageWorkflowHistoryLocal,
        BaseReferences<
          _$AppDatabase,
          $DamageWorkflowHistoriesTable,
          DamageWorkflowHistoryLocal
        >,
      ),
      DamageWorkflowHistoryLocal,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FarmersTableTableManager get farmers =>
      $$FarmersTableTableManager(_db, _db.farmers);
  $$FarmsTableTableManager get farms =>
      $$FarmsTableTableManager(_db, _db.farms);
  $$DamageReportsTableTableManager get damageReports =>
      $$DamageReportsTableTableManager(_db, _db.damageReports);
  $$DamageItemsTableTableManager get damageItems =>
      $$DamageItemsTableTableManager(_db, _db.damageItems);
  $$DamageReportAttachmentsTableTableManager get damageReportAttachments =>
      $$DamageReportAttachmentsTableTableManager(
        _db,
        _db.damageReportAttachments,
      );
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$OwnershipTypesTableTableManager get ownershipTypes =>
      $$OwnershipTypesTableTableManager(_db, _db.ownershipTypes);
  $$AgriculturalSectorsTableTableManager get agriculturalSectors =>
      $$AgriculturalSectorsTableTableManager(_db, _db.agriculturalSectors);
  $$PoliticalClassificationsTableTableManager get politicalClassifications =>
      $$PoliticalClassificationsTableTableManager(
        _db,
        _db.politicalClassifications,
      );
  $$AreaUnitsTableTableManager get areaUnits =>
      $$AreaUnitsTableTableManager(_db, _db.areaUnits);
  $$RelationshipToOwnersTableTableManager get relationshipToOwners =>
      $$RelationshipToOwnersTableTableManager(_db, _db.relationshipToOwners);
  $$GovernoratesTableTableManager get governorates =>
      $$GovernoratesTableTableManager(_db, _db.governorates);
  $$DirectoratesTableTableManager get directorates =>
      $$DirectoratesTableTableManager(_db, _db.directorates);
  $$LocalitiesTableTableManager get localities =>
      $$LocalitiesTableTableManager(_db, _db.localities);
  $$DamageNaturesTableTableManager get damageNatures =>
      $$DamageNaturesTableTableManager(_db, _db.damageNatures);
  $$DamageCategoriesTableTableManager get damageCategories =>
      $$DamageCategoriesTableTableManager(_db, _db.damageCategories);
  $$DamageSubCategoriesTableTableManager get damageSubCategories =>
      $$DamageSubCategoriesTableTableManager(_db, _db.damageSubCategories);
  $$DamageClassificationsTableTableManager get damageClassifications =>
      $$DamageClassificationsTableTableManager(_db, _db.damageClassifications);
  $$DamageCauseCategoriesTableTableManager get damageCauseCategories =>
      $$DamageCauseCategoriesTableTableManager(_db, _db.damageCauseCategories);
  $$DamageCausesTableTableManager get damageCauses =>
      $$DamageCausesTableTableManager(_db, _db.damageCauses);
  $$CostingSheetsTableTableManager get costingSheets =>
      $$CostingSheetsTableTableManager(_db, _db.costingSheets);
  $$DamageWorkflowHistoriesTableTableManager get damageWorkflowHistories =>
      $$DamageWorkflowHistoriesTableTableManager(
        _db,
        _db.damageWorkflowHistories,
      );
}
