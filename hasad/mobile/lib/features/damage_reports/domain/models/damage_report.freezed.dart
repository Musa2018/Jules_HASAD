// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'damage_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DamageReport _$DamageReportFromJson(Map<String, dynamic> json) {
  return _DamageReport.fromJson(json);
}

/// @nodoc
mixin _$DamageReport {
  @JsonKey(name: 'clientId')
  String get id => throw _privateConstructorUsedError; // ClientId
  @JsonKey(name: 'id')
  String? get serverId => throw _privateConstructorUsedError;
  String get reportNumber => throw _privateConstructorUsedError;
  String get permanentFormNumber => throw _privateConstructorUsedError;
  String get temporaryFormNumber => throw _privateConstructorUsedError;
  int get damageYear => throw _privateConstructorUsedError;
  String get farmId => throw _privateConstructorUsedError;
  String get farmerId => throw _privateConstructorUsedError;
  DateTime get damageDate => throw _privateConstructorUsedError;
  DateTime get documentationDate => throw _privateConstructorUsedError;
  int get damageNatureId => throw _privateConstructorUsedError;
  int get damageCauseCategoryId => throw _privateConstructorUsedError;
  int get damageCauseId => throw _privateConstructorUsedError;
  String? get settlementName => throw _privateConstructorUsedError;
  String? get companyName => throw _privateConstructorUsedError;
  String get governorateId => throw _privateConstructorUsedError;
  String get directorateId => throw _privateConstructorUsedError;
  String get localityId => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String get statusId => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  String get rowVersion => throw _privateConstructorUsedError;
  List<DamageItem> get items => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;
  String? get lastSyncError => throw _privateConstructorUsedError;
  bool? get isDeleted => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String? get deletedBy => throw _privateConstructorUsedError;

  /// Serializes this DamageReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DamageReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DamageReportCopyWith<DamageReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DamageReportCopyWith<$Res> {
  factory $DamageReportCopyWith(
    DamageReport value,
    $Res Function(DamageReport) then,
  ) = _$DamageReportCopyWithImpl<$Res, DamageReport>;
  @useResult
  $Res call({
    @JsonKey(name: 'clientId') String id,
    @JsonKey(name: 'id') String? serverId,
    String reportNumber,
    String permanentFormNumber,
    String temporaryFormNumber,
    int damageYear,
    String farmId,
    String farmerId,
    DateTime damageDate,
    DateTime documentationDate,
    int damageNatureId,
    int damageCauseCategoryId,
    int damageCauseId,
    String? settlementName,
    String? companyName,
    String governorateId,
    String directorateId,
    String localityId,
    double? latitude,
    double? longitude,
    String statusId,
    String notes,
    String rowVersion,
    List<DamageItem> items,
    String syncStatus,
    String? lastSyncError,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
  });
}

/// @nodoc
class _$DamageReportCopyWithImpl<$Res, $Val extends DamageReport>
    implements $DamageReportCopyWith<$Res> {
  _$DamageReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DamageReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? reportNumber = null,
    Object? permanentFormNumber = null,
    Object? temporaryFormNumber = null,
    Object? damageYear = null,
    Object? farmId = null,
    Object? farmerId = null,
    Object? damageDate = null,
    Object? documentationDate = null,
    Object? damageNatureId = null,
    Object? damageCauseCategoryId = null,
    Object? damageCauseId = null,
    Object? settlementName = freezed,
    Object? companyName = freezed,
    Object? governorateId = null,
    Object? directorateId = null,
    Object? localityId = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? statusId = null,
    Object? notes = null,
    Object? rowVersion = null,
    Object? items = null,
    Object? syncStatus = null,
    Object? lastSyncError = freezed,
    Object? isDeleted = freezed,
    Object? deletedAt = freezed,
    Object? deletedBy = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            serverId: freezed == serverId
                ? _value.serverId
                : serverId // ignore: cast_nullable_to_non_nullable
                      as String?,
            reportNumber: null == reportNumber
                ? _value.reportNumber
                : reportNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            permanentFormNumber: null == permanentFormNumber
                ? _value.permanentFormNumber
                : permanentFormNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            temporaryFormNumber: null == temporaryFormNumber
                ? _value.temporaryFormNumber
                : temporaryFormNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            damageYear: null == damageYear
                ? _value.damageYear
                : damageYear // ignore: cast_nullable_to_non_nullable
                      as int,
            farmId: null == farmId
                ? _value.farmId
                : farmId // ignore: cast_nullable_to_non_nullable
                      as String,
            farmerId: null == farmerId
                ? _value.farmerId
                : farmerId // ignore: cast_nullable_to_non_nullable
                      as String,
            damageDate: null == damageDate
                ? _value.damageDate
                : damageDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            documentationDate: null == documentationDate
                ? _value.documentationDate
                : documentationDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            damageNatureId: null == damageNatureId
                ? _value.damageNatureId
                : damageNatureId // ignore: cast_nullable_to_non_nullable
                      as int,
            damageCauseCategoryId: null == damageCauseCategoryId
                ? _value.damageCauseCategoryId
                : damageCauseCategoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            damageCauseId: null == damageCauseId
                ? _value.damageCauseId
                : damageCauseId // ignore: cast_nullable_to_non_nullable
                      as int,
            settlementName: freezed == settlementName
                ? _value.settlementName
                : settlementName // ignore: cast_nullable_to_non_nullable
                      as String?,
            companyName: freezed == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            governorateId: null == governorateId
                ? _value.governorateId
                : governorateId // ignore: cast_nullable_to_non_nullable
                      as String,
            directorateId: null == directorateId
                ? _value.directorateId
                : directorateId // ignore: cast_nullable_to_non_nullable
                      as String,
            localityId: null == localityId
                ? _value.localityId
                : localityId // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            statusId: null == statusId
                ? _value.statusId
                : statusId // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            rowVersion: null == rowVersion
                ? _value.rowVersion
                : rowVersion // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<DamageItem>,
            syncStatus: null == syncStatus
                ? _value.syncStatus
                : syncStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            lastSyncError: freezed == lastSyncError
                ? _value.lastSyncError
                : lastSyncError // ignore: cast_nullable_to_non_nullable
                      as String?,
            isDeleted: freezed == isDeleted
                ? _value.isDeleted
                : isDeleted // ignore: cast_nullable_to_non_nullable
                      as bool?,
            deletedAt: freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deletedBy: freezed == deletedBy
                ? _value.deletedBy
                : deletedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DamageReportImplCopyWith<$Res>
    implements $DamageReportCopyWith<$Res> {
  factory _$$DamageReportImplCopyWith(
    _$DamageReportImpl value,
    $Res Function(_$DamageReportImpl) then,
  ) = __$$DamageReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'clientId') String id,
    @JsonKey(name: 'id') String? serverId,
    String reportNumber,
    String permanentFormNumber,
    String temporaryFormNumber,
    int damageYear,
    String farmId,
    String farmerId,
    DateTime damageDate,
    DateTime documentationDate,
    int damageNatureId,
    int damageCauseCategoryId,
    int damageCauseId,
    String? settlementName,
    String? companyName,
    String governorateId,
    String directorateId,
    String localityId,
    double? latitude,
    double? longitude,
    String statusId,
    String notes,
    String rowVersion,
    List<DamageItem> items,
    String syncStatus,
    String? lastSyncError,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
  });
}

/// @nodoc
class __$$DamageReportImplCopyWithImpl<$Res>
    extends _$DamageReportCopyWithImpl<$Res, _$DamageReportImpl>
    implements _$$DamageReportImplCopyWith<$Res> {
  __$$DamageReportImplCopyWithImpl(
    _$DamageReportImpl _value,
    $Res Function(_$DamageReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DamageReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? reportNumber = null,
    Object? permanentFormNumber = null,
    Object? temporaryFormNumber = null,
    Object? damageYear = null,
    Object? farmId = null,
    Object? farmerId = null,
    Object? damageDate = null,
    Object? documentationDate = null,
    Object? damageNatureId = null,
    Object? damageCauseCategoryId = null,
    Object? damageCauseId = null,
    Object? settlementName = freezed,
    Object? companyName = freezed,
    Object? governorateId = null,
    Object? directorateId = null,
    Object? localityId = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? statusId = null,
    Object? notes = null,
    Object? rowVersion = null,
    Object? items = null,
    Object? syncStatus = null,
    Object? lastSyncError = freezed,
    Object? isDeleted = freezed,
    Object? deletedAt = freezed,
    Object? deletedBy = freezed,
  }) {
    return _then(
      _$DamageReportImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        serverId: freezed == serverId
            ? _value.serverId
            : serverId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reportNumber: null == reportNumber
            ? _value.reportNumber
            : reportNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        permanentFormNumber: null == permanentFormNumber
            ? _value.permanentFormNumber
            : permanentFormNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        temporaryFormNumber: null == temporaryFormNumber
            ? _value.temporaryFormNumber
            : temporaryFormNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        damageYear: null == damageYear
            ? _value.damageYear
            : damageYear // ignore: cast_nullable_to_non_nullable
                  as int,
        farmId: null == farmId
            ? _value.farmId
            : farmId // ignore: cast_nullable_to_non_nullable
                  as String,
        farmerId: null == farmerId
            ? _value.farmerId
            : farmerId // ignore: cast_nullable_to_non_nullable
                  as String,
        damageDate: null == damageDate
            ? _value.damageDate
            : damageDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        documentationDate: null == documentationDate
            ? _value.documentationDate
            : documentationDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        damageNatureId: null == damageNatureId
            ? _value.damageNatureId
            : damageNatureId // ignore: cast_nullable_to_non_nullable
                  as int,
        damageCauseCategoryId: null == damageCauseCategoryId
            ? _value.damageCauseCategoryId
            : damageCauseCategoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        damageCauseId: null == damageCauseId
            ? _value.damageCauseId
            : damageCauseId // ignore: cast_nullable_to_non_nullable
                  as int,
        settlementName: freezed == settlementName
            ? _value.settlementName
            : settlementName // ignore: cast_nullable_to_non_nullable
                  as String?,
        companyName: freezed == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        governorateId: null == governorateId
            ? _value.governorateId
            : governorateId // ignore: cast_nullable_to_non_nullable
                  as String,
        directorateId: null == directorateId
            ? _value.directorateId
            : directorateId // ignore: cast_nullable_to_non_nullable
                  as String,
        localityId: null == localityId
            ? _value.localityId
            : localityId // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        statusId: null == statusId
            ? _value.statusId
            : statusId // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        rowVersion: null == rowVersion
            ? _value.rowVersion
            : rowVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<DamageItem>,
        syncStatus: null == syncStatus
            ? _value.syncStatus
            : syncStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        lastSyncError: freezed == lastSyncError
            ? _value.lastSyncError
            : lastSyncError // ignore: cast_nullable_to_non_nullable
                  as String?,
        isDeleted: freezed == isDeleted
            ? _value.isDeleted
            : isDeleted // ignore: cast_nullable_to_non_nullable
                  as bool?,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deletedBy: freezed == deletedBy
            ? _value.deletedBy
            : deletedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DamageReportImpl implements _DamageReport {
  const _$DamageReportImpl({
    @JsonKey(name: 'clientId') required this.id,
    @JsonKey(name: 'id') this.serverId,
    this.reportNumber = '',
    this.permanentFormNumber = '',
    this.temporaryFormNumber = '',
    this.damageYear = 0,
    required this.farmId,
    required this.farmerId,
    required this.damageDate,
    required this.documentationDate,
    this.damageNatureId = 0,
    this.damageCauseCategoryId = 0,
    this.damageCauseId = 0,
    this.settlementName,
    this.companyName,
    required this.governorateId,
    required this.directorateId,
    required this.localityId,
    this.latitude,
    this.longitude,
    required this.statusId,
    required this.notes,
    this.rowVersion = '',
    final List<DamageItem> items = const [],
    this.syncStatus = 'completed',
    this.lastSyncError,
    this.isDeleted,
    this.deletedAt,
    this.deletedBy,
  }) : _items = items;

  factory _$DamageReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$DamageReportImplFromJson(json);

  @override
  @JsonKey(name: 'clientId')
  final String id;
  // ClientId
  @override
  @JsonKey(name: 'id')
  final String? serverId;
  @override
  @JsonKey()
  final String reportNumber;
  @override
  @JsonKey()
  final String permanentFormNumber;
  @override
  @JsonKey()
  final String temporaryFormNumber;
  @override
  @JsonKey()
  final int damageYear;
  @override
  final String farmId;
  @override
  final String farmerId;
  @override
  final DateTime damageDate;
  @override
  final DateTime documentationDate;
  @override
  @JsonKey()
  final int damageNatureId;
  @override
  @JsonKey()
  final int damageCauseCategoryId;
  @override
  @JsonKey()
  final int damageCauseId;
  @override
  final String? settlementName;
  @override
  final String? companyName;
  @override
  final String governorateId;
  @override
  final String directorateId;
  @override
  final String localityId;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String statusId;
  @override
  final String notes;
  @override
  @JsonKey()
  final String rowVersion;
  final List<DamageItem> _items;
  @override
  @JsonKey()
  List<DamageItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final String syncStatus;
  @override
  final String? lastSyncError;
  @override
  final bool? isDeleted;
  @override
  final DateTime? deletedAt;
  @override
  final String? deletedBy;

  @override
  String toString() {
    return 'DamageReport(id: $id, serverId: $serverId, reportNumber: $reportNumber, permanentFormNumber: $permanentFormNumber, temporaryFormNumber: $temporaryFormNumber, damageYear: $damageYear, farmId: $farmId, farmerId: $farmerId, damageDate: $damageDate, documentationDate: $documentationDate, damageNatureId: $damageNatureId, damageCauseCategoryId: $damageCauseCategoryId, damageCauseId: $damageCauseId, settlementName: $settlementName, companyName: $companyName, governorateId: $governorateId, directorateId: $directorateId, localityId: $localityId, latitude: $latitude, longitude: $longitude, statusId: $statusId, notes: $notes, rowVersion: $rowVersion, items: $items, syncStatus: $syncStatus, lastSyncError: $lastSyncError, isDeleted: $isDeleted, deletedAt: $deletedAt, deletedBy: $deletedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DamageReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.reportNumber, reportNumber) ||
                other.reportNumber == reportNumber) &&
            (identical(other.permanentFormNumber, permanentFormNumber) ||
                other.permanentFormNumber == permanentFormNumber) &&
            (identical(other.temporaryFormNumber, temporaryFormNumber) ||
                other.temporaryFormNumber == temporaryFormNumber) &&
            (identical(other.damageYear, damageYear) ||
                other.damageYear == damageYear) &&
            (identical(other.farmId, farmId) || other.farmId == farmId) &&
            (identical(other.farmerId, farmerId) ||
                other.farmerId == farmerId) &&
            (identical(other.damageDate, damageDate) ||
                other.damageDate == damageDate) &&
            (identical(other.documentationDate, documentationDate) ||
                other.documentationDate == documentationDate) &&
            (identical(other.damageNatureId, damageNatureId) ||
                other.damageNatureId == damageNatureId) &&
            (identical(other.damageCauseCategoryId, damageCauseCategoryId) ||
                other.damageCauseCategoryId == damageCauseCategoryId) &&
            (identical(other.damageCauseId, damageCauseId) ||
                other.damageCauseId == damageCauseId) &&
            (identical(other.settlementName, settlementName) ||
                other.settlementName == settlementName) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.governorateId, governorateId) ||
                other.governorateId == governorateId) &&
            (identical(other.directorateId, directorateId) ||
                other.directorateId == directorateId) &&
            (identical(other.localityId, localityId) ||
                other.localityId == localityId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.statusId, statusId) ||
                other.statusId == statusId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.rowVersion, rowVersion) ||
                other.rowVersion == rowVersion) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.lastSyncError, lastSyncError) ||
                other.lastSyncError == lastSyncError) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.deletedBy, deletedBy) ||
                other.deletedBy == deletedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    serverId,
    reportNumber,
    permanentFormNumber,
    temporaryFormNumber,
    damageYear,
    farmId,
    farmerId,
    damageDate,
    documentationDate,
    damageNatureId,
    damageCauseCategoryId,
    damageCauseId,
    settlementName,
    companyName,
    governorateId,
    directorateId,
    localityId,
    latitude,
    longitude,
    statusId,
    notes,
    rowVersion,
    const DeepCollectionEquality().hash(_items),
    syncStatus,
    lastSyncError,
    isDeleted,
    deletedAt,
    deletedBy,
  ]);

  /// Create a copy of DamageReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DamageReportImplCopyWith<_$DamageReportImpl> get copyWith =>
      __$$DamageReportImplCopyWithImpl<_$DamageReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DamageReportImplToJson(this);
  }
}

abstract class _DamageReport implements DamageReport {
  const factory _DamageReport({
    @JsonKey(name: 'clientId') required final String id,
    @JsonKey(name: 'id') final String? serverId,
    final String reportNumber,
    final String permanentFormNumber,
    final String temporaryFormNumber,
    final int damageYear,
    required final String farmId,
    required final String farmerId,
    required final DateTime damageDate,
    required final DateTime documentationDate,
    final int damageNatureId,
    final int damageCauseCategoryId,
    final int damageCauseId,
    final String? settlementName,
    final String? companyName,
    required final String governorateId,
    required final String directorateId,
    required final String localityId,
    final double? latitude,
    final double? longitude,
    required final String statusId,
    required final String notes,
    final String rowVersion,
    final List<DamageItem> items,
    final String syncStatus,
    final String? lastSyncError,
    final bool? isDeleted,
    final DateTime? deletedAt,
    final String? deletedBy,
  }) = _$DamageReportImpl;

  factory _DamageReport.fromJson(Map<String, dynamic> json) =
      _$DamageReportImpl.fromJson;

  @override
  @JsonKey(name: 'clientId')
  String get id; // ClientId
  @override
  @JsonKey(name: 'id')
  String? get serverId;
  @override
  String get reportNumber;
  @override
  String get permanentFormNumber;
  @override
  String get temporaryFormNumber;
  @override
  int get damageYear;
  @override
  String get farmId;
  @override
  String get farmerId;
  @override
  DateTime get damageDate;
  @override
  DateTime get documentationDate;
  @override
  int get damageNatureId;
  @override
  int get damageCauseCategoryId;
  @override
  int get damageCauseId;
  @override
  String? get settlementName;
  @override
  String? get companyName;
  @override
  String get governorateId;
  @override
  String get directorateId;
  @override
  String get localityId;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String get statusId;
  @override
  String get notes;
  @override
  String get rowVersion;
  @override
  List<DamageItem> get items;
  @override
  String get syncStatus;
  @override
  String? get lastSyncError;
  @override
  bool? get isDeleted;
  @override
  DateTime? get deletedAt;
  @override
  String? get deletedBy;

  /// Create a copy of DamageReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DamageReportImplCopyWith<_$DamageReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
