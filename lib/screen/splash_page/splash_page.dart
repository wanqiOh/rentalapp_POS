import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentalapp_pos/app_folder/app_theme.dart';
import 'package:rentalapp_pos/constants/image_path.dart';
import 'package:rentalapp_pos/custom_router.dart';
import 'package:rentalapp_pos/dialog/dialog.dart';
import 'package:rentalapp_pos/global/globals.dart' as globals;
import 'package:rentalapp_pos/provider/user_state/user_state.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Future.delayed(Duration(seconds: 10), () => checkStatus()));
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: AppTheme.white,
          image: DecorationImage(
            image: AssetImage(bgSplash),
            fit: BoxFit.contain,
          )),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircleAvatar(
              backgroundColor: AppTheme.white.withOpacity(0.7),
              child: Image.asset(
                icLogo,
                scale: 0.65,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkStatus() {
    final state = Provider.of<UserState>(context, listen: false);
    state.getUsersRentalApp();
    log('Device Id', error: state.deviceId, name: "Device Id Dialog");
    log('Verified User',
        error: state.verifyUser(), name: "Verified User Dialog");
    globals.currentLoginUser = state.verifyUser();
    log('User', error: state.users, name: "User Dialog");

    if (state.verifyUser() == null) {
      Dialogs.showMerchantIdDialog(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, CustomRouter.dashboardRoute,
          ModalRoute.withName(Navigator.defaultRouteName));
    }
  }
}
