part of 'notifications.dart';

Notifications _$NotificationsFromJson(Map<String, dynamic> json) {
  return Notifications(
    notifications: json['notifications']
            ?.map<NotificationsItem>((dynamic notificationsItem) =>
                NotificationsItem.fromJson(
                    notificationsItem.cast<String, dynamic>()))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$NotificationsToJson(Notifications instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
    };
