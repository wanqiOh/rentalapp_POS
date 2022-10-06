import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rentalapp_pos/base_helper/app_utils.dart';
import 'package:rentalapp_pos/constants/image_path.dart';

class OTPPage extends StatefulWidget {
  String phoneNo;
  OTPPage({this.phoneNo});

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load data only once after screen load
    generateOtp(widget.phoneNo);
  }

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  //build method for UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset("${icLogo}"),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: "${widget.phoneNo}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.yellow.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v.length < 3) {
                          return 'Cannot be empty';
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor:
                            hasError ? Colors.transparent : Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: TextStyle(
                      color: Colors.transparent,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  TextButton(
                      onPressed: () async {
                        generateOtp(widget.phoneNo);
                      },
                      child: Text(
                        'RESEND',
                        style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))
                ],
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: TextButton(
                    onPressed: () async {
                      formKey.currentState.validate();
                      final bool result = await verifyOtp();
                      if (result) Navigator.pop(context, true);
                    },
                    child: Center(
                        child: Text(
                      'VERIFY',
                      style: TextStyle(color: Colors.grey),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> generateOtp(String contact) async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;
    };
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: contact,
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          },
          codeSent: smsOTPSent,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            snackBar(context, phoneAuthCredential.toString());
          },
          verificationFailed: (FirebaseAuthException exception) {
            // Navigator.pop(context, exception.message);
            snackBar(context, exception.message);
          });
    } catch (e) {
      handleError(e as PlatformException);
      // Navigator.pop(context, (e as PlatformException).message);
    }
  }

//Method for verify otp entered by user
  Future<bool> verifyOtp() async {
    if (textEditingController.text == '') {
      showAlertDialog(context, 'please enter 6 digit otp');
    }

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: textEditingController.text,
      );

      final UserCredential user = await _auth.signInWithCredential(credential);
      final User currentUser = await _auth.currentUser;

      assert(user.user.uid == currentUser.uid);
      return true;
      // Navigator.pushReplacementNamed(context, CustomRouter.loginRoute);
    } catch (e) {
      handleError(e as PlatformException);
    }
  }

//Method for handle the errors
  void handleError(PlatformException error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        showAlertDialog(context, 'Invalid Code');
        break;
      default:
        showAlertDialog(context, error.message);
        break;
    }
  }

  //Basic alert dialogue for alert errors and confirmations
  void showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
