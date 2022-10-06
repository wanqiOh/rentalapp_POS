import 'dart:math' as math;
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rentalapp_pos/app_folder/app_theme.dart';
import 'package:rentalapp_pos/custom_router.dart';
import 'package:rentalapp_pos/dialog/dialog.dart';
import 'package:rentalapp_pos/global/globals.dart' as globals;
import 'package:rentalapp_pos/model/firestore_respond/firestore_service.dart';
import 'package:rentalapp_pos/model/view_model/category_item.dart';
import 'package:url_launcher/url_launcher.dart';

extension HexString on String {
  Color toHexColor() {
    final buffer = StringBuffer();
    if (this.length == 6 || this.length == 7) buffer.write('ff');
    buffer.write(this.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension IntStr on num {
  String valueToStr() {
    var formatter = NumberFormat('###,###,###,###,###,###,000.00');
    return 'RM ' + formatter.format(this);
  }
}

bool checkPhoneNumberValidation(String mobileNum) {
  if (mobileNum.isNotEmpty &&
      (mobileNum.length >= 9 ||
          mobileNum.length >= 7 ||
          mobileNum.length >= 8)) {
    return true;
  } else {
    return false;
  }
}

generateTitle(String title) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: AutoSizeText(
      title,
      style: TextStyle(color: Colors.grey, fontSize: 25),
    ),
  );
}

backwardButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: CircleAvatar(
      backgroundColor: Colors.black.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppTheme.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

void fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

Future<void> getUrl() async {
  final imageUrl = await FirebaseStorage.instance
      .ref()
      .child("images/add_icon.png")
      .getDownloadURL();
  print('test : $imageUrl');
}

navigateToEditingPage(BuildContext context, CategoryItem data) {
  switch (data.machineType) {
    case 'aerial_lift':
    case 'scissor_lift':
    case 'crawler_crane':
    case 'boom_lift':
    case 'fork_lift':
    case 'sky_lift':
    case 'beach_lift':
    case 'spider_lift':
      Navigator.pushNamed(context, CustomRouter.editingRoute, arguments: data);
      break;
    case 'add_machine':
      Dialogs.showAddMachineCategoryDialog(context);
      break;
  }
}

checkMachineImage(String id) {
  switch (id) {
    case 'scissor_lift':
      return 'https://firebasestorage.googleapis.com/v0/b/rentalapp-fa5bd.appspot.com/o/images%2Fscissor_lift.png?alt=media&token=eea35166-3d4a-4dc4-968a-222bcd8b1ad2';
      break;
    case 'spider_lift':
      return 'https://firebasestorage.googleapis.com/v0/b/rentalapp-fa5bd.appspot.com/o/images%2Fspider_lift.png?alt=media&token=3dd4fe4a-d887-4ce1-a35e-110c288e0a33';
      break;
    case 'aerial_lift':
      return 'https://firebasestorage.googleapis.com/v0/b/rentalapp-fa5bd.appspot.com/o/images%2Faerial_lift.png?alt=media&token=89b3fa9d-b76d-4081-8595-723cbed446cd';
      break;
    case 'crawler_crane':
      return 'https://firebasestorage.googleapis.com/v0/b/rentalapp-fa5bd.appspot.com/o/images%2Fcrawler_crane.png?alt=media&token=0d0956c8-c3b4-4ebe-8d1f-7f09ad986ba2';
      break;
    case 'boom_lift':
      return 'https://firebasestorage.googleapis.com/v0/b/rentalapp-fa5bd.appspot.com/o/images%2Fboom_lift.png?alt=media&token=5edec986-32c4-429b-9949-49786a45be64';
      break;
    case 'fork_lift':
      return 'https://firebasestorage.googleapis.com/v0/b/rentalapp-fa5bd.appspot.com/o/images%2Ffork_lift.png?alt=media&token=a7c6f209-91ce-44d4-96c3-60dec7829d4d';
      break;
    case 'sky_lift':
      return 'https://firebasestorage.googleapis.com/v0/b/rentalapp-fa5bd.appspot.com/o/images%2Ftower_lift.png?alt=media&token=7430c832-0ed8-477f-9918-2a6afc1ebbd0';
      break;
    case 'beach_lift':
      return 'https://firebasestorage.googleapis.com/v0/b/rentalapp-fa5bd.appspot.com/o/images%2Fbeach_lift.png?alt=media&token=1c60c625-2e1d-496a-890e-af2cb1c5c75a';
      break;
    case 'add_machine':
      return 'https://firebasestorage.googleapis.com/v0/b/rentalapp-fa5bd.appspot.com/o/images%2Fadd_icon.png?alt=media&token=63e43566-4b0e-4723-81ec-8d5a030b38b0';
      break;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

setSearchParam(String caseNumber) {
  List<String> caseSearchList = [];
  String temp = "";
  for (int i = 0; i < caseNumber.length; i++) {
    temp = temp + caseNumber[i];
    caseSearchList.add(temp);
  }
  return caseSearchList;
}

snackBar(BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ),
  );
}

launchURL(fileUrl) async {
  print('File url: ${fileUrl}');
  await canLaunch(fileUrl)
      ? await launch(fileUrl)
      : throw 'Could not launch ${fileUrl}';
}

formatPrice(double price) => '\RM ${price.toStringAsFixed(2)}';
formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

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
