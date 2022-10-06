import 'package:json_annotation/json_annotation.dart';

part 'category_item.g.dart';

@JsonSerializable(nullable: true)
class CategoryItem {
  String id;
  String machineImage;
  String machineType;

  CategoryItem({this.id, this.machineImage, this.machineType});

  // Map<String, dynamic> toJson() => _$CategoryItemToJson(this);
  // factory CategoryItem.fromJson(Map<String, dynamic> json) =>
  //     _$CategoryItemFromJson(json);
  //
  // @override
  // List<Object> get props => [id, machineType, machineImage];

// static List<RecommendItem> setPromotionItemList(List<Highlights> list) {
//   list.asMap().forEach((index, item) {
//     promotionItemList.add(
//         PromotionItem(imagePath: item.image, url: item.uri, index: index));
//   });
//
//   return promotionItemList;
// }
}
