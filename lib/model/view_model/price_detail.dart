import 'package:json_annotation/json_annotation.dart';

part 'price_detail.g.dart';

@JsonSerializable(nullable: true)
class PriceDetail {
  double dailyRate;
  double deliveryCharge;

  PriceDetail({this.dailyRate, this.deliveryCharge});

  Map<String, dynamic> toJson() => _$PriceDetailToJson(this);
  factory PriceDetail.fromJson(Map<String, dynamic> json) =>
      _$PriceDetailFromJson(json);

  @override
  List<Object> get props => [dailyRate, deliveryCharge];
}
