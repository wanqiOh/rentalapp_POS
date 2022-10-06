import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(nullable: true)
class AddressDes {
  String address1;
  String address2;
  String city;
  String postcode;
  String state;

  AddressDes(
      {this.address1, this.address2, this.city, this.postcode, this.state});

  Map<String, dynamic> toJson() => _$AddressToJson(this);
  factory AddressDes.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  @override
  List<Object> get props => [address1, address2, city, postcode, state];
}
