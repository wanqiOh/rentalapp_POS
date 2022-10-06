import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rentalapp_pos/model/view_model/address.dart';
import 'package:rentalapp_pos/model/view_model/locations.dart';
import 'package:rentalapp_pos/model/view_model/machine_item.dart';

part 'merchant.g.dart';

@JsonSerializable(nullable: true)
class Merchant {
  String id;
  String notifId;
  String logo;
  String companyName;
  Locations location;
  AddressDes address;
  String description;
  int orderNum;
  int index;
  String director;
  String phoneNo;
  String website;
  Position position;
  List<MachineItem> machine;

  Merchant(
      {this.id,
      this.notifId,
      this.logo,
      this.companyName,
      this.location,
      this.description,
      this.orderNum,
      this.index,
      this.director,
      this.phoneNo,
      this.website,
      this.address,
      this.position});
  Merchant.invoice({this.companyName, this.address, this.phoneNo});

  Map<String, dynamic> toJson() => _$MerchantToJson(this);
  factory Merchant.fromJson(Map<String, dynamic> json) =>
      _$MerchantFromJson(json);

  @override
  List<Object> get props => [
        id,
        notifId,
        logo,
        companyName,
        location,
        description,
        orderNum,
        index,
        director,
        phoneNo,
        website,
        address,
        position
      ];
}
