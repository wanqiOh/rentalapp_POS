part of 'merchant.dart';

Merchant _$MerchantFromJson(Map<String, dynamic> json) {
  return Merchant(
      id: json['id'] as String,
      logo: json['logo'] as String,
      companyName: json['name'] as String,
      location: Locations.fromJson(json['location']),
      address: AddressDes.fromJson(json['address']),
      description: json['description'] as String,
      orderNum: json['orderNum'] as int,
      director: json['director'] as String,
      phoneNo: json['phoneNo'] as String,
      website: json['website'] as String,
      notifId: json['notifId'] as String,
      position: Position.fromMap(json['position']));
}

Map<String, dynamic> _$MerchantToJson(Merchant instance) => <String, dynamic>{
      'id': instance.id,
      'logo': instance.logo,
      'name': instance.companyName,
      'location': instance.location.toJson(),
      'address': instance.address.toJson(),
      'description': instance.description,
      'orderNum': instance.orderNum,
      'director': instance.director,
      'phoneNo': instance.phoneNo,
      'website': instance.website,
      'notifId': instance.notifId,
      'position': instance.position.toJson()
    };
