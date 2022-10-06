import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rentalapp_pos/model/view_model/address.dart';

part 'customer.g.dart';

@JsonSerializable(nullable: true)
class Customer {
  String id;
  String notifId;
  String email;
  String name;
  String phoneNo;
  Position position;
  AddressDes address;

  Customer(
      {this.id,
      this.notifId,
      this.email,
      this.name,
      this.phoneNo,
      this.position});
  Customer.invoice({this.name, this.address});

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  @override
  List<Object> get props => [id, notifId, name, email, phoneNo, position];
}
