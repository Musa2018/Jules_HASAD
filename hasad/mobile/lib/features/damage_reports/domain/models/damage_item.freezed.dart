// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'damage_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DamageItem _$DamageItemFromJson(Map<String, dynamic> json) {
  return _DamageItem.fromJson(json);
}

/// @nodoc
mixin _$DamageItem {
  @JsonKey(name: 'clientId')
  String get id => throw _privateConstructorUsedError; // ClientId
  @JsonKey(name: 'id')
  String? get serverId => throw _privateConstructorUsedError;
  String get damageReportId => throw _privateConstructorUsedError;
  int get classificationId => throw _privateConstructorUsedError;
  @Deprecated('Use costingSheetItemId. Kept for backend sync compatibility.')
  String get costingSheetId => throw _privateConstructorUsedError;
  String? get costingSheetItemId => throw _privateConstructorUsedError;
  double get calculatedUnitPrice => throw _privateConstructorUsedError;
  String get measurementUnitSnapshot => throw _privateConstructorUsedError;
  double get affectedArea => throw _privateConstructorUsedError;
  double get damagePercentage => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  double get estimatedLoss => throw _privateConstructorUsedError;
  String get rowVersion => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;
  String? get lastSyncError => throw _privateConstructorUsedError;
  bool? get isDeleted => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String? get deletedBy => throw _privateConstructorUsedError;

  /// Serializes this DamageItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DamageItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DamageItemCopyWith<DamageItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DamageItemCopyWith<$Res> {
  factory $DamageItemCopyWith(
    DamageItem value,
    $Res Function(DamageItem) then,
  ) = _$DamageItemCopyWithImpl<$Res, DamageItem>;
  @useResult
  $Res call({
    @JsonKey(name: 'clientId') String id,
    @JsonKey(name: 'id') String? serverId,
    String damageReportId,
    int classificationId,
    @Deprecated('Use costingSheetItemId. Kept for backend sync compatibility.')
    String costingSheetId,
    String? costingSheetItemId,
    double calculatedUnitPrice,
    String measurementUnitSnapshot,
    double affectedArea,
    double damagePercentage,
    double quantity,
    double estimatedLoss,
    String rowVersion,
    String syncStatus,
    String? lastSyncError,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
  });
}

/// @nodoc
class _$DamageItemCopyWithImpl<$Res, $Val extends DamageItem>
    implements $DamageItemCopyWith<$Res> {
  _$DamageItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DamageItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? damageReportId = null,
    Object? classificationId = null,
    Object? costingSheetId = null,
    Object? costingSheetItemId = freezed,
    Object? calculatedUnitPrice = null,
    Object? measurementUnitSnapshot = null,
    Object? affectedArea = null,
    Object? damagePercentage = null,
    Object? quantity = null,
    Object? estimatedLoss = null,
    Object? rowVersion = null,
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
            damageReportId: null == damageReportId
                ? _value.damageReportId
                : damageReportId // ignore: cast_nullable_to_non_nullable
                      as String,
            classificationId: null == classificationId
                ? _value.classificationId
                : classificationId // ignore: cast_nullable_to_non_nullable
                      as int,
            costingSheetId: null == costingSheetId
                ? _value.costingSheetId
                : costingSheetId // ignore: cast_nullable_to_non_nullable
                      as String,
            costingSheetItemId: freezed == costingSheetItemId
                ? _value.costingSheetItemId
                : costingSheetItemId // ignore: cast_nullable_to_non_nullable
                      as String?,
            calculatedUnitPrice: null == calculatedUnitPrice
                ? _value.calculatedUnitPrice
                : calculatedUnitPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            measurementUnitSnapshot: null == measurementUnitSnapshot
                ? _value.measurementUnitSnapshot
                : measurementUnitSnapshot // ignore: cast_nullable_to_non_nullable
                      as String,
            affectedArea: null == affectedArea
                ? _value.affectedArea
                : affectedArea // ignore: cast_nullable_to_non_nullable
                      as double,
            damagePercentage: null == damagePercentage
                ? _value.damagePercentage
                : damagePercentage // ignore: cast_nullable_to_non_nullable
                      as double,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            estimatedLoss: null == estimatedLoss
                ? _value.estimatedLoss
                : estimatedLoss // ignore: cast_nullable_to_non_nullable
                      as double,
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
abstract class _$$DamageItemImplCopyWith<$Res>
    implements $DamageItemCopyWith<$Res> {
  factory _$$DamageItemImplCopyWith(
    _$DamageItemImpl value,
    $Res Function(_$DamageItemImpl) then,
  ) = __$$DamageItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'clientId') String id,
    @JsonKey(name: 'id') String? serverId,
    String damageReportId,
    int classificationId,
    @Deprecated('Use costingSheetItemId. Kept for backend sync compatibility.')
    String costingSheetId,
    String? costingSheetItemId,
    double calculatedUnitPrice,
    String measurementUnitSnapshot,
    double affectedArea,
    double damagePercentage,
    double quantity,
    double estimatedLoss,
    String rowVersion,
    String syncStatus,
    String? lastSyncError,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
  });
}

/// @nodoc
class __$$DamageItemImplCopyWithImpl<$Res>
    extends _$DamageItemCopyWithImpl<$Res, _$DamageItemImpl>
    implements _$$DamageItemImplCopyWith<$Res> {
  __$$DamageItemImplCopyWithImpl(
    _$DamageItemImpl _value,
    $Res Function(_$DamageItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DamageItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? damageReportId = null,
    Object? classificationId = null,
    Object? costingSheetId = null,
    Object? costingSheetItemId = freezed,
    Object? calculatedUnitPrice = null,
    Object? measurementUnitSnapshot = null,
    Object? affectedArea = null,
    Object? damagePercentage = null,
    Object? quantity = null,
    Object? estimatedLoss = null,
    Object? rowVersion = null,
    Object? syncStatus = null,
    Object? lastSyncError = freezed,
    Object? isDeleted = freezed,
    Object? deletedAt = freezed,
    Object? deletedBy = freezed,
  }) {
    return _then(
      _$DamageItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        serverId: freezed == serverId
            ? _value.serverId
            : serverId // ignore: cast_nullable_to_non_nullable
                  as String?,
        damageReportId: null == damageReportId
            ? _value.damageReportId
            : damageReportId // ignore: cast_nullable_to_non_nullable
                  as String,
        classificationId: null == classificationId
            ? _value.classificationId
            : classificationId // ignore: cast_nullable_to_non_nullable
                  as int,
        costingSheetId: null == costingSheetId
            ? _value.costingSheetId
            : costingSheetId // ignore: cast_nullable_to_non_nullable
                  as String,
        costingSheetItemId: freezed == costingSheetItemId
            ? _value.costingSheetItemId
            : costingSheetItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        calculatedUnitPrice: null == calculatedUnitPrice
            ? _value.calculatedUnitPrice
            : calculatedUnitPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        measurementUnitSnapshot: null == measurementUnitSnapshot
            ? _value.measurementUnitSnapshot
            : measurementUnitSnapshot // ignore: cast_nullable_to_non_nullable
                  as String,
        affectedArea: null == affectedArea
            ? _value.affectedArea
            : affectedArea // ignore: cast_nullable_to_non_nullable
                  as double,
        damagePercentage: null == damagePercentage
            ? _value.damagePercentage
            : damagePercentage // ignore: cast_nullable_to_non_nullable
                  as double,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        estimatedLoss: null == estimatedLoss
            ? _value.estimatedLoss
            : estimatedLoss // ignore: cast_nullable_to_non_nullable
                  as double,
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
class _$DamageItemImpl implements _DamageItem {
  const _$DamageItemImpl({
    @JsonKey(name: 'clientId') required this.id,
    @JsonKey(name: 'id') this.serverId,
    required this.damageReportId,
    this.classificationId = 0,
    @Deprecated('Use costingSheetItemId. Kept for backend sync compatibility.')
    this.costingSheetId = '',
    this.costingSheetItemId,
    this.calculatedUnitPrice = 0.0,
    this.measurementUnitSnapshot = '',
    required this.affectedArea,
    required this.damagePercentage,
    required this.quantity,
    required this.estimatedLoss,
    this.rowVersion = '',
    this.syncStatus = 'completed',
    this.lastSyncError,
    this.isDeleted,
    this.deletedAt,
    this.deletedBy,
  });

  factory _$DamageItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$DamageItemImplFromJson(json);

  @override
  @JsonKey(name: 'clientId')
  final String id;
  // ClientId
  @override
  @JsonKey(name: 'id')
  final String? serverId;
  @override
  final String damageReportId;
  @override
  @JsonKey()
  final int classificationId;
  @override
  @JsonKey()
  @Deprecated('Use costingSheetItemId. Kept for backend sync compatibility.')
  final String costingSheetId;
  @override
  final String? costingSheetItemId;
  @override
  @JsonKey()
  final double calculatedUnitPrice;
  @override
  @JsonKey()
  final String measurementUnitSnapshot;
  @override
  final double affectedArea;
  @override
  final double damagePercentage;
  @override
  final double quantity;
  @override
  final double estimatedLoss;
  @override
  @JsonKey()
  final String rowVersion;
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
    return 'DamageItem(id: $id, serverId: $serverId, damageReportId: $damageReportId, classificationId: $classificationId, costingSheetId: $costingSheetId, costingSheetItemId: $costingSheetItemId, calculatedUnitPrice: $calculatedUnitPrice, measurementUnitSnapshot: $measurementUnitSnapshot, affectedArea: $affectedArea, damagePercentage: $damagePercentage, quantity: $quantity, estimatedLoss: $estimatedLoss, rowVersion: $rowVersion, syncStatus: $syncStatus, lastSyncError: $lastSyncError, isDeleted: $isDeleted, deletedAt: $deletedAt, deletedBy: $deletedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DamageItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.damageReportId, damageReportId) ||
                other.damageReportId == damageReportId) &&
            (identical(other.classificationId, classificationId) ||
                other.classificationId == classificationId) &&
            (identical(other.costingSheetId, costingSheetId) ||
                other.costingSheetId == costingSheetId) &&
            (identical(other.costingSheetItemId, costingSheetItemId) ||
                other.costingSheetItemId == costingSheetItemId) &&
            (identical(other.calculatedUnitPrice, calculatedUnitPrice) ||
                other.calculatedUnitPrice == calculatedUnitPrice) &&
            (identical(
                  other.measurementUnitSnapshot,
                  measurementUnitSnapshot,
                ) ||
                other.measurementUnitSnapshot == measurementUnitSnapshot) &&
            (identical(other.affectedArea, affectedArea) ||
                other.affectedArea == affectedArea) &&
            (identical(other.damagePercentage, damagePercentage) ||
                other.damagePercentage == damagePercentage) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.estimatedLoss, estimatedLoss) ||
                other.estimatedLoss == estimatedLoss) &&
            (identical(other.rowVersion, rowVersion) ||
                other.rowVersion == rowVersion) &&
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
  int get hashCode => Object.hash(
    runtimeType,
    id,
    serverId,
    damageReportId,
    classificationId,
    costingSheetId,
    costingSheetItemId,
    calculatedUnitPrice,
    measurementUnitSnapshot,
    affectedArea,
    damagePercentage,
    quantity,
    estimatedLoss,
    rowVersion,
    syncStatus,
    lastSyncError,
    isDeleted,
    deletedAt,
    deletedBy,
  );

  /// Create a copy of DamageItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DamageItemImplCopyWith<_$DamageItemImpl> get copyWith =>
      __$$DamageItemImplCopyWithImpl<_$DamageItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DamageItemImplToJson(this);
  }
}

abstract class _DamageItem implements DamageItem {
  const factory _DamageItem({
    @JsonKey(name: 'clientId') required final String id,
    @JsonKey(name: 'id') final String? serverId,
    required final String damageReportId,
    final int classificationId,
    @Deprecated('Use costingSheetItemId. Kept for backend sync compatibility.')
    final String costingSheetId,
    final String? costingSheetItemId,
    final double calculatedUnitPrice,
    final String measurementUnitSnapshot,
    required final double affectedArea,
    required final double damagePercentage,
    required final double quantity,
    required final double estimatedLoss,
    final String rowVersion,
    final String syncStatus,
    final String? lastSyncError,
    final bool? isDeleted,
    final DateTime? deletedAt,
    final String? deletedBy,
  }) = _$DamageItemImpl;

  factory _DamageItem.fromJson(Map<String, dynamic> json) =
      _$DamageItemImpl.fromJson;

  @override
  @JsonKey(name: 'clientId')
  String get id; // ClientId
  @override
  @JsonKey(name: 'id')
  String? get serverId;
  @override
  String get damageReportId;
  @override
  int get classificationId;
  @override
  @Deprecated('Use costingSheetItemId. Kept for backend sync compatibility.')
  String get costingSheetId;
  @override
  String? get costingSheetItemId;
  @override
  double get calculatedUnitPrice;
  @override
  String get measurementUnitSnapshot;
  @override
  double get affectedArea;
  @override
  double get damagePercentage;
  @override
  double get quantity;
  @override
  double get estimatedLoss;
  @override
  String get rowVersion;
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

  /// Create a copy of DamageItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DamageItemImplCopyWith<_$DamageItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
