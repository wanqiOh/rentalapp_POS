import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rentalapp_pos/base_helper/app_utils.dart';
import 'package:rentalapp_pos/base_helper/ui/drop_down_bar.dart';
import 'package:rentalapp_pos/dialog/dialog.dart';
import 'package:rentalapp_pos/model/firestore_respond/firestore_service.dart';
import 'package:rentalapp_pos/model/view_model/address.dart';
import 'package:rentalapp_pos/model/view_model/drop_down_item.dart';
import 'package:rentalapp_pos/model/view_model/locations.dart';
import 'package:rentalapp_pos/model/view_model/machine_detail.dart';
import 'package:rentalapp_pos/model/view_model/merchant.dart';
import 'package:rentalapp_pos/model/view_model/price_detail.dart';
import 'package:rentalapp_pos/model/view_model/user.dart';
import 'package:rentalapp_pos/provider/user_state/user_state.dart';
import 'package:rentalapp_pos/global/globals.dart' as globals;

class AddMachineCategoryDialog extends StatefulWidget {
  @override
  _AddMachineCategoryDialogState createState() =>
      _AddMachineCategoryDialogState();
}

class _AddMachineCategoryDialogState extends State<AddMachineCategoryDialog> {
  String _model, _machineType, _imageUrl, _engine, _remark;
  int _quantity = 1, _index, _weight, _capacity;
  double _dailyRate, _deliveryCharge, _workingHeight, _width, _length, _height;
  final _formKey = GlobalKey<FormState>();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   DropDownItem.objMachineType.name = 'Selected';
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        elevation: 10,
        title: Text('Add Machine'),
        content: SingleChildScrollView(
          reverse: true,
          child: Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  generateTitle('Category'),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: makeDropDownBar(
                      selectedSite: DropDownItem.objMachineType,
                      list: DropDownItem.listMachineType,
                      callBack: (DropDownItem value) {
                        DropDownItem.objMachineType = value;
                        _machineType = value.name;
                        _index = value.id;
                        setState(() {});
                      },
                    ),
                  ),
                  TextFormField(
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Model \*',
                      ),
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                      validator: (model) {
                        if (model.isEmpty)
                          return 'This field cannot be empty';
                        else
                          return null;
                      },
                      onSaved: (model) => _model = model),
                  TextFormField(
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Quantity \*',
                      ),
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (quantity) {
                        if (quantity.isEmpty)
                          return 'This field cannot be empty';
                        else
                          return null;
                      },
                      onSaved: (quantity) => _quantity = int.parse(quantity)),
                  GestureDetector(
                      onTap: () async {
                        print('Upload Picture');
                        _imageUrl = await uploadImage();
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(15),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                border: Border.all(color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(2, 2),
                                    spreadRadius: 2,
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              child: (_imageUrl != null)
                                  ? Image.network(_imageUrl)
                                  : Image.network(
                                      'https://i.imgur.com/sUFH1Aq.png'),
                            ),
                          ],
                        ),
                      )),
                  generateTitle('Details'),
                  TextFormField(
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Width (m)\*',
                        hintText: '(in unit m)',
                      ),
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2)
                      ],
                      validator: (width) {
                        if (width.isEmpty)
                          return 'This field cannot be empty';
                        else
                          return null;
                      },
                      onSaved: (width) => _width = double.parse(width)),
                  TextFormField(
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Length (m)\*',
                        hintText: '(in unit m)',
                      ),
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2)
                      ],
                      validator: (length) {
                        if (length.isEmpty)
                          return 'This field cannot be empty';
                        else
                          return null;
                      },
                      onSaved: (length) => _length = double.parse(length)),
                  TextFormField(
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Height (m)\*',
                        hintText: '(in unit m)',
                      ),
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2)
                      ],
                      validator: (height) {
                        if (height.isEmpty)
                          return 'This field cannot be empty';
                        else
                          return null;
                      },
                      onSaved: (height) => _height = double.parse(height)),
                  TextFormField(
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Weight (kg)\*',
                        hintText: '(in unit kg)',
                      ),
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (weight) {
                        if (weight.isEmpty)
                          return 'This field cannot be empty';
                        else
                          return null;
                      },
                      onSaved: (weight) => _weight = int.parse(weight)),
                  TextFormField(
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Working Height, Max (m)\*',
                        hintText: '(in unit m)',
                      ),
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2)
                      ],
                      validator: (workingHeight) {
                        if (workingHeight.isEmpty)
                          return 'This field cannot be empty';
                        else
                          return null;
                      },
                      onSaved: (workingHeight) =>
                          _workingHeight = double.parse(workingHeight)),
                  TextFormField(
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Platform Capacity, Max (kg) \*',
                        hintText: '(in unit kg)',
                      ),
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (capacity) {
                        if (capacity.isEmpty)
                          return 'This field cannot be empty';
                        else
                          return null;
                      },
                      onSaved: (capacity) => _capacity = int.parse(capacity)),
                  TextFormField(
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Engine \*',
                      ),
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                      validator: (engine) {
                        if (engine.isEmpty)
                          return 'This field cannot be empty';
                        else
                          return null;
                      },
                      onSaved: (engine) => _engine = engine),
                  TextFormField(
                      maxLines: null,
                      minLines: 2,
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Remark \*',
                        hintText:
                            'Track Adjustable (Standard/Option), Stabilisation System (Standard/Option), Platform Load Person',
                      ),
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(''),
                      ],
                      validator: (remark) {
                        if (remark.isEmpty)
                          return 'This field cannot be empty';
                        else
                          return null;
                      },
                      onSaved: (remark) => _remark = remark),
                  generateTitle('Price'),
                  TextFormField(
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Daily Rate (RM)\*',
                      ),
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2)
                      ],
                      validator: (dailyRate) {
                        if (dailyRate.isEmpty)
                          return 'This field cannot be empty';
                        else
                          return null;
                      },
                      onSaved: (dailyRate) =>
                          _dailyRate = double.parse(dailyRate)),
                  TextFormField(
                      style: TextStyle(color: Colors.blue),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Delivery Charge (RM)\*',
                      ),
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2)
                      ],
                      validator: (deliveryCharge) {
                        if (deliveryCharge.isEmpty)
                          return 'This field cannot be empty';
                        else
                          return null;
                      },
                      onSaved: (deliveryCharge) =>
                          _deliveryCharge = double.parse(deliveryCharge)),
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
                              final id = await addNewMachine(
                                  _model,
                                  _quantity,
                                  _machineType,
                                  _index,
                                  _imageUrl,
                                  _length,
                                  _height,
                                  _weight,
                                  _width,
                                  _workingHeight,
                                  _capacity,
                                  _engine,
                                  _remark,
                                  _dailyRate,
                                  _deliveryCharge);
                              print('Id: $id');
                              if (id.isNotEmpty) {
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> addNewMachine(
      String model,
      int quantity,
      String machineType,
      int index,
      String imageUrl,
      double length,
      double height,
      int weight,
      double width,
      double workingHeight,
      int capacity,
      String engine,
      String remark,
      double dailyPrice,
      double charge) async {
    final ID = Provider.of<UserState>(context, listen: false).deviceId;
    print("role: ${globals.currentLoginUser.role}");
    if(globals.currentLoginUser.role == 'Merchant'){
      Merchant merchant = await FirestoreService.getUsers()
          .doc(ID)
          .get()
          .then((element) {
        if (element.get('firstTime')) {
          fillInDetail(context);
        } else {
          return Merchant(
            id: element.reference.id,
            notifId: element.get('notifId'),
            logo: element.get('logo'),
            companyName: element.get('name'),
            location: Locations.fromJson(element.get('location')),
            address: AddressDes.fromJson(element.get('address')),
            director: element.get('director'),
            phoneNo: element.get('phoneNo'),
            website: element.get('website'),
            position: Position(
                latitude: element.get('position')['latitude'],
                longitude: element.get('position')['longitude']),
          );
        }
      });

      final String isSuccess = await FirestoreService.getMachines().add({
        'model': model,
        'quantity': quantity,
        'image': imageUrl,
        'type': machineType,
        'detail': MachineDetail(
            width: width,
            length: length,
            height: height,
            weight: weight,
            workingHeight: workingHeight,
            capacity: capacity,
            engine: engine,
            remark: remark)
            .toJson(),
        'price':
        PriceDetail(dailyRate: dailyPrice, deliveryCharge: charge).toJson(),
        'merchant': merchant.toJson(),
        'enable': true,
        'caseSearch': setSearchParam(model) +
            setSearchParam(merchant.companyName) +
            setSearchParam(machineType.split('_').join(' ')) +
            setSearchParam(model.toLowerCase()) +
            setSearchParam(merchant.companyName.toString().toLowerCase()) +
            setSearchParam(machineType.split('_').join(' ').toLowerCase()) +
            setSearchParam(model.toUpperCase()) +
            setSearchParam(merchant.companyName.toString().toUpperCase()) +
            setSearchParam(machineType.split('_').join(' ').toUpperCase()),
      }).then((value) {
        return value.id;
      }).catchError((error) => print("Failed to add machine: $error"));

      return isSuccess;
    }
    else {
      UserRentalApp admin = await FirestoreService.getUsers()
          .doc(ID)
          .get()
          .then((element) {
        return UserRentalApp(name: element.get('name'), id: element.get('id'), role: element.get('role'));
      });

      print('Admin: ${admin}');

      final String isSuccess = await FirestoreService.getMachines().add({
        'model': model,
        'quantity': quantity,
        'image': imageUrl,
        'type': machineType,
        'detail': MachineDetail(
            width: width,
            length: length,
            height: height,
            weight: weight,
            workingHeight: workingHeight,
            capacity: capacity,
            engine: engine,
            remark: remark)
            .toJson(),
        'price': PriceDetail(dailyRate: dailyPrice, deliveryCharge: charge).toJson(),
        'merchant': admin.toJson(),
        'enable': true,
        'caseSearch': setSearchParam(model) +
            setSearchParam(admin.name) +
            setSearchParam(machineType.split('_').join(' ')) +
            setSearchParam(model.toLowerCase()) +
            setSearchParam(admin.name.toString().toLowerCase()) +
            setSearchParam(machineType.split('_').join(' ').toLowerCase()) +
            setSearchParam(model.toUpperCase()) +
            setSearchParam(admin.name.toString().toUpperCase()) +
            setSearchParam(machineType.split('_').join(' ').toUpperCase()),
      }).then((value) {
        return value.id;
      }).catchError((error) => print("Failed to add machine: $error"));

      return isSuccess;
    }
  }

  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _imagePicker.getImage(source: ImageSource.gallery);

      if (image != null) {
        //Upload to Firebase
        Reference storageReference = _firebaseStorage
            .ref()
            .child('rental_machines/${Path.basename(image.path)}}');
        UploadTask uploadTask = storageReference.putFile(File(image.path));
        await uploadTask.whenComplete(() {
          print('File Uploaded');
        });
        storageReference.getDownloadURL().then((fileURL) {
          setState(() {
            _imageUrl = fileURL;
          });
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }
}
