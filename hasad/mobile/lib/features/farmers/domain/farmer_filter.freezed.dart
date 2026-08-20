// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farmer_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FarmerFilter {
  String get searchText => throw _privateConstructorUsedError;
  Gender? get gender => throw _privateConstructorUsedError;
  String? get syncStatus => throw _privateConstructorUsedError;
  String? get governorateId => throw _privateConstructorUsedError;
  String? get localityId => throw _privateConstructorUsedError;
  bool get isOperational => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FarmerFilterCopyWith<FarmerFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FarmerFilterCopyWith<$Res> {
  factory $FarmerFilterCopyWith(
          FarmerFilter value, $Res Function(FarmerFilter) then) =
      _$FarmerFilterCopyWithImpl<$Res, FarmerFilter>;
  @useResult
  $Res call(
      {String searchText,
      Gender? gender,
      String? syncStatus,
      String? governorateId,
      String? localityId,
      bool isOperational});
}

/// @nodoc
class _$FarmerFilterCopyWithImpl<$Res, $Val extends FarmerFilter>
    implements $FarmerFilterCopyWith<$Res> {
  _$FarmerFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchText = null,
    Object? gender = freezed,
    Object? syncStatus = freezed,
    Object? governorateId = freezed,
    Object? localityId = freezed,
    Object? isOperational = null,
  }) {
    return _then(_value.copyWith(
      searchText: null == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender?,
      syncStatus: freezed == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      governorateId: freezed == governorateId
          ? _value.governorateId
          : governorateId // ignore: cast_nullable_to_non_nullable
              as String?,
      localityId: freezed == localityId
          ? _value.localityId
          : localityId // ignore: cast_nullable_to_non_nullable
              as String?,
      isOperational: null == isOperational
          ? _value.isOperational
          : isOperational // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FarmerFilterImplCopyWith<$Res>
    implements $FarmerFilterCopyWith<$Res> {
  factory _$$FarmerFilterImplCopyWith(
          _$FarmerFilterImpl value, $Res Function(_$FarmerFilterImpl) then) =
      __$$FarmerFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String searchText,
      Gender? gender,
      String? syncStatus,
      String? governorateId,
      String? localityId,
      bool isOperational});
}

/// @nodoc
class __$$FarmerFilterImplCopyWithImpl<$Res>
    extends _$FarmerFilterCopyWithImpl<$Res, _$FarmerFilterImpl>
    implements _$$FarmerFilterImplCopyWith<$Res> {
  __$$FarmerFilterImplCopyWithImpl(
      _$FarmerFilterImpl _value, $Res Function(_$FarmerFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchText = null,
    Object? gender = freezed,
    Object? syncStatus = freezed,
    Object? governorateId = freezed,
    Object? localityId = freezed,
    Object? isOperational = null,
  }) {
    return _then(_$FarmerFilterImpl(
      searchText: null == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender?,
      syncStatus: freezed == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      governorateId: freezed == governorateId
          ? _value.governorateId
          : governorateId // ignore: cast_nullable_to_non_nullable
              as String?,
      localityId: freezed == localityId
          ? _value.localityId
          : localityId // ignore: cast_nullable_to_non_nullable
              as String?,
      isOperational: null == isOperational
          ? _value.isOperational
          : isOperational // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$FarmerFilterImpl implements _FarmerFilter {
  const _$FarmerFilterImpl(
      {this.searchText = '',
      this.gender,
      this.syncStatus,
      this.governorateId,
      this.localityId,
      this.isOperational = false});

  @override
  @JsonKey()
  final String searchText;
  @override
  final Gender? gender;
  @override
  final String? syncStatus;
  @override
  final String? governorateId;
  @override
  final String? localityId;
  @override
  @JsonKey()
  final bool isOperational;

  @override
  String toString() {
    return 'FarmerFilter(searchText: $searchText, gender: $gender, syncStatus: $syncStatus, governorateId: $governorateId, localityId: $localityId, isOperational: $isOperational)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FarmerFilterImpl &&
            (identical(other.searchText, searchText) ||
                other.searchText == searchText) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.governorateId, governorateId) ||
                other.governorateId == governorateId) &&
            (identical(other.localityId, localityId) ||
                other.localityId == localityId) &&
            (identical(other.isOperational, isOperational) ||
                other.isOperational == isOperational));
  }

  @override
  int get hashCode => Object.hash(runtimeType, searchText, gender, syncStatus,
      governorateId, localityId, isOperational);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FarmerFilterImplCopyWith<_$FarmerFilterImpl> get copyWith =>
      __$$FarmerFilterImplCopyWithImpl<_$FarmerFilterImpl>(this, _$identity);
}

abstract class _FarmerFilter implements FarmerFilter {
  const factory _FarmerFilter(
      {final String searchText,
      final Gender? gender,
      final String? syncStatus,
      final String? governorateId,
      final String? localityId,
      final bool isOperational}) = _$FarmerFilterImpl;

  @override
  String get searchText;
  @override
  Gender? get gender;
  @override
  String? get syncStatus;
  @override
  String? get governorateId;
  @override
  String? get localityId;
  @override
  bool get isOperational;
  @override
  @JsonKey(ignore: true)
  _$$FarmerFilterImplCopyWith<_$FarmerFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
