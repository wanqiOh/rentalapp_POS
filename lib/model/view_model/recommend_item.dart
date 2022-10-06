class RecommendItem {
  String logo;
  String companyName;
  String location;
  String description;
  int orderNum;
  int index;
  static List<RecommendItem> promotionItemList = [];

  RecommendItem(
      {this.logo,
      this.companyName,
      this.location,
      this.description,
      this.orderNum,
      this.index});

  // static List<RecommendItem> setPromotionItemList(List<Highlights> list) {
  //   list.asMap().forEach((index, item) {
  //     promotionItemList.add(
  //         PromotionItem(imagePath: item.image, url: item.uri, index: index));
  //   });
  //
  //   return promotionItemList;
  // }
}
