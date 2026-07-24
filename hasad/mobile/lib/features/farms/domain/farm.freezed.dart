// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Farm _$FarmFromJson(Map<String, dynamic> json) {
  return _Farm.fromJson(json);
}

/// @nodoc
mixin _$Farm {
  @JsonKey(name: 'clientId')
  String get id => throw _privateConstructorUsedError; // ClientId
  @JsonKey(name: 'id')
  String? get serverId => throw _privateConstructorUsedError;
  String get farmerId => throw _privateConstructorUsedError;
  String get localFarmName => throw _privateConstructorUsedError;
  int get ownershipTypeId => throw _privateConstructorUsedError;
  String? get ownerFarmerId => throw _privateConstructorUsedError;
  int? get relationshipToOwnerId =>
      throw _privateConstructorUsedError; // Geography
  String get governorateId => throw _privateConstructorUsedError;
  String get directorateId => throw _privateConstructorUsedError;
  String get localityId => throw _privateConstructorUsedError;
  String get basin => throw _privateConstructorUsedError;
  String get parcel => throw _privateConstructorUsedError; // Area
  double get area => throw _privateConstructorUsedError;
  @Deprecated('Use measurementUnitId. Kept for backend sync compatibility.')
  int get areaUnitId => throw _privateConstructorUsedError;
  int? get measurementUnitId =>
      throw _privateConstructorUsedError; // Agriculture
  int get agriculturalSectorId => throw _privateConstructorUsedError;
  int get politicalClassificationId =>
      throw _privateConstructorUsedError; // Location
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError; // Sync & Metadata
  String get rowVersion => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;
  String? get lastSyncError => throw _privateConstructorUsedError;
  bool get isPendingDelete => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Soft Delete from backend
  bool get isDeleted => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String? get deletedBy => throw _privateConstructorUsedError;

  /// Serializes this Farm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Farm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FarmCopyWith<Farm> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FarmCopyWith<$Res> {
  factory $FarmCopyWith(Farm value, $Res Function(Farm) then) =
      _$FarmCopyWithImpl<$Res, Farm>;
  @useResult
  $Res call({
    @JsonKey(name: 'clientId') String id,
    @JsonKey(name: 'id') String? serverId,
    String farmerId,
    String localFarmName,
    int ownershipTypeId,
    String? ownerFarmerId,
    int? relationshipToOwnerId,
    String governorateId,
    String directorateId,
    String localityId,
    String basin,
    String parcel,
    double area,
    @Deprecated('Use measurementUnitId. Kept for backend sync compatibility.')
    int areaUnitId,
    int? measurementUnitId,
    int agriculturalSectorId,
    int politicalClassificationId,
    double? latitude,
    double? longitude,
    String? notes,
    String rowVersion,
    String syncStatus,
    String? lastSyncError,
    bool isPendingDelete,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
  });
}

/// @nodoc
class _$FarmCopyWithImpl<$Res, $Val extends Farm>
    implements $FarmCopyWith<$Res> {
  _$FarmCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Farm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? farmerId = null,
    Object? localFarmName = null,
    Object? ownershipTypeId = null,
    Object? ownerFarmerId = freezed,
    Object? relationshipToOwnerId = freezed,
    Object? governorateId = null,
    Object? directorateId = null,
    Object? localityId = null,
    Object? basin = null,
    Object? parcel = null,
    Object? area = null,
    Object? areaUnitId = null,
    Object? measurementUnitId = freezed,
    Object? agriculturalSectorId = null,
    Object? politicalClassificationId = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? notes = freezed,
    Object? rowVersion = null,
    Object? syncStatus = null,
    Object? lastSyncError = freezed,
    Object? isPendingDelete = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isDeleted = null,
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
            farmerId: null == farmerId
                ? _value.farmerId
                : farmerId // ignore: cast_nullable_to_non_nullable
                      as String,
            localFarmName: null == localFarmName
                ? _value.localFarmName
                : localFarmName // ignore: cast_nullable_to_non_nullable
                      as String,
            ownershipTypeId: null == ownershipTypeId
                ? _value.ownershipTypeId
                : ownershipTypeId // ignore: cast_nullable_to_non_nullable
                      as int,
            ownerFarmerId: freezed == ownerFarmerId
                ? _value.ownerFarmerId
                : ownerFarmerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            relationshipToOwnerId: freezed == relationshipToOwnerId
                ? _value.relationshipToOwnerId
                : relationshipToOwnerId // ignore: cast_nullable_to_non_nullable
                      as int?,
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
            basin: null == basin
                ? _value.basin
                : basin // ignore: cast_nullable_to_non_nullable
                      as String,
            parcel: null == parcel
                ? _value.parcel
                : parcel // ignore: cast_nullable_to_non_nullable
                      as String,
            area: null == area
                ? _value.area
                : area // ignore: cast_nullable_to_non_nullable
                      as double,
            areaUnitId: null == areaUnitId
                ? _value.areaUnitId
                : areaUnitId // ignore: cast_nullable_to_non_nullable
                      as int,
            measurementUnitId: freezed == measurementUnitId
                ? _value.measurementUnitId
                : measurementUnitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            agriculturalSectorId: null == agriculturalSectorId
                ? _value.agriculturalSectorId
                : agriculturalSectorId // ignore: cast_nullable_to_non_nullable
                      as int,
            politicalClassificationId: null == politicalClassificationId
                ? _value.politicalClassificationId
                : politicalClassificationId // ignore: cast_nullable_to_non_nullable
                      as int,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            rowVersion: null == rowVersion
                ? _value.rowVersion
                : rowVersion // ignore: cast_nullable_to_non_nullable
                      as String,
            syncStatus: null == syncStatus
                ? _value.syncStatus
                : syncStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            lastSyncError: freezed == lastSyncError
                ? _value.lastSyncError
                : lastSyncError // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPendingDelete: null == isPendingDelete
                ? _value.isPendingDelete
                : isPendingDelete // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isDeleted: null == isDeleted
                ? _value.isDeleted
                : isDeleted // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$FarmImplCopyWith<$Res> implements $FarmCopyWith<$Res> {
  factory _$$FarmImplCopyWith(
    _$FarmImpl value,
    $Res Function(_$FarmImpl) then,
  ) = __$$FarmImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'clientId') String id,
    @JsonKey(name: 'id') String? serverId,
    String farmerId,
    String localFarmName,
    int ownershipTypeId,
    String? ownerFarmerId,
    int? relationshipToOwnerId,
    String governorateId,
    String directorateId,
    String localityId,
    String basin,
    String parcel,
    double area,
    @Deprecated('Use measurementUnitId. Kept for backend sync compatibility.')
    int areaUnitId,
    int? measurementUnitId,
    int agriculturalSectorId,
    int politicalClassificationId,
    double? latitude,
    double? longitude,
    String? notes,
    String rowVersion,
    String syncStatus,
    String? lastSyncError,
    bool isPendingDelete,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
  });
}

/// @nodoc
class __$$FarmImplCopyWithImpl<$Res>
    extends _$FarmCopyWithImpl<$Res, _$FarmImpl>
    implements _$$FarmImplCopyWith<$Res> {
  __$$FarmImplCopyWithImpl(_$FarmImpl _value, $Res Function(_$FarmImpl) _then)
    : super(_value, _then);

  /// Create a copy of Farm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? farmerId = null,
    Object? localFarmName = null,
    Object? ownershipTypeId = null,
    Object? ownerFarmerId = freezed,
    Object? relationshipToOwnerId = freezed,
    Object? governorateId = null,
    Object? directorateId = null,
    Object? localityId = null,
    Object? basin = null,
    Object? parcel = null,
    Object? area = null,
    Object? areaUnitId = null,
    Object? measurementUnitId = freezed,
    Object? agriculturalSectorId = null,
    Object? politicalClassificationId = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? notes = freezed,
    Object? rowVersion = null,
    Object? syncStatus = null,
    Object? lastSyncError = freezed,
    Object? isPendingDelete = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? deletedBy = freezed,
  }) {
    return _then(
      _$FarmImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        serverId: freezed == serverId
            ? _value.serverId
            : serverId // ignore: cast_nullable_to_non_nullable
                  as String?,
        farmerId: null == farmerId
            ? _value.farmerId
            : farmerId // ignore: cast_nullable_to_non_nullable
                  as String,
        localFarmName: null == localFarmName
            ? _value.localFarmName
            : localFarmName // ignore: cast_nullable_to_non_nullable
                  as String,
        ownershipTypeId: null == ownershipTypeId
            ? _value.ownershipTypeId
            : ownershipTypeId // ignore: cast_nullable_to_non_nullable
                  as int,
        ownerFarmerId: freezed == ownerFarmerId
            ? _value.ownerFarmerId
            : ownerFarmerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        relationshipToOwnerId: freezed == relationshipToOwnerId
            ? _value.relationshipToOwnerId
            : relationshipToOwnerId // ignore: cast_nullable_to_non_nullable
                  as int?,
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
        basin: null == basin
            ? _value.basin
            : basin // ignore: cast_nullable_to_non_nullable
                  as String,
        parcel: null == parcel
            ? _value.parcel
            : parcel // ignore: cast_nullable_to_non_nullable
                  as String,
        area: null == area
            ? _value.area
            : area // ignore: cast_nullable_to_non_nullable
                  as double,
        areaUnitId: null == areaUnitId
            ? _value.areaUnitId
            : areaUnitId // ignore: cast_nullable_to_non_nullable
                  as int,
        measurementUnitId: freezed == measurementUnitId
            ? _value.measurementUnitId
            : measurementUnitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        agriculturalSectorId: null == agriculturalSectorId
            ? _value.agriculturalSectorId
            : agriculturalSectorId // ignore: cast_nullable_to_non_nullable
                  as int,
        politicalClassificationId: null == politicalClassificationId
            ? _value.politicalClassificationId
            : politicalClassificationId // ignore: cast_nullable_to_non_nullable
                  as int,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        rowVersion: null == rowVersion
            ? _value.rowVersion
            : rowVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        syncStatus: null == syncStatus
            ? _value.syncStatus
            : syncStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        lastSyncError: freezed == lastSyncError
            ? _value.lastSyncError
            : lastSyncError // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPendingDelete: null == isPendingDelete
            ? _value.isPendingDelete
            : isPendingDelete // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isDeleted: null == isDeleted
            ? _value.isDeleted
            : isDeleted // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$FarmImpl implements _Farm {
  const _$FarmImpl({
    @JsonKey(name: 'clientId') required this.id,
    @JsonKey(name: 'id') this.serverId,
    required this.farmerId,
    required this.localFarmName,
    required this.ownershipTypeId,
    this.ownerFarmerId,
    this.relationshipToOwnerId,
    required this.governorateId,
    required this.directorateId,
    required this.localityId,
    required this.basin,
    required this.parcel,
    required this.area,
    @Deprecated('Use measurementUnitId. Kept for backend sync compatibility.')
    required this.areaUnitId,
    this.measurementUnitId,
    required this.agriculturalSectorId,
    required this.politicalClassificationId,
    this.latitude,
    this.longitude,
    this.notes,
    this.rowVersion = '',
    this.syncStatus = 'completed',
    this.lastSyncError,
    this.isPendingDelete = false,
    this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.deletedBy,
  });

  factory _$FarmImpl.fromJson(Map<String, dynamic> json) =>
      _$$FarmImplFromJson(json);

  @override
  @JsonKey(name: 'clientId')
  final String id;
  // ClientId
  @override
  @JsonKey(name: 'id')
  final String? serverId;
  @override
  final String farmerId;
  @override
  final String localFarmName;
  @override
  final int ownershipTypeId;
  @override
  final String? ownerFarmerId;
  @override
  final int? relationshipToOwnerId;
  // Geography
  @override
  final String governorateId;
  @override
  final String directorateId;
  @override
  final String localityId;
  @override
  final String basin;
  @override
  final String parcel;
  // Area
  @override
  final double area;
  @override
  @Deprecated('Use measurementUnitId. Kept for backend sync compatibility.')
  final int areaUnitId;
  @override
  final int? measurementUnitId;
  // Agriculture
  @override
  final int agriculturalSectorId;
  @override
  final int politicalClassificationId;
  // Location
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? notes;
  // Sync & Metadata
  @override
  @JsonKey()
  final String rowVersion;
  @override
  @JsonKey()
  final String syncStatus;
  @override
  final String? lastSyncError;
  @override
  @JsonKey()
  final bool isPendingDelete;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  // Soft Delete from backend
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  final DateTime? deletedAt;
  @override
  final String? deletedBy;

  @override
  String toString() {
    return 'Farm(id: $id, serverId: $serverId, farmerId: $farmerId, localFarmName: $localFarmName, ownershipTypeId: $ownershipTypeId, ownerFarmerId: $ownerFarmerId, relationshipToOwnerId: $relationshipToOwnerId, governorateId: $governorateId, directorateId: $directorateId, localityId: $localityId, basin: $basin, parcel: $parcel, area: $area, areaUnitId: $areaUnitId, measurementUnitId: $measurementUnitId, agriculturalSectorId: $agriculturalSectorId, politicalClassificationId: $politicalClassificationId, latitude: $latitude, longitude: $longitude, notes: $notes, rowVersion: $rowVersion, syncStatus: $syncStatus, lastSyncError: $lastSyncError, isPendingDelete: $isPendingDelete, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, deletedAt: $deletedAt, deletedBy: $deletedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FarmImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.farmerId, farmerId) ||
                other.farmerId == farmerId) &&
            (identical(other.localFarmName, localFarmName) ||
                other.localFarmName == localFarmName) &&
            (identical(other.ownershipTypeId, ownershipTypeId) ||
                other.ownershipTypeId == ownershipTypeId) &&
            (identical(other.ownerFarmerId, ownerFarmerId) ||
                other.ownerFarmerId == ownerFarmerId) &&
            (identical(other.relationshipToOwnerId, relationshipToOwnerId) ||
                other.relationshipToOwnerId == relationshipToOwnerId) &&
            (identical(other.governorateId, governorateId) ||
                other.governorateId == governorateId) &&
            (identical(other.directorateId, directorateId) ||
                other.directorateId == directorateId) &&
            (identical(other.localityId, localityId) ||
                other.localityId == localityId) &&
            (identical(other.basin, basin) || other.basin == basin) &&
            (identical(other.parcel, parcel) || other.parcel == parcel) &&
            (identical(other.area, area) || other.area == area) &&
            (identical(other.areaUnitId, areaUnitId) ||
                other.areaUnitId == areaUnitId) &&
            (identical(other.measurementUnitId, measurementUnitId) ||
                other.measurementUnitId == measurementUnitId) &&
            (identical(other.agriculturalSectorId, agriculturalSectorId) ||
                other.agriculturalSectorId == agriculturalSectorId) &&
            (identical(
                  other.politicalClassificationId,
                  politicalClassificationId,
                ) ||
                other.politicalClassificationId == politicalClassificationId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.rowVersion, rowVersion) ||
                other.rowVersion == rowVersion) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.lastSyncError, lastSyncError) ||
                other.lastSyncError == lastSyncError) &&
            (identical(other.isPendingDelete, isPendingDelete) ||
                other.isPendingDelete == isPendingDelete) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
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
    farmerId,
    localFarmName,
    ownershipTypeId,
    ownerFarmerId,
    relationshipToOwnerId,
    governorateId,
    directorateId,
    localityId,
    basin,
    parcel,
    area,
    areaUnitId,
    measurementUnitId,
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
    isDeleted,
    deletedAt,
    deletedBy,
  ]);

  /// Create a copy of Farm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FarmImplCopyWith<_$FarmImpl> get copyWith =>
      __$$FarmImplCopyWithImpl<_$FarmImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FarmImplToJson(this);
  }
}

abstract class _Farm implements Farm {
  const factory _Farm({
    @JsonKey(name: 'clientId') required final String id,
    @JsonKey(name: 'id') final String? serverId,
    required final String farmerId,
    required final String localFarmName,
    required final int ownershipTypeId,
    final String? ownerFarmerId,
    final int? relationshipToOwnerId,
    required final String governorateId,
    required final String directorateId,
    required final String localityId,
    required final String basin,
    required final String parcel,
    required final double area,
    @Deprecated('Use measurementUnitId. Kept for backend sync compatibility.')
    required final int areaUnitId,
    final int? measurementUnitId,
    required final int agriculturalSectorId,
    required final int politicalClassificationId,
    final double? latitude,
    final double? longitude,
    final String? notes,
    final String rowVersion,
    final String syncStatus,
    final String? lastSyncError,
    final bool isPendingDelete,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final bool isDeleted,
    final DateTime? deletedAt,
    final String? deletedBy,
  }) = _$FarmImpl;

  factory _Farm.fromJson(Map<String, dynamic> json) = _$FarmImpl.fromJson;

  @override
  @JsonKey(name: 'clientId')
  String get id; // ClientId
  @override
  @JsonKey(name: 'id')
  String? get serverId;
  @override
  String get farmerId;
  @override
  String get localFarmName;
  @override
  int get ownershipTypeId;
  @override
  String? get ownerFarmerId;
  @override
  int? get relationshipToOwnerId; // Geography
  @override
  String get governorateId;
  @override
  String get directorateId;
  @override
  String get localityId;
  @override
  String get basin;
  @override
  String get parcel; // Area
  @override
  double get area;
  @override
  @Deprecated('Use measurementUnitId. Kept for backend sync compatibility.')
  int get areaUnitId;
  @override
  int? get measurementUnitId; // Agriculture
  @override
  int get agriculturalSectorId;
  @override
  int get politicalClassificationId; // Location
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get notes; // Sync & Metadata
  @override
  String get rowVersion;
  @override
  String get syncStatus;
  @override
  String? get lastSyncError;
  @override
  bool get isPendingDelete;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Soft Delete from backend
  @override
  bool get isDeleted;
  @override
  DateTime? get deletedAt;
  @override
  String? get deletedBy;

  /// Create a copy of Farm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FarmImplCopyWith<_$FarmImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
