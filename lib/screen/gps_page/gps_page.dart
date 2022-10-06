import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rentalapp_pos/constants/image_path.dart';
import 'package:rentalapp_pos/custom_router.dart';
import 'package:rentalapp_pos/dialog/dialog.dart';
import 'package:rentalapp_pos/global/globals.dart' as globals;
import 'package:rentalapp_pos/model/firestore_respond/firestore_service.dart';
import 'package:rentalapp_pos/model/view_model/locations.dart';
import 'package:rentalapp_pos/provider/user_state/user_state.dart';

class GPSPage extends HookWidget {
  Position _currentPosition;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      makeTitle(),
                      makeBodyText(),
                      makeIconSection(),
                      makeAllowButton(useContext()),
                    ],
                  )),
            ),
          ),
        ));
  }

  makeTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: AutoSizeText(
        'Location Access Is Important',
        style: TextStyle(color: Colors.grey, fontSize: 35),
      ),
    );
  }

  makeBodyText() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: AutoSizeText(
        'Ride pick-off and other services will be faster and more accurate. We can also better ensure your rent experience.',
        style: TextStyle(color: Colors.grey, fontSize: 20),
      ),
    );
  }

  makeIconSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Align(
          alignment: FractionalOffset.center,
          child: Image.asset(
            bgGPS,
            scale: 0.5,
          )),
    );
  }

  makeAllowButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              getCurrentLocation(context);
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey.shade50),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.grey, width: 2)))),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Allow Location Address',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ))),
      ),
    );
  }

  getCurrentLocation(BuildContext context) async {
    Position _currentPosition;
    if (!(await Geolocator.isLocationServiceEnabled())) {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) async {
        _currentPosition = position;
        print(position);
        final state = Provider.of<UserState>(context, listen: false);
        await FirestoreService.setLocation(state.deviceId).update({
          'position': _currentPosition.toJson(),
          'notifMer': {'id': globals.id},
        }).then((value) {
          return value.id;
        }).catchError((error) => print("Failed to add user: $error"));
        getAddressFromLatLng(context, _currentPosition);
      }).catchError((e) {
        print(e);
        Navigator.pushNamed(context, CustomRouter.gpsRoute);
      });
    } else {
      getAddressFromLatLng(context, _currentPosition);
    }
  }

  getAddressFromLatLng(BuildContext context, Position _currentPosition) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];
      final state = Provider.of<UserState>(context, listen: false);
      await FirestoreService.setLocation(state.deviceId).update({
        'location': Locations(postcode: place.postalCode, state: place.locality)
            .toJson(),
      }).then((value) {
        return value.id;
      }).catchError((error) => print("Failed to add user: $error"));
      fillInDetail(context);
    } catch (e) {
      print(e);
    }
  }

  fillInDetail(BuildContext context) {
    FirestoreService.getDeviceIds()
        .doc(globals.currentLoginUser.id)
        .get()
        .then((element) {
      print(element.data());
    });
    Dialogs.showMessageProfile(context,
        title: 'Details of Merchant',
        content: Text('The details of your company need to fill in'));
  }
}
