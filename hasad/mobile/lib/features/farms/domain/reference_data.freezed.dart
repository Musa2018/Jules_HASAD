// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reference_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReferenceData _$ReferenceDataFromJson(Map<String, dynamic> json) {
  return _ReferenceData.fromJson(json);
}

/// @nodoc
mixin _$ReferenceData {
  List<OwnershipType> get ownershipTypes => throw _privateConstructorUsedError;
  List<AgriculturalSector> get agriculturalSectors =>
      throw _privateConstructorUsedError;
  List<PoliticalClassification> get politicalClassifications =>
      throw _privateConstructorUsedError;
  List<AreaUnit> get areaUnits => throw _privateConstructorUsedError;
  List<RelationshipToOwner> get relationshipToOwners =>
      throw _privateConstructorUsedError;

  /// Serializes this ReferenceData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReferenceData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReferenceDataCopyWith<ReferenceData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReferenceDataCopyWith<$Res> {
  factory $ReferenceDataCopyWith(
    ReferenceData value,
    $Res Function(ReferenceData) then,
  ) = _$ReferenceDataCopyWithImpl<$Res, ReferenceData>;
  @useResult
  $Res call({
    List<OwnershipType> ownershipTypes,
    List<AgriculturalSector> agriculturalSectors,
    List<PoliticalClassification> politicalClassifications,
    List<AreaUnit> areaUnits,
    List<RelationshipToOwner> relationshipToOwners,
  });
}

/// @nodoc
class _$ReferenceDataCopyWithImpl<$Res, $Val extends ReferenceData>
    implements $ReferenceDataCopyWith<$Res> {
  _$ReferenceDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReferenceData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ownershipTypes = null,
    Object? agriculturalSectors = null,
    Object? politicalClassifications = null,
    Object? areaUnits = null,
    Object? relationshipToOwners = null,
  }) {
    return _then(
      _value.copyWith(
            ownershipTypes: null == ownershipTypes
                ? _value.ownershipTypes
                : ownershipTypes // ignore: cast_nullable_to_non_nullable
                      as List<OwnershipType>,
            agriculturalSectors: null == agriculturalSectors
                ? _value.agriculturalSectors
                : agriculturalSectors // ignore: cast_nullable_to_non_nullable
                      as List<AgriculturalSector>,
            politicalClassifications: null == politicalClassifications
                ? _value.politicalClassifications
                : politicalClassifications // ignore: cast_nullable_to_non_nullable
                      as List<PoliticalClassification>,
            areaUnits: null == areaUnits
                ? _value.areaUnits
                : areaUnits // ignore: cast_nullable_to_non_nullable
                      as List<AreaUnit>,
            relationshipToOwners: null == relationshipToOwners
                ? _value.relationshipToOwners
                : relationshipToOwners // ignore: cast_nullable_to_non_nullable
                      as List<RelationshipToOwner>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReferenceDataImplCopyWith<$Res>
    implements $ReferenceDataCopyWith<$Res> {
  factory _$$ReferenceDataImplCopyWith(
    _$ReferenceDataImpl value,
    $Res Function(_$ReferenceDataImpl) then,
  ) = __$$ReferenceDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<OwnershipType> ownershipTypes,
    List<AgriculturalSector> agriculturalSectors,
    List<PoliticalClassification> politicalClassifications,
    List<AreaUnit> areaUnits,
    List<RelationshipToOwner> relationshipToOwners,
  });
}

/// @nodoc
class __$$ReferenceDataImplCopyWithImpl<$Res>
    extends _$ReferenceDataCopyWithImpl<$Res, _$ReferenceDataImpl>
    implements _$$ReferenceDataImplCopyWith<$Res> {
  __$$ReferenceDataImplCopyWithImpl(
    _$ReferenceDataImpl _value,
    $Res Function(_$ReferenceDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReferenceData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ownershipTypes = null,
    Object? agriculturalSectors = null,
    Object? politicalClassifications = null,
    Object? areaUnits = null,
    Object? relationshipToOwners = null,
  }) {
    return _then(
      _$ReferenceDataImpl(
        ownershipTypes: null == ownershipTypes
            ? _value._ownershipTypes
            : ownershipTypes // ignore: cast_nullable_to_non_nullable
                  as List<OwnershipType>,
        agriculturalSectors: null == agriculturalSectors
            ? _value._agriculturalSectors
            : agriculturalSectors // ignore: cast_nullable_to_non_nullable
                  as List<AgriculturalSector>,
        politicalClassifications: null == politicalClassifications
            ? _value._politicalClassifications
            : politicalClassifications // ignore: cast_nullable_to_non_nullable
                  as List<PoliticalClassification>,
        areaUnits: null == areaUnits
            ? _value._areaUnits
            : areaUnits // ignore: cast_nullable_to_non_nullable
                  as List<AreaUnit>,
        relationshipToOwners: null == relationshipToOwners
            ? _value._relationshipToOwners
            : relationshipToOwners // ignore: cast_nullable_to_non_nullable
                  as List<RelationshipToOwner>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReferenceDataImpl implements _ReferenceData {
  const _$ReferenceDataImpl({
    required final List<OwnershipType> ownershipTypes,
    required final List<AgriculturalSector> agriculturalSectors,
    required final List<PoliticalClassification> politicalClassifications,
    required final List<AreaUnit> areaUnits,
    required final List<RelationshipToOwner> relationshipToOwners,
  }) : _ownershipTypes = ownershipTypes,
       _agriculturalSectors = agriculturalSectors,
       _politicalClassifications = politicalClassifications,
       _areaUnits = areaUnits,
       _relationshipToOwners = relationshipToOwners;

  factory _$ReferenceDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReferenceDataImplFromJson(json);

  final List<OwnershipType> _ownershipTypes;
  @override
  List<OwnershipType> get ownershipTypes {
    if (_ownershipTypes is EqualUnmodifiableListView) return _ownershipTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ownershipTypes);
  }

  final List<AgriculturalSector> _agriculturalSectors;
  @override
  List<AgriculturalSector> get agriculturalSectors {
    if (_agriculturalSectors is EqualUnmodifiableListView)
      return _agriculturalSectors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_agriculturalSectors);
  }

  final List<PoliticalClassification> _politicalClassifications;
  @override
  List<PoliticalClassification> get politicalClassifications {
    if (_politicalClassifications is EqualUnmodifiableListView)
      return _politicalClassifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_politicalClassifications);
  }

  final List<AreaUnit> _areaUnits;
  @override
  List<AreaUnit> get areaUnits {
    if (_areaUnits is EqualUnmodifiableListView) return _areaUnits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_areaUnits);
  }

  final List<RelationshipToOwner> _relationshipToOwners;
  @override
  List<RelationshipToOwner> get relationshipToOwners {
    if (_relationshipToOwners is EqualUnmodifiableListView)
      return _relationshipToOwners;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relationshipToOwners);
  }

  @override
  String toString() {
    return 'ReferenceData(ownershipTypes: $ownershipTypes, agriculturalSectors: $agriculturalSectors, politicalClassifications: $politicalClassifications, areaUnits: $areaUnits, relationshipToOwners: $relationshipToOwners)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReferenceDataImpl &&
            const DeepCollectionEquality().equals(
              other._ownershipTypes,
              _ownershipTypes,
            ) &&
            const DeepCollectionEquality().equals(
              other._agriculturalSectors,
              _agriculturalSectors,
            ) &&
            const DeepCollectionEquality().equals(
              other._politicalClassifications,
              _politicalClassifications,
            ) &&
            const DeepCollectionEquality().equals(
              other._areaUnits,
              _areaUnits,
            ) &&
            const DeepCollectionEquality().equals(
              other._relationshipToOwners,
              _relationshipToOwners,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_ownershipTypes),
    const DeepCollectionEquality().hash(_agriculturalSectors),
    const DeepCollectionEquality().hash(_politicalClassifications),
    const DeepCollectionEquality().hash(_areaUnits),
    const DeepCollectionEquality().hash(_relationshipToOwners),
  );

  /// Create a copy of ReferenceData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReferenceDataImplCopyWith<_$ReferenceDataImpl> get copyWith =>
      __$$ReferenceDataImplCopyWithImpl<_$ReferenceDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReferenceDataImplToJson(this);
  }
}

abstract class _ReferenceData implements ReferenceData {
  const factory _ReferenceData({
    required final List<OwnershipType> ownershipTypes,
    required final List<AgriculturalSector> agriculturalSectors,
    required final List<PoliticalClassification> politicalClassifications,
    required final List<AreaUnit> areaUnits,
    required final List<RelationshipToOwner> relationshipToOwners,
  }) = _$ReferenceDataImpl;

  factory _ReferenceData.fromJson(Map<String, dynamic> json) =
      _$ReferenceDataImpl.fromJson;

  @override
  List<OwnershipType> get ownershipTypes;
  @override
  List<AgriculturalSector> get agriculturalSectors;
  @override
  List<PoliticalClassification> get politicalClassifications;
  @override
  List<AreaUnit> get areaUnits;
  @override
  List<RelationshipToOwner> get relationshipToOwners;

  /// Create a copy of ReferenceData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReferenceDataImplCopyWith<_$ReferenceDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
