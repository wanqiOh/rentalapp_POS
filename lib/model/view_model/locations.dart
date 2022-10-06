import 'package:json_annotation/json_annotation.dart';

part 'locations.g.dart';

@JsonSerializable(nullable: true)
class Locations {
  String postcode;
  String state;

  Locations({this.postcode, this.state});

  Map<String, dynamic> toJson() => _$LocationToJson(this);
  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  @override
  List<Object> get props => [postcode, state];
}
