// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lookup_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OwnershipType _$OwnershipTypeFromJson(Map<String, dynamic> json) {
  return _OwnershipType.fromJson(json);
}

/// @nodoc
mixin _$OwnershipType {
  int get id => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;

  /// Serializes this OwnershipType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OwnershipType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OwnershipTypeCopyWith<OwnershipType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OwnershipTypeCopyWith<$Res> {
  factory $OwnershipTypeCopyWith(
    OwnershipType value,
    $Res Function(OwnershipType) then,
  ) = _$OwnershipTypeCopyWithImpl<$Res, OwnershipType>;
  @useResult
  $Res call({int id, String nameAr, String nameEn});
}

/// @nodoc
class _$OwnershipTypeCopyWithImpl<$Res, $Val extends OwnershipType>
    implements $OwnershipTypeCopyWith<$Res> {
  _$OwnershipTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OwnershipType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nameAr = null, Object? nameEn = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nameAr: null == nameAr
                ? _value.nameAr
                : nameAr // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OwnershipTypeImplCopyWith<$Res>
    implements $OwnershipTypeCopyWith<$Res> {
  factory _$$OwnershipTypeImplCopyWith(
    _$OwnershipTypeImpl value,
    $Res Function(_$OwnershipTypeImpl) then,
  ) = __$$OwnershipTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nameAr, String nameEn});
}

/// @nodoc
class __$$OwnershipTypeImplCopyWithImpl<$Res>
    extends _$OwnershipTypeCopyWithImpl<$Res, _$OwnershipTypeImpl>
    implements _$$OwnershipTypeImplCopyWith<$Res> {
  __$$OwnershipTypeImplCopyWithImpl(
    _$OwnershipTypeImpl _value,
    $Res Function(_$OwnershipTypeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OwnershipType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nameAr = null, Object? nameEn = null}) {
    return _then(
      _$OwnershipTypeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nameAr: null == nameAr
            ? _value.nameAr
            : nameAr // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: null == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OwnershipTypeImpl implements _OwnershipType {
  const _$OwnershipTypeImpl({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory _$OwnershipTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$OwnershipTypeImplFromJson(json);

  @override
  final int id;
  @override
  final String nameAr;
  @override
  final String nameEn;

  @override
  String toString() {
    return 'OwnershipType(id: $id, nameAr: $nameAr, nameEn: $nameEn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OwnershipTypeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nameAr, nameEn);

  /// Create a copy of OwnershipType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OwnershipTypeImplCopyWith<_$OwnershipTypeImpl> get copyWith =>
      __$$OwnershipTypeImplCopyWithImpl<_$OwnershipTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OwnershipTypeImplToJson(this);
  }
}

abstract class _OwnershipType implements OwnershipType {
  const factory _OwnershipType({
    required final int id,
    required final String nameAr,
    required final String nameEn,
  }) = _$OwnershipTypeImpl;

  factory _OwnershipType.fromJson(Map<String, dynamic> json) =
      _$OwnershipTypeImpl.fromJson;

  @override
  int get id;
  @override
  String get nameAr;
  @override
  String get nameEn;

  /// Create a copy of OwnershipType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OwnershipTypeImplCopyWith<_$OwnershipTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AgriculturalSector _$AgriculturalSectorFromJson(Map<String, dynamic> json) {
  return _AgriculturalSector.fromJson(json);
}

/// @nodoc
mixin _$AgriculturalSector {
  int get id => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;

  /// Serializes this AgriculturalSector to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AgriculturalSector
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AgriculturalSectorCopyWith<AgriculturalSector> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgriculturalSectorCopyWith<$Res> {
  factory $AgriculturalSectorCopyWith(
    AgriculturalSector value,
    $Res Function(AgriculturalSector) then,
  ) = _$AgriculturalSectorCopyWithImpl<$Res, AgriculturalSector>;
  @useResult
  $Res call({int id, String nameAr, String nameEn});
}

/// @nodoc
class _$AgriculturalSectorCopyWithImpl<$Res, $Val extends AgriculturalSector>
    implements $AgriculturalSectorCopyWith<$Res> {
  _$AgriculturalSectorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AgriculturalSector
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nameAr = null, Object? nameEn = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nameAr: null == nameAr
                ? _value.nameAr
                : nameAr // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AgriculturalSectorImplCopyWith<$Res>
    implements $AgriculturalSectorCopyWith<$Res> {
  factory _$$AgriculturalSectorImplCopyWith(
    _$AgriculturalSectorImpl value,
    $Res Function(_$AgriculturalSectorImpl) then,
  ) = __$$AgriculturalSectorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nameAr, String nameEn});
}

/// @nodoc
class __$$AgriculturalSectorImplCopyWithImpl<$Res>
    extends _$AgriculturalSectorCopyWithImpl<$Res, _$AgriculturalSectorImpl>
    implements _$$AgriculturalSectorImplCopyWith<$Res> {
  __$$AgriculturalSectorImplCopyWithImpl(
    _$AgriculturalSectorImpl _value,
    $Res Function(_$AgriculturalSectorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AgriculturalSector
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nameAr = null, Object? nameEn = null}) {
    return _then(
      _$AgriculturalSectorImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nameAr: null == nameAr
            ? _value.nameAr
            : nameAr // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: null == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AgriculturalSectorImpl implements _AgriculturalSector {
  const _$AgriculturalSectorImpl({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory _$AgriculturalSectorImpl.fromJson(Map<String, dynamic> json) =>
      _$$AgriculturalSectorImplFromJson(json);

  @override
  final int id;
  @override
  final String nameAr;
  @override
  final String nameEn;

  @override
  String toString() {
    return 'AgriculturalSector(id: $id, nameAr: $nameAr, nameEn: $nameEn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgriculturalSectorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nameAr, nameEn);

  /// Create a copy of AgriculturalSector
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AgriculturalSectorImplCopyWith<_$AgriculturalSectorImpl> get copyWith =>
      __$$AgriculturalSectorImplCopyWithImpl<_$AgriculturalSectorImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AgriculturalSectorImplToJson(this);
  }
}

abstract class _AgriculturalSector implements AgriculturalSector {
  const factory _AgriculturalSector({
    required final int id,
    required final String nameAr,
    required final String nameEn,
  }) = _$AgriculturalSectorImpl;

  factory _AgriculturalSector.fromJson(Map<String, dynamic> json) =
      _$AgriculturalSectorImpl.fromJson;

  @override
  int get id;
  @override
  String get nameAr;
  @override
  String get nameEn;

  /// Create a copy of AgriculturalSector
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AgriculturalSectorImplCopyWith<_$AgriculturalSectorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PoliticalClassification _$PoliticalClassificationFromJson(
  Map<String, dynamic> json,
) {
  return _PoliticalClassification.fromJson(json);
}

/// @nodoc
mixin _$PoliticalClassification {
  int get id => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;

  /// Serializes this PoliticalClassification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PoliticalClassification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoliticalClassificationCopyWith<PoliticalClassification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoliticalClassificationCopyWith<$Res> {
  factory $PoliticalClassificationCopyWith(
    PoliticalClassification value,
    $Res Function(PoliticalClassification) then,
  ) = _$PoliticalClassificationCopyWithImpl<$Res, PoliticalClassification>;
  @useResult
  $Res call({int id, String nameAr, String nameEn});
}

/// @nodoc
class _$PoliticalClassificationCopyWithImpl<
  $Res,
  $Val extends PoliticalClassification
>
    implements $PoliticalClassificationCopyWith<$Res> {
  _$PoliticalClassificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoliticalClassification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nameAr = null, Object? nameEn = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nameAr: null == nameAr
                ? _value.nameAr
                : nameAr // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PoliticalClassificationImplCopyWith<$Res>
    implements $PoliticalClassificationCopyWith<$Res> {
  factory _$$PoliticalClassificationImplCopyWith(
    _$PoliticalClassificationImpl value,
    $Res Function(_$PoliticalClassificationImpl) then,
  ) = __$$PoliticalClassificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nameAr, String nameEn});
}

/// @nodoc
class __$$PoliticalClassificationImplCopyWithImpl<$Res>
    extends
        _$PoliticalClassificationCopyWithImpl<
          $Res,
          _$PoliticalClassificationImpl
        >
    implements _$$PoliticalClassificationImplCopyWith<$Res> {
  __$$PoliticalClassificationImplCopyWithImpl(
    _$PoliticalClassificationImpl _value,
    $Res Function(_$PoliticalClassificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoliticalClassification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nameAr = null, Object? nameEn = null}) {
    return _then(
      _$PoliticalClassificationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nameAr: null == nameAr
            ? _value.nameAr
            : nameAr // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: null == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PoliticalClassificationImpl implements _PoliticalClassification {
  const _$PoliticalClassificationImpl({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory _$PoliticalClassificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoliticalClassificationImplFromJson(json);

  @override
  final int id;
  @override
  final String nameAr;
  @override
  final String nameEn;

  @override
  String toString() {
    return 'PoliticalClassification(id: $id, nameAr: $nameAr, nameEn: $nameEn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoliticalClassificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nameAr, nameEn);

  /// Create a copy of PoliticalClassification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoliticalClassificationImplCopyWith<_$PoliticalClassificationImpl>
  get copyWith =>
      __$$PoliticalClassificationImplCopyWithImpl<
        _$PoliticalClassificationImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoliticalClassificationImplToJson(this);
  }
}

abstract class _PoliticalClassification implements PoliticalClassification {
  const factory _PoliticalClassification({
    required final int id,
    required final String nameAr,
    required final String nameEn,
  }) = _$PoliticalClassificationImpl;

  factory _PoliticalClassification.fromJson(Map<String, dynamic> json) =
      _$PoliticalClassificationImpl.fromJson;

  @override
  int get id;
  @override
  String get nameAr;
  @override
  String get nameEn;

  /// Create a copy of PoliticalClassification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoliticalClassificationImplCopyWith<_$PoliticalClassificationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AreaUnit _$AreaUnitFromJson(Map<String, dynamic> json) {
  return _AreaUnit.fromJson(json);
}

/// @nodoc
mixin _$AreaUnit {
  int get id => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;

  /// Serializes this AreaUnit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AreaUnit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AreaUnitCopyWith<AreaUnit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AreaUnitCopyWith<$Res> {
  factory $AreaUnitCopyWith(AreaUnit value, $Res Function(AreaUnit) then) =
      _$AreaUnitCopyWithImpl<$Res, AreaUnit>;
  @useResult
  $Res call({int id, String nameAr, String nameEn});
}

/// @nodoc
class _$AreaUnitCopyWithImpl<$Res, $Val extends AreaUnit>
    implements $AreaUnitCopyWith<$Res> {
  _$AreaUnitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AreaUnit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nameAr = null, Object? nameEn = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nameAr: null == nameAr
                ? _value.nameAr
                : nameAr // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AreaUnitImplCopyWith<$Res>
    implements $AreaUnitCopyWith<$Res> {
  factory _$$AreaUnitImplCopyWith(
    _$AreaUnitImpl value,
    $Res Function(_$AreaUnitImpl) then,
  ) = __$$AreaUnitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nameAr, String nameEn});
}

/// @nodoc
class __$$AreaUnitImplCopyWithImpl<$Res>
    extends _$AreaUnitCopyWithImpl<$Res, _$AreaUnitImpl>
    implements _$$AreaUnitImplCopyWith<$Res> {
  __$$AreaUnitImplCopyWithImpl(
    _$AreaUnitImpl _value,
    $Res Function(_$AreaUnitImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AreaUnit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nameAr = null, Object? nameEn = null}) {
    return _then(
      _$AreaUnitImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nameAr: null == nameAr
            ? _value.nameAr
            : nameAr // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: null == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AreaUnitImpl implements _AreaUnit {
  const _$AreaUnitImpl({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory _$AreaUnitImpl.fromJson(Map<String, dynamic> json) =>
      _$$AreaUnitImplFromJson(json);

  @override
  final int id;
  @override
  final String nameAr;
  @override
  final String nameEn;

  @override
  String toString() {
    return 'AreaUnit(id: $id, nameAr: $nameAr, nameEn: $nameEn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AreaUnitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nameAr, nameEn);

  /// Create a copy of AreaUnit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AreaUnitImplCopyWith<_$AreaUnitImpl> get copyWith =>
      __$$AreaUnitImplCopyWithImpl<_$AreaUnitImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AreaUnitImplToJson(this);
  }
}

abstract class _AreaUnit implements AreaUnit {
  const factory _AreaUnit({
    required final int id,
    required final String nameAr,
    required final String nameEn,
  }) = _$AreaUnitImpl;

  factory _AreaUnit.fromJson(Map<String, dynamic> json) =
      _$AreaUnitImpl.fromJson;

  @override
  int get id;
  @override
  String get nameAr;
  @override
  String get nameEn;

  /// Create a copy of AreaUnit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AreaUnitImplCopyWith<_$AreaUnitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MeasurementUnit _$MeasurementUnitFromJson(Map<String, dynamic> json) {
  return _MeasurementUnit.fromJson(json);
}

/// @nodoc
mixin _$MeasurementUnit {
  int get id => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;

  /// Serializes this MeasurementUnit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MeasurementUnit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MeasurementUnitCopyWith<MeasurementUnit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeasurementUnitCopyWith<$Res> {
  factory $MeasurementUnitCopyWith(
    MeasurementUnit value,
    $Res Function(MeasurementUnit) then,
  ) = _$MeasurementUnitCopyWithImpl<$Res, MeasurementUnit>;
  @useResult
  $Res call({
    int id,
    String nameAr,
    String nameEn,
    String? code,
    String category,
  });
}

/// @nodoc
class _$MeasurementUnitCopyWithImpl<$Res, $Val extends MeasurementUnit>
    implements $MeasurementUnitCopyWith<$Res> {
  _$MeasurementUnitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MeasurementUnit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? code = freezed,
    Object? category = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nameAr: null == nameAr
                ? _value.nameAr
                : nameAr // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String,
            code: freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MeasurementUnitImplCopyWith<$Res>
    implements $MeasurementUnitCopyWith<$Res> {
  factory _$$MeasurementUnitImplCopyWith(
    _$MeasurementUnitImpl value,
    $Res Function(_$MeasurementUnitImpl) then,
  ) = __$$MeasurementUnitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String nameAr,
    String nameEn,
    String? code,
    String category,
  });
}

/// @nodoc
class __$$MeasurementUnitImplCopyWithImpl<$Res>
    extends _$MeasurementUnitCopyWithImpl<$Res, _$MeasurementUnitImpl>
    implements _$$MeasurementUnitImplCopyWith<$Res> {
  __$$MeasurementUnitImplCopyWithImpl(
    _$MeasurementUnitImpl _value,
    $Res Function(_$MeasurementUnitImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MeasurementUnit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? code = freezed,
    Object? category = null,
  }) {
    return _then(
      _$MeasurementUnitImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nameAr: null == nameAr
            ? _value.nameAr
            : nameAr // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: null == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MeasurementUnitImpl implements _MeasurementUnit {
  const _$MeasurementUnitImpl({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.code,
    required this.category,
  });

  factory _$MeasurementUnitImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeasurementUnitImplFromJson(json);

  @override
  final int id;
  @override
  final String nameAr;
  @override
  final String nameEn;
  @override
  final String? code;
  @override
  final String category;

  @override
  String toString() {
    return 'MeasurementUnit(id: $id, nameAr: $nameAr, nameEn: $nameEn, code: $code, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeasurementUnitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, nameAr, nameEn, code, category);

  /// Create a copy of MeasurementUnit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MeasurementUnitImplCopyWith<_$MeasurementUnitImpl> get copyWith =>
      __$$MeasurementUnitImplCopyWithImpl<_$MeasurementUnitImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MeasurementUnitImplToJson(this);
  }
}

abstract class _MeasurementUnit implements MeasurementUnit {
  const factory _MeasurementUnit({
    required final int id,
    required final String nameAr,
    required final String nameEn,
    final String? code,
    required final String category,
  }) = _$MeasurementUnitImpl;

  factory _MeasurementUnit.fromJson(Map<String, dynamic> json) =
      _$MeasurementUnitImpl.fromJson;

  @override
  int get id;
  @override
  String get nameAr;
  @override
  String get nameEn;
  @override
  String? get code;
  @override
  String get category;

  /// Create a copy of MeasurementUnit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MeasurementUnitImplCopyWith<_$MeasurementUnitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RelationshipToOwner _$RelationshipToOwnerFromJson(Map<String, dynamic> json) {
  return _RelationshipToOwner.fromJson(json);
}

/// @nodoc
mixin _$RelationshipToOwner {
  int get id => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;

  /// Serializes this RelationshipToOwner to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RelationshipToOwner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RelationshipToOwnerCopyWith<RelationshipToOwner> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RelationshipToOwnerCopyWith<$Res> {
  factory $RelationshipToOwnerCopyWith(
    RelationshipToOwner value,
    $Res Function(RelationshipToOwner) then,
  ) = _$RelationshipToOwnerCopyWithImpl<$Res, RelationshipToOwner>;
  @useResult
  $Res call({int id, String nameAr, String nameEn});
}

/// @nodoc
class _$RelationshipToOwnerCopyWithImpl<$Res, $Val extends RelationshipToOwner>
    implements $RelationshipToOwnerCopyWith<$Res> {
  _$RelationshipToOwnerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RelationshipToOwner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nameAr = null, Object? nameEn = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nameAr: null == nameAr
                ? _value.nameAr
                : nameAr // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RelationshipToOwnerImplCopyWith<$Res>
    implements $RelationshipToOwnerCopyWith<$Res> {
  factory _$$RelationshipToOwnerImplCopyWith(
    _$RelationshipToOwnerImpl value,
    $Res Function(_$RelationshipToOwnerImpl) then,
  ) = __$$RelationshipToOwnerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nameAr, String nameEn});
}

/// @nodoc
class __$$RelationshipToOwnerImplCopyWithImpl<$Res>
    extends _$RelationshipToOwnerCopyWithImpl<$Res, _$RelationshipToOwnerImpl>
    implements _$$RelationshipToOwnerImplCopyWith<$Res> {
  __$$RelationshipToOwnerImplCopyWithImpl(
    _$RelationshipToOwnerImpl _value,
    $Res Function(_$RelationshipToOwnerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RelationshipToOwner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nameAr = null, Object? nameEn = null}) {
    return _then(
      _$RelationshipToOwnerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nameAr: null == nameAr
            ? _value.nameAr
            : nameAr // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: null == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RelationshipToOwnerImpl implements _RelationshipToOwner {
  const _$RelationshipToOwnerImpl({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory _$RelationshipToOwnerImpl.fromJson(Map<String, dynamic> json) =>
      _$$RelationshipToOwnerImplFromJson(json);

  @override
  final int id;
  @override
  final String nameAr;
  @override
  final String nameEn;

  @override
  String toString() {
    return 'RelationshipToOwner(id: $id, nameAr: $nameAr, nameEn: $nameEn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RelationshipToOwnerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nameAr, nameEn);

  /// Create a copy of RelationshipToOwner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RelationshipToOwnerImplCopyWith<_$RelationshipToOwnerImpl> get copyWith =>
      __$$RelationshipToOwnerImplCopyWithImpl<_$RelationshipToOwnerImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RelationshipToOwnerImplToJson(this);
  }
}

abstract class _RelationshipToOwner implements RelationshipToOwner {
  const factory _RelationshipToOwner({
    required final int id,
    required final String nameAr,
    required final String nameEn,
  }) = _$RelationshipToOwnerImpl;

  factory _RelationshipToOwner.fromJson(Map<String, dynamic> json) =
      _$RelationshipToOwnerImpl.fromJson;

  @override
  int get id;
  @override
  String get nameAr;
  @override
  String get nameEn;

  /// Create a copy of RelationshipToOwner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RelationshipToOwnerImplCopyWith<_$RelationshipToOwnerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DamageNature _$DamageNatureFromJson(Map<String, dynamic> json) {
  return _DamageNature.fromJson(json);
}

/// @nodoc
mixin _$DamageNature {
  int get id => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;

  /// Serializes this DamageNature to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DamageNature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DamageNatureCopyWith<DamageNature> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DamageNatureCopyWith<$Res> {
  factory $DamageNatureCopyWith(
    DamageNature value,
    $Res Function(DamageNature) then,
  ) = _$DamageNatureCopyWithImpl<$Res, DamageNature>;
  @useResult
  $Res call({int id, String nameAr, String nameEn});
}

/// @nodoc
class _$DamageNatureCopyWithImpl<$Res, $Val extends DamageNature>
    implements $DamageNatureCopyWith<$Res> {
  _$DamageNatureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DamageNature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nameAr = null, Object? nameEn = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nameAr: null == nameAr
                ? _value.nameAr
                : nameAr // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DamageNatureImplCopyWith<$Res>
    implements $DamageNatureCopyWith<$Res> {
  factory _$$DamageNatureImplCopyWith(
    _$DamageNatureImpl value,
    $Res Function(_$DamageNatureImpl) then,
  ) = __$$DamageNatureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nameAr, String nameEn});
}

/// @nodoc
class __$$DamageNatureImplCopyWithImpl<$Res>
    extends _$DamageNatureCopyWithImpl<$Res, _$DamageNatureImpl>
    implements _$$DamageNatureImplCopyWith<$Res> {
  __$$DamageNatureImplCopyWithImpl(
    _$DamageNatureImpl _value,
    $Res Function(_$DamageNatureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DamageNature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nameAr = null, Object? nameEn = null}) {
    return _then(
      _$DamageNatureImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nameAr: null == nameAr
            ? _value.nameAr
            : nameAr // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: null == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DamageNatureImpl implements _DamageNature {
  const _$DamageNatureImpl({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory _$DamageNatureImpl.fromJson(Map<String, dynamic> json) =>
      _$$DamageNatureImplFromJson(json);

  @override
  final int id;
  @override
  final String nameAr;
  @override
  final String nameEn;

  @override
  String toString() {
    return 'DamageNature(id: $id, nameAr: $nameAr, nameEn: $nameEn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DamageNatureImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nameAr, nameEn);

  /// Create a copy of DamageNature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DamageNatureImplCopyWith<_$DamageNatureImpl> get copyWith =>
      __$$DamageNatureImplCopyWithImpl<_$DamageNatureImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DamageNatureImplToJson(this);
  }
}

abstract class _DamageNature implements DamageNature {
  const factory _DamageNature({
    required final int id,
    required final String nameAr,
    required final String nameEn,
  }) = _$DamageNatureImpl;

  factory _DamageNature.fromJson(Map<String, dynamic> json) =
      _$DamageNatureImpl.fromJson;

  @override
  int get id;
  @override
  String get nameAr;
  @override
  String get nameEn;

  /// Create a copy of DamageNature
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DamageNatureImplCopyWith<_$DamageNatureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DamageCategory _$DamageCategoryFromJson(Map<String, dynamic> json) {
  return _DamageCategory.fromJson(json);
}

/// @nodoc
mixin _$DamageCategory {
  int get id => throw _privateConstructorUsedError;
  int get parentId => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;

  /// Serializes this DamageCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DamageCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DamageCategoryCopyWith<DamageCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DamageCategoryCopyWith<$Res> {
  factory $DamageCategoryCopyWith(
    DamageCategory value,
    $Res Function(DamageCategory) then,
  ) = _$DamageCategoryCopyWithImpl<$Res, DamageCategory>;
  @useResult
  $Res call({int id, int parentId, String nameAr, String nameEn});
}

/// @nodoc
class _$DamageCategoryCopyWithImpl<$Res, $Val extends DamageCategory>
    implements $DamageCategoryCopyWith<$Res> {
  _$DamageCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DamageCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = null,
    Object? nameAr = null,
    Object? nameEn = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            parentId: null == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as int,
            nameAr: null == nameAr
                ? _value.nameAr
                : nameAr // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DamageCategoryImplCopyWith<$Res>
    implements $DamageCategoryCopyWith<$Res> {
  factory _$$DamageCategoryImplCopyWith(
    _$DamageCategoryImpl value,
    $Res Function(_$DamageCategoryImpl) then,
  ) = __$$DamageCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int parentId, String nameAr, String nameEn});
}

/// @nodoc
class __$$DamageCategoryImplCopyWithImpl<$Res>
    extends _$DamageCategoryCopyWithImpl<$Res, _$DamageCategoryImpl>
    implements _$$DamageCategoryImplCopyWith<$Res> {
  __$$DamageCategoryImplCopyWithImpl(
    _$DamageCategoryImpl _value,
    $Res Function(_$DamageCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DamageCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = null,
    Object? nameAr = null,
    Object? nameEn = null,
  }) {
    return _then(
      _$DamageCategoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        parentId: null == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as int,
        nameAr: null == nameAr
            ? _value.nameAr
            : nameAr // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: null == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DamageCategoryImpl implements _DamageCategory {
  const _$DamageCategoryImpl({
    required this.id,
    required this.parentId,
    required this.nameAr,
    required this.nameEn,
  });

  factory _$DamageCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DamageCategoryImplFromJson(json);

  @override
  final int id;
  @override
  final int parentId;
  @override
  final String nameAr;
  @override
  final String nameEn;

  @override
  String toString() {
    return 'DamageCategory(id: $id, parentId: $parentId, nameAr: $nameAr, nameEn: $nameEn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DamageCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, parentId, nameAr, nameEn);

  /// Create a copy of DamageCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DamageCategoryImplCopyWith<_$DamageCategoryImpl> get copyWith =>
      __$$DamageCategoryImplCopyWithImpl<_$DamageCategoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DamageCategoryImplToJson(this);
  }
}

abstract class _DamageCategory implements DamageCategory {
  const factory _DamageCategory({
    required final int id,
    required final int parentId,
    required final String nameAr,
    required final String nameEn,
  }) = _$DamageCategoryImpl;

  factory _DamageCategory.fromJson(Map<String, dynamic> json) =
      _$DamageCategoryImpl.fromJson;

  @override
  int get id;
  @override
  int get parentId;
  @override
  String get nameAr;
  @override
  String get nameEn;

  /// Create a copy of DamageCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DamageCategoryImplCopyWith<_$DamageCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DamageSubCategory _$DamageSubCategoryFromJson(Map<String, dynamic> json) {
  return _DamageSubCategory.fromJson(json);
}

/// @nodoc
mixin _$DamageSubCategory {
  int get id => throw _privateConstructorUsedError;
  int get parentId => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;

  /// Serializes this DamageSubCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DamageSubCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DamageSubCategoryCopyWith<DamageSubCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DamageSubCategoryCopyWith<$Res> {
  factory $DamageSubCategoryCopyWith(
    DamageSubCategory value,
    $Res Function(DamageSubCategory) then,
  ) = _$DamageSubCategoryCopyWithImpl<$Res, DamageSubCategory>;
  @useResult
  $Res call({int id, int parentId, String nameAr, String nameEn});
}

/// @nodoc
class _$DamageSubCategoryCopyWithImpl<$Res, $Val extends DamageSubCategory>
    implements $DamageSubCategoryCopyWith<$Res> {
  _$DamageSubCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DamageSubCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = null,
    Object? nameAr = null,
    Object? nameEn = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            parentId: null == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as int,
            nameAr: null == nameAr
                ? _value.nameAr
                : nameAr // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DamageSubCategoryImplCopyWith<$Res>
    implements $DamageSubCategoryCopyWith<$Res> {
  factory _$$DamageSubCategoryImplCopyWith(
    _$DamageSubCategoryImpl value,
    $Res Function(_$DamageSubCategoryImpl) then,
  ) = __$$DamageSubCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int parentId, String nameAr, String nameEn});
}

/// @nodoc
class __$$DamageSubCategoryImplCopyWithImpl<$Res>
    extends _$DamageSubCategoryCopyWithImpl<$Res, _$DamageSubCategoryImpl>
    implements _$$DamageSubCategoryImplCopyWith<$Res> {
  __$$DamageSubCategoryImplCopyWithImpl(
    _$DamageSubCategoryImpl _value,
    $Res Function(_$DamageSubCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DamageSubCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = null,
    Object? nameAr = null,
    Object? nameEn = null,
  }) {
    return _then(
      _$DamageSubCategoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        parentId: null == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as int,
        nameAr: null == nameAr
            ? _value.nameAr
            : nameAr // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: null == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DamageSubCategoryImpl implements _DamageSubCategory {
  const _$DamageSubCategoryImpl({
    required this.id,
    required this.parentId,
    required this.nameAr,
    required this.nameEn,
  });

  factory _$DamageSubCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DamageSubCategoryImplFromJson(json);

  @override
  final int id;
  @override
  final int parentId;
  @override
  final String nameAr;
  @override
  final String nameEn;

  @override
  String toString() {
    return 'DamageSubCategory(id: $id, parentId: $parentId, nameAr: $nameAr, nameEn: $nameEn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DamageSubCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, parentId, nameAr, nameEn);

  /// Create a copy of DamageSubCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DamageSubCategoryImplCopyWith<_$DamageSubCategoryImpl> get copyWith =>
      __$$DamageSubCategoryImplCopyWithImpl<_$DamageSubCategoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DamageSubCategoryImplToJson(this);
  }
}

abstract class _DamageSubCategory implements DamageSubCategory {
  const factory _DamageSubCategory({
    required final int id,
    required final int parentId,
    required final String nameAr,
    required final String nameEn,
  }) = _$DamageSubCategoryImpl;

  factory _DamageSubCategory.fromJson(Map<String, dynamic> json) =
      _$DamageSubCategoryImpl.fromJson;

  @override
  int get id;
  @override
  int get parentId;
  @override
  String get nameAr;
  @override
  String get nameEn;

  /// Create a copy of DamageSubCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DamageSubCategoryImplCopyWith<_$DamageSubCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DamageClassification _$DamageClassificationFromJson(Map<String, dynamic> json) {
  return _DamageClassification.fromJson(json);
}

/// @nodoc
mixin _$DamageClassification {
  int get id => throw _privateConstructorUsedError;
  int get parentId => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;

  /// Serializes this DamageClassification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DamageClassification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DamageClassificationCopyWith<DamageClassification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DamageClassificationCopyWith<$Res> {
  factory $DamageClassificationCopyWith(
    DamageClassification value,
    $Res Function(DamageClassification) then,
  ) = _$DamageClassificationCopyWithImpl<$Res, DamageClassification>;
  @useResult
  $Res call({int id, int parentId, String nameAr, String nameEn});
}

/// @nodoc
class _$DamageClassificationCopyWithImpl<
  $Res,
  $Val extends DamageClassification
>
    implements $DamageClassificationCopyWith<$Res> {
  _$DamageClassificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DamageClassification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = null,
    Object? nameAr = null,
    Object? nameEn = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            parentId: null == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as int,
            nameAr: null == nameAr
                ? _value.nameAr
                : nameAr // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DamageClassificationImplCopyWith<$Res>
    implements $DamageClassificationCopyWith<$Res> {
  factory _$$DamageClassificationImplCopyWith(
    _$DamageClassificationImpl value,
    $Res Function(_$DamageClassificationImpl) then,
  ) = __$$DamageClassificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int parentId, String nameAr, String nameEn});
}

/// @nodoc
class __$$DamageClassificationImplCopyWithImpl<$Res>
    extends _$DamageClassificationCopyWithImpl<$Res, _$DamageClassificationImpl>
    implements _$$DamageClassificationImplCopyWith<$Res> {
  __$$DamageClassificationImplCopyWithImpl(
    _$DamageClassificationImpl _value,
    $Res Function(_$DamageClassificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DamageClassification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = null,
    Object? nameAr = null,
    Object? nameEn = null,
  }) {
    return _then(
      _$DamageClassificationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        parentId: null == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as int,
        nameAr: null == nameAr
            ? _value.nameAr
            : nameAr // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: null == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DamageClassificationImpl implements _DamageClassification {
  const _$DamageClassificationImpl({
    required this.id,
    required this.parentId,
    required this.nameAr,
    required this.nameEn,
  });

  factory _$DamageClassificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$DamageClassificationImplFromJson(json);

  @override
  final int id;
  @override
  final int parentId;
  @override
  final String nameAr;
  @override
  final String nameEn;

  @override
  String toString() {
    return 'DamageClassification(id: $id, parentId: $parentId, nameAr: $nameAr, nameEn: $nameEn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DamageClassificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, parentId, nameAr, nameEn);

  /// Create a copy of DamageClassification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DamageClassificationImplCopyWith<_$DamageClassificationImpl>
  get copyWith =>
      __$$DamageClassificationImplCopyWithImpl<_$DamageClassificationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DamageClassificationImplToJson(this);
  }
}

abstract class _DamageClassification implements DamageClassification {
  const factory _DamageClassification({
    required final int id,
    required final int parentId,
    required final String nameAr,
    required final String nameEn,
  }) = _$DamageClassificationImpl;

  factory _DamageClassification.fromJson(Map<String, dynamic> json) =
      _$DamageClassificationImpl.fromJson;

  @override
  int get id;
  @override
  int get parentId;
  @override
  String get nameAr;
  @override
  String get nameEn;

  /// Create a copy of DamageClassification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DamageClassificationImplCopyWith<_$DamageClassificationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

DamageCauseCategory _$DamageCauseCategoryFromJson(Map<String, dynamic> json) {
  return _DamageCauseCategory.fromJson(json);
}

/// @nodoc
mixin _$DamageCauseCategory {
  int get id => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;

  /// Serializes this DamageCauseCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DamageCauseCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DamageCauseCategoryCopyWith<DamageCauseCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DamageCauseCategoryCopyWith<$Res> {
  factory $DamageCauseCategoryCopyWith(
    DamageCauseCategory value,
    $Res Function(DamageCauseCategory) then,
  ) = _$DamageCauseCategoryCopyWithImpl<$Res, DamageCauseCategory>;
  @useResult
  $Res call({int id, String nameAr, String nameEn});
}

/// @nodoc
class _$DamageCauseCategoryCopyWithImpl<$Res, $Val extends DamageCauseCategory>
    implements $DamageCauseCategoryCopyWith<$Res> {
  _$DamageCauseCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DamageCauseCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nameAr = null, Object? nameEn = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nameAr: null == nameAr
                ? _value.nameAr
                : nameAr // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DamageCauseCategoryImplCopyWith<$Res>
    implements $DamageCauseCategoryCopyWith<$Res> {
  factory _$$DamageCauseCategoryImplCopyWith(
    _$DamageCauseCategoryImpl value,
    $Res Function(_$DamageCauseCategoryImpl) then,
  ) = __$$DamageCauseCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nameAr, String nameEn});
}

/// @nodoc
class __$$DamageCauseCategoryImplCopyWithImpl<$Res>
    extends _$DamageCauseCategoryCopyWithImpl<$Res, _$DamageCauseCategoryImpl>
    implements _$$DamageCauseCategoryImplCopyWith<$Res> {
  __$$DamageCauseCategoryImplCopyWithImpl(
    _$DamageCauseCategoryImpl _value,
    $Res Function(_$DamageCauseCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DamageCauseCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nameAr = null, Object? nameEn = null}) {
    return _then(
      _$DamageCauseCategoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nameAr: null == nameAr
            ? _value.nameAr
            : nameAr // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: null == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DamageCauseCategoryImpl implements _DamageCauseCategory {
  const _$DamageCauseCategoryImpl({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory _$DamageCauseCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DamageCauseCategoryImplFromJson(json);

  @override
  final int id;
  @override
  final String nameAr;
  @override
  final String nameEn;

  @override
  String toString() {
    return 'DamageCauseCategory(id: $id, nameAr: $nameAr, nameEn: $nameEn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DamageCauseCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nameAr, nameEn);

  /// Create a copy of DamageCauseCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DamageCauseCategoryImplCopyWith<_$DamageCauseCategoryImpl> get copyWith =>
      __$$DamageCauseCategoryImplCopyWithImpl<_$DamageCauseCategoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DamageCauseCategoryImplToJson(this);
  }
}

abstract class _DamageCauseCategory implements DamageCauseCategory {
  const factory _DamageCauseCategory({
    required final int id,
    required final String nameAr,
    required final String nameEn,
  }) = _$DamageCauseCategoryImpl;

  factory _DamageCauseCategory.fromJson(Map<String, dynamic> json) =
      _$DamageCauseCategoryImpl.fromJson;

  @override
  int get id;
  @override
  String get nameAr;
  @override
  String get nameEn;

  /// Create a copy of DamageCauseCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DamageCauseCategoryImplCopyWith<_$DamageCauseCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DamageCause _$DamageCauseFromJson(Map<String, dynamic> json) {
  return _DamageCause.fromJson(json);
}

/// @nodoc
mixin _$DamageCause {
  int get id => throw _privateConstructorUsedError;
  int get parentId => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;

  /// Serializes this DamageCause to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DamageCause
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DamageCauseCopyWith<DamageCause> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DamageCauseCopyWith<$Res> {
  factory $DamageCauseCopyWith(
    DamageCause value,
    $Res Function(DamageCause) then,
  ) = _$DamageCauseCopyWithImpl<$Res, DamageCause>;
  @useResult
  $Res call({int id, int parentId, String nameAr, String nameEn});
}

/// @nodoc
class _$DamageCauseCopyWithImpl<$Res, $Val extends DamageCause>
    implements $DamageCauseCopyWith<$Res> {
  _$DamageCauseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DamageCause
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = null,
    Object? nameAr = null,
    Object? nameEn = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            parentId: null == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as int,
            nameAr: null == nameAr
                ? _value.nameAr
                : nameAr // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DamageCauseImplCopyWith<$Res>
    implements $DamageCauseCopyWith<$Res> {
  factory _$$DamageCauseImplCopyWith(
    _$DamageCauseImpl value,
    $Res Function(_$DamageCauseImpl) then,
  ) = __$$DamageCauseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int parentId, String nameAr, String nameEn});
}

/// @nodoc
class __$$DamageCauseImplCopyWithImpl<$Res>
    extends _$DamageCauseCopyWithImpl<$Res, _$DamageCauseImpl>
    implements _$$DamageCauseImplCopyWith<$Res> {
  __$$DamageCauseImplCopyWithImpl(
    _$DamageCauseImpl _value,
    $Res Function(_$DamageCauseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DamageCause
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = null,
    Object? nameAr = null,
    Object? nameEn = null,
  }) {
    return _then(
      _$DamageCauseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        parentId: null == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as int,
        nameAr: null == nameAr
            ? _value.nameAr
            : nameAr // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: null == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DamageCauseImpl implements _DamageCause {
  const _$DamageCauseImpl({
    required this.id,
    required this.parentId,
    required this.nameAr,
    required this.nameEn,
  });

  factory _$DamageCauseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DamageCauseImplFromJson(json);

  @override
  final int id;
  @override
  final int parentId;
  @override
  final String nameAr;
  @override
  final String nameEn;

  @override
  String toString() {
    return 'DamageCause(id: $id, parentId: $parentId, nameAr: $nameAr, nameEn: $nameEn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DamageCauseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, parentId, nameAr, nameEn);

  /// Create a copy of DamageCause
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DamageCauseImplCopyWith<_$DamageCauseImpl> get copyWith =>
      __$$DamageCauseImplCopyWithImpl<_$DamageCauseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DamageCauseImplToJson(this);
  }
}

abstract class _DamageCause implements DamageCause {
  const factory _DamageCause({
    required final int id,
    required final int parentId,
    required final String nameAr,
    required final String nameEn,
  }) = _$DamageCauseImpl;

  factory _DamageCause.fromJson(Map<String, dynamic> json) =
      _$DamageCauseImpl.fromJson;

  @override
  int get id;
  @override
  int get parentId;
  @override
  String get nameAr;
  @override
  String get nameEn;

  /// Create a copy of DamageCause
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DamageCauseImplCopyWith<_$DamageCauseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CostingSheetCatalog _$CostingSheetCatalogFromJson(Map<String, dynamic> json) {
  return _CostingSheetCatalog.fromJson(json);
}

/// @nodoc
mixin _$CostingSheetCatalog {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;

  /// Serializes this CostingSheetCatalog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CostingSheetCatalog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CostingSheetCatalogCopyWith<CostingSheetCatalog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CostingSheetCatalogCopyWith<$Res> {
  factory $CostingSheetCatalogCopyWith(
    CostingSheetCatalog value,
    $Res Function(CostingSheetCatalog) then,
  ) = _$CostingSheetCatalogCopyWithImpl<$Res, CostingSheetCatalog>;
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    DateTime createdAt,
    String createdBy,
  });
}

/// @nodoc
class _$CostingSheetCatalogCopyWithImpl<$Res, $Val extends CostingSheetCatalog>
    implements $CostingSheetCatalogCopyWith<$Res> {
  _$CostingSheetCatalogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CostingSheetCatalog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? createdBy = null,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CostingSheetCatalogImplCopyWith<$Res>
    implements $CostingSheetCatalogCopyWith<$Res> {
  factory _$$CostingSheetCatalogImplCopyWith(
    _$CostingSheetCatalogImpl value,
    $Res Function(_$CostingSheetCatalogImpl) then,
  ) = __$$CostingSheetCatalogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    DateTime createdAt,
    String createdBy,
  });
}

/// @nodoc
class __$$CostingSheetCatalogImplCopyWithImpl<$Res>
    extends _$CostingSheetCatalogCopyWithImpl<$Res, _$CostingSheetCatalogImpl>
    implements _$$CostingSheetCatalogImplCopyWith<$Res> {
  __$$CostingSheetCatalogImplCopyWithImpl(
    _$CostingSheetCatalogImpl _value,
    $Res Function(_$CostingSheetCatalogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CostingSheetCatalog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? createdBy = null,
  }) {
    return _then(
      _$CostingSheetCatalogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CostingSheetCatalogImpl implements _CostingSheetCatalog {
  const _$CostingSheetCatalogImpl({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.createdBy,
  });

  factory _$CostingSheetCatalogImpl.fromJson(Map<String, dynamic> json) =>
      _$$CostingSheetCatalogImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final DateTime createdAt;
  @override
  final String createdBy;

  @override
  String toString() {
    return 'CostingSheetCatalog(id: $id, name: $name, description: $description, createdAt: $createdAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CostingSheetCatalogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, description, createdAt, createdBy);

  /// Create a copy of CostingSheetCatalog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CostingSheetCatalogImplCopyWith<_$CostingSheetCatalogImpl> get copyWith =>
      __$$CostingSheetCatalogImplCopyWithImpl<_$CostingSheetCatalogImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CostingSheetCatalogImplToJson(this);
  }
}

abstract class _CostingSheetCatalog implements CostingSheetCatalog {
  const factory _CostingSheetCatalog({
    required final String id,
    required final String name,
    final String? description,
    required final DateTime createdAt,
    required final String createdBy,
  }) = _$CostingSheetCatalogImpl;

  factory _CostingSheetCatalog.fromJson(Map<String, dynamic> json) =
      _$CostingSheetCatalogImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  DateTime get createdAt;
  @override
  String get createdBy;

  /// Create a copy of CostingSheetCatalog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CostingSheetCatalogImplCopyWith<_$CostingSheetCatalogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CostingSheetVersion _$CostingSheetVersionFromJson(Map<String, dynamic> json) {
  return _CostingSheetVersion.fromJson(json);
}

/// @nodoc
mixin _$CostingSheetVersion {
  String get id => throw _privateConstructorUsedError;
  String get catalogId => throw _privateConstructorUsedError;
  int get versionNumber => throw _privateConstructorUsedError;
  int get status =>
      throw _privateConstructorUsedError; // 0: Draft, 1: PendingApproval, 2: Active, 3: Archived
  DateTime get effectiveFrom => throw _privateConstructorUsedError;
  DateTime? get effectiveTo => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  String? get approvedBy => throw _privateConstructorUsedError;

  /// Serializes this CostingSheetVersion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CostingSheetVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CostingSheetVersionCopyWith<CostingSheetVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CostingSheetVersionCopyWith<$Res> {
  factory $CostingSheetVersionCopyWith(
    CostingSheetVersion value,
    $Res Function(CostingSheetVersion) then,
  ) = _$CostingSheetVersionCopyWithImpl<$Res, CostingSheetVersion>;
  @useResult
  $Res call({
    String id,
    String catalogId,
    int versionNumber,
    int status,
    DateTime effectiveFrom,
    DateTime? effectiveTo,
    DateTime createdAt,
    String createdBy,
    DateTime? approvedAt,
    String? approvedBy,
  });
}

/// @nodoc
class _$CostingSheetVersionCopyWithImpl<$Res, $Val extends CostingSheetVersion>
    implements $CostingSheetVersionCopyWith<$Res> {
  _$CostingSheetVersionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CostingSheetVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? catalogId = null,
    Object? versionNumber = null,
    Object? status = null,
    Object? effectiveFrom = null,
    Object? effectiveTo = freezed,
    Object? createdAt = null,
    Object? createdBy = null,
    Object? approvedAt = freezed,
    Object? approvedBy = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            catalogId: null == catalogId
                ? _value.catalogId
                : catalogId // ignore: cast_nullable_to_non_nullable
                      as String,
            versionNumber: null == versionNumber
                ? _value.versionNumber
                : versionNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as int,
            effectiveFrom: null == effectiveFrom
                ? _value.effectiveFrom
                : effectiveFrom // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            effectiveTo: freezed == effectiveTo
                ? _value.effectiveTo
                : effectiveTo // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            approvedAt: freezed == approvedAt
                ? _value.approvedAt
                : approvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            approvedBy: freezed == approvedBy
                ? _value.approvedBy
                : approvedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CostingSheetVersionImplCopyWith<$Res>
    implements $CostingSheetVersionCopyWith<$Res> {
  factory _$$CostingSheetVersionImplCopyWith(
    _$CostingSheetVersionImpl value,
    $Res Function(_$CostingSheetVersionImpl) then,
  ) = __$$CostingSheetVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String catalogId,
    int versionNumber,
    int status,
    DateTime effectiveFrom,
    DateTime? effectiveTo,
    DateTime createdAt,
    String createdBy,
    DateTime? approvedAt,
    String? approvedBy,
  });
}

/// @nodoc
class __$$CostingSheetVersionImplCopyWithImpl<$Res>
    extends _$CostingSheetVersionCopyWithImpl<$Res, _$CostingSheetVersionImpl>
    implements _$$CostingSheetVersionImplCopyWith<$Res> {
  __$$CostingSheetVersionImplCopyWithImpl(
    _$CostingSheetVersionImpl _value,
    $Res Function(_$CostingSheetVersionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CostingSheetVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? catalogId = null,
    Object? versionNumber = null,
    Object? status = null,
    Object? effectiveFrom = null,
    Object? effectiveTo = freezed,
    Object? createdAt = null,
    Object? createdBy = null,
    Object? approvedAt = freezed,
    Object? approvedBy = freezed,
  }) {
    return _then(
      _$CostingSheetVersionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        catalogId: null == catalogId
            ? _value.catalogId
            : catalogId // ignore: cast_nullable_to_non_nullable
                  as String,
        versionNumber: null == versionNumber
            ? _value.versionNumber
            : versionNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as int,
        effectiveFrom: null == effectiveFrom
            ? _value.effectiveFrom
            : effectiveFrom // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        effectiveTo: freezed == effectiveTo
            ? _value.effectiveTo
            : effectiveTo // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        approvedAt: freezed == approvedAt
            ? _value.approvedAt
            : approvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        approvedBy: freezed == approvedBy
            ? _value.approvedBy
            : approvedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CostingSheetVersionImpl implements _CostingSheetVersion {
  const _$CostingSheetVersionImpl({
    required this.id,
    required this.catalogId,
    required this.versionNumber,
    required this.status,
    required this.effectiveFrom,
    this.effectiveTo,
    required this.createdAt,
    required this.createdBy,
    this.approvedAt,
    this.approvedBy,
  });

  factory _$CostingSheetVersionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CostingSheetVersionImplFromJson(json);

  @override
  final String id;
  @override
  final String catalogId;
  @override
  final int versionNumber;
  @override
  final int status;
  // 0: Draft, 1: PendingApproval, 2: Active, 3: Archived
  @override
  final DateTime effectiveFrom;
  @override
  final DateTime? effectiveTo;
  @override
  final DateTime createdAt;
  @override
  final String createdBy;
  @override
  final DateTime? approvedAt;
  @override
  final String? approvedBy;

  @override
  String toString() {
    return 'CostingSheetVersion(id: $id, catalogId: $catalogId, versionNumber: $versionNumber, status: $status, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, createdAt: $createdAt, createdBy: $createdBy, approvedAt: $approvedAt, approvedBy: $approvedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CostingSheetVersionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.catalogId, catalogId) ||
                other.catalogId == catalogId) &&
            (identical(other.versionNumber, versionNumber) ||
                other.versionNumber == versionNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.effectiveFrom, effectiveFrom) ||
                other.effectiveFrom == effectiveFrom) &&
            (identical(other.effectiveTo, effectiveTo) ||
                other.effectiveTo == effectiveTo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    catalogId,
    versionNumber,
    status,
    effectiveFrom,
    effectiveTo,
    createdAt,
    createdBy,
    approvedAt,
    approvedBy,
  );

  /// Create a copy of CostingSheetVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CostingSheetVersionImplCopyWith<_$CostingSheetVersionImpl> get copyWith =>
      __$$CostingSheetVersionImplCopyWithImpl<_$CostingSheetVersionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CostingSheetVersionImplToJson(this);
  }
}

abstract class _CostingSheetVersion implements CostingSheetVersion {
  const factory _CostingSheetVersion({
    required final String id,
    required final String catalogId,
    required final int versionNumber,
    required final int status,
    required final DateTime effectiveFrom,
    final DateTime? effectiveTo,
    required final DateTime createdAt,
    required final String createdBy,
    final DateTime? approvedAt,
    final String? approvedBy,
  }) = _$CostingSheetVersionImpl;

  factory _CostingSheetVersion.fromJson(Map<String, dynamic> json) =
      _$CostingSheetVersionImpl.fromJson;

  @override
  String get id;
  @override
  String get catalogId;
  @override
  int get versionNumber;
  @override
  int get status; // 0: Draft, 1: PendingApproval, 2: Active, 3: Archived
  @override
  DateTime get effectiveFrom;
  @override
  DateTime? get effectiveTo;
  @override
  DateTime get createdAt;
  @override
  String get createdBy;
  @override
  DateTime? get approvedAt;
  @override
  String? get approvedBy;

  /// Create a copy of CostingSheetVersion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CostingSheetVersionImplCopyWith<_$CostingSheetVersionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CostingSheetItem _$CostingSheetItemFromJson(Map<String, dynamic> json) {
  return _CostingSheetItem.fromJson(json);
}

/// @nodoc
mixin _$CostingSheetItem {
  String get id => throw _privateConstructorUsedError;
  String get versionId => throw _privateConstructorUsedError;
  int get classificationId => throw _privateConstructorUsedError;
  int? get measurementUnitId => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CostingSheetItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CostingSheetItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CostingSheetItemCopyWith<CostingSheetItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CostingSheetItemCopyWith<$Res> {
  factory $CostingSheetItemCopyWith(
    CostingSheetItem value,
    $Res Function(CostingSheetItem) then,
  ) = _$CostingSheetItemCopyWithImpl<$Res, CostingSheetItem>;
  @useResult
  $Res call({
    String id,
    String versionId,
    int classificationId,
    int? measurementUnitId,
    double unitPrice,
    DateTime createdAt,
  });
}

/// @nodoc
class _$CostingSheetItemCopyWithImpl<$Res, $Val extends CostingSheetItem>
    implements $CostingSheetItemCopyWith<$Res> {
  _$CostingSheetItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CostingSheetItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? versionId = null,
    Object? classificationId = null,
    Object? measurementUnitId = freezed,
    Object? unitPrice = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            versionId: null == versionId
                ? _value.versionId
                : versionId // ignore: cast_nullable_to_non_nullable
                      as String,
            classificationId: null == classificationId
                ? _value.classificationId
                : classificationId // ignore: cast_nullable_to_non_nullable
                      as int,
            measurementUnitId: freezed == measurementUnitId
                ? _value.measurementUnitId
                : measurementUnitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CostingSheetItemImplCopyWith<$Res>
    implements $CostingSheetItemCopyWith<$Res> {
  factory _$$CostingSheetItemImplCopyWith(
    _$CostingSheetItemImpl value,
    $Res Function(_$CostingSheetItemImpl) then,
  ) = __$$CostingSheetItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String versionId,
    int classificationId,
    int? measurementUnitId,
    double unitPrice,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$CostingSheetItemImplCopyWithImpl<$Res>
    extends _$CostingSheetItemCopyWithImpl<$Res, _$CostingSheetItemImpl>
    implements _$$CostingSheetItemImplCopyWith<$Res> {
  __$$CostingSheetItemImplCopyWithImpl(
    _$CostingSheetItemImpl _value,
    $Res Function(_$CostingSheetItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CostingSheetItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? versionId = null,
    Object? classificationId = null,
    Object? measurementUnitId = freezed,
    Object? unitPrice = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$CostingSheetItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        versionId: null == versionId
            ? _value.versionId
            : versionId // ignore: cast_nullable_to_non_nullable
                  as String,
        classificationId: null == classificationId
            ? _value.classificationId
            : classificationId // ignore: cast_nullable_to_non_nullable
                  as int,
        measurementUnitId: freezed == measurementUnitId
            ? _value.measurementUnitId
            : measurementUnitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CostingSheetItemImpl implements _CostingSheetItem {
  const _$CostingSheetItemImpl({
    required this.id,
    required this.versionId,
    required this.classificationId,
    this.measurementUnitId,
    required this.unitPrice,
    required this.createdAt,
  });

  factory _$CostingSheetItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CostingSheetItemImplFromJson(json);

  @override
  final String id;
  @override
  final String versionId;
  @override
  final int classificationId;
  @override
  final int? measurementUnitId;
  @override
  final double unitPrice;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CostingSheetItem(id: $id, versionId: $versionId, classificationId: $classificationId, measurementUnitId: $measurementUnitId, unitPrice: $unitPrice, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CostingSheetItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.versionId, versionId) ||
                other.versionId == versionId) &&
            (identical(other.classificationId, classificationId) ||
                other.classificationId == classificationId) &&
            (identical(other.measurementUnitId, measurementUnitId) ||
                other.measurementUnitId == measurementUnitId) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    versionId,
    classificationId,
    measurementUnitId,
    unitPrice,
    createdAt,
  );

  /// Create a copy of CostingSheetItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CostingSheetItemImplCopyWith<_$CostingSheetItemImpl> get copyWith =>
      __$$CostingSheetItemImplCopyWithImpl<_$CostingSheetItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CostingSheetItemImplToJson(this);
  }
}

abstract class _CostingSheetItem implements CostingSheetItem {
  const factory _CostingSheetItem({
    required final String id,
    required final String versionId,
    required final int classificationId,
    final int? measurementUnitId,
    required final double unitPrice,
    required final DateTime createdAt,
  }) = _$CostingSheetItemImpl;

  factory _CostingSheetItem.fromJson(Map<String, dynamic> json) =
      _$CostingSheetItemImpl.fromJson;

  @override
  String get id;
  @override
  String get versionId;
  @override
  int get classificationId;
  @override
  int? get measurementUnitId;
  @override
  double get unitPrice;
  @override
  DateTime get createdAt;

  /// Create a copy of CostingSheetItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CostingSheetItemImplCopyWith<_$CostingSheetItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
