import 'package:json_annotation/json_annotation.dart';

part 'machine_detail.g.dart';

@JsonSerializable(nullable: true)
class MachineDetail {
  double length;
  int weight;
  int capacity;
  double width;
  double height;
  double workingHeight;
  String engine;
  String remark;

  MachineDetail(
      {this.width,
      this.length,
      this.height,
      this.weight,
      this.workingHeight,
      this.capacity,
      this.engine,
      this.remark});

  Map<String, dynamic> toJson() => _$MachineDetailToJson(this);
  factory MachineDetail.fromJson(Map<String, dynamic> json) =>
      _$MachineDetailFromJson(json);

  @override
  List<Object> get props =>
      [length, weight, capacity, width, height, workingHeight, engine, remark];
}
