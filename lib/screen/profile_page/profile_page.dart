import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';
import 'package:rentalapp_pos/base_helper/app_utils.dart';
import 'package:rentalapp_pos/base_helper/ui/drop_down_bar.dart';
import 'package:rentalapp_pos/dialog/dialog.dart';
import 'package:rentalapp_pos/dialog/loading_dialog.dart';
import 'package:rentalapp_pos/global/globals.dart' as globals;
import 'package:rentalapp_pos/model/firestore_respond/firestore_service.dart';
import 'package:rentalapp_pos/model/view_model/address.dart';
import 'package:rentalapp_pos/model/view_model/drop_down_item.dart';
import 'package:rentalapp_pos/model/view_model/merchant.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController stateController = TextEditingController();
  TextEditingController addressController1 = TextEditingController();
  TextEditingController addressController2 = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController PICController = TextEditingController();
  TextEditingController dialCodeController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  FocusNode stateFocusNode = FocusNode();
  FocusNode addressFocusNode1 = FocusNode();
  FocusNode addressFocusNode2 = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode postcodeFocusNode = FocusNode();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode PICFocusNode = FocusNode();
  FocusNode dialCodeFocusNode = FocusNode();
  FocusNode contactFocusNode = FocusNode();
  FocusNode websiteFocusNode = FocusNode();
  String _imageUrl;
  final _formKey = GlobalKey<FormState>();
  Merchant merchant;

  @override
  void dispose() {
    super.dispose();
    addressController1.dispose();
    addressController2.dispose();
    cityController.dispose();
    postcodeController.dispose();
    usernameController.dispose();
    PICController.dispose();
    dialCodeController.dispose();
    contactController.dispose();
    websiteController.dispose();
    addressFocusNode1.dispose();
    addressFocusNode2.dispose();
    cityFocusNode.dispose();
    postcodeFocusNode.dispose();
    usernameFocusNode.dispose();
    PICFocusNode.dispose();
    dialCodeFocusNode.dispose();
    contactFocusNode.dispose();
    websiteFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    usernameController.text = globals.currentLoginUser.name;
    dialCodeController.text = DropDownItem.objDialCode.name;
    print('Dial Code: ${dialCodeController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        leading: backwardButton(context),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirestoreService.getMerchantsByID(
                  'id', globals.currentLoginUser.id)
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
              Map<String, dynamic> data;
              snapshot.data.docs.map((doc) {
                data = doc.data();
                if (!(data.containsKey('address'))) {
                  usernameController.text = doc.get('name');
                } else {
                  usernameController.text = doc.get('name');
                  dialCodeController.text = doc.get('phoneNo').substring(0, 3);
                  contactController.text = doc.get('phoneNo').substring(3);
                  addressController1.text = doc.get('address')['address1'];
                  addressController2.text = doc.get('address')['address2'];
                  cityController.text = doc.get('address')['city'];
                  postcodeController.text = doc.get('address')['postcode'];
                  stateController.text = doc.get('address')['state'];
                  PICController.text = doc.get('director');
                  print('State: ${stateController.text}');
                  websiteController.text = doc.get('website');
                  _imageUrl = doc.get('logo');
                }
              }).toList();

              return SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      generateTitle('Profile'),
                      makeEditProfileForm(),
                    ]),
              );
            }
          }),
    );
  }

  makeEditProfileForm() {
    print('State: ${stateController.text}');
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Username'),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
                        validator: (username) {
                          if (username.isEmpty)
                            return 'This field cannot be empty';
                          else
                            return null;
                        },
                        onSaved: (username) => usernameController.text =
                            username, // Only numbers can be entered
                        focusNode: usernameFocusNode,
                        onFieldSubmitted: (_) {
                          fieldFocusChange(
                              context, usernameFocusNode, PICFocusNode);
                        },
                      )),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('\*', style: TextStyle(color: Colors.red)),
                Text('Person In Charge'),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextFormField(
                        controller: PICController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
                        validator: (PIC) {
                          if (PIC.isEmpty)
                            return 'This field cannot be empty';
                          else
                            return null;
                        },
                        focusNode: PICFocusNode,
                        onSaved: (PIC) => PICController.text =
                            PIC, // Only numbers can be entered
                        onFieldSubmitted: (_) {
                          fieldFocusChange(
                              context, PICFocusNode, contactFocusNode);
                        },
                      )),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: makeSmallDropDownBar(
                      selectedSite: DropDownItem.objDialCode,
                      list: DropDownItem.listDialCode,
                      callBack: (DropDownItem value) {
                        setState(() {
                          DropDownItem.objDialCode = value;
                          dialCodeController.text = value.name;
                        });
                      }),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: contactController,
                    style: TextStyle(color: Colors.blue),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                      ),
                      labelText: 'Contact No \*',
                      hintText: '1234XXXXX',
                    ),
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9+]')),
                    ],
                    validator: (mobileNum) {
                      if (checkPhoneNumberValidation(mobileNum)) {
                        return null;
                      } else {
                        return null;
                      }
                    },
                    onSaved: (contactNo) => contactController.text = contactNo,
                    focusNode: contactFocusNode,
                    onFieldSubmitted: (_) {
                      fieldFocusChange(
                          context, contactFocusNode, addressFocusNode1);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('\*', style: TextStyle(color: Colors.red)),
                Text('Address'),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextFormField(
                        controller: addressController1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        keyboardType: TextInputType.streetAddress,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
                        validator: (address1) {
                          if (address1.isEmpty)
                            return 'This field cannot be empty';
                          else
                            return null;
                        },
                        onSaved: (address1) => addressController1.text =
                            address1, // Only numbers can be entered
                        focusNode: addressFocusNode1,
                        onFieldSubmitted: (_) {
                          fieldFocusChange(
                              context, addressFocusNode1, addressFocusNode2);
                        },
                      )),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 75),
              child: TextFormField(
                controller: addressController2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                keyboardType: TextInputType.streetAddress,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                validator: (address2) {
                  if (address2.isEmpty)
                    return 'This field cannot be empty';
                  else
                    return null;
                },
                onSaved: (address2) => addressController2.text =
                    address2, // Only numbers can be entered
                focusNode: addressFocusNode2,
                onFieldSubmitted: (_) {
                  fieldFocusChange(context, addressFocusNode2, cityFocusNode);
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('\*', style: TextStyle(color: Colors.red)),
                Text('City'),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 45.0),
                      child: TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        keyboardType: TextInputType.streetAddress,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
                        validator: (city) {
                          if (city.isEmpty)
                            return 'This field cannot be empty';
                          else
                            return null;
                        }, // Only numbers can be entered
                        onSaved: (city) => cityController.text = city,
                        focusNode: cityFocusNode,
                        onFieldSubmitted: (_) {
                          fieldFocusChange(
                              context, cityFocusNode, postcodeFocusNode);
                        },
                      )),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('\*', style: TextStyle(color: Colors.red)),
                Text('Postcode'),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 13.0),
                      child: TextFormField(
                        controller: postcodeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (postcode) {
                          if (postcode.length < 5 || postcode.length > 5)
                            return 'Kindly to fill in the correct postcode';
                          else if (postcode.isEmpty)
                            return 'This field cannot be empty';
                          else
                            return null;
                        },
                        onSaved: (postcode) => postcodeController.text =
                            postcode, // Only numbers can be entered
                        focusNode: postcodeFocusNode,
                        onFieldSubmitted: (_) {
                          fieldFocusChange(context, postcodeFocusNode, null);
                        },
                      )),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(children: [
              Text('\*', style: TextStyle(color: Colors.red)),
              Text('State'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: makeDropDownBar(
                      selectedSite: DropDownItem(name: stateController.text),
                      list: DropDownItem.listState,
                      callBack: (DropDownItem value) {
                        stateController.text = value.name;
                        setState(() {});
                      }),
                ),
              ),
            ]),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Website'),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextFormField(
                        controller: websiteController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
                        onSaved: (website) => websiteController.text =
                            website, // Only numbers can be entered
                        focusNode: websiteFocusNode,
                        onFieldSubmitted: (_) {
                          fieldFocusChange(context, websiteFocusNode, null);
                        },
                      )),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(children: [
              Row(children: [
                Text('\*', style: TextStyle(color: Colors.red)),
                Text('Logo')
              ]),
              GestureDetector(
                onTap: () async {
                  print('Upload Picture');
                  uploadImage();
                  print(_imageUrl);
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
                            : Image.network('https://i.imgur.com/sUFH1Aq.png'),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
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
                        //   final responseMessage = await Navigator.pushNamed(
                        //       context, CustomRouter.otpRoute,
                        //       arguments:
                        //           '${dialCodeController.text}${contactController.text}');
                        //
                        //   print('Response Message: ${responseMessage}');
                        //   if (responseMessage) {
                        final success = await updateDetails(
                            usernameController.text,
                            PICController.text,
                            '${dialCodeController.text}${contactController.text}',
                            addressController1.text,
                            addressController2.text,
                            cityController.text,
                            postcodeController.text,
                            stateController.text,
                            _imageUrl,
                            websiteController.text == ''
                                ? null
                                : websiteController.text);
                        print('Id: $success');
                        if (success) {
                          Navigator.pop(context);
                          Dialogs.showMessage(context,
                              title: 'Success to added');
                        }
                        // }
                        // final success = await updateDetails(
                        //     usernameController.text,
                        //     PICController.text,
                        //     '${dialCodeController.text}${contactController.text}',
                        //     addressController1.text,
                        //     addressController2.text,
                        //     cityController.text,
                        //     postcodeController.text,
                        //     stateController.text,
                        //     _imageUrl,
                        //     websiteController.text == ''
                        //         ? null
                        //         : websiteController.text);
                        // print('Id: $success');
                        // if (success) {
                        //   Navigator.pop(context);
                        //   Dialogs.showMessage(context,
                        //       title: 'Success to added');
                        // }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
            .child('company_logo/${Path.basename(image.path)}}');
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

  updateDetails(username, pic, contact, address1, address2, city, postcode,
      state, logo, website) async {
    final isSuccess = await FirestoreService.getDeviceIds()
        .doc(globals.currentLoginUser.id)
        .update({
      'name': username,
      'logo': logo,
      'address': AddressDes(
              address1: address1,
              address2: address2,
              city: city,
              postcode: postcode,
              state: state)
          .toJson(),
      'director': pic,
      'phoneNo': contact,
      'website': website,
      'orderNum': 0,
      'notifId': globals.id,
      'firstTime': false,
    }).then((value) {
      return true;
    }).catchError((error) => print("Failed to add user: $error"));

    return isSuccess;
  }
}
