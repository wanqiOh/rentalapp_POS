part of 'category_item.dart';

CategoryItem _$CategoryItemFromJson(Map<String, dynamic> json) {
  return CategoryItem(machineType: json['type'] as String);
}

Map<String, dynamic> _$CategoryItemToJson(CategoryItem instance) =>
    <String, dynamic>{
      'type': instance.machineType,
    };
