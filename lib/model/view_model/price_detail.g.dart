part of 'price_detail.dart';

PriceDetail _$PriceDetailFromJson(Map<String, dynamic> json) {
  return PriceDetail(
      dailyRate: (json['dailyRate'] as num ?? 0).toDouble(),
      deliveryCharge: (json['deliveryCharge'] as num ?? 0).toDouble(),);
}

Map<String, dynamic> _$PriceDetailToJson(PriceDetail instance) =>
    <String, dynamic>{
      'dailyRate': instance.dailyRate,
      'deliveryCharge': instance.deliveryCharge
    };
