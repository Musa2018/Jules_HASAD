import 'package:freezed_annotation/freezed_annotation.dart';

part 'governorate.freezed.dart';
part 'governorate.g.dart';

@freezed
class Governorate with _$Governorate {
  const factory Governorate({
    required String id,
    required String nameAr,
    required String nameEn,
    required String code,
  }) = _Governorate;

  factory Governorate.fromJson(Map<String, dynamic> json) =>
      _$GovernorateFromJson(json);
}
