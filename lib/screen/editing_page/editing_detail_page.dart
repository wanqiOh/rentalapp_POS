import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';
import 'package:rentalapp_pos/base_helper/app_utils.dart';
import 'package:rentalapp_pos/base_helper/ui/drop_down_bar.dart';
import 'package:rentalapp_pos/dialog/dialog.dart';
import 'package:rentalapp_pos/model/firestore_respond/firestore_service.dart';
import 'package:rentalapp_pos/model/view_model/drop_down_item.dart';
import 'package:rentalapp_pos/model/view_model/machine_detail.dart';
import 'package:rentalapp_pos/model/view_model/price_detail.dart';

class EditingDetailPage extends StatefulWidget {
  DocumentSnapshot selectedDocument;
  EditingDetailPage({this.selectedDocument});
  @override
  _EditingDetailPageState createState() => _EditingDetailPageState();
}

class _EditingDetailPageState extends State<EditingDetailPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController modelController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController workingHeightController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController engineController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController dayRateController = TextEditingController();
  TextEditingController deliveryChargeController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  FocusNode modelFocusNode = FocusNode();
  FocusNode quantityFocusNode = FocusNode();
  FocusNode widthFocusNode = FocusNode();
  FocusNode lengthFocusNode = FocusNode();
  FocusNode heightFocusNode = FocusNode();
  FocusNode weightFocusNode = FocusNode();
  FocusNode workingHeightFocusNode = FocusNode();
  FocusNode capacityFocusNode = FocusNode();
  FocusNode engineFocusNode = FocusNode();
  FocusNode remarkFocusNode = FocusNode();
  FocusNode dayRateFocusNode = FocusNode();
  FocusNode deliveryChargeFocusNode = FocusNode();
  String documentId, detailId, priceId;

  @override
  void dispose() {
    super.dispose();
    modelController.dispose();
    quantityController.dispose();
    typeController.dispose();
    widthController.dispose();
    lengthController.dispose();
    heightController.dispose();
    weightController.dispose();
    workingHeightController.dispose();
    capacityController.dispose();
    engineController.dispose();
    remarkController.dispose();
    dayRateController.dispose();
    deliveryChargeController.dispose();
    imageController.dispose();
    modelFocusNode.dispose();
    quantityFocusNode.dispose();
    widthFocusNode.dispose();
    lengthFocusNode.dispose();
    heightFocusNode.dispose();
    weightFocusNode.dispose();
    workingHeightFocusNode.dispose();
    capacityFocusNode.dispose();
    engineFocusNode.dispose();
    remarkFocusNode.dispose();
    dayRateFocusNode.dispose();
    deliveryChargeFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    documentId = widget.selectedDocument.reference.id;
    modelController.text = widget.selectedDocument['model'];
    quantityController.text = widget.selectedDocument['quantity'].toString();
    typeController.text = widget.selectedDocument['type'];
    imageController.text = widget.selectedDocument['image'];
    widthController.text =
        (widget.selectedDocument['detail']['width']).toString();
    lengthController.text =
        (widget.selectedDocument['detail']['length']).toString();
    heightController.text =
        (widget.selectedDocument['detail']['height']).toString();
    weightController.text =
        (widget.selectedDocument['detail']['weight']).toString();
    workingHeightController.text =
        (widget.selectedDocument['detail']['workingHeight']).toString();
    capacityController.text =
        (widget.selectedDocument['detail']['capacity']).toString();
    engineController.text = widget.selectedDocument['detail']['engine'];
    remarkController.text = widget.selectedDocument['detail']['remark'];
    dayRateController.text =
        (widget.selectedDocument['price']['dailyRate']).toString();
    deliveryChargeController.text =
        (widget.selectedDocument['price']['deliveryCharge']).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        leading: backwardButton(context),
      ),
      body: makeEditingDetailsTextForm(context),
    );
  }

  makeEditingDetailsTextForm(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              generateTitle('MACHINE\nDETAILS'),
              Row(
                children: [
                  Text('\*', style: TextStyle(color: Colors.red)),
                  Text('Model'),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: TextFormField(
                          focusNode: modelFocusNode,
                          controller: modelController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (term) {
                            fieldFocusChange(
                                context, modelFocusNode, widthFocusNode);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter,
                          ],
                          onSaved: (model) => modelController.text = model,
                        )),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('\*', style: TextStyle(color: Colors.red)),
                  Text('Width'),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: TextFormField(
                            focusNode: widthFocusNode,
                            controller: widthController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            onFieldSubmitted: (term) {
                              fieldFocusChange(
                                  context, widthFocusNode, lengthFocusNode);
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onSaved: (width) => widthController.text =
                                width.toString() // Only numbers can be entered
                            )),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('\*', style: TextStyle(color: Colors.red)),
                  Text('Length'),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: TextFormField(
                            focusNode: lengthFocusNode,
                            controller: lengthController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            onFieldSubmitted: (term) {
                              fieldFocusChange(
                                  context, lengthFocusNode, heightFocusNode);
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onSaved: (length) => lengthController.text =
                                length.toString() // Only numbers can be entered
                            )),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('\*', style: TextStyle(color: Colors.red)),
                  Text('Height'),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: TextFormField(
                            focusNode: heightFocusNode,
                            controller: heightController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            // textInputAction: TextInputAction.next,
                            onFieldSubmitted: (term) {
                              fieldFocusChange(
                                  context, heightFocusNode, weightFocusNode);
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onSaved: (height) => heightController.text =
                                height.toString() // Only numbers can be entered
                            )),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('\*', style: TextStyle(color: Colors.red)),
                  Text('Weight'),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: TextFormField(
                            focusNode: weightFocusNode,
                            controller: weightController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (term) {
                              fieldFocusChange(context, weightFocusNode, null);
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onSaved: (weight) => weightController.text =
                                weight.toString() // Only numbers can be entered
                            )),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(children: [
                Text('\*', style: TextStyle(color: Colors.red)),
                Text('Machine Type'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: makeDropDownBar(
                        selectedSite: DropDownItem(name: typeController.text),
                        list: DropDownItem.listMachineType,
                        callBack: (DropDownItem value) {
                          typeController.text = value.name;
                          setState(() {});
                        }),
                  ),
                ),
              ]),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('\*', style: TextStyle(color: Colors.red)),
                  Text('Working Height, Max'),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextFormField(
                            focusNode: workingHeightFocusNode,
                            controller: workingHeightController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (term) {
                              fieldFocusChange(context, workingHeightFocusNode,
                                  capacityFocusNode);
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onSaved: (workingHeight) => workingHeightController
                                .text = workingHeight.toString()
                            // Only numbers can be entered
                            )),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('\*', style: TextStyle(color: Colors.red)),
                  Text('Paltform Capacity, Max'),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: TextFormField(
                            focusNode: capacityFocusNode,
                            controller: capacityController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (term) {
                              fieldFocusChange(
                                  context, capacityFocusNode, engineFocusNode);
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onSaved: (capacity) =>
                                capacityController.text = capacity.toString()
                            // Only numbers can be entered
                            )),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('\*', style: TextStyle(color: Colors.red)),
                  Text('Engine'),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: TextFormField(
                            focusNode: engineFocusNode,
                            controller: engineController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter,
                            ],
                            onFieldSubmitted: (term) {
                              fieldFocusChange(
                                  context, engineFocusNode, quantityFocusNode);
                            },
                            keyboardType: TextInputType.text,
                            // textInputAction: TextInputAction.next,
                            onSaved: (engine) =>
                                engineController.text = engine)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('\*', style: TextStyle(color: Colors.red)),
                  Text('Quantity'),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 34.0),
                        child: TextFormField(
                          focusNode: quantityFocusNode,
                          controller: quantityController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onFieldSubmitted: (term) {
                            fieldFocusChange(
                                context, quantityFocusNode, remarkFocusNode);
                          },
                          onSaved: (quantity) => quantityController.text =
                              quantity
                                  .toString(), // Only numbers can be entered
                        )),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('\*', style: TextStyle(color: Colors.red)),
                  Text('Remark'),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: TextFormField(
                            maxLines: null,
                            minLines: 4,
                            focusNode: remarkFocusNode,
                            controller: remarkController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(''),
                            ],
                            onFieldSubmitted: (term) {
                              remarkFocusNode.unfocus();
                            },
                            keyboardType: TextInputType.text,
                            onSaved: (remark) =>
                                remarkController.text = remark)),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  print('Upload Picture');
                  uploadImage();
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
                        child: (imageController.text != null)
                            ? Image.network(imageController.text)
                            : Image.network('https://i.imgur.com/sUFH1Aq.png'),
                      ),
                    ],
                  ),
                ),
              ),
              generateTitle('PRICE\nDETAILS'),
              Row(
                children: [
                  Text('\*', style: TextStyle(color: Colors.red)),
                  Text('Daily Price'),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 35.0),
                        child: TextFormField(
                            focusNode: dayRateFocusNode,
                            controller: dayRateController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            textInputAction: TextInputAction.next,
                            inputFormatters: <TextInputFormatter>[
                              DecimalTextInputFormatter(decimalRange: 2),
                            ],
                            onSaved: (dayRate) => dayRateController.text =
                                dayRate
                                    .toString() // Only numbers can be entered
                            )),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('\*', style: TextStyle(color: Colors.red)),
                  Text('Delivery Charge'),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: TextFormField(
                            focusNode: deliveryChargeFocusNode,
                            controller: deliveryChargeController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            textInputAction: TextInputAction.done,
                            inputFormatters: <TextInputFormatter>[
                              DecimalTextInputFormatter(decimalRange: 2)
                            ],
                            onSaved: (deliveryCharge) =>
                                deliveryChargeController.text = deliveryCharge
                                    .toString() // Only numbers can be entered
                            )),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      final bool isSuccess = await updateDetails(
                          modelController.text,
                          widthController.text,
                          lengthController.text,
                          heightController.text,
                          weightController.text,
                          typeController.text,
                          workingHeightController.text,
                          capacityController.text,
                          engineController.text,
                          quantityController.text,
                          remarkController.text,
                          imageController.text,
                          dayRateController.text,
                          deliveryChargeController.text);

                      if (isSuccess) {
                        Navigator.pop(context);
                        Dialogs.showMessage(context,
                            title: 'Success to updated');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                    minimumSize:
                        Size(MediaQuery.of(context).size.width / 2, 50.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> updateDetails(
      String model,
      String width,
      String length,
      String height,
      String weight,
      String type,
      String workingHeight,
      String capacity,
      String engine,
      String quantity,
      String remark,
      String image,
      String dayRate,
      String charge) async {
    print(documentId);
    final isSuccess =
        await FirestoreService.getMachines().doc(documentId).update({
      'model': model,
      'type': type,
      'quantity': int.parse(quantity),
      'image': image,
      'caseSearch': setSearchParam(model) +
          setSearchParam(widget.selectedDocument.get('merchant.name')) +
          setSearchParam(type.split('_').join(' ')) +
          setSearchParam(model.toLowerCase()) +
          setSearchParam(widget.selectedDocument
              .get('merchant.name')
              .toString()
              .toLowerCase()) +
          setSearchParam(type.split('_').join(' ').toLowerCase()) +
          setSearchParam(model.toUpperCase()) +
          setSearchParam(widget.selectedDocument
              .get('merchant.name')
              .toString()
              .toUpperCase()) +
          setSearchParam(type.split('_').join(' ').toUpperCase()),
      'detail': MachineDetail(
              width: double.parse(width),
              length: double.parse(length),
              height: double.parse(height),
              weight: int.parse(weight),
              workingHeight: double.parse(workingHeight),
              capacity: int.parse(capacity),
              engine: engine,
              remark: remark)
          .toJson(),
      'price': PriceDetail(
              dailyRate: double.parse(dayRate),
              deliveryCharge: double.parse(charge))
          .toJson(),
    }).then((value) {
      return true;
    }).catchError((error) => print("Failed to update details`: $error"));
    return isSuccess;
  }

  void uploadImage() async {
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
            imageController.text = fileURL;
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
