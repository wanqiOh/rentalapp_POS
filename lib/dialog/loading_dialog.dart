import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final String message;

  const LoadingPage({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
              if (message != null) Text(message)
            ],
          ),
        ),
      );
}
