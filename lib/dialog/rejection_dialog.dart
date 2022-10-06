import 'package:flutter/material.dart';
import 'package:rentalapp_pos/custom_router.dart';
class RejectionDialog extends StatefulWidget {

  @override
  _RejectionDialogState createState() => _RejectionDialogState();
}

class _RejectionDialogState extends State<RejectionDialog> {
  bool agree = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        scrollable: true,
        title: Text('Confirmation'),
        content: Column(children: [
          Text('By clicking \"Confirm\", Rejection will undergoes penalty.\n\nAre you sure want to continue?'),
          Column(
            children: [
              Row(children: [
                Material(
                  child: Checkbox(
                    value: agree,
                    onChanged: (value) {
                      setState(() {
                        agree = value;
                      });
                    },
                  ),
                ),
                Text(
                  'I have read and accept',
                ),
              ]),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context, CustomRouter.termAndConditionRoute);
                },
                child: Text(
                  ' terms and conditions',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),]),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          OutlinedButton(
            child: Text('Confirm'),
            onPressed: () => !agree ? null : Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}