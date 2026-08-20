// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReportDefinitionMetadata _$ReportDefinitionMetadataFromJson(
    Map<String, dynamic> json) {
  return _ReportDefinitionMetadata.fromJson(json);
}

/// @nodoc
mixin _$ReportDefinitionMetadata {
  String get reportId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get dataSourceViewName => throw _privateConstructorUsedError;
  String get defaultSortField => throw _privateConstructorUsedError;
  Map<String, ReportFieldMetadata> get allowedFields =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReportDefinitionMetadataCopyWith<ReportDefinitionMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportDefinitionMetadataCopyWith<$Res> {
  factory $ReportDefinitionMetadataCopyWith(ReportDefinitionMetadata value,
          $Res Function(ReportDefinitionMetadata) then) =
      _$ReportDefinitionMetadataCopyWithImpl<$Res, ReportDefinitionMetadata>;
  @useResult
  $Res call(
      {String reportId,
      String title,
      String dataSourceViewName,
      String defaultSortField,
      Map<String, ReportFieldMetadata> allowedFields});
}

/// @nodoc
class _$ReportDefinitionMetadataCopyWithImpl<$Res,
        $Val extends ReportDefinitionMetadata>
    implements $ReportDefinitionMetadataCopyWith<$Res> {
  _$ReportDefinitionMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportId = null,
    Object? title = null,
    Object? dataSourceViewName = null,
    Object? defaultSortField = null,
    Object? allowedFields = null,
  }) {
    return _then(_value.copyWith(
      reportId: null == reportId
          ? _value.reportId
          : reportId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      dataSourceViewName: null == dataSourceViewName
          ? _value.dataSourceViewName
          : dataSourceViewName // ignore: cast_nullable_to_non_nullable
              as String,
      defaultSortField: null == defaultSortField
          ? _value.defaultSortField
          : defaultSortField // ignore: cast_nullable_to_non_nullable
              as String,
      allowedFields: null == allowedFields
          ? _value.allowedFields
          : allowedFields // ignore: cast_nullable_to_non_nullable
              as Map<String, ReportFieldMetadata>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportDefinitionMetadataImplCopyWith<$Res>
    implements $ReportDefinitionMetadataCopyWith<$Res> {
  factory _$$ReportDefinitionMetadataImplCopyWith(
          _$ReportDefinitionMetadataImpl value,
          $Res Function(_$ReportDefinitionMetadataImpl) then) =
      __$$ReportDefinitionMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String reportId,
      String title,
      String dataSourceViewName,
      String defaultSortField,
      Map<String, ReportFieldMetadata> allowedFields});
}

/// @nodoc
class __$$ReportDefinitionMetadataImplCopyWithImpl<$Res>
    extends _$ReportDefinitionMetadataCopyWithImpl<$Res,
        _$ReportDefinitionMetadataImpl>
    implements _$$ReportDefinitionMetadataImplCopyWith<$Res> {
  __$$ReportDefinitionMetadataImplCopyWithImpl(
      _$ReportDefinitionMetadataImpl _value,
      $Res Function(_$ReportDefinitionMetadataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportId = null,
    Object? title = null,
    Object? dataSourceViewName = null,
    Object? defaultSortField = null,
    Object? allowedFields = null,
  }) {
    return _then(_$ReportDefinitionMetadataImpl(
      reportId: null == reportId
          ? _value.reportId
          : reportId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      dataSourceViewName: null == dataSourceViewName
          ? _value.dataSourceViewName
          : dataSourceViewName // ignore: cast_nullable_to_non_nullable
              as String,
      defaultSortField: null == defaultSortField
          ? _value.defaultSortField
          : defaultSortField // ignore: cast_nullable_to_non_nullable
              as String,
      allowedFields: null == allowedFields
          ? _value._allowedFields
          : allowedFields // ignore: cast_nullable_to_non_nullable
              as Map<String, ReportFieldMetadata>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportDefinitionMetadataImpl implements _ReportDefinitionMetadata {
  const _$ReportDefinitionMetadataImpl(
      {required this.reportId,
      required this.title,
      required this.dataSourceViewName,
      required this.defaultSortField,
      required final Map<String, ReportFieldMetadata> allowedFields})
      : _allowedFields = allowedFields;

  factory _$ReportDefinitionMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportDefinitionMetadataImplFromJson(json);

  @override
  final String reportId;
  @override
  final String title;
  @override
  final String dataSourceViewName;
  @override
  final String defaultSortField;
  final Map<String, ReportFieldMetadata> _allowedFields;
  @override
  Map<String, ReportFieldMetadata> get allowedFields {
    if (_allowedFields is EqualUnmodifiableMapView) return _allowedFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_allowedFields);
  }

  @override
  String toString() {
    return 'ReportDefinitionMetadata(reportId: $reportId, title: $title, dataSourceViewName: $dataSourceViewName, defaultSortField: $defaultSortField, allowedFields: $allowedFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportDefinitionMetadataImpl &&
            (identical(other.reportId, reportId) ||
                other.reportId == reportId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.dataSourceViewName, dataSourceViewName) ||
                other.dataSourceViewName == dataSourceViewName) &&
            (identical(other.defaultSortField, defaultSortField) ||
                other.defaultSortField == defaultSortField) &&
            const DeepCollectionEquality()
                .equals(other._allowedFields, _allowedFields));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      reportId,
      title,
      dataSourceViewName,
      defaultSortField,
      const DeepCollectionEquality().hash(_allowedFields));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportDefinitionMetadataImplCopyWith<_$ReportDefinitionMetadataImpl>
      get copyWith => __$$ReportDefinitionMetadataImplCopyWithImpl<
          _$ReportDefinitionMetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportDefinitionMetadataImplToJson(
      this,
    );
  }
}

abstract class _ReportDefinitionMetadata implements ReportDefinitionMetadata {
  const factory _ReportDefinitionMetadata(
          {required final String reportId,
          required final String title,
          required final String dataSourceViewName,
          required final String defaultSortField,
          required final Map<String, ReportFieldMetadata> allowedFields}) =
      _$ReportDefinitionMetadataImpl;

  factory _ReportDefinitionMetadata.fromJson(Map<String, dynamic> json) =
      _$ReportDefinitionMetadataImpl.fromJson;

  @override
  String get reportId;
  @override
  String get title;
  @override
  String get dataSourceViewName;
  @override
  String get defaultSortField;
  @override
  Map<String, ReportFieldMetadata> get allowedFields;
  @override
  @JsonKey(ignore: true)
  _$$ReportDefinitionMetadataImplCopyWith<_$ReportDefinitionMetadataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReportFieldMetadata _$ReportFieldMetadataFromJson(Map<String, dynamic> json) {
  return _ReportFieldMetadata.fromJson(json);
}

/// @nodoc
mixin _$ReportFieldMetadata {
  String get fieldName => throw _privateConstructorUsedError;
  String get dataType => throw _privateConstructorUsedError;
  bool get isFilterable => throw _privateConstructorUsedError;
  bool get isSortable => throw _privateConstructorUsedError;
  List<String> get allowedOperators => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReportFieldMetadataCopyWith<ReportFieldMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportFieldMetadataCopyWith<$Res> {
  factory $ReportFieldMetadataCopyWith(
          ReportFieldMetadata value, $Res Function(ReportFieldMetadata) then) =
      _$ReportFieldMetadataCopyWithImpl<$Res, ReportFieldMetadata>;
  @useResult
  $Res call(
      {String fieldName,
      String dataType,
      bool isFilterable,
      bool isSortable,
      List<String> allowedOperators});
}

/// @nodoc
class _$ReportFieldMetadataCopyWithImpl<$Res, $Val extends ReportFieldMetadata>
    implements $ReportFieldMetadataCopyWith<$Res> {
  _$ReportFieldMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fieldName = null,
    Object? dataType = null,
    Object? isFilterable = null,
    Object? isSortable = null,
    Object? allowedOperators = null,
  }) {
    return _then(_value.copyWith(
      fieldName: null == fieldName
          ? _value.fieldName
          : fieldName // ignore: cast_nullable_to_non_nullable
              as String,
      dataType: null == dataType
          ? _value.dataType
          : dataType // ignore: cast_nullable_to_non_nullable
              as String,
      isFilterable: null == isFilterable
          ? _value.isFilterable
          : isFilterable // ignore: cast_nullable_to_non_nullable
              as bool,
      isSortable: null == isSortable
          ? _value.isSortable
          : isSortable // ignore: cast_nullable_to_non_nullable
              as bool,
      allowedOperators: null == allowedOperators
          ? _value.allowedOperators
          : allowedOperators // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportFieldMetadataImplCopyWith<$Res>
    implements $ReportFieldMetadataCopyWith<$Res> {
  factory _$$ReportFieldMetadataImplCopyWith(_$ReportFieldMetadataImpl value,
          $Res Function(_$ReportFieldMetadataImpl) then) =
      __$$ReportFieldMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String fieldName,
      String dataType,
      bool isFilterable,
      bool isSortable,
      List<String> allowedOperators});
}

/// @nodoc
class __$$ReportFieldMetadataImplCopyWithImpl<$Res>
    extends _$ReportFieldMetadataCopyWithImpl<$Res, _$ReportFieldMetadataImpl>
    implements _$$ReportFieldMetadataImplCopyWith<$Res> {
  __$$ReportFieldMetadataImplCopyWithImpl(_$ReportFieldMetadataImpl _value,
      $Res Function(_$ReportFieldMetadataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fieldName = null,
    Object? dataType = null,
    Object? isFilterable = null,
    Object? isSortable = null,
    Object? allowedOperators = null,
  }) {
    return _then(_$ReportFieldMetadataImpl(
      fieldName: null == fieldName
          ? _value.fieldName
          : fieldName // ignore: cast_nullable_to_non_nullable
              as String,
      dataType: null == dataType
          ? _value.dataType
          : dataType // ignore: cast_nullable_to_non_nullable
              as String,
      isFilterable: null == isFilterable
          ? _value.isFilterable
          : isFilterable // ignore: cast_nullable_to_non_nullable
              as bool,
      isSortable: null == isSortable
          ? _value.isSortable
          : isSortable // ignore: cast_nullable_to_non_nullable
              as bool,
      allowedOperators: null == allowedOperators
          ? _value._allowedOperators
          : allowedOperators // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportFieldMetadataImpl implements _ReportFieldMetadata {
  const _$ReportFieldMetadataImpl(
      {required this.fieldName,
      this.dataType = 'string',
      this.isFilterable = true,
      this.isSortable = true,
      required final List<String> allowedOperators})
      : _allowedOperators = allowedOperators;

  factory _$ReportFieldMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportFieldMetadataImplFromJson(json);

  @override
  final String fieldName;
  @override
  @JsonKey()
  final String dataType;
  @override
  @JsonKey()
  final bool isFilterable;
  @override
  @JsonKey()
  final bool isSortable;
  final List<String> _allowedOperators;
  @override
  List<String> get allowedOperators {
    if (_allowedOperators is EqualUnmodifiableListView)
      return _allowedOperators;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allowedOperators);
  }

  @override
  String toString() {
    return 'ReportFieldMetadata(fieldName: $fieldName, dataType: $dataType, isFilterable: $isFilterable, isSortable: $isSortable, allowedOperators: $allowedOperators)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportFieldMetadataImpl &&
            (identical(other.fieldName, fieldName) ||
                other.fieldName == fieldName) &&
            (identical(other.dataType, dataType) ||
                other.dataType == dataType) &&
            (identical(other.isFilterable, isFilterable) ||
                other.isFilterable == isFilterable) &&
            (identical(other.isSortable, isSortable) ||
                other.isSortable == isSortable) &&
            const DeepCollectionEquality()
                .equals(other._allowedOperators, _allowedOperators));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      fieldName,
      dataType,
      isFilterable,
      isSortable,
      const DeepCollectionEquality().hash(_allowedOperators));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportFieldMetadataImplCopyWith<_$ReportFieldMetadataImpl> get copyWith =>
      __$$ReportFieldMetadataImplCopyWithImpl<_$ReportFieldMetadataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportFieldMetadataImplToJson(
      this,
    );
  }
}

abstract class _ReportFieldMetadata implements ReportFieldMetadata {
  const factory _ReportFieldMetadata(
          {required final String fieldName,
          final String dataType,
          final bool isFilterable,
          final bool isSortable,
          required final List<String> allowedOperators}) =
      _$ReportFieldMetadataImpl;

  factory _ReportFieldMetadata.fromJson(Map<String, dynamic> json) =
      _$ReportFieldMetadataImpl.fromJson;

  @override
  String get fieldName;
  @override
  String get dataType;
  @override
  bool get isFilterable;
  @override
  bool get isSortable;
  @override
  List<String> get allowedOperators;
  @override
  @JsonKey(ignore: true)
  _$$ReportFieldMetadataImplCopyWith<_$ReportFieldMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportRequest _$ReportRequestFromJson(Map<String, dynamic> json) {
  return _ReportRequest.fromJson(json);
}

/// @nodoc
mixin _$ReportRequest {
  String get reportId => throw _privateConstructorUsedError;
  int get pageIndex => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  List<String> get selectedColumns => throw _privateConstructorUsedError;
  List<ReportFilter> get filters => throw _privateConstructorUsedError;
  List<String>? get groupBy => throw _privateConstructorUsedError;
  List<ReportAggregate>? get aggregates => throw _privateConstructorUsedError;
  List<ReportSort>? get sorts => throw _privateConstructorUsedError;
  String get exportFormat => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReportRequestCopyWith<ReportRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportRequestCopyWith<$Res> {
  factory $ReportRequestCopyWith(
          ReportRequest value, $Res Function(ReportRequest) then) =
      _$ReportRequestCopyWithImpl<$Res, ReportRequest>;
  @useResult
  $Res call(
      {String reportId,
      int pageIndex,
      int pageSize,
      List<String> selectedColumns,
      List<ReportFilter> filters,
      List<String>? groupBy,
      List<ReportAggregate>? aggregates,
      List<ReportSort>? sorts,
      String exportFormat});
}

/// @nodoc
class _$ReportRequestCopyWithImpl<$Res, $Val extends ReportRequest>
    implements $ReportRequestCopyWith<$Res> {
  _$ReportRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportId = null,
    Object? pageIndex = null,
    Object? pageSize = null,
    Object? selectedColumns = null,
    Object? filters = null,
    Object? groupBy = freezed,
    Object? aggregates = freezed,
    Object? sorts = freezed,
    Object? exportFormat = null,
  }) {
    return _then(_value.copyWith(
      reportId: null == reportId
          ? _value.reportId
          : reportId // ignore: cast_nullable_to_non_nullable
              as String,
      pageIndex: null == pageIndex
          ? _value.pageIndex
          : pageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      selectedColumns: null == selectedColumns
          ? _value.selectedColumns
          : selectedColumns // ignore: cast_nullable_to_non_nullable
              as List<String>,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as List<ReportFilter>,
      groupBy: freezed == groupBy
          ? _value.groupBy
          : groupBy // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      aggregates: freezed == aggregates
          ? _value.aggregates
          : aggregates // ignore: cast_nullable_to_non_nullable
              as List<ReportAggregate>?,
      sorts: freezed == sorts
          ? _value.sorts
          : sorts // ignore: cast_nullable_to_non_nullable
              as List<ReportSort>?,
      exportFormat: null == exportFormat
          ? _value.exportFormat
          : exportFormat // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportRequestImplCopyWith<$Res>
    implements $ReportRequestCopyWith<$Res> {
  factory _$$ReportRequestImplCopyWith(
          _$ReportRequestImpl value, $Res Function(_$ReportRequestImpl) then) =
      __$$ReportRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String reportId,
      int pageIndex,
      int pageSize,
      List<String> selectedColumns,
      List<ReportFilter> filters,
      List<String>? groupBy,
      List<ReportAggregate>? aggregates,
      List<ReportSort>? sorts,
      String exportFormat});
}

/// @nodoc
class __$$ReportRequestImplCopyWithImpl<$Res>
    extends _$ReportRequestCopyWithImpl<$Res, _$ReportRequestImpl>
    implements _$$ReportRequestImplCopyWith<$Res> {
  __$$ReportRequestImplCopyWithImpl(
      _$ReportRequestImpl _value, $Res Function(_$ReportRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportId = null,
    Object? pageIndex = null,
    Object? pageSize = null,
    Object? selectedColumns = null,
    Object? filters = null,
    Object? groupBy = freezed,
    Object? aggregates = freezed,
    Object? sorts = freezed,
    Object? exportFormat = null,
  }) {
    return _then(_$ReportRequestImpl(
      reportId: null == reportId
          ? _value.reportId
          : reportId // ignore: cast_nullable_to_non_nullable
              as String,
      pageIndex: null == pageIndex
          ? _value.pageIndex
          : pageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      selectedColumns: null == selectedColumns
          ? _value._selectedColumns
          : selectedColumns // ignore: cast_nullable_to_non_nullable
              as List<String>,
      filters: null == filters
          ? _value._filters
          : filters // ignore: cast_nullable_to_non_nullable
              as List<ReportFilter>,
      groupBy: freezed == groupBy
          ? _value._groupBy
          : groupBy // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      aggregates: freezed == aggregates
          ? _value._aggregates
          : aggregates // ignore: cast_nullable_to_non_nullable
              as List<ReportAggregate>?,
      sorts: freezed == sorts
          ? _value._sorts
          : sorts // ignore: cast_nullable_to_non_nullable
              as List<ReportSort>?,
      exportFormat: null == exportFormat
          ? _value.exportFormat
          : exportFormat // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportRequestImpl implements _ReportRequest {
  const _$ReportRequestImpl(
      {required this.reportId,
      this.pageIndex = 1,
      this.pageSize = 50,
      final List<String> selectedColumns = const [],
      final List<ReportFilter> filters = const [],
      final List<String>? groupBy,
      final List<ReportAggregate>? aggregates,
      final List<ReportSort>? sorts,
      this.exportFormat = 'JSON'})
      : _selectedColumns = selectedColumns,
        _filters = filters,
        _groupBy = groupBy,
        _aggregates = aggregates,
        _sorts = sorts;

  factory _$ReportRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportRequestImplFromJson(json);

  @override
  final String reportId;
  @override
  @JsonKey()
  final int pageIndex;
  @override
  @JsonKey()
  final int pageSize;
  final List<String> _selectedColumns;
  @override
  @JsonKey()
  List<String> get selectedColumns {
    if (_selectedColumns is EqualUnmodifiableListView) return _selectedColumns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedColumns);
  }

  final List<ReportFilter> _filters;
  @override
  @JsonKey()
  List<ReportFilter> get filters {
    if (_filters is EqualUnmodifiableListView) return _filters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filters);
  }

  final List<String>? _groupBy;
  @override
  List<String>? get groupBy {
    final value = _groupBy;
    if (value == null) return null;
    if (_groupBy is EqualUnmodifiableListView) return _groupBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ReportAggregate>? _aggregates;
  @override
  List<ReportAggregate>? get aggregates {
    final value = _aggregates;
    if (value == null) return null;
    if (_aggregates is EqualUnmodifiableListView) return _aggregates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ReportSort>? _sorts;
  @override
  List<ReportSort>? get sorts {
    final value = _sorts;
    if (value == null) return null;
    if (_sorts is EqualUnmodifiableListView) return _sorts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final String exportFormat;

  @override
  String toString() {
    return 'ReportRequest(reportId: $reportId, pageIndex: $pageIndex, pageSize: $pageSize, selectedColumns: $selectedColumns, filters: $filters, groupBy: $groupBy, aggregates: $aggregates, sorts: $sorts, exportFormat: $exportFormat)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportRequestImpl &&
            (identical(other.reportId, reportId) ||
                other.reportId == reportId) &&
            (identical(other.pageIndex, pageIndex) ||
                other.pageIndex == pageIndex) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            const DeepCollectionEquality()
                .equals(other._selectedColumns, _selectedColumns) &&
            const DeepCollectionEquality().equals(other._filters, _filters) &&
            const DeepCollectionEquality().equals(other._groupBy, _groupBy) &&
            const DeepCollectionEquality()
                .equals(other._aggregates, _aggregates) &&
            const DeepCollectionEquality().equals(other._sorts, _sorts) &&
            (identical(other.exportFormat, exportFormat) ||
                other.exportFormat == exportFormat));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      reportId,
      pageIndex,
      pageSize,
      const DeepCollectionEquality().hash(_selectedColumns),
      const DeepCollectionEquality().hash(_filters),
      const DeepCollectionEquality().hash(_groupBy),
      const DeepCollectionEquality().hash(_aggregates),
      const DeepCollectionEquality().hash(_sorts),
      exportFormat);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportRequestImplCopyWith<_$ReportRequestImpl> get copyWith =>
      __$$ReportRequestImplCopyWithImpl<_$ReportRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportRequestImplToJson(
      this,
    );
  }
}

abstract class _ReportRequest implements ReportRequest {
  const factory _ReportRequest(
      {required final String reportId,
      final int pageIndex,
      final int pageSize,
      final List<String> selectedColumns,
      final List<ReportFilter> filters,
      final List<String>? groupBy,
      final List<ReportAggregate>? aggregates,
      final List<ReportSort>? sorts,
      final String exportFormat}) = _$ReportRequestImpl;

  factory _ReportRequest.fromJson(Map<String, dynamic> json) =
      _$ReportRequestImpl.fromJson;

  @override
  String get reportId;
  @override
  int get pageIndex;
  @override
  int get pageSize;
  @override
  List<String> get selectedColumns;
  @override
  List<ReportFilter> get filters;
  @override
  List<String>? get groupBy;
  @override
  List<ReportAggregate>? get aggregates;
  @override
  List<ReportSort>? get sorts;
  @override
  String get exportFormat;
  @override
  @JsonKey(ignore: true)
  _$$ReportRequestImplCopyWith<_$ReportRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportFilter _$ReportFilterFromJson(Map<String, dynamic> json) {
  return _ReportFilter.fromJson(json);
}

/// @nodoc
mixin _$ReportFilter {
  String get field => throw _privateConstructorUsedError;
  String get operator => throw _privateConstructorUsedError;
  List<String> get values => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReportFilterCopyWith<ReportFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportFilterCopyWith<$Res> {
  factory $ReportFilterCopyWith(
          ReportFilter value, $Res Function(ReportFilter) then) =
      _$ReportFilterCopyWithImpl<$Res, ReportFilter>;
  @useResult
  $Res call({String field, String operator, List<String> values});
}

/// @nodoc
class _$ReportFilterCopyWithImpl<$Res, $Val extends ReportFilter>
    implements $ReportFilterCopyWith<$Res> {
  _$ReportFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? operator = null,
    Object? values = null,
  }) {
    return _then(_value.copyWith(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as String,
      values: null == values
          ? _value.values
          : values // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportFilterImplCopyWith<$Res>
    implements $ReportFilterCopyWith<$Res> {
  factory _$$ReportFilterImplCopyWith(
          _$ReportFilterImpl value, $Res Function(_$ReportFilterImpl) then) =
      __$$ReportFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String field, String operator, List<String> values});
}

/// @nodoc
class __$$ReportFilterImplCopyWithImpl<$Res>
    extends _$ReportFilterCopyWithImpl<$Res, _$ReportFilterImpl>
    implements _$$ReportFilterImplCopyWith<$Res> {
  __$$ReportFilterImplCopyWithImpl(
      _$ReportFilterImpl _value, $Res Function(_$ReportFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? operator = null,
    Object? values = null,
  }) {
    return _then(_$ReportFilterImpl(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as String,
      values: null == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportFilterImpl implements _ReportFilter {
  const _$ReportFilterImpl(
      {required this.field,
      this.operator = 'EQUALS',
      required final List<String> values})
      : _values = values;

  factory _$ReportFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportFilterImplFromJson(json);

  @override
  final String field;
  @override
  @JsonKey()
  final String operator;
  final List<String> _values;
  @override
  List<String> get values {
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_values);
  }

  @override
  String toString() {
    return 'ReportFilter(field: $field, operator: $operator, values: $values)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportFilterImpl &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            const DeepCollectionEquality().equals(other._values, _values));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, field, operator,
      const DeepCollectionEquality().hash(_values));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportFilterImplCopyWith<_$ReportFilterImpl> get copyWith =>
      __$$ReportFilterImplCopyWithImpl<_$ReportFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportFilterImplToJson(
      this,
    );
  }
}

abstract class _ReportFilter implements ReportFilter {
  const factory _ReportFilter(
      {required final String field,
      final String operator,
      required final List<String> values}) = _$ReportFilterImpl;

  factory _ReportFilter.fromJson(Map<String, dynamic> json) =
      _$ReportFilterImpl.fromJson;

  @override
  String get field;
  @override
  String get operator;
  @override
  List<String> get values;
  @override
  @JsonKey(ignore: true)
  _$$ReportFilterImplCopyWith<_$ReportFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportAggregate _$ReportAggregateFromJson(Map<String, dynamic> json) {
  return _ReportAggregate.fromJson(json);
}

/// @nodoc
mixin _$ReportAggregate {
  String get field => throw _privateConstructorUsedError;
  String get function => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReportAggregateCopyWith<ReportAggregate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportAggregateCopyWith<$Res> {
  factory $ReportAggregateCopyWith(
          ReportAggregate value, $Res Function(ReportAggregate) then) =
      _$ReportAggregateCopyWithImpl<$Res, ReportAggregate>;
  @useResult
  $Res call({String field, String function});
}

/// @nodoc
class _$ReportAggregateCopyWithImpl<$Res, $Val extends ReportAggregate>
    implements $ReportAggregateCopyWith<$Res> {
  _$ReportAggregateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? function = null,
  }) {
    return _then(_value.copyWith(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
      function: null == function
          ? _value.function
          : function // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportAggregateImplCopyWith<$Res>
    implements $ReportAggregateCopyWith<$Res> {
  factory _$$ReportAggregateImplCopyWith(_$ReportAggregateImpl value,
          $Res Function(_$ReportAggregateImpl) then) =
      __$$ReportAggregateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String field, String function});
}

/// @nodoc
class __$$ReportAggregateImplCopyWithImpl<$Res>
    extends _$ReportAggregateCopyWithImpl<$Res, _$ReportAggregateImpl>
    implements _$$ReportAggregateImplCopyWith<$Res> {
  __$$ReportAggregateImplCopyWithImpl(
      _$ReportAggregateImpl _value, $Res Function(_$ReportAggregateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? function = null,
  }) {
    return _then(_$ReportAggregateImpl(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
      function: null == function
          ? _value.function
          : function // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportAggregateImpl implements _ReportAggregate {
  const _$ReportAggregateImpl({required this.field, this.function = 'SUM'});

  factory _$ReportAggregateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportAggregateImplFromJson(json);

  @override
  final String field;
  @override
  @JsonKey()
  final String function;

  @override
  String toString() {
    return 'ReportAggregate(field: $field, function: $function)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportAggregateImpl &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.function, function) ||
                other.function == function));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, field, function);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportAggregateImplCopyWith<_$ReportAggregateImpl> get copyWith =>
      __$$ReportAggregateImplCopyWithImpl<_$ReportAggregateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportAggregateImplToJson(
      this,
    );
  }
}

abstract class _ReportAggregate implements ReportAggregate {
  const factory _ReportAggregate(
      {required final String field,
      final String function}) = _$ReportAggregateImpl;

  factory _ReportAggregate.fromJson(Map<String, dynamic> json) =
      _$ReportAggregateImpl.fromJson;

  @override
  String get field;
  @override
  String get function;
  @override
  @JsonKey(ignore: true)
  _$$ReportAggregateImplCopyWith<_$ReportAggregateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportSort _$ReportSortFromJson(Map<String, dynamic> json) {
  return _ReportSort.fromJson(json);
}

/// @nodoc
mixin _$ReportSort {
  String get field => throw _privateConstructorUsedError;
  String get direction => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReportSortCopyWith<ReportSort> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportSortCopyWith<$Res> {
  factory $ReportSortCopyWith(
          ReportSort value, $Res Function(ReportSort) then) =
      _$ReportSortCopyWithImpl<$Res, ReportSort>;
  @useResult
  $Res call({String field, String direction});
}

/// @nodoc
class _$ReportSortCopyWithImpl<$Res, $Val extends ReportSort>
    implements $ReportSortCopyWith<$Res> {
  _$ReportSortCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? direction = null,
  }) {
    return _then(_value.copyWith(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportSortImplCopyWith<$Res>
    implements $ReportSortCopyWith<$Res> {
  factory _$$ReportSortImplCopyWith(
          _$ReportSortImpl value, $Res Function(_$ReportSortImpl) then) =
      __$$ReportSortImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String field, String direction});
}

/// @nodoc
class __$$ReportSortImplCopyWithImpl<$Res>
    extends _$ReportSortCopyWithImpl<$Res, _$ReportSortImpl>
    implements _$$ReportSortImplCopyWith<$Res> {
  __$$ReportSortImplCopyWithImpl(
      _$ReportSortImpl _value, $Res Function(_$ReportSortImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? direction = null,
  }) {
    return _then(_$ReportSortImpl(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportSortImpl implements _ReportSort {
  const _$ReportSortImpl({required this.field, this.direction = 'ASC'});

  factory _$ReportSortImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportSortImplFromJson(json);

  @override
  final String field;
  @override
  @JsonKey()
  final String direction;

  @override
  String toString() {
    return 'ReportSort(field: $field, direction: $direction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportSortImpl &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.direction, direction) ||
                other.direction == direction));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, field, direction);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportSortImplCopyWith<_$ReportSortImpl> get copyWith =>
      __$$ReportSortImplCopyWithImpl<_$ReportSortImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportSortImplToJson(
      this,
    );
  }
}

abstract class _ReportSort implements ReportSort {
  const factory _ReportSort(
      {required final String field, final String direction}) = _$ReportSortImpl;

  factory _ReportSort.fromJson(Map<String, dynamic> json) =
      _$ReportSortImpl.fromJson;

  @override
  String get field;
  @override
  String get direction;
  @override
  @JsonKey(ignore: true)
  _$$ReportSortImplCopyWith<_$ReportSortImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportResultDto _$ReportResultDtoFromJson(Map<String, dynamic> json) {
  return _ReportResultDto.fromJson(json);
}

/// @nodoc
mixin _$ReportResultDto {
  String get reportId => throw _privateConstructorUsedError;
  List<String> get columns => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get rows => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get pageIndex => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  Map<String, dynamic>? get aggregates => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReportResultDtoCopyWith<ReportResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportResultDtoCopyWith<$Res> {
  factory $ReportResultDtoCopyWith(
          ReportResultDto value, $Res Function(ReportResultDto) then) =
      _$ReportResultDtoCopyWithImpl<$Res, ReportResultDto>;
  @useResult
  $Res call(
      {String reportId,
      List<String> columns,
      List<Map<String, dynamic>> rows,
      int totalCount,
      int pageIndex,
      int pageSize,
      Map<String, dynamic>? aggregates});
}

/// @nodoc
class _$ReportResultDtoCopyWithImpl<$Res, $Val extends ReportResultDto>
    implements $ReportResultDtoCopyWith<$Res> {
  _$ReportResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportId = null,
    Object? columns = null,
    Object? rows = null,
    Object? totalCount = null,
    Object? pageIndex = null,
    Object? pageSize = null,
    Object? aggregates = freezed,
  }) {
    return _then(_value.copyWith(
      reportId: null == reportId
          ? _value.reportId
          : reportId // ignore: cast_nullable_to_non_nullable
              as String,
      columns: null == columns
          ? _value.columns
          : columns // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rows: null == rows
          ? _value.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      pageIndex: null == pageIndex
          ? _value.pageIndex
          : pageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      aggregates: freezed == aggregates
          ? _value.aggregates
          : aggregates // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportResultDtoImplCopyWith<$Res>
    implements $ReportResultDtoCopyWith<$Res> {
  factory _$$ReportResultDtoImplCopyWith(_$ReportResultDtoImpl value,
          $Res Function(_$ReportResultDtoImpl) then) =
      __$$ReportResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String reportId,
      List<String> columns,
      List<Map<String, dynamic>> rows,
      int totalCount,
      int pageIndex,
      int pageSize,
      Map<String, dynamic>? aggregates});
}

/// @nodoc
class __$$ReportResultDtoImplCopyWithImpl<$Res>
    extends _$ReportResultDtoCopyWithImpl<$Res, _$ReportResultDtoImpl>
    implements _$$ReportResultDtoImplCopyWith<$Res> {
  __$$ReportResultDtoImplCopyWithImpl(
      _$ReportResultDtoImpl _value, $Res Function(_$ReportResultDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportId = null,
    Object? columns = null,
    Object? rows = null,
    Object? totalCount = null,
    Object? pageIndex = null,
    Object? pageSize = null,
    Object? aggregates = freezed,
  }) {
    return _then(_$ReportResultDtoImpl(
      reportId: null == reportId
          ? _value.reportId
          : reportId // ignore: cast_nullable_to_non_nullable
              as String,
      columns: null == columns
          ? _value._columns
          : columns // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rows: null == rows
          ? _value._rows
          : rows // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      pageIndex: null == pageIndex
          ? _value.pageIndex
          : pageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      aggregates: freezed == aggregates
          ? _value._aggregates
          : aggregates // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportResultDtoImpl implements _ReportResultDto {
  const _$ReportResultDtoImpl(
      {required this.reportId,
      required final List<String> columns,
      required final List<Map<String, dynamic>> rows,
      required this.totalCount,
      required this.pageIndex,
      required this.pageSize,
      final Map<String, dynamic>? aggregates})
      : _columns = columns,
        _rows = rows,
        _aggregates = aggregates;

  factory _$ReportResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportResultDtoImplFromJson(json);

  @override
  final String reportId;
  final List<String> _columns;
  @override
  List<String> get columns {
    if (_columns is EqualUnmodifiableListView) return _columns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_columns);
  }

  final List<Map<String, dynamic>> _rows;
  @override
  List<Map<String, dynamic>> get rows {
    if (_rows is EqualUnmodifiableListView) return _rows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rows);
  }

  @override
  final int totalCount;
  @override
  final int pageIndex;
  @override
  final int pageSize;
  final Map<String, dynamic>? _aggregates;
  @override
  Map<String, dynamic>? get aggregates {
    final value = _aggregates;
    if (value == null) return null;
    if (_aggregates is EqualUnmodifiableMapView) return _aggregates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ReportResultDto(reportId: $reportId, columns: $columns, rows: $rows, totalCount: $totalCount, pageIndex: $pageIndex, pageSize: $pageSize, aggregates: $aggregates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportResultDtoImpl &&
            (identical(other.reportId, reportId) ||
                other.reportId == reportId) &&
            const DeepCollectionEquality().equals(other._columns, _columns) &&
            const DeepCollectionEquality().equals(other._rows, _rows) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.pageIndex, pageIndex) ||
                other.pageIndex == pageIndex) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            const DeepCollectionEquality()
                .equals(other._aggregates, _aggregates));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      reportId,
      const DeepCollectionEquality().hash(_columns),
      const DeepCollectionEquality().hash(_rows),
      totalCount,
      pageIndex,
      pageSize,
      const DeepCollectionEquality().hash(_aggregates));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportResultDtoImplCopyWith<_$ReportResultDtoImpl> get copyWith =>
      __$$ReportResultDtoImplCopyWithImpl<_$ReportResultDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportResultDtoImplToJson(
      this,
    );
  }
}

abstract class _ReportResultDto implements ReportResultDto {
  const factory _ReportResultDto(
      {required final String reportId,
      required final List<String> columns,
      required final List<Map<String, dynamic>> rows,
      required final int totalCount,
      required final int pageIndex,
      required final int pageSize,
      final Map<String, dynamic>? aggregates}) = _$ReportResultDtoImpl;

  factory _ReportResultDto.fromJson(Map<String, dynamic> json) =
      _$ReportResultDtoImpl.fromJson;

  @override
  String get reportId;
  @override
  List<String> get columns;
  @override
  List<Map<String, dynamic>> get rows;
  @override
  int get totalCount;
  @override
  int get pageIndex;
  @override
  int get pageSize;
  @override
  Map<String, dynamic>? get aggregates;
  @override
  @JsonKey(ignore: true)
  _$$ReportResultDtoImplCopyWith<_$ReportResultDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
