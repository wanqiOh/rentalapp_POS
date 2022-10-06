import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentalapp_pos/app_folder/app_theme.dart';
import 'package:rentalapp_pos/base_helper/app_utils.dart';
import 'package:rentalapp_pos/custom_router.dart';
import 'package:rentalapp_pos/dialog/dialog.dart';
import 'package:rentalapp_pos/dialog/loading_dialog.dart';
import 'package:rentalapp_pos/global/globals.dart' as globals;
import 'package:rentalapp_pos/model/firestore_respond/firestore_service.dart';
import 'package:rentalapp_pos/model/view_model/category_item.dart';

class EditingPage extends StatefulWidget {
  CategoryItem machines;
  EditingPage({this.machines});
  @override
  _EditingPageState createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  bool enable = true;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          leading: backwardButton(context),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: ((globals.currentLoginUser.role == 'Merchant')
                    ? (widget.machines != null
                        ? FirestoreService.filterMachineTypeAndMerchant(
                            'type',
                            widget.machines.machineType,
                            'merchant.id',
                            globals.currentLoginUser.id)
                        : FirestoreService.filterMachine(
                            'merchant.id', globals.currentLoginUser.id))
                    : FirestoreService.getMachines())
                .snapshots(),
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
                        generateTitle('RENTAL\nMACHINE'),
                        GridView.count(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                          childAspectRatio:
                              MediaQuery.of(context).size.width >= 700
                                  ? MediaQuery.of(context).size.width / 125
                                  : MediaQuery.of(context).size.width / 130,
                          crossAxisCount: 1,
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            print(document.data());
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
                                  secondaryBackground: slideLeftBackground(),
                                  confirmDismiss: (direction) async {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      bool confirm =
                                          await Dialogs.showConfirmation(
                                              context,
                                              'Do you confirm want to delete?');
                                      print('Answer: ${confirm}');

                                      if (confirm) {
                                        final success =
                                            await deleteMachine(document);
                                        print("Success: $success");
                                        success
                                            ? Dialogs.showMessage(context,
                                                title: 'Success to deleted')
                                            : null;
                                      }
                                    } else {
                                      Navigator.pushNamed(context,
                                          CustomRouter.editingDetailRoute,
                                          arguments: document);
                                    }
                                  },
                                  child: Stack(children: [
                                    InkWell(
                                      onLongPress: () {
                                        globals.currentLoginUser.role == 'Admin'
                                            ? FirestoreService.getMachines()
                                                .doc(document.reference.id)
                                                .update({
                                                'enable':
                                                    !(document.get('enable'))
                                              }).then((value) {
                                                return true;
                                              }).catchError((error) => print(
                                                    "Failed to update details: $error"))
                                            : null;
                                      },
                                      onTap: () {
                                        print(
                                            "${document.get('model')} clicked");
                                        Navigator.pushNamed(context,
                                            CustomRouter.editingDetailRoute,
                                            arguments: document);
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
                                                    document.get('image'),
                                                    scale: 4,
                                                    fit: BoxFit.contain),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AutoSizeText(
                                                      document
                                                          .get('model')
                                                          .toUpperCase(),
                                                      // machines.machineName.toUpperCase(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    SizedBox(height: 10),
                                                    AutoSizeText(
                                                        document
                                                            .get('type')
                                                            .toString()
                                                            .split('_')
                                                            .join(' '),
                                                        // machines.machineType,
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                    SizedBox(height: 10),
                                                    AutoSizeText(
                                                        'Quantity: ${(document.get('quantity')).toString()}',
                                                        style: TextStyle(
                                                            fontSize: 10)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ),
                                    document.get('enable')
                                        ? Container()
                                        : InkWell(
                                            onLongPress: () {
                                              FirestoreService.getMachines()
                                                  .doc(document.reference.id)
                                                  .update({
                                                'enable':
                                                    !(document.get('enable'))
                                              }).then((value) {
                                                return true;
                                              }).catchError((error) => print(
                                                      "Failed to update details: $error"));
                                            },
                                            child: Positioned(
                                              bottom: 0.0,
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    7,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors
                                                            .transparent), //color is transparent so that it does not blend with the actual color specified
                                                    color: Color.fromRGBO(
                                                        255,
                                                        255,
                                                        255,
                                                        0.7) // Specifies the background color and the opacity
                                                    ),
                                                child: Center(
                                                  child: Text(
                                                    'Disable Now',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 40),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ]),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ]),
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: Icon(Icons.add),
            backgroundColor: Colors.black.withOpacity(0.5),
            onPressed: () {
              Dialogs.showAddMachineCategoryDialog(context);
            }),
      ),
      globals.currentLoginUser.role == 'Admin'
          ? Positioned(
              bottom: 0.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 8.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.transparent),
                    color: Color.fromRGBO(128, 128, 128,
                        0.7) // Specifies the background color and the opacity
                    ),
                child: Text('Long press to enable/disable the machine',
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 13)),
              ),
            )
          : Container(),
    ]);
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
              "Edit",
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
              "Delete",
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
}
