// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'damage_workflow_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DamageWorkflowHistory _$DamageWorkflowHistoryFromJson(
  Map<String, dynamic> json,
) {
  return _DamageWorkflowHistory.fromJson(json);
}

/// @nodoc
mixin _$DamageWorkflowHistory {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'serverId')
  String? get serverId => throw _privateConstructorUsedError;
  String get damageReportId => throw _privateConstructorUsedError;
  String get fromStatus => throw _privateConstructorUsedError;
  String get toStatus => throw _privateConstructorUsedError;
  String get changedByUserId => throw _privateConstructorUsedError;
  DateTime get changedAt => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  bool get isOverride => throw _privateConstructorUsedError;

  /// Serializes this DamageWorkflowHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DamageWorkflowHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DamageWorkflowHistoryCopyWith<DamageWorkflowHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DamageWorkflowHistoryCopyWith<$Res> {
  factory $DamageWorkflowHistoryCopyWith(
    DamageWorkflowHistory value,
    $Res Function(DamageWorkflowHistory) then,
  ) = _$DamageWorkflowHistoryCopyWithImpl<$Res, DamageWorkflowHistory>;
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'serverId') String? serverId,
    String damageReportId,
    String fromStatus,
    String toStatus,
    String changedByUserId,
    DateTime changedAt,
    String? comment,
    bool isOverride,
  });
}

/// @nodoc
class _$DamageWorkflowHistoryCopyWithImpl<
  $Res,
  $Val extends DamageWorkflowHistory
>
    implements $DamageWorkflowHistoryCopyWith<$Res> {
  _$DamageWorkflowHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DamageWorkflowHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? damageReportId = null,
    Object? fromStatus = null,
    Object? toStatus = null,
    Object? changedByUserId = null,
    Object? changedAt = null,
    Object? comment = freezed,
    Object? isOverride = null,
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
            fromStatus: null == fromStatus
                ? _value.fromStatus
                : fromStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            toStatus: null == toStatus
                ? _value.toStatus
                : toStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            changedByUserId: null == changedByUserId
                ? _value.changedByUserId
                : changedByUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            changedAt: null == changedAt
                ? _value.changedAt
                : changedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOverride: null == isOverride
                ? _value.isOverride
                : isOverride // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DamageWorkflowHistoryImplCopyWith<$Res>
    implements $DamageWorkflowHistoryCopyWith<$Res> {
  factory _$$DamageWorkflowHistoryImplCopyWith(
    _$DamageWorkflowHistoryImpl value,
    $Res Function(_$DamageWorkflowHistoryImpl) then,
  ) = __$$DamageWorkflowHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'serverId') String? serverId,
    String damageReportId,
    String fromStatus,
    String toStatus,
    String changedByUserId,
    DateTime changedAt,
    String? comment,
    bool isOverride,
  });
}

/// @nodoc
class __$$DamageWorkflowHistoryImplCopyWithImpl<$Res>
    extends
        _$DamageWorkflowHistoryCopyWithImpl<$Res, _$DamageWorkflowHistoryImpl>
    implements _$$DamageWorkflowHistoryImplCopyWith<$Res> {
  __$$DamageWorkflowHistoryImplCopyWithImpl(
    _$DamageWorkflowHistoryImpl _value,
    $Res Function(_$DamageWorkflowHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DamageWorkflowHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? damageReportId = null,
    Object? fromStatus = null,
    Object? toStatus = null,
    Object? changedByUserId = null,
    Object? changedAt = null,
    Object? comment = freezed,
    Object? isOverride = null,
  }) {
    return _then(
      _$DamageWorkflowHistoryImpl(
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
        fromStatus: null == fromStatus
            ? _value.fromStatus
            : fromStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        toStatus: null == toStatus
            ? _value.toStatus
            : toStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        changedByUserId: null == changedByUserId
            ? _value.changedByUserId
            : changedByUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        changedAt: null == changedAt
            ? _value.changedAt
            : changedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOverride: null == isOverride
            ? _value.isOverride
            : isOverride // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DamageWorkflowHistoryImpl implements _DamageWorkflowHistory {
  const _$DamageWorkflowHistoryImpl({
    @JsonKey(name: 'id') required this.id,
    @JsonKey(name: 'serverId') this.serverId,
    required this.damageReportId,
    required this.fromStatus,
    required this.toStatus,
    required this.changedByUserId,
    required this.changedAt,
    this.comment,
    this.isOverride = false,
  });

  factory _$DamageWorkflowHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DamageWorkflowHistoryImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'serverId')
  final String? serverId;
  @override
  final String damageReportId;
  @override
  final String fromStatus;
  @override
  final String toStatus;
  @override
  final String changedByUserId;
  @override
  final DateTime changedAt;
  @override
  final String? comment;
  @override
  @JsonKey()
  final bool isOverride;

  @override
  String toString() {
    return 'DamageWorkflowHistory(id: $id, serverId: $serverId, damageReportId: $damageReportId, fromStatus: $fromStatus, toStatus: $toStatus, changedByUserId: $changedByUserId, changedAt: $changedAt, comment: $comment, isOverride: $isOverride)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DamageWorkflowHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.damageReportId, damageReportId) ||
                other.damageReportId == damageReportId) &&
            (identical(other.fromStatus, fromStatus) ||
                other.fromStatus == fromStatus) &&
            (identical(other.toStatus, toStatus) ||
                other.toStatus == toStatus) &&
            (identical(other.changedByUserId, changedByUserId) ||
                other.changedByUserId == changedByUserId) &&
            (identical(other.changedAt, changedAt) ||
                other.changedAt == changedAt) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.isOverride, isOverride) ||
                other.isOverride == isOverride));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
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

  /// Create a copy of DamageWorkflowHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DamageWorkflowHistoryImplCopyWith<_$DamageWorkflowHistoryImpl>
  get copyWith =>
      __$$DamageWorkflowHistoryImplCopyWithImpl<_$DamageWorkflowHistoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DamageWorkflowHistoryImplToJson(this);
  }
}

abstract class _DamageWorkflowHistory implements DamageWorkflowHistory {
  const factory _DamageWorkflowHistory({
    @JsonKey(name: 'id') required final String id,
    @JsonKey(name: 'serverId') final String? serverId,
    required final String damageReportId,
    required final String fromStatus,
    required final String toStatus,
    required final String changedByUserId,
    required final DateTime changedAt,
    final String? comment,
    final bool isOverride,
  }) = _$DamageWorkflowHistoryImpl;

  factory _DamageWorkflowHistory.fromJson(Map<String, dynamic> json) =
      _$DamageWorkflowHistoryImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'serverId')
  String? get serverId;
  @override
  String get damageReportId;
  @override
  String get fromStatus;
  @override
  String get toStatus;
  @override
  String get changedByUserId;
  @override
  DateTime get changedAt;
  @override
  String? get comment;
  @override
  bool get isOverride;

  /// Create a copy of DamageWorkflowHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DamageWorkflowHistoryImplCopyWith<_$DamageWorkflowHistoryImpl>
  get copyWith => throw _privateConstructorUsedError;
}
