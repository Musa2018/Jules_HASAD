import 'package:freezed_annotation/freezed_annotation.dart';

part 'farmer.freezed.dart';
part 'farmer.g.dart';

@freezed
class Farmer with _$Farmer {
  const factory Farmer({
    required String id,
    required String name,
    required String nationalId,
    required String phoneNumber,
    required String address,
    @Default('') String rowVersion,
  }) = _Farmer;

  factory Farmer.fromJson(Map<String, dynamic> json) => _$FarmerFromJson(json);
}
