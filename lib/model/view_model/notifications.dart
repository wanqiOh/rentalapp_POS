import 'package:json_annotation/json_annotation.dart';
import 'package:rentalapp_pos/model/view_model/notification_item.dart';

part 'notifications.g.dart';

@JsonSerializable(nullable: true)
class Notifications {
  List<NotificationsItem> notifications;

  Notifications({this.notifications});

  Map<String, dynamic> toJson() => _$NotificationsToJson(this);
  factory Notifications.fromJson(Map<String, dynamic> json) =>
      _$NotificationsFromJson(json);

  @override
  List<Object> get props => [notifications];
}
