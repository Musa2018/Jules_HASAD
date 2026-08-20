// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuditLogEntry _$AuditLogEntryFromJson(Map<String, dynamic> json) {
  return _AuditLogEntry.fromJson(json);
}

/// @nodoc
mixin _$AuditLogEntry {
  String get eventType => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get performedBy => throw _privateConstructorUsedError;
  DateTime get eventDate => throw _privateConstructorUsedError;
  String? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuditLogEntryCopyWith<AuditLogEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuditLogEntryCopyWith<$Res> {
  factory $AuditLogEntryCopyWith(
          AuditLogEntry value, $Res Function(AuditLogEntry) then) =
      _$AuditLogEntryCopyWithImpl<$Res, AuditLogEntry>;
  @useResult
  $Res call(
      {String eventType,
      String description,
      String performedBy,
      DateTime eventDate,
      String? metadata});
}

/// @nodoc
class _$AuditLogEntryCopyWithImpl<$Res, $Val extends AuditLogEntry>
    implements $AuditLogEntryCopyWith<$Res> {
  _$AuditLogEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventType = null,
    Object? description = null,
    Object? performedBy = null,
    Object? eventDate = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      performedBy: null == performedBy
          ? _value.performedBy
          : performedBy // ignore: cast_nullable_to_non_nullable
              as String,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuditLogEntryImplCopyWith<$Res>
    implements $AuditLogEntryCopyWith<$Res> {
  factory _$$AuditLogEntryImplCopyWith(
          _$AuditLogEntryImpl value, $Res Function(_$AuditLogEntryImpl) then) =
      __$$AuditLogEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String eventType,
      String description,
      String performedBy,
      DateTime eventDate,
      String? metadata});
}

/// @nodoc
class __$$AuditLogEntryImplCopyWithImpl<$Res>
    extends _$AuditLogEntryCopyWithImpl<$Res, _$AuditLogEntryImpl>
    implements _$$AuditLogEntryImplCopyWith<$Res> {
  __$$AuditLogEntryImplCopyWithImpl(
      _$AuditLogEntryImpl _value, $Res Function(_$AuditLogEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventType = null,
    Object? description = null,
    Object? performedBy = null,
    Object? eventDate = null,
    Object? metadata = freezed,
  }) {
    return _then(_$AuditLogEntryImpl(
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      performedBy: null == performedBy
          ? _value.performedBy
          : performedBy // ignore: cast_nullable_to_non_nullable
              as String,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuditLogEntryImpl implements _AuditLogEntry {
  const _$AuditLogEntryImpl(
      {required this.eventType,
      required this.description,
      required this.performedBy,
      required this.eventDate,
      this.metadata});

  factory _$AuditLogEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuditLogEntryImplFromJson(json);

  @override
  final String eventType;
  @override
  final String description;
  @override
  final String performedBy;
  @override
  final DateTime eventDate;
  @override
  final String? metadata;

  @override
  String toString() {
    return 'AuditLogEntry(eventType: $eventType, description: $description, performedBy: $performedBy, eventDate: $eventDate, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuditLogEntryImpl &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.performedBy, performedBy) ||
                other.performedBy == performedBy) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, eventType, description, performedBy, eventDate, metadata);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuditLogEntryImplCopyWith<_$AuditLogEntryImpl> get copyWith =>
      __$$AuditLogEntryImplCopyWithImpl<_$AuditLogEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuditLogEntryImplToJson(
      this,
    );
  }
}

abstract class _AuditLogEntry implements AuditLogEntry {
  const factory _AuditLogEntry(
      {required final String eventType,
      required final String description,
      required final String performedBy,
      required final DateTime eventDate,
      final String? metadata}) = _$AuditLogEntryImpl;

  factory _AuditLogEntry.fromJson(Map<String, dynamic> json) =
      _$AuditLogEntryImpl.fromJson;

  @override
  String get eventType;
  @override
  String get description;
  @override
  String get performedBy;
  @override
  DateTime get eventDate;
  @override
  String? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$AuditLogEntryImplCopyWith<_$AuditLogEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
