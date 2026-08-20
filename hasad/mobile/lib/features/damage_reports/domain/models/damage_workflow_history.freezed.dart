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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DamageWorkflowHistory _$DamageWorkflowHistoryFromJson(
    Map<String, dynamic> json) {
  return _DamageWorkflowHistory.fromJson(json);
}

/// @nodoc
mixin _$DamageWorkflowHistory {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError; // Local Drift ID
  @JsonKey(name: 'serverId')
  String? get serverId =>
      throw _privateConstructorUsedError; // Authority ID from server
  String get damageReportId => throw _privateConstructorUsedError;
  String get fromStatus => throw _privateConstructorUsedError;
  String get toStatus => throw _privateConstructorUsedError;
  String get changedByUserId => throw _privateConstructorUsedError;
  String get changedByUserName => throw _privateConstructorUsedError;
  DateTime? get changedAt => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  bool get isOverride => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DamageWorkflowHistoryCopyWith<DamageWorkflowHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DamageWorkflowHistoryCopyWith<$Res> {
  factory $DamageWorkflowHistoryCopyWith(DamageWorkflowHistory value,
          $Res Function(DamageWorkflowHistory) then) =
      _$DamageWorkflowHistoryCopyWithImpl<$Res, DamageWorkflowHistory>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'serverId') String? serverId,
      String damageReportId,
      String fromStatus,
      String toStatus,
      String changedByUserId,
      String changedByUserName,
      DateTime? changedAt,
      String? comment,
      bool isOverride});
}

/// @nodoc
class _$DamageWorkflowHistoryCopyWithImpl<$Res,
        $Val extends DamageWorkflowHistory>
    implements $DamageWorkflowHistoryCopyWith<$Res> {
  _$DamageWorkflowHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? damageReportId = null,
    Object? fromStatus = null,
    Object? toStatus = null,
    Object? changedByUserId = null,
    Object? changedByUserName = null,
    Object? changedAt = freezed,
    Object? comment = freezed,
    Object? isOverride = null,
  }) {
    return _then(_value.copyWith(
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
      changedByUserName: null == changedByUserName
          ? _value.changedByUserName
          : changedByUserName // ignore: cast_nullable_to_non_nullable
              as String,
      changedAt: freezed == changedAt
          ? _value.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      isOverride: null == isOverride
          ? _value.isOverride
          : isOverride // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DamageWorkflowHistoryImplCopyWith<$Res>
    implements $DamageWorkflowHistoryCopyWith<$Res> {
  factory _$$DamageWorkflowHistoryImplCopyWith(
          _$DamageWorkflowHistoryImpl value,
          $Res Function(_$DamageWorkflowHistoryImpl) then) =
      __$$DamageWorkflowHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'serverId') String? serverId,
      String damageReportId,
      String fromStatus,
      String toStatus,
      String changedByUserId,
      String changedByUserName,
      DateTime? changedAt,
      String? comment,
      bool isOverride});
}

/// @nodoc
class __$$DamageWorkflowHistoryImplCopyWithImpl<$Res>
    extends _$DamageWorkflowHistoryCopyWithImpl<$Res,
        _$DamageWorkflowHistoryImpl>
    implements _$$DamageWorkflowHistoryImplCopyWith<$Res> {
  __$$DamageWorkflowHistoryImplCopyWithImpl(_$DamageWorkflowHistoryImpl _value,
      $Res Function(_$DamageWorkflowHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? damageReportId = null,
    Object? fromStatus = null,
    Object? toStatus = null,
    Object? changedByUserId = null,
    Object? changedByUserName = null,
    Object? changedAt = freezed,
    Object? comment = freezed,
    Object? isOverride = null,
  }) {
    return _then(_$DamageWorkflowHistoryImpl(
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
      changedByUserName: null == changedByUserName
          ? _value.changedByUserName
          : changedByUserName // ignore: cast_nullable_to_non_nullable
              as String,
      changedAt: freezed == changedAt
          ? _value.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      isOverride: null == isOverride
          ? _value.isOverride
          : isOverride // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DamageWorkflowHistoryImpl implements _DamageWorkflowHistory {
  const _$DamageWorkflowHistoryImpl(
      {@JsonKey(name: 'id') this.id = '',
      @JsonKey(name: 'serverId') this.serverId,
      this.damageReportId = '',
      this.fromStatus = '',
      this.toStatus = '',
      this.changedByUserId = '',
      this.changedByUserName = '',
      this.changedAt,
      this.comment,
      this.isOverride = false});

  factory _$DamageWorkflowHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DamageWorkflowHistoryImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
// Local Drift ID
  @override
  @JsonKey(name: 'serverId')
  final String? serverId;
// Authority ID from server
  @override
  @JsonKey()
  final String damageReportId;
  @override
  @JsonKey()
  final String fromStatus;
  @override
  @JsonKey()
  final String toStatus;
  @override
  @JsonKey()
  final String changedByUserId;
  @override
  @JsonKey()
  final String changedByUserName;
  @override
  final DateTime? changedAt;
  @override
  final String? comment;
  @override
  @JsonKey()
  final bool isOverride;

  @override
  String toString() {
    return 'DamageWorkflowHistory(id: $id, serverId: $serverId, damageReportId: $damageReportId, fromStatus: $fromStatus, toStatus: $toStatus, changedByUserId: $changedByUserId, changedByUserName: $changedByUserName, changedAt: $changedAt, comment: $comment, isOverride: $isOverride)';
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
            (identical(other.changedByUserName, changedByUserName) ||
                other.changedByUserName == changedByUserName) &&
            (identical(other.changedAt, changedAt) ||
                other.changedAt == changedAt) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.isOverride, isOverride) ||
                other.isOverride == isOverride));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      serverId,
      damageReportId,
      fromStatus,
      toStatus,
      changedByUserId,
      changedByUserName,
      changedAt,
      comment,
      isOverride);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DamageWorkflowHistoryImplCopyWith<_$DamageWorkflowHistoryImpl>
      get copyWith => __$$DamageWorkflowHistoryImplCopyWithImpl<
          _$DamageWorkflowHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DamageWorkflowHistoryImplToJson(
      this,
    );
  }
}

abstract class _DamageWorkflowHistory implements DamageWorkflowHistory {
  const factory _DamageWorkflowHistory(
      {@JsonKey(name: 'id') final String id,
      @JsonKey(name: 'serverId') final String? serverId,
      final String damageReportId,
      final String fromStatus,
      final String toStatus,
      final String changedByUserId,
      final String changedByUserName,
      final DateTime? changedAt,
      final String? comment,
      final bool isOverride}) = _$DamageWorkflowHistoryImpl;

  factory _DamageWorkflowHistory.fromJson(Map<String, dynamic> json) =
      _$DamageWorkflowHistoryImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override // Local Drift ID
  @JsonKey(name: 'serverId')
  String? get serverId;
  @override // Authority ID from server
  String get damageReportId;
  @override
  String get fromStatus;
  @override
  String get toStatus;
  @override
  String get changedByUserId;
  @override
  String get changedByUserName;
  @override
  DateTime? get changedAt;
  @override
  String? get comment;
  @override
  bool get isOverride;
  @override
  @JsonKey(ignore: true)
  _$$DamageWorkflowHistoryImplCopyWith<_$DamageWorkflowHistoryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
