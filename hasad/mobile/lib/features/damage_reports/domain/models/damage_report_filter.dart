import 'package:freezed_annotation/freezed_annotation.dart';

part 'damage_report_filter.freezed.dart';

@freezed
class DamageReportFilter with _$DamageReportFilter {
  const factory DamageReportFilter({
    @Default('') String searchText,
    String? statusId,
    String? syncStatus,
    String? governorateId,
    String? directorateId,
    String? localityId,
  }) = _DamageReportFilter;
}
