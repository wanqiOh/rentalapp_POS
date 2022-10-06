import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rentalapp_pos/app_folder/app_theme.dart';
import 'package:rentalapp_pos/base_helper/app_utils.dart';
import 'package:rentalapp_pos/dialog/dialog.dart';
import 'package:rentalapp_pos/dialog/loading_dialog.dart';
import 'package:rentalapp_pos/global/globals.dart' as globals;
import 'package:rentalapp_pos/model/firestore_respond/firestore_service.dart';
import 'package:rentalapp_pos/model/view_model/address.dart';
import 'package:rentalapp_pos/model/view_model/customer.dart';
import 'package:rentalapp_pos/model/view_model/invoice.dart';
import 'package:rentalapp_pos/model/view_model/machine_item.dart';
import 'package:rentalapp_pos/model/view_model/merchant.dart';
import 'package:rentalapp_pos/model/view_model/order_item.dart';
import 'package:rentalapp_pos/repository/pdf_invoice_repository.dart';
import 'package:rentalapp_pos/repository/pdf_repository.dart';

class VerifyPage extends StatefulWidget {
  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  String invoiceNum;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        leading: backwardButton(context),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirestoreService.filterOrders('reply', 'PROGRESS').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingPage(message: 'Waiting for connection...');
            }
            if (!snapshot.hasData)
              return CircularProgressIndicator();
            else {
              return SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      generateTitle('PAYMENT\nVERIFICATION'),
                      snapshot.data.docs.length != 0
                          ? GridView.count(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 0, 16.0, 16.0),
                              childAspectRatio:
                                  MediaQuery.of(context).size.width >= 700
                                      ? MediaQuery.of(context).size.width / 125
                                      : MediaQuery.of(context).size.width / 130,
                              crossAxisCount: 1,
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot document) {
                                DateTime startDate =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        ((document.get('date.startDate'))
                                                .seconds *
                                            1000));
                                DateTime endDate =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        ((document.get('date.endDate'))
                                                .seconds *
                                            1000));
                                DateTime createdDate =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        ((document.get('date.createdDate'))
                                                .seconds *
                                            1000));
                                globals.order = OrderItem(
                                  customer: Customer.fromJson(
                                      document.get('customer')),
                                  merchant: Merchant.fromJson(
                                      document.get('merchant')),
                                  destination: AddressDes.fromJson(
                                      document.get('address')),
                                  startDate: startDate,
                                  endDate: endDate,
                                  machine: MachineItem.fromJson(
                                      document.get('machine')),
                                  orderQuantity: document.get('orderQuantity'),
                                  totalDistance:
                                      document.get('distance').toString(),
                                  orderStatus: document.get('reply'),
                                  amountPaid:
                                      (document.get('payment.paid') as num ?? 0)
                                          .toDouble(),
                                  fileUrl: document.get('payment.fileUrl'),
                                );
                                return GridTile(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 8.0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 2.0,
                                            color: Colors.grey.shade200),
                                      ),
                                    ),
                                    child: Dismissible(
                                      key: Key(document.reference.id),
                                      background: slideRightBackground(),
                                      secondaryBackground:
                                          slideLeftBackground(),
                                      confirmDismiss: (direction) async {
                                        if (direction ==
                                            DismissDirection.endToStart) {
                                          final successOrder =
                                              await FirestoreService.getOrders()
                                                  .doc(document.reference.id)
                                                  .update({
                                            'reply': 'REJECT'
                                          }).then((value) {
                                            return true;
                                          }).catchError((error) => print(
                                                      "Failed to delete user: $error"));

                                          final successMachine =
                                              await FirestoreService
                                                      .getMachines()
                                                  .doc(document
                                                      .get('machine')['id'])
                                                  .update({
                                            'quantity': (document.get(
                                                    'machine')['quantity'] +
                                                document.get('orderQuantity'))
                                          }).then((value) {
                                            return true;
                                          }).catchError((error) => print(
                                                      "Failed to add field: $error"));

                                          final success =
                                              successOrder && successMachine;
                                          success
                                              ? Dialogs.showMessage(context,
                                                  title:
                                                      'This order was rejected')
                                              : null;
                                        } else {
                                          bool confirm =
                                              await Dialogs.showConfirmation(
                                                  context, 'Confirmation',
                                                  content:
                                                      'By clicking \"Confirm\", Rentalapp Guarantee will proceed for this order.\n\nYou will not be able to return or refund after you confirm.\n\nPlease ensure you have received the money with correct reference number of bank.',
                                                  okText: 'Confirm');
                                          if (confirm) {
                                            final success = await FirestoreService
                                                    .getOrders()
                                                .doc(document.reference.id)
                                                .update({
                                              'reply': 'PLACED'
                                            }).then((value) {
                                              return true;
                                            }).catchError((error) => print(
                                                    "Failed to update: $error"));
                                            print("Success: $success");
                                            success
                                                ? generateInvoiceAndSendEmail(
                                                    document)
                                                : print('Somethings was wrong');
                                          }
                                        }
                                      },
                                      child: InkWell(
                                        onTap: () {
                                          launchURL(
                                              document.get('payment.fileUrl'));
                                        },
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  child: Image.network(
                                                      document.get('payment.fileUrl').split('.').last.toString().substring(
                                                                  document
                                                                      .get(
                                                                          'payment.fileUrl')
                                                                      .split(
                                                                          '.')
                                                                      .last
                                                                      .toString()
                                                                      .indexOf(
                                                                          'p'),
                                                                  (document
                                                                          .get(
                                                                              'payment.fileUrl')
                                                                          .split(
                                                                              '.')
                                                                          .last
                                                                          .toString()
                                                                          .indexOf(
                                                                              'p') +
                                                                      3)) ==
                                                              'pdf'
                                                          ? 'https://firebasestorage.googleapis.com/v0/b/rentalapp-fa5bd.appspot.com/o/images%2Fpdf.logo.png?alt=media&token=7ef6cb03-eadb-40de-afb4-3158cf342994'
                                                          : document.get(
                                                              'payment.fileUrl'),
                                                      fit: document
                                                                  .get(
                                                                      'payment.fileUrl')
                                                                  .split('.')
                                                                  .last
                                                                  .toString()
                                                                  .substring(
                                                                      document
                                                                          .get('payment.fileUrl')
                                                                          .split('.')
                                                                          .last
                                                                          .toString()
                                                                          .indexOf('p'),
                                                                      (document.get('payment.fileUrl').split('.').last.toString().indexOf('p') + 3)) ==
                                                              'pdf'
                                                          ? BoxFit.contain
                                                          : BoxFit.cover),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AutoSizeText(
                                                        formatPrice((document.get(
                                                                        'payment.paid')
                                                                    as num ??
                                                                0)
                                                            .toDouble()),
                                                        // machines.machineName.toUpperCase(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                      SizedBox(height: 10),
                                                      // AutoSizeText(
                                                      //     document.get(
                                                      //         'payment.payType'),
                                                      //     // machines.machineType,
                                                      //     style: TextStyle(
                                                      //         fontSize: 15)),
                                                      SizedBox(height: 10),
                                                      AutoSizeText(
                                                          'Refer No: ${document.get('payment.referNo')}',
                                                          style: TextStyle(
                                                              fontSize: 15)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height >= 700
                                  ? MediaQuery.of(context).size.height * 0.7
                                  : MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  'No received any order yet',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                    ]),
              );
            }
          }),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              "Approve",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              "Reject",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Future<bool> deleteMachine(DocumentSnapshot document) async {
    final isSuccess = await FirestoreService.getMachines()
        .doc(document.reference.id)
        .delete()
        .then((value) {
      print('Value: ${value.toString()}');
      return true;
    }).catchError((error) => print("Failed to delete user: $error"));
    return isSuccess;
  }

  generateInvoiceAndSendEmail(DocumentSnapshot<Object> document) async {
    await OneSignal.shared.postNotification(
      OSCreateNotification(
        playerIds: [document.get('merchant.notifId')],
        content: "You just received an order now!!!",
        heading: "Order Received",
      ),
    );

    await FirestoreService.getOrders().get().then((element) {
      setState(() {
        invoiceNum = element.docs.length.toString();
      });
    });

    final date = DateTime.now();
    final dueDate = date.add(Duration(days: 7));

    // initial invoice
    final invoice = Invoice(
      supplier: Merchant.invoice(
        companyName: document.get('merchant.name'),
        address: AddressDes.fromJson(document.get('merchant.address')),
        phoneNo: document.get('merchant.phoneNo'),
      ),
      customer: Customer.invoice(
        name: '${document.get('title')} ${document.get('customer.name')}',
        address: AddressDes.fromJson(document.get('address')),
      ),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: 'Thank you for using and supporting our service',
        number:
            '${DateFormat('yyyyMMdd').format(DateTime.now())}-${invoiceNum.padLeft(6, '0')}',
      ),
      items: [MachineItem.fromJson(document.get('machine'))],
    );

    // Generate pdf invoice
    final pdfFile = await PdfInvoiceRepository.generate(invoice);
    print(pdfFile);
    String url = await PdfRepository.uploadInvoice(pdfFile);
    String invoiceId = await FirestoreService.getInvoice().add({
      'id':
          '${DateFormat('yyyyMMdd').format(DateTime.now())}-${invoiceNum.padLeft(6, '0')}',
      'url': url,
      'orderID': document.reference.id,
    }).then((value) {
      return value.id;
    }).catchError((error) => print("Failed to add field: $error"));

    //Send email
    final smtpServer = gmail('pinanclezenith@gmail.com', 'thisisComp_Email');

    final message = Message()
      ..from = Address('wanqi.oh@gmail.com', 'Rentalapp')
      ..recipients.add(document.get('customer.email'))
      ..subject =
          'Rentalapp Invoice - ${DateFormat('yyyyMMdd').format(DateTime.now())}-${invoiceNum.padLeft(6, '0')}'
      ..html = '<img src = https://firebasestorage.googleapis.com/v0/b/rentalapp-fa5bd.appspot.com/o/email%2FheaderImage.PNG?alt=media&token=d5bbed07-9ff1-4530-8389-184188ab1b1b, alt = rentalapp><br><br>'
          '<h1>Thank you for supporting and using our service</h1><br>'
          '<p>We appreciate your continous support towards rentalapp, the cashless machinery renting experience</p><br><br>'
          '<p>Your invoice is ready!</p>'
          '<p>Click <a href = ${url}>here</a> to view your invoice</p><br><br>'
          '<img src = https://firebasestorage.googleapis.com/v0/b/rentalapp-fa5bd.appspot.com/o/email%2FbottomImage.PNG?alt=media&token=f766e653-0fd4-4e6d-980f-4aeaaae75024, alt = rentalapp>';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      Dialogs.showMessage(context,
          title:
              'This order will be proceed\n\nInvoice was generated and sent to Customer\'s email.');
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
