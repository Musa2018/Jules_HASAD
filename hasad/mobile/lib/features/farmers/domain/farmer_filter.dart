import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/features/farmers/domain/gender.dart';

part 'farmer_filter.freezed.dart';

@freezed
class FarmerFilter with _$FarmerFilter {
  const factory FarmerFilter({
    @Default('') String searchText,
    Gender? gender,
    String? syncStatus,
    String? governorateId,
    String? localityId,
  }) = _FarmerFilter;
}
