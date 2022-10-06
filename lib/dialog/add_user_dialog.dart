import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentalapp_pos/base_helper/ui/drop_down_bar.dart';
import 'package:rentalapp_pos/dialog/dialog.dart';
import 'package:rentalapp_pos/model/firestore_respond/firestore_service.dart';
import 'package:rentalapp_pos/model/view_model/drop_down_item.dart';

class AddUserDialog extends StatefulWidget {
  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  TextEditingController deviceIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   DropDownItem.objRole.name = 'Selected';
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        elevation: 10,
        title: Text('Add User'),
        content: SingleChildScrollView(
          reverse: true,
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Device ID \*',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[0-9a-zA-Z]')),
                      ],
                      //TODO: Validate the length of deviceId
                      validator: (devideId) {
                        if (devideId.length != 16)
                          return 'Invalid Device ID';
                        else if (devideId.isEmpty)
                          return 'This field cannot be empty';
                        else
                          return null;
                      },
                      onSaved: (deviceId) =>
                          deviceIdController.text = deviceId),
                  TextFormField(
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Name \*',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(''),
                      ],
                      validator: (name) {
                        if (name.isEmpty)
                          return 'This field cannot be empty';
                        else
                          return null;
                      },
                      onSaved: (name) => nameController.text = name),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: makeDropDownBar(
                      selectedSite: DropDownItem.objRole,
                      list: DropDownItem.listRole,
                      callBack: (DropDownItem value) {
                        DropDownItem.objRole = value;
                        roleController.text = value.name;
                        setState(() {});
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ButtonBar(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text('Cancel')),
                        OutlinedButton(
                          child: Text('Ok'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              final bool isSuccess = await addNewUser(
                                  deviceIdController.text,
                                  nameController.text,
                                  roleController.text);
                              if (isSuccess) {
                                Navigator.pop(context);
                                Dialogs.showMessage(context,
                                    title: 'Success to added');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future<bool> addNewUser(String deviceId, String name, String role) async {
    if (role == 'Admin') {
      bool isSuccess = await FirestoreService.getUsers().doc(deviceId).set({
        'id': deviceId,
        'name': name,
        'role': role,
        'isSelected': false,
        'createdDateTime': DateTime.now(),
        'notifId': null,
        'firstTime': true,
      }).then((value) {
        return true;
      }).catchError((error) => print("Failed to add user: $error"));
      return isSuccess;
    } else {
      bool isSuccess = await FirestoreService.getUsers().doc(deviceId).set({
        'id': deviceId,
        'name': name,
        'role': role,
        'isSelected': false,
        'createdDateTime': DateTime.now(),
        'firstTime': true,
        'logo': null,
        'notifId': null,
      }).then((value) {
        return true;
      }).catchError((error) => print("Failed to add user: $error"));
      return isSuccess;
    }
  }
}
