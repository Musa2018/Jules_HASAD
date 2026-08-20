// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportDefinitionMetadataImpl _$$ReportDefinitionMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$ReportDefinitionMetadataImpl(
      reportId: json['reportId'] as String,
      title: json['title'] as String,
      dataSourceViewName: json['dataSourceViewName'] as String,
      defaultSortField: json['defaultSortField'] as String,
      allowedFields: (json['allowedFields'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, ReportFieldMetadata.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$ReportDefinitionMetadataImplToJson(
        _$ReportDefinitionMetadataImpl instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'title': instance.title,
      'dataSourceViewName': instance.dataSourceViewName,
      'defaultSortField': instance.defaultSortField,
      'allowedFields': instance.allowedFields,
    };

_$ReportFieldMetadataImpl _$$ReportFieldMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$ReportFieldMetadataImpl(
      fieldName: json['fieldName'] as String,
      dataType: json['dataType'] as String? ?? 'string',
      isFilterable: json['isFilterable'] as bool? ?? true,
      isSortable: json['isSortable'] as bool? ?? true,
      allowedOperators: (json['allowedOperators'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ReportFieldMetadataImplToJson(
        _$ReportFieldMetadataImpl instance) =>
    <String, dynamic>{
      'fieldName': instance.fieldName,
      'dataType': instance.dataType,
      'isFilterable': instance.isFilterable,
      'isSortable': instance.isSortable,
      'allowedOperators': instance.allowedOperators,
    };

_$ReportRequestImpl _$$ReportRequestImplFromJson(Map<String, dynamic> json) =>
    _$ReportRequestImpl(
      reportId: json['reportId'] as String,
      pageIndex: (json['pageIndex'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 50,
      selectedColumns: (json['selectedColumns'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      filters: (json['filters'] as List<dynamic>?)
              ?.map((e) => ReportFilter.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      groupBy:
          (json['groupBy'] as List<dynamic>?)?.map((e) => e as String).toList(),
      aggregates: (json['aggregates'] as List<dynamic>?)
          ?.map((e) => ReportAggregate.fromJson(e as Map<String, dynamic>))
          .toList(),
      sorts: (json['sorts'] as List<dynamic>?)
          ?.map((e) => ReportSort.fromJson(e as Map<String, dynamic>))
          .toList(),
      exportFormat: json['exportFormat'] as String? ?? 'JSON',
    );

Map<String, dynamic> _$$ReportRequestImplToJson(_$ReportRequestImpl instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'pageIndex': instance.pageIndex,
      'pageSize': instance.pageSize,
      'selectedColumns': instance.selectedColumns,
      'filters': instance.filters,
      'groupBy': instance.groupBy,
      'aggregates': instance.aggregates,
      'sorts': instance.sorts,
      'exportFormat': instance.exportFormat,
    };

_$ReportFilterImpl _$$ReportFilterImplFromJson(Map<String, dynamic> json) =>
    _$ReportFilterImpl(
      field: json['field'] as String,
      operator: json['operator'] as String? ?? 'EQUALS',
      values:
          (json['values'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$ReportFilterImplToJson(_$ReportFilterImpl instance) =>
    <String, dynamic>{
      'field': instance.field,
      'operator': instance.operator,
      'values': instance.values,
    };

_$ReportAggregateImpl _$$ReportAggregateImplFromJson(
        Map<String, dynamic> json) =>
    _$ReportAggregateImpl(
      field: json['field'] as String,
      function: json['function'] as String? ?? 'SUM',
    );

Map<String, dynamic> _$$ReportAggregateImplToJson(
        _$ReportAggregateImpl instance) =>
    <String, dynamic>{
      'field': instance.field,
      'function': instance.function,
    };

_$ReportSortImpl _$$ReportSortImplFromJson(Map<String, dynamic> json) =>
    _$ReportSortImpl(
      field: json['field'] as String,
      direction: json['direction'] as String? ?? 'ASC',
    );

Map<String, dynamic> _$$ReportSortImplToJson(_$ReportSortImpl instance) =>
    <String, dynamic>{
      'field': instance.field,
      'direction': instance.direction,
    };

_$ReportResultDtoImpl _$$ReportResultDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReportResultDtoImpl(
      reportId: json['reportId'] as String,
      columns:
          (json['columns'] as List<dynamic>).map((e) => e as String).toList(),
      rows: (json['rows'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      pageIndex: (json['pageIndex'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      aggregates: json['aggregates'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ReportResultDtoImplToJson(
        _$ReportResultDtoImpl instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'columns': instance.columns,
      'rows': instance.rows,
      'totalCount': instance.totalCount,
      'pageIndex': instance.pageIndex,
      'pageSize': instance.pageSize,
      'aggregates': instance.aggregates,
    };
