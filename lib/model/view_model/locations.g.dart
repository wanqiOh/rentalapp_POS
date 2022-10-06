part of 'locations.dart';

Locations _$LocationFromJson(Map<String, dynamic> json) {
  return Locations(
    postcode: json['postcode'],
    state: json['state'],
  );
}

Map<String, dynamic> _$LocationToJson(Locations instance) =>
    <String, dynamic>{'postcode': instance.postcode, 'state': instance.state};
