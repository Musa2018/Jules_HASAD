import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_metadata.freezed.dart';
part 'report_metadata.g.dart';

@freezed
class ReportDefinitionMetadata with _$ReportDefinitionMetadata {
  const factory ReportDefinitionMetadata({
    required String reportId,
    required String title,
    required String dataSourceViewName,
    required String defaultSortField,
    required Map<String, ReportFieldMetadata> allowedFields,
  }) = _ReportDefinitionMetadata;

  factory ReportDefinitionMetadata.fromJson(Map<String, dynamic> json) =>
      _$ReportDefinitionMetadataFromJson(json);
}

@freezed
class ReportFieldMetadata with _$ReportFieldMetadata {
  const factory ReportFieldMetadata({
    required String fieldName,
    @Default('string') String dataType,
    @Default(true) bool isFilterable,
    @Default(true) bool isSortable,
    required List<String> allowedOperators,
  }) = _ReportFieldMetadata;

  factory ReportFieldMetadata.fromJson(Map<String, dynamic> json) =>
      _$ReportFieldMetadataFromJson(json);
}

@freezed
class ReportRequest with _$ReportRequest {
  const factory ReportRequest({
    required String reportId,
    @Default(1) int pageIndex,
    @Default(50) int pageSize,
    @Default([]) List<String> selectedColumns,
    @Default([]) List<ReportFilter> filters,
    List<String>? groupBy,
    List<ReportAggregate>? aggregates,
    List<ReportSort>? sorts,
    @Default('JSON') String exportFormat,
  }) = _ReportRequest;

  factory ReportRequest.fromJson(Map<String, dynamic> json) =>
      _$ReportRequestFromJson(json);
}

@freezed
class ReportFilter with _$ReportFilter {
  const factory ReportFilter({
    required String field,
    @Default('EQUALS') String operator,
    required List<String> values,
  }) = _ReportFilter;

  factory ReportFilter.fromJson(Map<String, dynamic> json) =>
      _$ReportFilterFromJson(json);
}

@freezed
class ReportAggregate with _$ReportAggregate {
  const factory ReportAggregate({
    required String field,
    @Default('SUM') String function,
  }) = _ReportAggregate;

  factory ReportAggregate.fromJson(Map<String, dynamic> json) =>
      _$ReportAggregateFromJson(json);
}

@freezed
class ReportSort with _$ReportSort {
  const factory ReportSort({
    required String field,
    @Default('ASC') String direction,
  }) = _ReportSort;

  factory ReportSort.fromJson(Map<String, dynamic> json) =>
      _$ReportSortFromJson(json);
}

@freezed
class ReportResultDto with _$ReportResultDto {
  const factory ReportResultDto({
    required String reportId,
    required List<String> columns,
    required List<Map<String, dynamic>> rows,
    required int totalCount,
    required int pageIndex,
    required int pageSize,
    Map<String, dynamic>? aggregates,
  }) = _ReportResultDto;

  factory ReportResultDto.fromJson(Map<String, dynamic> json) =>
      _$ReportResultDtoFromJson(json);
}
