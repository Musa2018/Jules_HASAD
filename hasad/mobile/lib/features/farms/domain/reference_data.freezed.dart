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
      throw _privateConstructorUsedError; // Damage Hierarchy
  List<DamageNature> get damageNatures => throw _privateConstructorUsedError;
  List<DamageCategory> get damageCategories =>
      throw _privateConstructorUsedError;
  List<DamageSubCategory> get damageSubCategories =>
      throw _privateConstructorUsedError;
  List<DamageClassification> get damageClassifications =>
      throw _privateConstructorUsedError; // Damage Causes
  List<DamageCauseCategory> get damageCauseCategories =>
      throw _privateConstructorUsedError;
  List<DamageCause> get damageCauses => throw _privateConstructorUsedError;
  List<CostingSheetVersion> get costingSheets =>
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
    List<DamageNature> damageNatures,
    List<DamageCategory> damageCategories,
    List<DamageSubCategory> damageSubCategories,
    List<DamageClassification> damageClassifications,
    List<DamageCauseCategory> damageCauseCategories,
    List<DamageCause> damageCauses,
    List<CostingSheetVersion> costingSheets,
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
    Object? damageNatures = null,
    Object? damageCategories = null,
    Object? damageSubCategories = null,
    Object? damageClassifications = null,
    Object? damageCauseCategories = null,
    Object? damageCauses = null,
    Object? costingSheets = null,
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
            damageNatures: null == damageNatures
                ? _value.damageNatures
                : damageNatures // ignore: cast_nullable_to_non_nullable
                      as List<DamageNature>,
            damageCategories: null == damageCategories
                ? _value.damageCategories
                : damageCategories // ignore: cast_nullable_to_non_nullable
                      as List<DamageCategory>,
            damageSubCategories: null == damageSubCategories
                ? _value.damageSubCategories
                : damageSubCategories // ignore: cast_nullable_to_non_nullable
                      as List<DamageSubCategory>,
            damageClassifications: null == damageClassifications
                ? _value.damageClassifications
                : damageClassifications // ignore: cast_nullable_to_non_nullable
                      as List<DamageClassification>,
            damageCauseCategories: null == damageCauseCategories
                ? _value.damageCauseCategories
                : damageCauseCategories // ignore: cast_nullable_to_non_nullable
                      as List<DamageCauseCategory>,
            damageCauses: null == damageCauses
                ? _value.damageCauses
                : damageCauses // ignore: cast_nullable_to_non_nullable
                      as List<DamageCause>,
            costingSheets: null == costingSheets
                ? _value.costingSheets
                : costingSheets // ignore: cast_nullable_to_non_nullable
                      as List<CostingSheetVersion>,
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
    List<DamageNature> damageNatures,
    List<DamageCategory> damageCategories,
    List<DamageSubCategory> damageSubCategories,
    List<DamageClassification> damageClassifications,
    List<DamageCauseCategory> damageCauseCategories,
    List<DamageCause> damageCauses,
    List<CostingSheetVersion> costingSheets,
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
    Object? damageNatures = null,
    Object? damageCategories = null,
    Object? damageSubCategories = null,
    Object? damageClassifications = null,
    Object? damageCauseCategories = null,
    Object? damageCauses = null,
    Object? costingSheets = null,
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
        damageNatures: null == damageNatures
            ? _value._damageNatures
            : damageNatures // ignore: cast_nullable_to_non_nullable
                  as List<DamageNature>,
        damageCategories: null == damageCategories
            ? _value._damageCategories
            : damageCategories // ignore: cast_nullable_to_non_nullable
                  as List<DamageCategory>,
        damageSubCategories: null == damageSubCategories
            ? _value._damageSubCategories
            : damageSubCategories // ignore: cast_nullable_to_non_nullable
                  as List<DamageSubCategory>,
        damageClassifications: null == damageClassifications
            ? _value._damageClassifications
            : damageClassifications // ignore: cast_nullable_to_non_nullable
                  as List<DamageClassification>,
        damageCauseCategories: null == damageCauseCategories
            ? _value._damageCauseCategories
            : damageCauseCategories // ignore: cast_nullable_to_non_nullable
                  as List<DamageCauseCategory>,
        damageCauses: null == damageCauses
            ? _value._damageCauses
            : damageCauses // ignore: cast_nullable_to_non_nullable
                  as List<DamageCause>,
        costingSheets: null == costingSheets
            ? _value._costingSheets
            : costingSheets // ignore: cast_nullable_to_non_nullable
                  as List<CostingSheetVersion>,
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
    required final List<DamageNature> damageNatures,
    required final List<DamageCategory> damageCategories,
    required final List<DamageSubCategory> damageSubCategories,
    required final List<DamageClassification> damageClassifications,
    required final List<DamageCauseCategory> damageCauseCategories,
    required final List<DamageCause> damageCauses,
    required final List<CostingSheetVersion> costingSheets,
  }) : _ownershipTypes = ownershipTypes,
       _agriculturalSectors = agriculturalSectors,
       _politicalClassifications = politicalClassifications,
       _areaUnits = areaUnits,
       _relationshipToOwners = relationshipToOwners,
       _damageNatures = damageNatures,
       _damageCategories = damageCategories,
       _damageSubCategories = damageSubCategories,
       _damageClassifications = damageClassifications,
       _damageCauseCategories = damageCauseCategories,
       _damageCauses = damageCauses,
       _costingSheets = costingSheets;

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

  // Damage Hierarchy
  final List<DamageNature> _damageNatures;
  // Damage Hierarchy
  @override
  List<DamageNature> get damageNatures {
    if (_damageNatures is EqualUnmodifiableListView) return _damageNatures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_damageNatures);
  }

  final List<DamageCategory> _damageCategories;
  @override
  List<DamageCategory> get damageCategories {
    if (_damageCategories is EqualUnmodifiableListView)
      return _damageCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_damageCategories);
  }

  final List<DamageSubCategory> _damageSubCategories;
  @override
  List<DamageSubCategory> get damageSubCategories {
    if (_damageSubCategories is EqualUnmodifiableListView)
      return _damageSubCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_damageSubCategories);
  }

  final List<DamageClassification> _damageClassifications;
  @override
  List<DamageClassification> get damageClassifications {
    if (_damageClassifications is EqualUnmodifiableListView)
      return _damageClassifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_damageClassifications);
  }

  // Damage Causes
  final List<DamageCauseCategory> _damageCauseCategories;
  // Damage Causes
  @override
  List<DamageCauseCategory> get damageCauseCategories {
    if (_damageCauseCategories is EqualUnmodifiableListView)
      return _damageCauseCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_damageCauseCategories);
  }

  final List<DamageCause> _damageCauses;
  @override
  List<DamageCause> get damageCauses {
    if (_damageCauses is EqualUnmodifiableListView) return _damageCauses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_damageCauses);
  }

  final List<CostingSheetVersion> _costingSheets;
  @override
  List<CostingSheetVersion> get costingSheets {
    if (_costingSheets is EqualUnmodifiableListView) return _costingSheets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_costingSheets);
  }

  @override
  String toString() {
    return 'ReferenceData(ownershipTypes: $ownershipTypes, agriculturalSectors: $agriculturalSectors, politicalClassifications: $politicalClassifications, areaUnits: $areaUnits, relationshipToOwners: $relationshipToOwners, damageNatures: $damageNatures, damageCategories: $damageCategories, damageSubCategories: $damageSubCategories, damageClassifications: $damageClassifications, damageCauseCategories: $damageCauseCategories, damageCauses: $damageCauses, costingSheets: $costingSheets)';
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
            ) &&
            const DeepCollectionEquality().equals(
              other._damageNatures,
              _damageNatures,
            ) &&
            const DeepCollectionEquality().equals(
              other._damageCategories,
              _damageCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._damageSubCategories,
              _damageSubCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._damageClassifications,
              _damageClassifications,
            ) &&
            const DeepCollectionEquality().equals(
              other._damageCauseCategories,
              _damageCauseCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._damageCauses,
              _damageCauses,
            ) &&
            const DeepCollectionEquality().equals(
              other._costingSheets,
              _costingSheets,
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
    const DeepCollectionEquality().hash(_damageNatures),
    const DeepCollectionEquality().hash(_damageCategories),
    const DeepCollectionEquality().hash(_damageSubCategories),
    const DeepCollectionEquality().hash(_damageClassifications),
    const DeepCollectionEquality().hash(_damageCauseCategories),
    const DeepCollectionEquality().hash(_damageCauses),
    const DeepCollectionEquality().hash(_costingSheets),
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
    required final List<DamageNature> damageNatures,
    required final List<DamageCategory> damageCategories,
    required final List<DamageSubCategory> damageSubCategories,
    required final List<DamageClassification> damageClassifications,
    required final List<DamageCauseCategory> damageCauseCategories,
    required final List<DamageCause> damageCauses,
    required final List<CostingSheetVersion> costingSheets,
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
  List<RelationshipToOwner> get relationshipToOwners; // Damage Hierarchy
  @override
  List<DamageNature> get damageNatures;
  @override
  List<DamageCategory> get damageCategories;
  @override
  List<DamageSubCategory> get damageSubCategories;
  @override
  List<DamageClassification> get damageClassifications; // Damage Causes
  @override
  List<DamageCauseCategory> get damageCauseCategories;
  @override
  List<DamageCause> get damageCauses;
  @override
  List<CostingSheetVersion> get costingSheets;

  /// Create a copy of ReferenceData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReferenceDataImplCopyWith<_$ReferenceDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
