import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentalapp_pos/custom_router.dart';
import 'package:rentalapp_pos/provider/user_state/user_state.dart';

class MerchantIdDialog extends StatefulWidget {
  @override
  _MerchantIdDialogState createState() => _MerchantIdDialogState();
}

class _MerchantIdDialogState extends State<MerchantIdDialog> {
  @override
  Widget build(BuildContext context) {
    final deviceId = Provider.of<UserState>(context, listen: false).deviceId;
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        elevation: 10,
        content: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  'Kindly copy the message to admin in order to add on \n\nRental App Device ID: $deviceId'),
              ButtonBar(
                children: <Widget>[
                  TextButton(
                    child: Text('Copy'),
                    onPressed: () {
                      ClipboardManager.copyToClipBoard(
                              'Rental App Device ID: $deviceId')
                          .then((result) {
                        final snackBar = SnackBar(
                          content: Text('Copied to Clipboard'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      });
                    },
                  ),
                  OutlinedButton(
                    child: const Text('Retry'),
                    onPressed: () {
                      Navigator.pushNamed(context, CustomRouter.splashRoute);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
