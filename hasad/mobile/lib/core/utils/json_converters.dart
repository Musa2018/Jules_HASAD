import 'package:json_annotation/json_annotation.dart';

/// A converter that can parse both [double] and [String] into a [double].
/// Useful when the backend sends numbers as strings.
class FlexibleDoubleConverter implements JsonConverter<double, dynamic> {
  const FlexibleDoubleConverter();

  @override
  double fromJson(dynamic json) {
    if (json == null) return 0.0;
    if (json is double) return json;
    if (json is int) return json.toDouble();
    if (json is String) {
      return double.tryParse(json) ?? 0.0;
    }
    return 0.0;
  }

  @override
  dynamic toJson(double object) => object;
}

/// A converter that can parse both [double] and [String] into a nullable [double].
class FlexibleDoubleNullableConverter implements JsonConverter<double?, dynamic> {
  const FlexibleDoubleNullableConverter();

  @override
  double? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is double) return json;
    if (json is int) return json.toDouble();
    if (json is String) {
      return double.tryParse(json);
    }
    return null;
  }

  @override
  dynamic toJson(double? object) => object;
}
