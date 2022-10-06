part of 'user.dart';

UserRentalApp _$UserFromJson(Map<String, dynamic> json) {
  return UserRentalApp(
    name: json['name'] as String,
    id: json['id'] as String,
    role: json['role'] as String,
  );
}

Map<String, dynamic> _$UserToJson(UserRentalApp instance) => <String, dynamic>{
      'role': instance.role,
      'name': instance.name,
  'id' : instance.id,
    };
