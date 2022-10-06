import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentalapp_pos/model/view_model/user.dart';

class UserState with ChangeNotifier {
  CollectionReference databaseReference =
      FirebaseFirestore.instance.collection('device_ids');
  String deviceId;
  List<UserRentalApp> users = [];
  String currentPosition;

  UserState() {
    getDeviceId();
    getUsersRentalApp();
    checkStoredLocation();
  }

  void getUsersRentalApp() {
    databaseReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        UserRentalApp tmpUser = UserRentalApp.fromJson(result.data());
        tmpUser.addId(result.reference.id);
        tmpUser.setIsSelected(false);
        users.add(tmpUser);
      });
    });
    notifyListeners();
  }

  Future<String> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.androidId;
    }
    print("device id: ${deviceId}");
    notifyListeners();
    return deviceId;
  }

  UserRentalApp verifyUser() {
    return users.firstWhere((user) {
      notifyListeners();
      return user.id == deviceId;
    }, orElse: () => null);
  }

  Future<void> checkStoredLocation() async {
    String device_id = await getDeviceId();
    databaseReference.doc(device_id).get().then((value) {
      currentPosition = '${value.get('location')['state']}' +
          ', ${value.get('location')['postcode']}';
    });
    notifyListeners();
  }
}
