import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rentalapp_pos/custom_router.dart';
import 'package:rentalapp_pos/global/globals.dart' as globals;
import 'package:rentalapp_pos/provider/user_state/user_state.dart';
import 'package:rentalapp_pos/repository/notifications_repository.dart';

import 'screen/splash_page/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await EasyLocalization.ensureInitialized();
  await setupOneSignal();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.blue, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
    // statusBarBrightness: Brightness.dark,//status bar brigtness
    statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    // systemNavigationBarDividerColor: Colors.greenAccent,//Navigation bar divider color
    // systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
  ));

  runApp(
    EasyLocalization(
      child: MultiProvider(
        providers: [
          ListenableProvider<UserState>(
              lazy: false, create: (_) => UserState()),
        ],
        child: MyApp(),
      ),
      supportedLocales: [
        Locale('en-US', 'US'),
      ],
      path: 'resources/langs',
      fallbackLocale: Locale('en-US', 'US'),
      startLocale: Locale('en-US', 'US'),
      saveLocale: true,
      useOnlyLangCode: true,
      assetLoader: RootBundleAssetLoader(),
    ),
  );
}

setupOneSignal() async {
  BuildContext context;
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  final _oneSignalID = '91888631-a4e0-4633-b4b5-50090584ae95';
  OneSignal.shared.init(_oneSignalID, iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: true
  });

  // OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
  //   print("Accepted permission: $accepted");
  // });

  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);

  var status = await OneSignal.shared.getPermissionSubscriptionState();
  String tokenId = status.subscriptionStatus.userId;
  OneSignal.shared.sendTag('Token_ID', tokenId);

  print(tokenId);
  globals.id = tokenId;
  await NotificationsRepository().getNotifications();
  globals.notifications.clear();
  globals.notifications = NotificationsRepository.notifications;

  // OneSignal.shared
  //     .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //   // a notification has been opened
  //   // Navigator.pushNamedAndRemoveUntil(context, CustomRouter.dashboardRoute,
  //   //     ModalRoute.withName(Navigator.defaultRouteName));
  // });

  // OneSignal.shared
  //     .setNotificationReceivedHandler((OSNotification notification) {
  //   // a notification has been received
  //   notification.payload.rawPayload.forEach((key, value) {
  //     print('Received value: ${value.toString()}');
  //   });
  // });
// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//   await OneSignal.shared
//       .promptUserForPushNotificationPermission(fallbackToSettings: true);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rentalapp_pos',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: CustomRouter.generateRoute,
      home: SplashPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container());
  }
}
