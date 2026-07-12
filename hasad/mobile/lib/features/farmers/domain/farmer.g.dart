// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FarmerImpl _$$FarmerImplFromJson(Map<String, dynamic> json) => _$FarmerImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  nationalId: json['nationalId'] as String,
  phoneNumber: json['phoneNumber'] as String,
  address: json['address'] as String,
  rowVersion: json['rowVersion'] as String? ?? '',
);

Map<String, dynamic> _$$FarmerImplToJson(_$FarmerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nationalId': instance.nationalId,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'rowVersion': instance.rowVersion,
    };
