import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentalapp_pos/base_helper/app_utils.dart';
import 'package:rentalapp_pos/dialog/dialog.dart';
import 'package:rentalapp_pos/dialog/loading_dialog.dart';
import 'package:rentalapp_pos/model/firestore_respond/firestore_service.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<QueryDocumentSnapshot> deleteUsers = [];
  List<String> title = ['logo', 'ID', 'role', 'name'];
  TextEditingController roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        leading: backwardButton(context),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirestoreService.getUsers().snapshots(),
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
              var selected = snapshot.data.docs
                  .where((element) => element.get('isSelected') == false);
              return Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: ButtonBar(
                      children: [
                        TextButton.icon(
                            onPressed: () {
                              Dialogs.showAddUserDialog(context);
                            },
                            icon: Icon(Icons.add),
                            label: Text('Add User')),
                        OutlinedButton.icon(
                          icon: Icon(Icons.delete),
                          label: const Text('Delete'),
                          onPressed: () async {
                            final confirm = await Dialogs.showConfirmation(
                                context, 'Do you confirm want to delete?');
                            if (confirm) {
                              final success = await deleteUserAndMachines();
                              success.retainWhere((element) {
                                element == true;
                              });
                              print(success);
                              success.isEmpty
                                  ? Dialogs.showMessage(context,
                                      title: 'Success to deleted')
                                  : Dialogs.showMessage(context,
                                      title: 'Some problem happened');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                            defaultColumnWidth: IntrinsicColumnWidth(),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            border: TableBorder.all(
                              color: Colors.grey.shade200,
                            ),
                            children: [
                              TableRow(children: [
                                SizedBox(),
                                // Checkbox(
                                //     value: selected.isNotEmpty ? false : true,
                                //     onChanged: (values) {
                                //       for (var element in snapshot.data.docs) {
                                //         final id = element.reference.id;
                                //         FirestoreService.getUsers()
                                //             .doc(id)
                                //             .update({'isSelected': values});
                                //         setState(() {});
                                //       }
                                //     }),
                                for (var key in title)
                                  Text(
                                    key.toUpperCase(),
                                    textAlign: TextAlign.center,
                                  ),
                              ]),
                              for (int i = 0;
                                  i < snapshot.data.docs.length;
                                  i++)
                                TableRow(children: [
                                  Checkbox(
                                      // value: state.users[i].isSelected,
                                      value: snapshot.data.docs[i]
                                          .get('isSelected'),
                                      onChanged: (values) {
                                        final id =
                                            snapshot.data.docs[i].reference.id;
                                        FirestoreService.getUsers()
                                            .doc(id)
                                            .update({'isSelected': values});
                                        setState(() {});
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: snapshot.data.docs[i].get('role') ==
                                            'Merchant'
                                        ? snapshot.data.docs[i].get('logo') !=
                                                null
                                            ? Image.network(
                                                snapshot.data.docs[i]
                                                    .get('logo'),
                                                scale: 6,
                                                fit: BoxFit.contain,
                                              )
                                            : Icon(Icons.warning_outlined)
                                        : Icon(
                                            Icons.admin_panel_settings_rounded),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data.docs[i].reference.id,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data.docs[i].get('role'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data.docs[i].get('name'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ]),
                            ]),
                      ),
                    ),
                  )),
                ],
              );
            }
          }),
    );
  }

  Future<List<bool>> deleteUserAndMachines() async {
    List<bool> success = [];
    String merchant =
        await FirestoreService.getQueryOfisSelected().get().then((value) async {
      for (DocumentSnapshot ds in value.docs) {
        success.add(await ds.reference
            .delete()
            .then((value) => true)
            .catchError((error) => print("Failed to delete user: $error")));
        return ds.reference.id;
      }
    });

    print(merchant);

    FirestoreService.filterMachine('merchant.id', merchant)
        .get()
        .then((value) async {
      for (var element in value.docs) {
        print('reference id: ${element.reference.id}');
        success.add(
          await FirestoreService.getMachines()
              .doc(element.reference.id)
              .delete()
              .then((value) => true)
              .catchError((error) => print("Failed to delete user: $error")),
        );
      }
    });

    return Future.delayed(Duration(seconds: 1), () => success);
  }
}
