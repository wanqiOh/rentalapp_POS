part of 'machine_detail.dart';

MachineDetail _$MachineDetailFromJson(Map<String, dynamic> json) {
  return MachineDetail(
      length: (json['length'] as num ?? 0).toDouble(),
      weight: (json['weight'] as num ?? 0).toInt(),
      capacity: (json['capacity'] as num ?? 0).toInt(),
      width: (json['width'] as num ?? 0).toDouble(),
      height: (json['height'] as num ?? 0).toDouble(),
      workingHeight: (json['workingHeight'] as num ?? 0).toDouble(),
      engine: json['engine'] as String,
      remark: json['remark'] as String);
}

Map<String, dynamic> _$MachineDetailToJson(MachineDetail instance) =>
    <String, dynamic>{
      'length': instance.length,
      'weight': instance.weight,
      'capacity': instance.capacity,
      'width': instance.width,
      'height': instance.height,
      'workingHeight': instance.workingHeight,
      'engine': instance.engine,
      'remark': instance.remark,
    };
