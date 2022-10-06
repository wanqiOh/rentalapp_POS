import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:rentalapp_pos/model/view_model/notification_item.dart';
import 'package:rentalapp_pos/model/view_model/notifications.dart';

class NotificationsRepository with ChangeNotifier {
  static const String _baseUrl = 'https://onesignal.com/api/v1/notifications?';
  static List<NotificationsItem> notifications = [];

  final Dio _dio;

  NotificationsRepository({Dio dio}) : _dio = dio ?? Dio();

  Future<void> getNotifications() async {
    final response = await _dio.get(_baseUrl,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization':
              'Basic MDVmMDJkMTItMmFkZS00ZTIyLTlmOTItNzMwZjg2M2EyMzEw'
        }),
        queryParameters: {'app_id': '91888631-a4e0-4633-b4b5-50090584ae95'});

    // Check if response is successful
    if (response.statusCode == 200) {
      notifications = Notifications.fromJson(response.data).notifications;
    }
    notifyListeners();
  }
}
