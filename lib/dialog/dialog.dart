import 'package:flutter/material.dart';
import 'package:rentalapp_pos/custom_router.dart';
import 'package:rentalapp_pos/dialog/add_address_dialog.dart';
import 'package:rentalapp_pos/dialog/add_machine_category_dialog.dart';
import 'package:rentalapp_pos/dialog/merchant_id_dialog.dart';
import 'package:rentalapp_pos/dialog/order_details_dialog.dart';
import 'package:rentalapp_pos/model/firestore_respond/firestore_service.dart';
import 'package:rentalapp_pos/model/view_model/order_item.dart';

import 'add_user_dialog.dart';

class Dialogs {
  static void showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(
          builder: (context) => AddUserDialog(),
        ),
      ),
    );
  }

  static void showAddMachineCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(
          builder: (context) => AddMachineCategoryDialog(),
        ),
      ),
    );
  }

  static void showAddAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(
          builder: (context) => AddAddressDialog(),
        ),
      ),
    );
  }

  static Future<bool> showConfirmation(BuildContext context, String title,
          {String content =
              'The data will be deleted forever, Do you confirm ?',
          String okText = 'Delete'}) async =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context, false),
            ),
            OutlinedButton(
              child: Text(okText),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );

  static Future<bool> showRejection(BuildContext context, String title,
      {String content =
      'The data will be deleted forever, Do you confirm ?',
        String okText = 'Delete', bool agree = false}) async =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: Column(children: [Text(content), Row(
            children: [
              Material(
                child: Checkbox(
                  value: agree,
                  onChanged: (value) {
                      agree = value;
                  },
                ),
              ),
              Text(
                'I have read and accept',
                overflow: TextOverflow.ellipsis,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context, CustomRouter.termAndConditionRoute);
                },
                child: Text(
                  ' terms and conditions',
                  style: TextStyle(color: Colors.blue),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),]),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context, false),
            ),
            !agree ? null : OutlinedButton(
              child: Text(okText),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );

  static Future<void> showMessage(
    BuildContext context, {
    String title,
    Widget content,
  }) async =>
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
          title: title == null ? null : Text(title),
          content: content,
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

  static Future<void> showMessageReply(
    BuildContext context, {
    String title,
    Widget content,
  }) async =>
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
          title: title == null ? null : Text(title),
          content: content,
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

  static Future<void> showMessageProfile(
    BuildContext context, {
    String title,
    Widget content,
  }) async =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: title == null ? null : Text(title),
            content: content,
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.popAndPushNamed(
                    context, CustomRouter.profileRoute),
              ),
            ],
          ),
        ),
      );

  static void showMerchantIdDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(
          builder: (context) => MerchantIdDialog(),
        ),
      ),
    );
  }

  static void showOrderDetailsDialog(BuildContext context, OrderItem order) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(
          builder: (context) => OrderDetailsDialog(order: order),
        ),
      ),
    );
  }

  static Future<bool> showConfirmationForCompleteOrder(
          BuildContext context, String title, OrderItem order,
          {String content, String okText}) async =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () => Navigator.pop(context, false),
            ),
            OutlinedButton(
              child: Text(okText),
              onPressed: () async {
                final success = await FirestoreService.getOrders()
                    .doc(order.id)
                    .update({'reply': 'COMPLETE'}).then((value) {
                  return true;
                }).catchError((error) => print("Failed to add field: $error"));
                Navigator.pop(context, success);
              },
            ),
          ],
        ),
      );
}
