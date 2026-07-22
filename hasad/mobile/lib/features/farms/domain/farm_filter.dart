import 'package:freezed_annotation/freezed_annotation.dart';

part 'farm_filter.freezed.dart';

@freezed
class FarmFilter with _$FarmFilter {
  const factory FarmFilter({
    @Default('') String searchText,
    String? syncStatus,
    String? governorateId,
    String? directorateId,
    String? localityId,
    int? ownershipTypeId,
    int? agriculturalSectorId,
  }) = _FarmFilter;
}
