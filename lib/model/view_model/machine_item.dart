import 'package:json_annotation/json_annotation.dart';
import 'package:rentalapp_pos/model/view_model/machine_detail.dart';
import 'package:rentalapp_pos/model/view_model/merchant.dart';
import 'package:rentalapp_pos/model/view_model/price_detail.dart';

part 'machine_item.g.dart';

@JsonSerializable(nullable: true)
class MachineItem {
  String id;
  Merchant merchant;
  String image;
  String machineName;
  String machineCategory;
  PriceDetail price;
  int quantity;
  int index;
  MachineDetail machineDetail;

  MachineItem(
      {this.id,
      this.merchant,
      this.image,
      this.machineName,
      this.machineCategory,
      this.quantity,
      this.price,
      this.machineDetail});

  Map<String, dynamic> toJson() => _$MachineItemToJson(this);
  factory MachineItem.fromJson(Map<String, dynamic> json) =>
      _$MachineItemFromJson(json);

  @override
  List<Object> get props => [
        id,
        merchant,
        image,
        machineName,
        machineCategory,
        price,
        quantity,
        machineDetail
      ];
}
