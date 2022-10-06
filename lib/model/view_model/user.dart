import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(nullable: true)
class UserRentalApp extends Equatable {
  String id;
  String name;
  String role;
  bool isSelected;

  UserRentalApp({this.id, this.name, this.role, this.isSelected});

  addId(String id) {
    this.id = id;
  }

  setIsSelected(bool isSelected) {
    this.isSelected = isSelected;
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
  factory UserRentalApp.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  @override
  List<Object> get props => [id, name, role, isSelected];
}
