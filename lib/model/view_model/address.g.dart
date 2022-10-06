part of 'address.dart';

AddressDes _$AddressFromJson(Map<String, dynamic> json) {
  return AddressDes(
      address1: json['address1'] as String,
      address2: json['address2'] as String,
      city: json['city'] as String,
      postcode: json['postcode'] as String,
      state: json['state'] as String);
}

Map<String, dynamic> _$AddressToJson(AddressDes instance) => <String, dynamic>{
      'address1': instance.address1,
      'address2': instance.address2,
      'city': instance.city,
      'postcode': instance.postcode,
      'state': instance.state
    };
