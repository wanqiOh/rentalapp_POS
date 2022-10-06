import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentalapp_pos/screen/analysis_page/graph_page.dart';
import 'package:rentalapp_pos/screen/editing_page/editing_detail_page.dart';
import 'package:rentalapp_pos/screen/editing_page/editing_page.dart';
import 'package:rentalapp_pos/screen/gps_page/gps_page.dart';
import 'package:rentalapp_pos/screen/history_page/history_page.dart';
import 'package:rentalapp_pos/screen/home_page/home_page.dart';
import 'package:rentalapp_pos/screen/notification_page/inbox_page.dart';
import 'package:rentalapp_pos/screen/notification_page/notification_page.dart';
import 'package:rentalapp_pos/screen/otp_page/otp_page.dart';
import 'package:rentalapp_pos/screen/profile_page/profile_page.dart';
import 'package:rentalapp_pos/screen/splash_page/splash_page.dart';
import 'package:rentalapp_pos/screen/term_and_condition_page/term_and_condition_page.dart';
import 'package:rentalapp_pos/screen/user_page/user_page.dart';
import 'package:rentalapp_pos/screen/verify_page/verify_page.dart';

class CustomRouter {
  static const String splashRoute = '/splashScreen';
  static const String userRoute = '/user';
  static const String gpsRoute = '/gps';
  static const String dashboardAdminRoute = '/dashboardAdmin';
  static const String dashboardRoute = '/dashboard';
  static const String editingRoute = '/editing';
  static const String editingDetailRoute = '/editingDetail';
  static const String notificationRoute = '/notification';
  static const String inboxRoute = '/inbox';
  static const String analysisRoute = '/analysis';
  static const String profileRoute = '/profile';
  static const String otpRoute = '/otp';
  static const String verifyRoute = '/verification';
  static const String historyRoute = '/history';
  static const String termAndConditionRoute = '/termAndCondition';

  static void backToDashboard(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      CustomRouter.dashboardRoute,
      ModalRoute.withName(Navigator.defaultRouteName),
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case userRoute:
        return MaterialPageRoute(builder: (_) => UserPage());
      case gpsRoute:
        return MaterialPageRoute(builder: (_) => GPSPage());
      case dashboardRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case editingRoute:
        return MaterialPageRoute(
            builder: (_) => EditingPage(machines: settings.arguments));
      case editingDetailRoute:
        return MaterialPageRoute(
            builder: (_) => EditingDetailPage(
                  selectedDocument: settings.arguments,
                ));
      case notificationRoute:
        return MaterialPageRoute(
            builder: (_) => NotificationPage(orders: settings.arguments));
      case analysisRoute:
        return MaterialPageRoute(builder: (_) => GraphPage());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case historyRoute:
        return MaterialPageRoute(builder: (_) => HistoryPage());
      case verifyRoute:
        return MaterialPageRoute(builder: (_) => VerifyPage());
      case termAndConditionRoute:
        return MaterialPageRoute(builder: (_) => TermAndConditionPage());
      case inboxRoute:
        return MaterialPageRoute(
            builder: (_) => InboxPage(orderDetails: settings.arguments));
      case otpRoute:
        return MaterialPageRoute(
            builder: (_) => OTPPage(
                  phoneNo: settings.arguments,
                ));

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
