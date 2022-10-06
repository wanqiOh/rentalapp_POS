import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentalapp_pos/base_helper/ui/drop_down_bar.dart';
import 'package:rentalapp_pos/dialog/dialog.dart';
import 'package:rentalapp_pos/model/firestore_respond/firestore_service.dart';
import 'package:rentalapp_pos/model/view_model/drop_down_item.dart';

class AddAddressDialog extends StatefulWidget {
  @override
  _AddAddressDialogState createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  String _deviceId, _name, _role = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        elevation: 10,
        title: Text('Add Address'),
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
                        labelText: 'Merchant Device ID \*',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[0-9a-zA-Z]')),
                      ],
                      //TODO: Validate the length of deviceId
                      onSaved: (deviceId) => _deviceId = deviceId),
                  TextFormField(
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Name \*',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[\s\b|\b\s+0-9a-zA-Z]')),
                      ],
                      onSaved: (name) => _name = name),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: makeDropDownBar(
                      selectedSite: DropDownItem.objRole,
                      list: DropDownItem.listRole,
                      callBack: (DropDownItem value) {
                        DropDownItem.objRole = value;
                        _role = value.name;
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
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              final bool isSuccess =
                                  addNewUser(_deviceId, _name, _role);
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

  bool addNewUser(String deviceId, String name, String role) {
    bool isSuccess = FirestoreService.getUsers()
        .doc(deviceId)
        .set({'name': name, 'role': role, 'isSelected': false}).then((value) {
      return true;
    }).catchError((error) => print("Failed to add user: $error"));
    return isSuccess;
  }
}
