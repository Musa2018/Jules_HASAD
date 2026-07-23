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
