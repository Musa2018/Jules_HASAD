// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farmer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Farmer _$FarmerFromJson(Map<String, dynamic> json) {
  return _Farmer.fromJson(json);
}

/// @nodoc
mixin _$Farmer {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get nationalId => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get rowVersion => throw _privateConstructorUsedError;

  /// Serializes this Farmer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Farmer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FarmerCopyWith<Farmer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FarmerCopyWith<$Res> {
  factory $FarmerCopyWith(Farmer value, $Res Function(Farmer) then) =
      _$FarmerCopyWithImpl<$Res, Farmer>;
  @useResult
  $Res call({
    String id,
    String name,
    String nationalId,
    String phoneNumber,
    String address,
    String rowVersion,
  });
}

/// @nodoc
class _$FarmerCopyWithImpl<$Res, $Val extends Farmer>
    implements $FarmerCopyWith<$Res> {
  _$FarmerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Farmer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nationalId = null,
    Object? phoneNumber = null,
    Object? address = null,
    Object? rowVersion = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            nationalId: null == nationalId
                ? _value.nationalId
                : nationalId // ignore: cast_nullable_to_non_nullable
                      as String,
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            rowVersion: null == rowVersion
                ? _value.rowVersion
                : rowVersion // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FarmerImplCopyWith<$Res> implements $FarmerCopyWith<$Res> {
  factory _$$FarmerImplCopyWith(
    _$FarmerImpl value,
    $Res Function(_$FarmerImpl) then,
  ) = __$$FarmerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String nationalId,
    String phoneNumber,
    String address,
    String rowVersion,
  });
}

/// @nodoc
class __$$FarmerImplCopyWithImpl<$Res>
    extends _$FarmerCopyWithImpl<$Res, _$FarmerImpl>
    implements _$$FarmerImplCopyWith<$Res> {
  __$$FarmerImplCopyWithImpl(
    _$FarmerImpl _value,
    $Res Function(_$FarmerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Farmer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nationalId = null,
    Object? phoneNumber = null,
    Object? address = null,
    Object? rowVersion = null,
  }) {
    return _then(
      _$FarmerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        nationalId: null == nationalId
            ? _value.nationalId
            : nationalId // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        rowVersion: null == rowVersion
            ? _value.rowVersion
            : rowVersion // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FarmerImpl implements _Farmer {
  const _$FarmerImpl({
    required this.id,
    required this.name,
    required this.nationalId,
    required this.phoneNumber,
    required this.address,
    this.rowVersion = '',
  });

  factory _$FarmerImpl.fromJson(Map<String, dynamic> json) =>
      _$$FarmerImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String nationalId;
  @override
  final String phoneNumber;
  @override
  final String address;
  @override
  @JsonKey()
  final String rowVersion;

  @override
  String toString() {
    return 'Farmer(id: $id, name: $name, nationalId: $nationalId, phoneNumber: $phoneNumber, address: $address, rowVersion: $rowVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FarmerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nationalId, nationalId) ||
                other.nationalId == nationalId) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.rowVersion, rowVersion) ||
                other.rowVersion == rowVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    nationalId,
    phoneNumber,
    address,
    rowVersion,
  );

  /// Create a copy of Farmer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FarmerImplCopyWith<_$FarmerImpl> get copyWith =>
      __$$FarmerImplCopyWithImpl<_$FarmerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FarmerImplToJson(this);
  }
}

abstract class _Farmer implements Farmer {
  const factory _Farmer({
    required final String id,
    required final String name,
    required final String nationalId,
    required final String phoneNumber,
    required final String address,
    final String rowVersion,
  }) = _$FarmerImpl;

  factory _Farmer.fromJson(Map<String, dynamic> json) = _$FarmerImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get nationalId;
  @override
  String get phoneNumber;
  @override
  String get address;
  @override
  String get rowVersion;

  /// Create a copy of Farmer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FarmerImplCopyWith<_$FarmerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
