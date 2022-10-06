import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rentalapp_pos/app_folder/app_theme.dart';
import 'package:rentalapp_pos/base_helper/app_utils.dart';
import 'package:rentalapp_pos/custom_router.dart';
import 'package:rentalapp_pos/dialog/dialog.dart';
import 'package:rentalapp_pos/global/globals.dart' as globals;
import 'package:rentalapp_pos/model/firestore_respond/firestore_service.dart';
import 'package:rentalapp_pos/model/view_model/order_item.dart';

class InboxPage extends StatefulWidget {
  OrderItem orderDetails;
  InboxPage({this.orderDetails});

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 10), () async {
      await FirestoreService.getOrders().doc(widget.orderDetails.id).update(
          {'notifMer.clicked': widget.orderDetails.clicked}).then((value) {
        return true;
      }).catchError((error) => print("Failed to add user: $error"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          leading: backwardButton(context),
          actions: [
            widget.orderDetails.orderStatus == 'PLACED' &&
                    globals.currentLoginUser.role == 'Merchant'
                ? TextButton(
                    onPressed: () async {
                      print('ACCEPT');
                      bool confirm = await Dialogs.showConfirmation(
                      context, 'Confirmation',
                      content:
                      'By clicking \"Confirm\", Rentalapp Guarantee will proceed for this order.\n\nYou will not be able to return or refund after you confirm.',
                      okText: 'Confirm');
                      if (confirm) {
                        print('customer: ${widget.orderDetails.customer.notifId}');
                        await OneSignal.shared.postNotification(
                          OSCreateNotification(
                            playerIds: [widget.orderDetails.customer.notifId],
                            content: "Your order just accepted by merchant!!!",
                            heading: "Order Accepted",
                          ),
                        );

                        final success = await FirestoreService.getOrders()
                            .doc(widget.orderDetails.id)
                            .update({'reply': 'ACCEPT'}).then((value) {
                          return true;
                        }).catchError(
                                (error) => print("Failed to add user: $error"));

                        if (success) {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              CustomRouter.dashboardRoute,
                              ModalRoute.withName(Navigator.defaultRouteName));
                        }
                      }
                    },
                    child: Text('Accept',
                        style: TextStyle(color: AppTheme.light_green)),
                  )
                : Container(),
            widget.orderDetails.orderStatus == 'PLACED' &&
                    globals.currentLoginUser.role == 'Merchant'
                ? TextButton(
                    onPressed: () async {
                      print('REJECT');
                      bool confirm = await Dialogs.showRejection(
                      context, 'Confirmation',
                      content:
                      'By clicking \"Confirm\", Rejection will undergoes penalty.\n\nAre you sure want to continue?',
                      okText: 'Confirm');
                      if (confirm) {
                        print('Customer: ${widget.orderDetails.customer.notifId}');
                        await OneSignal.shared.postNotification(
                          OSCreateNotification(
                            playerIds: [widget.orderDetails.customer.notifId],
                            content: "Your order just rejected by merchant!!!",
                            heading: "Order Rejected",
                          ),
                        );

                        final successOrder = await FirestoreService.getOrders()
                            .doc(widget.orderDetails.id)
                            .update({'reply': 'REJECT'}).then((value) {
                          return true;
                        }).catchError(
                                (error) => print("Failed to add user: $error"));

                        final successMachine =
                            await FirestoreService.getMachines()
                                .doc(widget.orderDetails.machine.id)
                                .update({
                          'quantity': (widget.orderDetails.machine.quantity +
                              widget.orderDetails.orderQuantity)
                        }).then((value) {
                          return true;
                        }).catchError((error) =>
                                    print("Failed to add field: $error"));

                        final success = successOrder && successMachine;

                        if (success) {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              CustomRouter.dashboardRoute,
                              ModalRoute.withName(Navigator.defaultRouteName));
                        }
                      }
                    },
                    child: Text('Reject',
                        style: TextStyle(color: AppTheme.primaryColor)),
                  )
                : Container(),
            widget.orderDetails.orderStatus == 'PROGRESS' &&
                    globals.currentLoginUser.role == 'Admin'
                ? TextButton(
                    onPressed: () async {
                      print('VERIFY ACCEPT');
                      bool confirm = await Dialogs.showConfirmation(
                          context, 'Confirmation',
                          content:
                              'By clicking \"Confirm\", Rentalapp Guarantee will proceed for this order.\n\nYou will not be able to return or refund after you confirm.\n\nPlease ensure you have received the money with correct reference number of bank.',
                          okText: 'Confirm');
                      if (confirm) {
                        await OneSignal.shared.postNotification(
                          OSCreateNotification(
                            playerIds: [widget.orderDetails.merchant.notifId],
                            content: "You just received an order now!!!",
                            heading: "Order Received",
                          ),
                        );

                        final success = await FirestoreService.getOrders()
                            .doc(widget.orderDetails.id)
                            .update({'reply': 'PLACED'}).then((value) {
                          return true;
                        }).catchError(
                                (error) => print("Failed to update: $error"));

                        success ? Navigator.pop(context) : null;
                      }
                    },
                    child: Text('Accept',
                        style: TextStyle(color: AppTheme.light_green)),
                  )
                : Container(),
            widget.orderDetails.orderStatus == 'PROGRESS' &&
                    globals.currentLoginUser.role == 'Admin'
                ? TextButton(
                    onPressed: () async {
                      print('VERIFY REJECT');
                      bool confirm = await Dialogs.showConfirmation(
                          context, 'Confirmation',
                          content:
                              'By clicking \"Confirm\", Rentalapp Guarantee will reject for this order.\n\nYou need to return or refund after you confirm.\n\nPlease ensure you have received the money with correct reference number of bank.',
                          okText: 'Confirm');
                      if (confirm) {
                        await OneSignal.shared.postNotification(
                          OSCreateNotification(
                            playerIds: [widget.orderDetails.customer.notifId],
                            content: "You just received an order now!!!",
                            heading: "Order Received",
                          ),
                        );

                        final successOrder = await FirestoreService.getOrders()
                            .doc(widget.orderDetails.id)
                            .update({'reply': 'REJECT'}).then((value) {
                          return true;
                        }).catchError(
                                (error) => print("Failed to update: $error"));
                        final successMachine =
                            await FirestoreService.getMachines()
                                .doc(widget.orderDetails.machine.id)
                                .update({
                          'quantity': (widget.orderDetails.machine.quantity +
                              widget.orderDetails.orderQuantity)
                        }).then((value) {
                          return true;
                        }).catchError((error) =>
                                    print("Failed to add field: $error"));

                        final success = successOrder && successMachine;

                        success ? Navigator.pop(context) : null;
                      }
                    },
                    child: Text('Reject',
                        style: TextStyle(color: AppTheme.primaryColor)),
                  )
                : Container(),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: AppTheme.mediumHorizontalMargin,
              right: AppTheme.mediumHorizontalMargin,
              top: AppTheme.mediumHorizontalMargin,
              bottom: AppTheme.largeMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                widget.orderDetails.title,
                style: AppTheme.title,
                minFontSize: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: AppTheme.mainMargin),
                child: AutoSizeText(
                  DateFormat('dd').format(widget.orderDetails.startDate) +
                      'th ' +
                      DateFormat('MMM yyyy')
                          .format(widget.orderDetails.startDate),
                  style: AppTheme.bodyText,
                  minFontSize: 5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: AppTheme.mainMargin),
              ),
              textLayoutMessagePage(
                  'The delivery of renting machines is scheduled on ' +
                      DateFormat('dd/MM/yyyy')
                          .format(widget.orderDetails.startDate)),
              Padding(
                padding: const EdgeInsets.only(top: AppTheme.mainMargin),
              ),
              textLayoutMessagePage('Delivery to ' +
                  widget.orderDetails.destination.address1 +
                  ', ' +
                  widget.orderDetails.destination.address2 +
                  ', ' +
                  widget.orderDetails.destination.city +
                  ', ' +
                  widget.orderDetails.destination.postcode +
                  ', ' +
                  widget.orderDetails.destination.state),
              widget.orderDetails.orderStatus == 'ACCEPT' ||
                      widget.orderDetails.orderStatus == 'REJECT' ||
                      widget.orderDetails.orderStatus == 'COMPLETE'
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppTheme.mainMargin),
                    )
                  : Container(),
              widget.orderDetails.orderStatus == 'ACCEPT' ||
                      widget.orderDetails.orderStatus == 'REJECT' ||
                      widget.orderDetails.orderStatus == 'COMPLETE'
                  ? textLayoutMessagePage(
                      'Order Status: ' + widget.orderDetails.orderStatus)
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(top: AppTheme.mainMargin),
              ),
              textLayoutMessagePage('Amount Earn: ' +
                  formatPrice(widget.orderDetails.machine.price.dailyRate)),
              globals.currentLoginUser.role == 'Admin'
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppTheme.mainMargin),
                    )
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? textLayoutMessagePage('Amount Paid: ' +
                      formatPrice(widget.orderDetails.amountPaid))
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppTheme.mainMargin),
                    )
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? textLayoutMessagePage(
                      'Order Status: ' + widget.orderDetails.orderStatus)
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppTheme.mainMargin),
                    )
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? textLayoutMessagePage('Net Profit: ' +
                      formatPrice(widget.orderDetails.getProfit()))
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppTheme.mainMargin),
                    )
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? InkWell(
                  onTap: () {
                    launchURL(
                        widget.orderDetails.fileUrl);
                  },
                  child: Image.network(
                      widget.orderDetails.fileUrl
                                  .split('.')
                                  .last
                                  .toString()
                                  .substring(
                                      widget.orderDetails.fileUrl
                                          .split('.')
                                          .last
                                          .toString()
                                          .indexOf('p'),
                                      (widget.orderDetails.fileUrl
                                              .split('.')
                                              .last
                                              .toString()
                                              .indexOf('p') +
                                          3)) ==
                              'pdf'
                          ? 'https://firebasestorage.googleapis.com/v0/b/rentalapp-fa5bd.appspot.com/o/images%2Fpdf.logo.png?alt=media&token=7ef6cb03-eadb-40de-afb4-3158cf342994'
                          : widget.orderDetails.fileUrl,
                      fit: widget.orderDetails.fileUrl
                                  .split('.')
                                  .last
                                  .toString()
                                  .substring(
                                      widget.orderDetails.fileUrl
                                          .split('.')
                                          .last
                                          .toString()
                                          .indexOf('p'),
                                      (widget.orderDetails.fileUrl
                                              .split('.')
                                              .last
                                              .toString()
                                              .indexOf('p') +
                                          3)) ==
                              'pdf'
                          ? BoxFit.contain
                          : BoxFit.cover))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  textLayoutMessagePage(String text) {
    return AutoSizeText(
      text,
      style: AppTheme.bodyText,
      minFontSize: 15,
    );
  }
}
